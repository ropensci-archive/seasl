#' List styles, locally, or from the CSL repository of styles
#'
#' @export
#' @param style (character) Style name
#' @return If \code{style=NULL}, a list of length two, independent and dependent styles.
#' If \code{style} is not NULL, then a path to the style file is returned if the style
#' exists.
#' @examples \dontrun{
#' styles()
#' styles("apa")
#' styles("zdm")
#'
#' style_exists("apa")
#' style_exists("apaggg")
#' }

styles <- function(style = NULL){
  mainpath <- file.path(Sys.getenv("HOME"), "styles")
  deppath <- file.path(Sys.getenv("HOME"), "styles", "dependent")
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
#' @rdname styles
style_exists <- function(style){
  out <- styles(style)
  if (is.null(out)) FALSE else TRUE
}