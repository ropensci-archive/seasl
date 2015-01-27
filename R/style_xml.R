#' Get XML for a CSL style
#'
#' @export
#'
#' @param input URL or local file path
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @details This function fetches the style XML document. If you want parsed data,
#' see \code{\link{style_load}}.
#' @examples \dontrun{
#' style_xml('http://zotero.org/styles/american-journal-of-political-science')
#' style_xml('http://zotero.org/styles/american-journal-of-political-science', TRUE)
#' }

style_xml <- function(input, raw=FALSE, ...){
  out <- csl_GET(input, ...)
  if(raw)
    out
  else
    XML::xmlParse(out)
}