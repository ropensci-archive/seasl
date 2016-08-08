#' Get CSL styles or locales
#'
#' @export
#'
#' @param path (character) Base path to store files in. Defaults to your home path using
#' \code{Sys.getenv("HOME")}. Styles go to home/styles/ and locales to home/locales/.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#'
#' @examples \dontrun{
#' # Get styles
#' get_styles()
#'
#' # Get locales
#' get_locales()
#' }

get_styles <- function(path = NULL, ...){
  if(is.null(path)) path <- Sys.getenv("HOME")
  unlink(file.path(path, "styles"), recursive = TRUE, force = TRUE)
  httr::GET(styles_zip_url(), write_disk(file.path(path, "styles.zip"), overwrite = TRUE), ...)
  utils::unzip(file.path(path, "styles.zip"), exdir = path)
  file.rename(file.path(path, "styles-distribution-master"), file.path(path, "styles"))
  unlink(file.path(path, "styles", Filter(function(x) !grepl("\\.csl|dependent", x), list.files(file.path(path, "styles")))), recursive = TRUE, force = TRUE)
  unlink(file.path(path, "styles.zip"))
  message(sprintf("\nDone! Files put in %s", file.path(path, "styles")))
}

#' @export
#' @rdname get_styles
get_locales <- function(path = NULL, ...){
  if(is.null(path)) path <- Sys.getenv("HOME")
  unlink(file.path(path, "locales"), recursive = TRUE, force = TRUE)
  httr::GET(locales_zip_url(), write_disk(file.path(path, "locales.zip"), overwrite = TRUE), ...)
  utils::unzip(file.path(path, "locales.zip"), exdir = path)
  file.rename(file.path(path, "locales-master"), file.path(path, "locales"))
  unlink(file.path(path, "locales", Filter(function(x) !grepl("\\.xml|\\.json", x), list.files(file.path(path, "locales")))), recursive = TRUE, force = TRUE)
  message(sprintf("\nDone! Files put in %s", file.path(path, "locales")))
}

styles_zip_url <- function() "https://github.com/citation-style-language/styles-distribution/archive/master.zip"
locales_zip_url <- function() "https://github.com/citation-style-language/locales/archive/master.zip"

# styles_url <- function() "https://github.com/citation-style-language/styles-distribution"

# get_styles <- function(path = NULL, ...){
#   sha1 <- sha("citation-style-language", "styles-distribution")
#   fileurls <- file_urls(owner="citation-style-language", repo="styles-distribution", sha=sha1)
#   if(is.null(path)) path <- file.path(Sys.getenv("HOME"), "styles")
#   if(!file.exists(path)) dir.create(file.path(path, "dependent"), showWarnings = FALSE, recursive = TRUE)
#
#   pb <- txtProgressBar(min = 0, max = length(fileurls), initial = 0)
#   for(i in seq_along(fileurls)){
#     setTxtProgressBar(pb, i)
#
#     fpath <- if(grepl("dependent", fileurls[[i]])){
#       file.path(path, "dependent", basename(fileurls[[i]]))
#     } else {
#       file.path(path, basename(fileurls[[i]]))
#     }
#     httr::GET(fileurls[[i]], write_disk(path = fpath, overwrite = TRUE))
#   }
# }

# ghbase <- function() "https://api.github.com"
#
# sha <- function(owner, repo){
#   url <- sprintf("%s/repos/%s/%s/commits", ghbase(), owner, repo)
#   res <- httr::GET(url)
#   content(res)[[1]]$sha
# }
#
# file_urls <- function(owner, repo, sha){
#   url <- sprintf("%s/repos/%s/%s/git/trees/%s?recursive=1", ghbase(), owner, repo, sha)
#   res <- httr::GET(url)
#   out <- content(res)
#   ff <- Filter(function(x) grepl("\\.csl", x), sapply(out$tree, "[[", "path"))
#   base <- "https://raw.githubusercontent.com/citation-style-language/styles-distribution/master/"
#   paste0(base, ff)
# }

