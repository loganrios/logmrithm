(ns com.logmrithm.auth
  (:require [buddy.hashers :as  hashers]))

(defn signin [{:keys [session] :as ctx}]
  (prn "Authing!"))

(def module
  {:routes [["/auth/logim" {:post signin}]]})
