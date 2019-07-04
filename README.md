
<!-- README.md is generated from README.Rmd. Please edit that file -->

# highlightr: highlight text in R output

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/JBGruber/highlightr.svg?branch=master)](https://travis-ci.org/JBGruber/highlightr)
[![Codecov test
coverage](https://codecov.io/gh/JBGruber/highlightr/branch/master/graph/badge.svg)](https://codecov.io/gh/JBGruber/highlightr?branch=master)
<!-- badges: end -->
<img src="man/figures/logo.png" align="right" width="120" />

When you hate paper and pens but still want to highlight stuff.

## Installation

You can install highlightr from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("JBGruber/highlightr")
```

## Usage

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

![highlightr.gif](./man/figures/highlightr.gif)
