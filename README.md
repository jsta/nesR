
<!-- README.md is generated from README.Rmd. Please edit that file -->
nesR
====

Code to rescue (scrape) data from the National Eutrophication Survey archival PDF.

Installation
------------

### Prerequites

Until `magick` can handle local adaptive thresholding. This package requires you to be able to call the `imagemagick` `convert` command with `system()`.

You can install nesR from github with:

``` r
# install.packages("devtools")
devtools::install_github("jsta/nesR")
```

Usage
-----

### Load package

``` r
library(nesR)
```

### Get data

``` r
nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
                      package = "nesR")

pages <- c(11, 12)

lapply(pages, function(x) nes_get(nes_file, x))
  
```

References
==========

Brett, M. T., and M. M. Benjamin. 2007. A review and reassessment of lake phosphorus retention and the nutrient loading concept. Freshwater Biology.

Reckhow, K. H. 1988. Empirical models for trophic state in southeastern US lakes and reservoirs.
