#' Load a CSL locale
#'
#' @export
#' @param input URL or local file path
#' @param ... Curl options passed on to [crul::HttpClient]
#' @details This function fetches the style XML document, and parses it into
#' a more reasonble R list that's easy to navigate. If you want the raw XML,
#' see `locale_xml`
#' @examples \dontrun{
#' # Load a locale from the CSL github repo
#' de_DE <- 'https://github.com/citation-style-language/locales/raw/master/locales-de-DE.xml'
#' res <- csl_locale_load(de_DE)
#' ## Query style information
#' res$info
#' res$info$translators
#' res$info$license
#' res$info$date_updated
#' res$dates
#' res$style_options
#' res$terms
#'
#' # Load from a local style file
#' ## just specify the style and we read from the local style files
#' csl_locale_load(input="fr-FR")
#' }
csl_locale_load <- function(input, ...){
  input <- as.location(input, "locale")
  out <- switch(attr(input, "type"),
                file = input[[1]],
                url = csl_GET(input, ...)
  )
  xml <- xml2::read_xml(out)
  xml2::xml_ns_strip(xml)
  parse_locale_xml(xml)
}

parse_locale_xml <- function(x) {
  childs <- xml2::xml_children(x)
  info <- parse_locale_info(xml2::xml_find_all(childs, "//info"))
  dates <- xml2::xml_find_all(childs, "//date")
  dates <- parse_date(dates)
  style_options <- as.list(
    xml2::xml_attrs(xml2::xml_find_all(x, "//style-options"))[[1]])
  terms <- parse_terms(xml2::xml_find_all(childs, "//terms/term"))
  list(info = info, dates = dates, style_options = style_options, 
    terms = terms)
}

parse_locale_info <- function(z){
  nms <- xml2::xml_text(xml2::xml_find_all(z, "translator/name"))
  lic <- xml2::xml_text(xml2::xml_find_all(z, "rights"))
  date <- xml2::xml_text(xml2::xml_find_all(z, "updated"))
  list(translators = nms, license = lic, date_updated = date)
}

parse_date <- function(x) {
  lapply(x, function(z) {
    form <- xml2::xml_attr(z, "form")
    tmp <- lapply(xml2::xml_find_all(z, "date-part"), function(w) {
      as.list(xml2::xml_attrs(w))
    })
    list(form = form, date_parts = tmp)
  })
}

xml_node_as_list <- function(x) {
  as.list(stats::setNames(xml2::xml_text(x), xml2::xml_name(x)))
}

xml_attr_as_list <- function(x) as.list(xml2::xml_attrs(x))

parse_terms <- function(x) {
  lapply(x, function(z) {
    atts <- as.list(xml2::xml_attrs(z))
    ch <- xml2::xml_children(z)
    if (length(ch) == 0) vals <- xml2::xml_text(z)
    if (length(ch) > 0) {
      vals <- lapply(ch, xml_node_as_list)
    }
    c(atts, unlist(vals, FALSE))
  })
}
