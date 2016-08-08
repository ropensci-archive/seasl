csl_GET <- function(x, ...) {
  out <- httr::GET(x, ...)
  httr::stop_for_status(out)
  httr::content(out, "text", encoding = "UTF-8")
}

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}
