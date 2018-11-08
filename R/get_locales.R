#' Get CSL locales from the web
#' 
#' Pulls down all CSL locale files into a directory on your machine,
#' returning the path to that directory
#'
#' @export
#' @param ... Curl options passed on to [crul::HttpClient]
#' @references https://github.com/citation-style-language/locales
#' @return path (character) to the files (invisibly)
#' @details Files are stored in 
#' `paste0(rappdirs::user_cache_dir(), "/R/seasl/styles")`. See [csl_cache]
#' for more
#' @examples \dontrun{
#' csl_fetch_locales()
#' }
csl_fetch_locales <- function(...) {
  csl_cache$mkdir()
  path <- csl_cache$cache_path_get()
  unlink(file.path(path, "locales"), recursive = TRUE, force = TRUE)
  cli <- crul::HttpClient$new(locales_zip_url(), opts = list(...))
  cli$get(disk = file.path(path, "locales.zip"))
  utils::unzip(file.path(path, "locales.zip"), exdir = path)
  file.rename(file.path(path, "locales-master"), file.path(path, "locales"))
  unlink(file.path(path, "locales", 
    Filter(function(x) !grepl("\\.xml|\\.json", x), 
      list.files(file.path(path, "locales")))), recursive = TRUE, force = TRUE)
  message(sprintf("\nDone! Files put in %s", file.path(path, "locales")))
  invisible(file.path(path, "locales"))
}

locales_zip_url <- function() {
  "https://github.com/citation-style-language/locales/archive/master.zip"
}
