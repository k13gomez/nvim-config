local M = {}

local function eval(form)
  vim.cmd("ConjureEval " .. form)
end

local function cword()
  return vim.fn.expand("<cword>")
end

function M.find_library_versions()
  local lib = cword()
  eval(
    "(do (require '[clojure.edn] '[clojure.tools.deps] '[clojure.tools.deps.extensions] '[clojure.tools.deps.util.maven]) (let [mvn-repos (->> (slurp \"deps.edn\") clojure.edn/read-string :mvn/repos (merge clojure.tools.deps.util.maven/standard-repos)) types (distinct (into [:mvn :git] (clojure.tools.deps.extensions/procurer-types))) lib '"
      .. lib
      .. " procurer {:mvn/repos mvn-repos}] (->> (some #(clojure.tools.deps.extensions/find-versions lib nil % procurer) types) (reverse) (take 10) (vec))))"
  )
end

function M.tap_expression()
  eval("(tap> " .. cword() .. ")")
end

function M.add_lib_portal()
  eval("(do (require 'clojure.repl.deps) (clojure.repl.deps/add-lib 'djblue/portal))")
end

function M.add_tap_expression()
  eval("(do (require 'portal.api) (portal.api/open) (add-tap #'portal.api/submit) (add-tap #'println))")
end

function M.remove_tap_expression()
  eval("(do (require 'portal.api) (portal.api/open) (remove-tap #'portal.api/submit) (remove-tap #'println))")
end

function M.run_test()
  eval("(do (require '[clojure.test]) (clojure.test/test-var #'" .. cword() .. "))")
end

function M.run_tests()
  eval("(do (require '[clojure.test]) (clojure.test/run-tests))")
end

function M.eval_fn()
  eval("(" .. cword() .. ")")
end

function M.warn_on_reflection()
  eval("(set! *warn-on-reflection* true)")
end

function M.get_pid()
  eval("(.. (java.lang.ProcessHandle/current) (pid))")
end

return M
