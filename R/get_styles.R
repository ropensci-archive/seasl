#' Get CSL styles from the web
#' 
#' Pulls down all CSL style files into a directory on your machine,
#' returning the path to that directory
#'
#' @export
#' @param ... Curl options passed on to [crul::HttpClient]
#' @references https://github.com/citation-style-language/styles-distribution
#' @return path (character) to the files (invisibly)
#' @details Files are stored in 
#' `paste0(rappdirs::user_cache_dir(), "/R/seasl/styles")`. See [csl_cache] 
#' for more
#' @examples \dontrun{
#' csl_fetch_styles()
#' }
csl_fetch_styles <- function(...) {
  csl_cache$mkdir()
  path <- csl_cache$cache_path_get()
  unlink(file.path(path, "styles"), recursive = TRUE, force = TRUE)
  cli <- crul::HttpClient$new(styles_zip_url(), opts = list(...))
  cli$get(disk = file.path(path, "styles.zip"))
  utils::unzip(file.path(path, "styles.zip"), exdir = path)
  file.rename(file.path(path, "styles-distribution-master"), 
    file.path(path, "styles"))
  unlink(file.path(path, "styles", 
    Filter(function(x) !grepl("\\.csl|dependent", x), 
      list.files(file.path(path, "styles")))),
    recursive = TRUE, force = TRUE)
  unlink(file.path(path, "styles.zip"))
  message(sprintf("\nDone! Files put in %s", file.path(path, "styles")))
  invisible(file.path(path, "styles"))
}

styles_zip_url <- function() {
  "https://github.com/citation-style-language/styles-distribution/archive/master.zip"
}
