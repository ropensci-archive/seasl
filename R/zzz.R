csl_GET <- function(x, ...) {
  cli <- crul::HttpClient$new(x, opts = list(...))
  out <- cli$get()
  out$raise_for_status()
  out$parse("UTF-8")
}

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}
