#' Load a CSL style
#'
#' @export
#' @param input URL or local file path
#' @param ... Curl options passed on to [crul::HttpClient]
#' @details This function fetches the style XML document, and parses it into
#' a more reasonble R list that's easy to navigate. If you want the raw XML,
#' see [csl_style_xml()]
#' @return named list, including slots for
#'
#' - info: basic top level information
#' - locale: locale information, if it exists
#' - macros: macros, 1 to many
#' - citation: the citation format, very messy now as the format is messy,
#' parsed with [xml2::as_list]
#' - bibliography: very messy for now, we just run [xml2::as_list] on this
#' element as it's complicated to parse
#'
#' @examples
#' # Load a style from the Zotero style repository
#' x <- 'http://www.zotero.org/styles/american-journal-of-political-science'
#' if (crul::ok(x)) {
#' jps <- csl_style_load(x)
#'
#' ## Query style information
#' jps$info
#' jps$locale
#' jps$macros
#' jps$citation
#' jps$bibliography
#' }
#'
#' \dontrun{
#' # fetch styles
#' csl_fetch_styles()
#' # Load from a local style file
#' ## just specify the style and we read from the local style files
#' csl_style_load(input="apa")
#' csl_style_load("computer-und-recht")
#' csl_style_load("bulletin-de-correspondance-hellenique")
#' }
csl_style_load <- function(input, ...) {
  input <- as.location(input)
  out <- switch(attr(input, "type"),
                file = input[[1]],
                url = csl_GET(input, ...)
  )
  xml <- xml2::read_xml(out)
  xml2::xml_ns_strip(xml)
  parse_style_xml(xml)
}

parse_style_xml <- function(x) {
  childs <- xml2::xml_children(x)
  info <- parse_info(childs[[1]])
  loc_ale <- xml2::as_list(xml2::xml_find_first(x, "locale"))
  macros <- childs[sapply(childs, xml2::xml_name) == "macro"]
  macros_ <- lapply(macros, parse_macro)
  # cite <- parse_citation(xml2::xml_find_first(x, "citation"))
  cite <- xml2::as_list(xml2::xml_find_first(x, "citation"))
  biblio <- parse_bibliography(xml2::xml_find_first(x, "bibliography"))
  list(info = info, locale = loc_ale, macros = macros_, citation = cite,
    bibliography = biblio)
}

get_name <- function(x){
  tmp <- xml2::xml_name(x)
  if (tmp == "macro") {
    xml2::xml_attr(x, "name")
  } else {
    tmp
  }
}

# parse_citation <- function(x) {
#   atts <- as.list(xml2::xml_attrs(x))
#   ch <- xml2::xml_children(x)
#   tmp <- lapply(ch, function(z) {
#     switch(
#       xml2::xml_name(z),
#       sort = {
#         list(
#           sort = sapply(
#             xml2::xml_children(z), function(w) {
#               stats::setNames(as.list(xml2::xml_attrs(w)), xml2::xml_name(w))
#             })
#         )
#       },
#       layout = {
#         ch <- xml2::xml_children(z)
#         switch(
#           xml2::xml_name(ch),
#           group = parse_group(ch)
#         )
#       }
#     )
#   })
#   list(attributes = atts, unlist(tmp, FALSE))
# }

parse_bibliography <- function(x) {
  # attributes
  atts <- as.list(xml2::xml_attrs(x))

  # sort
  st <- xml2::xml_find_all(x, "sort")
  so_rt <- NULL
  if (!is.na(st) %||% FALSE) {
    so_rt <- list(key = lapply(xml2::xml_children(st), xml_attr_as_list))
  }

  # layout
  lyt <- xml2::xml_find_all(x, "layout")
  lay_out <- NULL
  if (!is.na(lyt)) {
    lay_out <- xml2::as_list(lyt)
  }

  list(attributes = atts, sort = so_rt, layout = lay_out)
}

parse_group <- function(x) {
  list(
    attributes = as.list(xml2::xml_attrs(x)),
    stats::setNames(
      lapply(xml2::xml_children(x), function(n) {
        switch(
          xml2::xml_name(n),
          group = {
            list(
              attributes = as.list(xml2::xml_attrs(n)),
              stats::setNames(
                lapply(xml2::xml_children(n), function(z) as.list(xml2::xml_attrs(z))),
                xml2::xml_name(xml2::xml_children(n))
              )
            )
          },
          text = parse_text(n)
        )
      }),
      xml2::xml_name(xml2::xml_children(x))
    )
  )
}

parse_text <- function(x) {
  stats::setNames(
    list(as.list(xml2::xml_attrs(x))),
    xml2::xml_name(x)
  )
}

