library(seasl)
csl_cache$cache_path_set("seasl", type = "tempdir")
# download style files
invisible(suppressMessages(csl_fetch_styles()))
