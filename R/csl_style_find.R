#' Search for a CSL style
#'
#' @export
#' @param x (character) a full or partial journal name
#' @return if no matches `NULL`. otherwise, one or more file paths
#' to the style file on your machine
#' @examples \dontrun{
#' # single match
#' csl_style_find(x = "American Journal of Epidemiology")
#' 
#' # many matches
#' csl_style_find(x = "American Journal")
#' csl_style_find(x = "pediatrics")
#' csl_style_find(x = "analysis and prevention")
#' 
#' # no matches
#' csl_style_find(x = "foo bar")
#' }
csl_style_find <- function(x) {
  styles_exist()
  assert(x, 'character')
  tmp <- csl_styles()
  # independent
  c(matchem(x, tmp$independent),
  # dependent
  matchem(x, tmp$dependent, FALSE))
}

matchem <- function(x, y, independent = TRUE) {
  yy <- gsub("-", " ", y)
  mtch <- grep(tolower(x), yy, ignore.case = TRUE)
  if (length(mtch) == 0) return(NULL)
  if (length(mtch) == 1) return(make_path(y[mtch], independent))
  if (length(mtch) > 1) {
    return(vapply(mtch, function(w) make_path(y[w], independent), ""))
  }
}

make_path <- function(x, independent = TRUE) {
  file.path(csl_cache$cache_path_get(), "styles", 
    paste0(if (!independent) "dependent/" else "", x, ".csl"))
}
