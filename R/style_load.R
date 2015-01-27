#' Load a CSL style
#'
#' @export
#' @import XML httr
#'
#' @param input URL or local file path
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @details This function fetches the style XML document, and parses it into
#' a more reasonble R list that's easy to navigate. If you want the raw XML,
#' see \code{\link{style_xml}}.
#' @examples \dontrun{
#' # Load a style from the Zotero style repository
#' jps <- style_load(input = 'http://zotero.org/styles/american-journal-of-political-science')
#' ## Query style information
#' jps$info
#' jps$title
#' jps$citation_format
#' jps$links_template
#' jps$editor
#' jps$author
#' }

style_load <- function(input, ...){
  out <- csl_GET(input, ...)
  xml <- XML::xmlParse(out)
  parse_xml(xml)
}

parse_xml <- function(x){
  childs <- xmlChildren(xmlChildren(x)$style)
  out <- list()
  for(i in seq_along(childs)){
    z <- childs[[i]]
    type <- get_name(z)
    out[[type]] <- switch(type,
           info = parse_links(z),
           editor = parse_editor(z),
           author = parse_author(z)
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

parse_links <- function(z){
  tmp <- xmlToList(z)
  cats <- tmp[names(tmp) %in% "category"]
  cats2 <- list()
  for(i in seq_along(cats)){
    cats2[[ names(cats[[i]]) ]] <- cats[[i]][[1]]
  }
  tmp <- c(tmp[!names(tmp) %in% "category"], cats2)
  tmp2 <- lapply(tmp, function(w){
    ll <- as.list(w)
    if(length(ll) == 1) ll[[1]] else ll
  })
  links <- tmp2[names(tmp2) %in% "link"]
  links2 <- list()
  for(i in seq_along(links)){
    links2[[paste0("links_", links[[i]]$rel)]] <- links[[i]]$href
  }
  tmp3 <- c(tmp2[!names(tmp2) %in% "link"], links2)
  setNames(tmp3, gsub("-", "_", names(tmp3)))
}

parse_editor <- function(x){
  tmp <- xmlToList(x)
  list(editor = as.list(tmp$names$.attrs),
       label = as.list(tmp$names$label),
       name = as.list(tmp$names$name))
}

parse_author <- function(x){
  tmp <- xmlToList(x)
  list(author = as.list(tmp$names$.attrs),
       label = as.list(tmp$names$label),
       name = as.list(tmp$names$name),
       substitute = as.list(unlist(unname(tmp$names$substitute))))
}
