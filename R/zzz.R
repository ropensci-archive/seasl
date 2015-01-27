csl_GET <- function(x, ...){
  out <- httr::GET(x, ...)
  httr::stop_for_status(out)
  content(out, "text")
}