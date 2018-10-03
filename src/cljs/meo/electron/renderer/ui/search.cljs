(ns meo.electron.renderer.ui.search
  (:require [meo.common.utils.parse :as p]
            [meo.electron.renderer.ui.draft :as d]
            [taoensso.timbre :refer-macros [info]]
            [reagent.ratom :refer-macros [reaction]]
            [re-frame.core :refer [subscribe]]
            [reagent.core :as r]))

(defn editor-state
  "Create editor-state, either from deserialized state or from search string."
  [q]
  (if-let [editor-state (:editor-state q)]
    (d/editor-state-from-raw (clj->js editor-state))
    (d/editor-state-from-text (or (:search-text q) ""))))

(defn search-field-view
  "Renders search field for current tab."
  [_tab-group query-id _put-fn]
  (let [query-cfg (subscribe [:query-cfg])
        query (reaction (when-let [qid @query-id] (qid (:queries @query-cfg))))]
    (fn [tab-group _query-id put-fn]
      (let [search-send (fn [text editor-state]
                          (when text
                            (let [story (first (d/entry-stories editor-state))
                                  s (merge @query
                                           (p/parse-search text)
                                           {:story        story
                                            :tab-group    tab-group
                                            :editor-state editor-state})]
                              (put-fn [:search/update s]))))
            query @query
            starred (:starred query)
            star-fn #(put-fn [:search/update (update-in query [:starred] not)])
            flagged (:flagged query)
            flag-fn #(put-fn [:search/update (update-in query [:flagged] not)])]
        (when-not (or (:briefing query)
                      (:timestamp query))
          [:div.search
           [:div.search-row
            [:div [:i.far.fa-search]]
            [d/draft-search-field (editor-state query) search-send]
            [:div.star
             [:i {:class    (if starred
                              "fas fa-star starred"
                              "fal fa-star")
                  :on-click star-fn}]]
            [:div.flag
             [:i {:class    (if flagged
                              "fas fa-flag flagged"
                              "fal fa-flag")
                  :on-click flag-fn}]]]])))))
