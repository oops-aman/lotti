(ns iwaswhere-web.client-store
  (:require #?(:cljs [alandipert.storage-atom :refer [local-storage]])
    [matthiasn.systems-toolbox.component :as st]
    [iwaswhere-web.keepalive :as ka]
    [iwaswhere-web.client-store-entry :as cse]
    [iwaswhere-web.client-store-search :as s]
    [iwaswhere-web.client-store-cfg :as c]))

(defn new-state-fn
  "Update client side state with list of journal entries received from backend."
  [{:keys [current-state msg-payload msg-meta]}]
  (let [query-id (:query-id msg-payload)
        store-meta (:client/store-cmp msg-meta)
        entries (:entries msg-payload)
        new-state (-> current-state
                      (assoc-in [:results query-id :entries] entries)
                      (update-in [:entries-map] merge (:entries-map msg-payload))
                      (assoc-in [:timing] {:query (:duration-ms msg-payload)
                                           :rtt   (- (:in-ts store-meta)
                                                     (:out-ts store-meta))
                                           :count (count entries)}))]
    {:new-state new-state}))

(defn stats-tags-fn
  "Update client side state with stats and tags received from backend."
  [{:keys [current-state msg-payload]}]
  (let [new-state
        (-> current-state
            (assoc-in [:options :hashtags] (:hashtags msg-payload))
            (assoc-in [:options :pvt-hashtags] (:pvt-hashtags msg-payload))
            (assoc-in [:options :pvt-displayed] (:pvt-displayed msg-payload))
            (assoc-in [:options :activities] (:activities msg-payload))
            (assoc-in [:options :consumption-types] (:consumption-types msg-payload))
            (assoc-in [:options :mentions] (:mentions msg-payload))
            (assoc-in [:stats] (:stats msg-payload)))]
    {:new-state new-state}))

(defn initial-state-fn
  "Creates the initial component state atom. Holds a list of entries from the
   backend, a map with temporary entries that are being edited but not saved
   yet, and sets that contain information for which entries to show the map,
   or the edit mode."
  [put-fn]
  (let [initial-state (atom {:entries        []
                             :last-alive     (st/now)
                             :new-entries    @cse/new-entries-ls
                             :query-cfg      @s/query-cfg
                             :pomodoro-stats (sorted-map)
                             :activity-stats (sorted-map)
                             :task-stats     (sorted-map)
                             :cfg            @c/app-cfg})]
    (doseq [[_id q] (:queries (:query-cfg @initial-state))]
      (put-fn [:state/get q]))
    (put-fn [:state/stats-tags-get])
    {:state initial-state}))

(defn show-more-fn
  "Runs previous query but with more results. Also updates the number to show in
   the UI."
  [{:keys [current-state msg-payload]}]
  (let [query-path [:query-cfg :queries (:query-id msg-payload)]
        merged (merge (get-in current-state query-path) msg-payload)
        new-query (update-in merged [:n] + 20)
        new-state (assoc-in current-state query-path new-query)]
    {:new-state new-state
     :emit-msg  [:state/get new-query]}))

(defn toggle-active-fn
  "Sets entry in payload as the active entry for which to show linked entries."
  [{:keys [current-state msg-payload]}]
  (let [{:keys [timestamp query-id]} msg-payload
        currently-active (get-in current-state [:cfg :active query-id])]
    {:new-state (assoc-in current-state [:cfg :active query-id]
                          (if (= currently-active timestamp)
                            nil
                            timestamp))
     :emit-msg  s/update-location-hash-msg}))

(defn save-stats
  "Stores received stats on component state."
  [k]
  (fn [{:keys [current-state msg-payload]}]
    (let [ds (:date-string msg-payload)
          new-state (assoc-in current-state [k ds] msg-payload)]
      {:new-state new-state})))

(defn cmp-map
  "Creates map for the component which holds the client-side application state."
  [cmp-id]
  {:cmp-id            cmp-id
   :state-fn          initial-state-fn
   :snapshot-xform-fn #(dissoc % :last-alive)
   :state-spec        :state/client-store-spec
   :handler-map       (merge cse/entry-handler-map
                             s/search-handler-map
                             {:state/new          new-state-fn
                              :stats/pomo-day     (save-stats :pomodoro-stats)
                              :stats/activity-day (save-stats :activity-stats)
                              :stats/tasks-day    (save-stats :task-stats)
                              :state/stats-tags   stats-tags-fn
                              :show/more          show-more-fn
                              :cfg/save           c/save-cfg
                              :cmd/toggle-active  toggle-active-fn
                              :cmd/toggle         c/toggle-set-fn
                              :cmd/set-opt        c/set-conj-fn
                              :cmd/set-dragged    c/set-currently-dragged
                              :cmd/toggle-key     c/toggle-key-fn
                              :cmd/keep-alive     ka/reset-fn
                              :cmd/keep-alive-res ka/set-alive-fn
                              :cmd/toggle-lines   c/toggle-lines})})
