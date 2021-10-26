(ns meins.electron.main.import
  (:require ["glob" :as glob :refer [sync]]
            ["fs" :refer [copyFileSync existsSync readFileSync]]
            [taoensso.timbre :refer [error info]]
            [clojure.string :as str]
            [meins.electron.main.helpers :as h]
            [cljs.spec.alpha :as spec]
            ["child_process" :refer [spawn]]
            [clojure.pprint :as pp]
            [expound.alpha :as exp]
            [clojure.string :as s]))

(def audio-path-atom (atom ""))
(def image-path-atom (atom ""))

(defn parse-json [file]
  (let [json (.parse js/JSON (readFileSync file))
        data (js->clj json)]
    data))

(defn convert-audio-entry [data]
  (let [ts (get data "timestamp")
        text (str (h/format-time ts) " Audio")
        geolocation (get data "geolocation")
        entry {:timestamp  ts
               :md         text
               :text       text
               :mentions   #{}
               :utc-offset (get data "utcOffset")
               :audio_file (get data "audioFile")
               :timezone   (get data "timezone")
               :tags       #{"#audio" "#import"}
               :perm_tags  #{"#audio" "#task"}
               :longitude  (get geolocation "longitude")
               :latitude   (get geolocation "latitude")
               :vclock     (get data "vectorClock")}]
    entry))

(defn time-recording-entry [data]
  (let [entry (convert-audio-entry data)
        entry-ts (:timestamp entry)
        subentry (select-keys entry [:utc-offset
                                     :timezone
                                     :longitude
                                     :latitude])
        comment (merge subentry
                       {:timestamp      (+ entry-ts 1000)
                        :entry_type     :pomodoro
                        :comment_for    entry-ts
                        :text           "recording"
                        :md             "- recording"
                        :completed_time (/ (get data "duration")
                                           1000000)})]
    comment))

(defn import-audio-files [path put-fn]
  (let [files (sync (str path "/**/*.json"))]
    (doseq [json-file files]
      (when-not (s/includes? json-file "trash")
        (let [data (parse-json json-file)
              entry (convert-audio-entry data)
              comment (time-recording-entry data)
              file (str/replace json-file ".json" "")
              audio-file (:audio_file entry)
              audio-file-path (str @audio-path-atom "/" audio-file)]
          (when-not (existsSync audio-file-path)
            (when (existsSync file)
              (copyFileSync file audio-file-path)
              (when (spec/valid? :meins.entry/spec entry)
                (pp/pprint entry)
                (put-fn [:entry/save-initial entry]))
              (when (spec/valid? :meins.entry/spec comment)
                (pp/pprint comment)
                (put-fn [:entry/save-initial comment])))))))))

(defn import-audio [{:keys [msg-payload put-fn]}]
  (let [path (:directory msg-payload)]
    (info "import-audio:" path)
    (import-audio-files path put-fn)))

(defn convert-image-entry [data]
  (let [ts (get data "timestamp")
        text (str (h/format-time ts) " Image")
        geolocation (get data "geolocation")
        entry {:timestamp  ts
               :md         text
               :text       text
               :mentions   #{}
               :utc-offset 0
               :img_file   (s/replace (get data "imageFile") "HEIC" "JPG")
               :timezone   (get data "timezone")
               :tags       #{"#photo" "#import"}
               :perm_tags  #{"#photo"}
               :longitude  (get geolocation "longitude")
               :latitude   (get geolocation "latitude")
               :vclock     (get data "vectorClock")}]
    entry))

(defn spawn-process [cmd args opts]
  (info "STARTUP: spawning" cmd args opts)
  (spawn cmd (clj->js args) (clj->js opts)))

(defn import-image-files [path put-fn]
  (let [files (sync (str path "/**/*.json"))]
    (doseq [json-file files]
      (when-not (s/includes? json-file "trash")
        (let [data (parse-json json-file)
              entry (convert-image-entry data)
              file (str/replace json-file ".json" "")
              jpg (s/replace file "HEIC" "JPG")
              img-file (:img_file entry)
              img-file-path (str @image-path-atom "/" img-file)]
          (info (exp/expound-str :meins.entry/spec entry))
          (pp/pprint entry)
          (when-not (existsSync img-file-path)
            (when (existsSync file)
              (spawn-process "/usr/local/bin/magick" ["convert" file jpg] {})
              (js/setTimeout #(when (spec/valid? :meins.entry/spec entry)
                                (info "spec/valid")
                                (copyFileSync jpg img-file-path)
                                (put-fn [:import/gen-thumbs
                                         {:filename  img-file
                                          :full-path jpg}]))
                             2000)
              (js/setTimeout #(when (spec/valid? :meins.entry/spec entry)
                                (put-fn [:entry/save-initial entry]))
                             4000))))))))

