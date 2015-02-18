#' Convert a path or URL to a location object.
#'
#' @export
#'
#' @param x Input.
#' @param ... Ignored.
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

as.location <- function(x, y, ...) UseMethod("as.location")

#' @export
#' @rdname as.location
as.location.character <- function(x, y, ...) check_location(x, y, ...)

#' @export
#' @rdname as.location
as.location.location <- function(x, y, ...) x

check_location <- function(x, y, ...){
  if(is.url(x)){
    as_location(x, "url")
  } else {
    path <- switch(y,
                   style = styles(x),
                   locale = locales(x))
    if(!file.exists(path)) stop("File does not exist", call. = FALSE)
    as_location(path.expand(path), "file")
  }
}

as_location <- function(x, type){
  structure(x, class="location", type=type)
}

#' @export
#' @rdname as.location
print.location <- function(x, ...){
  cat("<location>", "\n")
  cat("   Type: ", attr(x, "type"), "\n")
  cat("   Location: ", x[[1]], "\n")
}

is.url <- function(x, ...){
  grepl("https?://", x)
}
