seasl
=====



[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
![R build status](https://github.com/ropensci/seasl/workflows/R-CMD-check/badge.svg)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/seasl?color=C9A115)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/seasl)](https://cran.r-project.org/package=seasl)
<!-- [![Build Status](https://travis-ci.org/ropensci/seasl.svg?branch=master)](https://travis-ci.org/ropensci/seasl) -->

`seasl` is an R client for exploring CSL styles.

This package is inspired by the Ruby gem `csl`: https://github.com/inukshuk/csl-ruby

The Citation Style Language 1.0.1 specification: http://citationstyles.org/downloads/specification.html

Package API:

 - `csl_locales`
 - `as.location`
 - `csl_styles`
 - `csl_locale_exists`
 - `csl_cache`
 - `csl_fetch_styles`
 - `csl_style_find`
 - `csl_style_xml`
 - `csl_style_load`
 - `csl_style_exists`
 - `csl_locale_load`
 - `csl_fetch_locales`

## Install


```r
install.packages("seasl")
```

or


```r
remotes::install_github("ropensci/seasl")
```


```r
library("seasl")
```

## Download styles and locales

First, you may want to download style and locale files. `csl_fetch_styles()` and `csl_fetch_locales()`
download the files to your machine. See `?csl_cache` for caching information, including
how to change the cache location.

Styles retrieved from the Github repo at https://github.com/citation-style-language/styles-distribution


```r
csl_fetch_styles()
#>
#> Done! Files put in /Users/sckott/Library/Caches/R/seasl/styles
```

Locales retrieved from the Github repo at https://github.com/citation-style-language/locales


```r
csl_fetch_locales()
#>
#> Done! Files put in /Users/sckott/Library/Caches/R/seasl/locales
```

## File paths to CSL styles and locales

calling `csl_styles` without inputs gives all styles, with separate lists for 
dependent and independent styles


```r
csl_styles()
#> $independent
#>    [1] "academy-of-management-review"                                                                                        
#>    [2] "accident-analysis-and-prevention"                                                                                    
#>    [3] "aci-materials-journal"                                                                                               
#>    [4] "acm-sig-proceedings-long-author-list"                                                                                
#>    [5] "acm-sig-proceedings"                                                                                                 
#>    [6] "acm-sigchi-proceedings-extended-abstract-format"                                                                     
#>    [7] "acm-sigchi-proceedings"                                                                                              
#>    [8] "acm-siggraph"                                                                                                        
#>    [9] "acme-an-international-journal-for-critical-geographies"                                                              
...
```

calling `csl_styles` with an input gives the path to that style, if found


```r
csl_styles("apa")
#> [1] "/Users/sckott/Library/Caches/R/seasl/styles/apa.csl"
csl_styles("archeologie-medievale")
#> [1] "/Users/sckott/Library/Caches/R/seasl/styles/archeologie-medievale.csl"
```

Same patterns go for locales (note that there are far fewer locales than styles)


```r
# just locale names
csl_locales()
#>  [1] "locales-af-ZA" "locales-ar"    "locales-bg-BG" "locales-ca-AD"
#>  [5] "locales-cs-CZ" "locales-cy-GB" "locales-da-DK" "locales-de-AT"
#>  [9] "locales-de-CH" "locales-de-DE" "locales-el-GR" "locales-en-GB"
#> [13] "locales-en-US" "locales-es-CL" "locales-es-ES" "locales-es-MX"
#> [17] "locales-et-EE" "locales-eu"    "locales-fa-IR" "locales-fi-FI"
#> [21] "locales-fr-CA" "locales-fr-FR" "locales-he-IL" "locales-hr-HR"
#> [25] "locales-hu-HU" "locales-id-ID" "locales-is-IS" "locales-it-IT"
#> [29] "locales-ja-JP" "locales-km-KH" "locales-ko-KR" "locales-la"   
#> [33] "locales-lt-LT" "locales-lv-LV" "locales-mn-MN" "locales-nb-NO"
#> [37] "locales-nl-NL" "locales-nn-NO" "locales-pl-PL" "locales-pt-BR"
#> [41] "locales-pt-PT" "locales-ro-RO" "locales-ru-RU" "locales-sk-SK"
#> [45] "locales-sl-SI" "locales-sr-RS" "locales-sv-SE" "locales-th-TH"
#> [49] "locales-tr-TR" "locales-uk-UA" "locales-vi-VN" "locales-zh-CN"
#> [53] "locales-zh-TW"
```


```r
# when locale given, you get the full path
csl_locales("fr-FR")
#> [1] "/Users/sckott/Library/Caches/R/seasl/locales/locales-fr-FR.xml"
```

Alternatively, you can try to find a style by using `csl_style_find()`


```r
# single match
csl_style_find(x = "American Journal of Epidemiology")
#> [1] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-epidemiology.csl"
```


```r
# many matches
csl_style_find(x = "American Journal")
#>  [1] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-agricultural-economics.csl"                                     
#>  [2] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-archaeology.csl"                                                
#>  [3] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-botany.csl"                                                     
#>  [4] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-climate-change.csl"                                             
#>  [5] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-clinical-pathology.csl"                                         
#>  [6] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-enology-and-viticulture.csl"                                    
#>  [7] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-epidemiology.csl"                                               
#>  [8] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-health-behavior.csl"                                            
#>  [9] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-hypertension.csl"                                               
#> [10] "/Users/sckott/Library/Caches/R/seasl/styles/american-journal-of-medical-genetics.csl"                                           
...
```

## Load CSL style from a URL


```r
jps <- csl_style_load('http://www.zotero.org/styles/american-journal-of-political-science')
```

## Query style information


```r
jps$info
#> $title
#> [1] "American Journal of Political Science"
#> 
#> $`title-short`
#> [1] "AJPS"
#> 
#> $id
#> [1] "http://www.zotero.org/styles/american-journal-of-political-science"
#> 
#> $contributor
...
```


```r
jps$info$title
#> [1] "American Journal of Political Science"
```


```r
jps$macros
#> [[1]]
#> [[1]]$name
#> [1] "editor"
#> 
#> [[1]][[2]]
#> [[1]][[2]]$names
#> [[1]][[2]]$names$variable
#> [1] "editor"
#> 
#> [[1]][[2]]$names$delimiter
...
```


```r
jps$citation
#> $sort
#> $sort$key
#> list()
#> attr(,"macro")
#> [1] "author-short"
#> 
#> $sort$key
#> list()
#> attr(,"macro")
#> [1] "year-date"
...
```


```r
jps$bibliography
#> $attributes
#> $attributes$`hanging-indent`
#> [1] "true"
#> 
#> $attributes$`et-al-min`
#> [1] "4"
#> 
#> $attributes$`et-al-use-first`
#> [1] "1"
#> 
...
```

## Get raw XML


```r
csl_style_xml('http://www.zotero.org/styles/american-journal-of-political-science')
#> {xml_document}
#> <style class="in-text" version="1.0" demote-non-dropping-particle="sort-only" default-locale="en-US" xmlns="http://purl.org/net/xbiblio/csl">
#>  [1] <info>\n  <title>American Journal of Political Science</title>\n  <title ...
#>  [2] <macro name="editor">\n  <names variable="editor" delimiter=", ">\n    < ...
#>  [3] <macro name="author">\n  <names variable="author">\n    <name name-as-so ...
#>  [4] <macro name="author-short">\n  <names variable="author">\n    <name form ...
#>  [5] <macro name="access">\n  <choose>\n    <if type="legal_case" match="none ...
#>  [6] <macro name="title">\n  <choose>\n    <if type="bill book graphic legal_ ...
#>  [7] <macro name="legal_case">\n  <group prefix=" " delimiter=" ">\n    <text ...
#>  [8] <macro name="publisher">\n  <choose>\n    <if type="thesis" match="none" ...
...
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/seasl/issues).
* License: MIT
* Citation: execute `citation(package = 'seasl')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/seasl/blob/master/CODE_OF_CONDUCT.md
