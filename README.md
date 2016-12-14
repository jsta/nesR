
<!-- README.md is generated from README.Rmd. Please edit that file -->
nesR
====

Code to scrape data from the National Eutrophication Survey archival PDF

Installation
------------

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
#> Warning in read_ocr_dt(dt, 1, "morpho"): The following morpho positions may
#> have bad OCR: 6
#> [[1]]
#>     state       name county storet_code lake_type drainage_area
#> 1 ARIZONA BIG LAKE . APACHE        0401   NATURAL    9999999999
#>   surface_area mean_depth total_inflow retention_time alkalinity
#> 1         1.94        4.4   9999999999         999999         77
#>   conductivity sechhi    tp   po4  tin   tn
#> 1          101    2.9 0.032 0.007 0.09 0.82
#> 
#> [[2]]
#>     state              name county storet_code   lake_type drainage_area
#> 1 ARIZONA FOOLS'HOLLOH LAKE NAVAJO        0402 IMPOUNDMENT         282.3
#>   surface_area mean_depth total_inflow retention_time alkalinity
#> 1         0.57          7         0.08           <NA>         81
#>   conductivity sechhi    tp   po4  tin   tn
#> 1          152    0.8 0.059 0.014 0.09 0.66
```
