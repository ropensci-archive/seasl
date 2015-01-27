csl
=======



`csl` is an R client for exploring CSL styles. 

* The [Citation Style Language 1.0.1 specification](http://citationstyles.org/downloads/specification.html)
* asdfadf

## Install


```r
install.packages("devtools")
devtools::install_github("sckott/csl")
```


```r
library("csl")
```

## Load CSL style from a URL


```r
jps <- load_style(input = 'http://zotero.org/styles/american-journal-of-political-science')
```

## Query style information


```r
jps$info
#> $title
#> [1] "American Journal of Political Science"
#> 
#> $title_short
#> [1] "AJPS"
#> 
#> $id
#> [1] "http://www.zotero.org/styles/american-journal-of-political-science"
#> 
#> $author
#> $author$name
#> [1] "Julian Onions"
#> 
#> $author$email
#> [1] "julian.onions@gmail.com"
#> 
#> 
#> $contributor
#> [1] "Sebastian Karcher"
#> 
#> $issn
#> [1] "0092-5853"
#> 
#> $eissn
#> [1] "1540-5907"
#> 
#> $summary
#> [1] "style for the AJPS Journal published by the midwest political science association, based on the APSA style"
#> 
#> $updated
#> [1] "2014-09-06T22:02:33+00:00"
#> 
#> $rights
#> $rights$text
#> [1] "This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 License"
#> 
#> $rights$.attrs
#>                                          license 
#> "http://creativecommons.org/licenses/by-sa/3.0/" 
#> 
#> 
#> $citation_format
#> [1] "author-date"
#> 
#> $field
#> [1] "political_science"
#> 
#> $links_self
#> [1] "http://www.zotero.org/styles/american-journal-of-political-science"
#> 
#> $links_template
#> [1] "http://www.zotero.org/styles/american-political-science-association"
#> 
#> $links_documentation
#> [1] "http://www.ajps.org/AJPS%20Style%20Guide.pdf"
```


```r
jps$title
#> [1] "American Journal of Political Science"
```


```r
jps$citation_format
#> [1] "author-date"
```


```r
jps$links_template
#> [1] "http://www.zotero.org/styles/american-political-science-association"
```


```r
jps$editor
#> $editor
#> $editor$variable
#> [1] "editor"
#> 
#> $editor$delimiter
#> [1] ", "
#> 
#> 
#> $label
#> $label$form
#> [1] "short"
#> 
#> $label$suffix
#> [1] " "
#> 
#> 
#> $name
#> $name$and
#> [1] "text"
#> 
#> $name$delimiter
#> [1] ", "
```


```r
jps$author
#> $author
#> $author$variable
#> [1] "author"
#> 
#> 
#> $label
#> $label$form
#> [1] "short"
#> 
#> $label$prefix
#> [1] ", "
#> 
#> 
#> $name
#> $name$`name-as-sort-order`
#> [1] "first"
#> 
#> $name$and
#> [1] "text"
#> 
#> $name$`sort-separator`
#> [1] ", "
#> 
#> $name$delimiter
#> [1] ", "
#> 
#> $name$`delimiter-precedes-last`
#> [1] "always"
#> 
#> 
#> $substitute
#> $substitute$variable
#> [1] "editor"
#> 
#> $substitute$macro
#> [1] "title"
```
