csl_cache <- NULL # nocov start

.onLoad <- function(libname, pkgname) {
  x <- hoardr::hoard()
  x$cache_path_set("seasl")
  csl_cache <<- x
} # nocov end