parse_info <- function(z){
  tmp <- list(
    title = xml2::xml_text(xml2::xml_find_first(z, "title")),
    `title-short` = xml2::xml_text(xml2::xml_find_first(z, "title-short")),
    id = xml2::xml_text(xml2::xml_find_first(z, "id")),
    contributor = xml2::xml_text(xml2::xml_find_first(z, "contributor")),
    issn = xml2::xml_text(xml2::xml_find_first(z, "issn")),
    eissn = xml2::xml_text(xml2::xml_find_first(z, "eissn")),
    summary = xml2::xml_text(xml2::xml_find_first(z, "summary")),
    updated = xml2::xml_text(xml2::xml_find_first(z, "updated")),
    license = xml2::xml_attr(xml2::xml_find_first(z, "rights"), "license"),
    author = list(
      name = xml2::xml_text(xml2::xml_find_first(z, "author/name")),
      email = xml2::xml_text(xml2::xml_find_first(z, "author/email"))
    ),
    category = list(
      `citation-format` = xml2::xml_attr(xml2::xml_find_first(z, "category[@citation-format]"), "citation-format"),
      field = xml2::xml_attr(xml2::xml_find_first(z, "category[@field]"), "field")
    )
  )
  links <- xml2::xml_find_all(z, "link")
  links2 <- list()
  for (i in seq_along(links)) {
    links2[[paste0("links_", xml2::xml_attr(links[[i]], "rel"))]] <- xml2::xml_attr(links[[i]], "href")
  }
  c(tmp, links2)
}

parse_macro <- function(m){
  mm <- xml2::xml_children(m)
  c(
    name = xml2::xml_attr(m, "name"),
    lapply(mm, function(w) {
      switch(
        xml2::xml_name(w),
        names = {
          tmp <- xml2::as_list(w)
          list(names = c(
            vardrop(attributes(tmp), "names"),
            lapply(tmp, attributes)
          ))
        },
        choose = {
          ifout <- elseout <- list()

          # if
          i_f <- xml2::xml_find_first(w, "if")
          if (xml2::xml_length(i_f) > 0) {
            if (xml2::xml_name(xml2::xml_child(i_f)) == "choose") {
              i_f2 <- xml2::xml_find_first(xml2::xml_child(i_f), "if")
              tmp <- xml2::as_list(i_f2)
              ifout <- list(
                `if` = list(
                  attributes = vardrop(attributes(tmp), "names"),
                  group = list(
                    vardrop(attributes(tmp$group), "names"),
                    text = vardrop(attributes(tmp$group$text), "names"),
                    group = list(
                      text = vardrop(attributes(tmp$group$group$text), "names"),
                      date = lapply(tmp$group$group$date, function(x) vardrop(attributes(x), "names"))
                    )
                  )
                )
              )
            } else {
              ifout <- list(
                `if` = stats::setNames(list(
                  as.list(xml2::xml_attrs(i_f)),
                  list(
                    as.list(xml2::xml_attrs(xml2::xml_child(i_f)))
                  )
                ), c("attributes", xml2::xml_name(xml2::xml_child(i_f))))
              )
            }
          }

          # else
          el_se <- xml2::xml_find_first(w, "else")
          if (xml2::xml_length(el_se) > 0) {
            if (xml2::xml_name(xml2::xml_child(el_se)) == "choose") {
              "stuff"
            } else {
              elseout <- list(
                `else` = stats::setNames(list(
                  as.list(xml2::xml_attrs(el_se)),
                  list(
                    as.list(xml2::xml_attrs(xml2::xml_child(el_se)))
                  )
                ), c('attributes', xml2::xml_name(xml2::xml_child(el_se))))
              )
            }
          }

          return(c(ifout, elseout))
        },
        group = {
          list(
            group = list(
              attributes = as.list(xml2::xml_attrs(w)),
              stats::setNames(
                lapply(xml2::xml_children(w), function(z) as.list(xml2::xml_attrs(z))),
                xml2::xml_name(xml2::xml_children(w))
              )
            )
          )
        },
        text = {
          stats::setNames(
            list(as.list(xml2::xml_attrs(w))),
            xml2::xml_name(w)
          )
        }
      )
    })
  )
}

vardrop <- function(x, z) x[!names(x) %in% z]

# THESE AREN'T USED RIGHT NOW
# parse_editor <- function(m){
#   list(
#     macro = xml2::xml_attr(m, 'name'),
#     editor = as.list(xml2::xml_attrs(x)[[1]]),
#     label = as.list(xml2::xml_attrs(xml2::xml_find_all(x, "label"))[[1]]),
#     name = as.list(xml2::xml_attrs(xml2::xml_find_all(x, "name"))[[1]])
#   )
# }

# parse_author <- function(x){
#   x <- xml2::xml_children(x)
#   tmp <- list(
#     author = as.list(xml2::xml_attrs(x)[[1]]),
#     name = as.list(xml2::xml_attrs(xml2::xml_find_all(x, "name"))[[1]]),
#     substitute = sapply(xml2::xml_attrs(xml2::xml_children(xml2::xml_find_all(x, "substitute"))), as.list)
#   )
#   if (length(xml2::xml_find_all(x, "label")) != 0) {
#     tmp$label <- as.list(xml2::xml_attrs(xml2::xml_find_all(x, "label"))[[1]])
#   }
#   tmp
# }

# parse_access <- function(x){
#   x <- xml2::xml_children(x)
#   tmp <- list(
#     author = as.list(xml2::xml_attrs(x)[[1]]),
#     name = as.list(xml2::xml_attrs(xml2::xml_find_all(x, "name"))[[1]]),
#     substitute = sapply(xml2::xml_attrs(xml2::xml_children(xml2::xml_find_all(x, "substitute"))), as.list)
#   )
#   if (length(xml2::xml_find_all(x, "label")) != 0) {
#     tmp$label <- as.list(xml2::xml_attrs(xml2::xml_find_all(x, "label"))[[1]])
#   }
#   tmp
# }
