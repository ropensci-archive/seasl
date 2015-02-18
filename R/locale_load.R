#' Load a CSL locale
#'
#' @export
#'
#' @param input URL or local file path
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @details This function fetches the style XML document, and parses it into
#' a more reasonble R list that's easy to navigate. If you want the raw XML,
#' see \code{\link{locale_xml}}.
#' @examples \dontrun{
#' # Load a style from the Zotero style repository
#' jps <- locale_load(input = 'http://zotero.org/styles/american-journal-of-political-science')
#' ## Query style information
#' jps$info
#' jps$title
#' jps$citation_format
#' jps$links_template
#' jps$editor
#' jps$author
#'
#' # Load from a local style file
#' ## just specify the style and we read from the local style files
#' locale_load(input="fr-FR")
#' locale_load(input="zdm")
#' }

locale_load <- function(input, ...){
  input <- as.location(input, y="locale")
  out <- switch(attr(input, "type"),
                file = input[[1]],
                url = csl_GET(input, ...)
  )
  xml <- XML::xmlParse(out)
  parse_locale_xml(xml)
}

parse_locale_xml <- function(x){
  childs <- xmlChildren(xmlChildren(x)$locale)
  out <- list()
  for(i in seq_along(childs)){
    z <- childs[[i]]
    type <- get_name(z)
    out[[type]] <- switch(type,
        info = parse_info(z),
        style_options = parse_so(z),
        date = parse_date(z)
    )
  }
  c(out, out$info)
}

get_name <- function(x){
  tmp <- xmlName(x)
  if(tmp == "macro")
    xmlAttrs(x)[[1]]
  else
    tmp
}

parse_info <- function(z){
  tmp <- xmlToList(z)
  tmp$rights <- modifyList(tmp$rights, list(license = tmp$rights$.attrs[["license"]], .attrs = NULL))
  tmp
}

parse_so <- function(x) as.list(xmlAttrs(x))

parse_date <- function(x){
  lapply(x, function(z){
    tmp <- xmlToList(z)
    out <- list()
    for(i in seq_along(tmp)){
      out[[ names(tmp[i]) ]] <- as.list(tmp[[i]])
    }
    out
  })
}

parse_author <- function(x){
  tmp <- xmlToList(x)
  list(author = as.list(tmp$names$.attrs),
       label = as.list(tmp$names$label),
       name = as.list(tmp$names$name),
       substitute = as.list(unlist(unname(tmp$names$substitute))))
}
