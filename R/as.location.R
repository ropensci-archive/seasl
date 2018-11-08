#' Convert a path or URL to a location object.
#'
#' @export
#'
#' @param x Input
#' @param type (character) One of style (default) or locale
#' @examples \donttest{
#' # Style files
#' as.location("apa")
#' as.location("teaching-and-learning-in-nursing")
#' as.location("regenerative-medicine-research")
#'
#' # A URL
#' url <- 'http://zotero.org/styles/american-journal-of-political-science'
#' as.location(url)
#' }

as.location <- function(x, type = "style") {
  UseMethod("as.location")
}

#' @export
as.location.character <- function(x, type = "style") check_location(x, type)

#' @export
as.location.location <- function(x, type = "style") x

check_location <- function(x, type = "style"){
  if (is.url(x)) {
    as_location(x, "url")
  } else {
    path <- switch(type,
                   style = csl_styles(x),
                   locale = csl_locales(x))
    tryfile <- tryCatch(file.exists(path), error = function(e) e)
    if (inherits(tryfile, "simpleError")) {
      stop("File does not exist, check spelling", call. = FALSE)
    }
    as_location(path.expand(path), "file")
  }
}

as_location <- function(x, type){
  structure(x, class = "location", type = type)
}

#' @export
print.location <- function(x, ...){
  cat("<location>", "\n")
  cat("   Type: ", attr(x, "type"), "\n")
  cat("   Location: ", x[[1]], "\n")
}

is.url <- function(x){
  grepl("https?://", x)
}
