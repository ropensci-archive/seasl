#' List locally stored styles
#'
#' @export
#' @param style (character) Style name
#' @return If `style=NULL`, a list of length two, independent and dependent 
#' styles. If `style` is not `NULL`, then a full path to the style file is 
#' returned if the style exists.
#' @examples \dontrun{
#' csl_styles()
#' csl_styles("apa")
#' csl_styles("zdm")
#'
#' csl_style_exists("apa")
#' csl_style_exists("apaggg")
#' }
csl_styles <- function(style = NULL) {
  csl_cache$mkdir()
  mainpath <- file.path(csl_cache$cache_path_get(), "styles")
  deppath <- file.path(csl_cache$cache_path_get(), "styles", "dependent")
  mainff <- getfiles(mainpath)
  depff <- getfiles(deppath)
  all <- list(independent = mainff, dependent = depff)
  if (is.null(style)) {
    all
  } else {
    if ( style %in% all$independent ) {
      file.path(mainpath, paste0(style, ".csl"))
    } else if ( style %in% all$dependent ) {
      file.path(deppath, paste0(style, ".csl"))
    } else {
      NULL
    }
  }
}

getfiles <- function(x) gsub("\\.csl", "", list.files(x, pattern = ".csl"))

#' @export
#' @rdname csl_styles
csl_style_exists <- function(style) {
  out <- styles(style)
  if (is.null(out)) FALSE else TRUE
}
