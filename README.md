
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

nes_get(nes_file, 11)
#> Warning in read_ocr_dt(dt, 1, "morpho"): The following morpho positions may
#> have bad OCR: 3
#>     state     name county storet_code lake_type drainage_area surface_area
#> 1 ARIZONA BIG LAKE APACHE        0401   NATURAL          <NA>         <NA>
#>   mean_depth total_inflow retention_time alkalinity conductivity sechhi
#> 1        4.4         <NA>           <NA>         77          101    2.9
#>      tp   po4  tin   tn
#> 1 0.032 0.007 0.09 0.82
```

References
==========

Brett, M. T., and M. M. Benjamin. 2007. A review and reassessment of lake phosphorus retention and the nutrient loading concept. Freshwater Biology.

Reckhow, K. H. 1988. Empirical models for trophic state in southeastern US lakes and reservoirs.
