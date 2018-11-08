#' Get XML for a CSL style
#'
#' @export
#' @param input (character) URL or local file path. Required.
#' @param raw (logical) If `FALSE` (default) return parsed XML to class
#' `xml_document`. If `TRUE`, get character string of XML.
#' @param ... Curl options passed on to [crul::HttpClient]
#' @return an object of class `xml_document`, see \pkg{xml2}
#' to parse the object
#' @details This function fetches the style XML document. If you want parsed data,
#' see [csl_style_load()].
#' @examples \dontrun{
#' csl_style_xml('http://zotero.org/styles/american-journal-of-political-science')
#' csl_style_xml('http://zotero.org/styles/american-journal-of-political-science', TRUE)
#' }
csl_style_xml <- function(input, raw = FALSE, ...) {
  out <- csl_GET(input, ...)
  if (raw) return(out)
  xml2::read_xml(out)
}
