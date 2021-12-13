(defproject day03 "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.10.3"]
                 [org.typedclojure/typed.clj.runtime "1.0.19"]]
  :profiles {:dev {:dependencies [[org.typedclojure/typed.clj.checker "1.0.19"]]}}
  :repl-options {:init-ns day03.core})
