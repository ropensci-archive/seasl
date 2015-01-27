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
jps <- style_load('http://zotero.org/styles/american-journal-of-political-science')
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
...
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
...
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
...
```


## Get raw XML


```r
style_xml('http://zotero.org/styles/american-journal-of-political-science')
#> <?xml version="1.0" encoding="utf-8"?>
#> <style xmlns="http://purl.org/net/xbiblio/csl" class="in-text" version="1.0" demote-non-dropping-particle="sort-only" default-locale="en-US">
#>   <info>
#>     <title>American Journal of Political Science</title>
#>     <title-short>AJPS</title-short>
#>     <id>http://www.zotero.org/styles/american-journal-of-political-science</id>
#>     <link href="http://www.zotero.org/styles/american-journal-of-political-science" rel="self"/>
#>     <link href="http://www.zotero.org/styles/american-political-science-association" rel="template"/>
#>     <link href="http://www.ajps.org/AJPS%20Style%20Guide.pdf" rel="documentation"/>
#>     <author>
...
```
