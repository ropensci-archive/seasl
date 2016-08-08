#' List locales, locally, or from the repository of locales
#'
#' @export
#' @param locale (character) Locale name
#' @return If \code{locale=NULL}, a list of locales. If \code{locale} is not NULL, then a
#' path to the locale file is returned if the locale exists.
#' @examples \dontrun{
#' locales()
#' locales("et")
#' locales("fr-FR")
#'
#' locale_exists("et")
#' locale_exists("cc")
#' locale_exists("fr-FR")
#' }

locales <- function(locale = NULL){
  path <- file.path(Sys.getenv("HOME"), "locales")
  ff <- getfilesloc(path)
  if (is.null(locale)) {
    ff
  } else {
    locs <- stats::setNames(lapply(ff, function(x){
      tmp <- strsplit(x, split = "-")[[1]][2:3]
      list(both = paste0(tmp, collapse = "-"), first = tmp[[1]], second = tmp[[2]])
    }), ff)

    if ( locale %in% pluck(locs, "first", "") ) {
      file.path(path, paste0(plmatch(locs, "first", locale), ".xml"))
    } else if ( locale %in% pluck(locs, "both") ) {
      file.path(path, paste0(plmatch(locs, "both", locale), ".xml"))
    } else {
      NULL
    }
  }
}

#' @export
#' @rdname locales
locale_exists <- function(locale){
  out <- locales(locale)
  if (is.null(out)) FALSE else TRUE
}

getfilesloc <- function(x) gsub("\\.xml", "", list.files(x, pattern = ".xml"))

plmatch <- function(x, what, loc){
  tmp <- pluck(x, what, "")
  names(tmp[tmp %in% loc])
}
