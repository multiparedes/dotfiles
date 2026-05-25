return {
  "2nthony/sortjson.nvim",
  cmd = {
    "SortJSONByAlphaNum",
    "SortJSONByAlphaNumReverse",
    "SortJSONByKeyLength",
    "SortJSONByKeyLengthReverse",
  },
  -- options with default values
  opts = {
    jq = "jq", -- jq command, you can try `jaq` `gojq` etc.
    log_level = "WARN", -- log level, see `:h vim.log.levels`, when parsing json failed
  },
}