(defn import-images [{:keys [msg-payload put-fn]}]
  (let [path (:directory msg-payload)]
    (info "import-images:" path)
    (import-image-files path put-fn)))

(defn import-sleep-entry [data put-fn]
  (let [date-to (get data "date_to")
        ts (h/health-date-to-ts date-to)
        value (get data "value")
        text (str "Sleep: " value " min")
        data-type (get data "data_type")]
    (when (= data-type "sleep_asleep")
      (let [entry {:timestamp     ts
                   :md            text
                   :text          text
                   :mentions      #{}
                   :utc-offset    120
                   :timezone      "Europe/Berlin"
                   :perm_tags     #{"#sleep"}
                   :tags          #{"#sleep"}
                   :primary_story 1479889430353
                   :health_data   data
                   :custom_fields {"#sleep" {:duration value}}}]
        (when (and entry (spec/valid? :meins.entry/spec entry))
          (put-fn [:entry/save-initial entry]))))))

(defn import-steps-entry [data put-fn]
  (let [date-to (get data "dateTo")
        ts (- (h/health-date-to-ts2 date-to) 123)
        value (get data "value")
        text (str "Steps: " value " total")
        data-type (get data "dataType")]
    (when (= data-type "cumulative_step_count")
      (let [entry {:timestamp     ts
                   :md            text
                   :text          text
                   :mentions      #{}
                   :utc-offset    120
                   :timezone      "Europe/Berlin"
                   :perm_tags     #{"#steps"}
                   :health_data   data
                   :custom_fields {"#steps" {:cnt value}}}]
        (when (and entry (spec/valid? :meins.entry/spec entry))
          (put-fn [:entry/save-initial entry]))))))

(defn import-weight-entry [data put-fn]
  (let [date-to (get data "date_to")
        ts (h/health-date-to-ts date-to)
        value (get data "value")
        rounded-value (/ (Math/round (* value 10)) 10)
        text (str "Weight: " rounded-value " kg")
        data-type (get data "data_type")]
    (when (= data-type "weight")
      (let [entry {:timestamp     ts
                   :md            text
                   :text          text
                   :mentions      #{}
                   :utc-offset    120
                   :timezone      "Europe/Berlin"
                   :perm_tags     #{"#weight"}
                   :health_data   data
                   :custom_fields {"#weight" {:weight value}}}]
        (when (and entry (spec/valid? :meins.entry/spec entry))
          (put-fn [:entry/save-initial entry]))))))

(defn import-bp-entry [data put-fn]
  (let [date-to (get data "date_to")
        ts (h/health-date-to-ts date-to)
        value (get data "value")
        data-type (get data "data_type")]
    (when (= data-type "blood_pressure_systolic")
      (let [text (str "BP: " value " systolic")
            entry {:timestamp     (+ ts 1)
                   :md            text
                   :text          text
                   :mentions      #{}
                   :utc-offset    120
                   :timezone      "Europe/Berlin"
                   :perm_tags     #{"#BP"}
                   :tags          #{"#BP"}
                   :health_data   data
                   :custom_fields {"#BP" {:bp_systolic value}}}]
        (when (and entry (spec/valid? :meins.entry/spec entry))
          (put-fn [:entry/save-initial entry]))))
    (when (= data-type "blood_pressure_diastolic")
      (let [text (str "BP: " value " mmHg diastolic")
            entry {:timestamp     (+ ts 2)
                   :md            text
                   :text          text
                   :mentions      #{}
                   :utc-offset    120
                   :timezone      "Europe/Berlin"
                   :perm_tags     #{"#BP"}
                   :tags          #{"#BP"}
                   :health_data   data
                   :custom_fields {"#BP" {:bp_diastolic value}}}]
        (when (and entry (spec/valid? :meins.entry/spec entry))
          (put-fn [:entry/save-initial entry]))))))

(defn import-health [{:keys [msg-payload put-fn]}]
  (let [files (:files msg-payload)]
    (info "import-health:" files)
    (doseq [json-file files]
      (let [items (parse-json json-file)]
        (doseq [item items]
          (import-sleep-entry item put-fn)
          (import-weight-entry item put-fn)
          (import-bp-entry item put-fn)
          (import-steps-entry item put-fn))))))

(defn cmp-map [cmp-id audio-path img-path]
  (reset! audio-path-atom audio-path)
  (reset! image-path-atom img-path)
  {:cmp-id      cmp-id
   :handler-map {:import/audio  import-audio
                 :import/health import-health
                 :import/images import-images}})
