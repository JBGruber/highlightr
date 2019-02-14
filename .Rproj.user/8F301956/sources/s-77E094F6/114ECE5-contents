
<!-- README.md is generated from README.Rmd. Please edit that file -->
highlightr: highlight text in R output
======================================

<img src="man/figures/logo.png" align="right" width="120" />

When you hate paper and pens but still want to highlight stuff.

Installation
------------

You can install highlightr from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("JBGruber/highlightr")
```

Usage
-----

``` r
library("highlightr")
library("tibble")
text <- c("This is a good test with some bad words", "bad guy vs good guy")
dict <- tibble(
  feature = c("good", "bad"),
  bg_colour = c("#2ca25f", "#de2d26")
)
highlight(text, dict)
```

<strong>1:</strong>
<p>
This is a <span style="background-color: #2ca25f"> <font color=''>good</font></span> test with some <span style="background-color: #de2d26"> <font color=''>bad</font></span> words
</p>
<strong>2:</strong>
<p>
<span style="background-color: #de2d26"> <font color=''>bad</font></span> guy vs <span style="background-color: #2ca25f"> <font color=''>good</font></span> guy
</p>
In `RStudio`:

![highlightr.gif](http://www.johannesbgruber.eu/img/highlightr.gif)
