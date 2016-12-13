
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

nes_get(nes_file, 11)
#> Warning in read_ocr_dt(dt, 1, "morpho"): The following morpho positions may
#> have bad OCR: 4
#>     state     name county storet_code lake_type drainage_area surface_area
#> 1 ARIZONA BIG LAKE APACHE        0401   NATURAL          <NA>         1.04
#>   mean_depth total_inflow retention_time alkalinity conductivity sechhi
#> 1       <NA>   9999909099         990999         77          101    2.9
#>      tp   po4  tin   tn
#> 1 0.032 0.001 0.09 0.82
nes_get(nes_file, 12)
#> Warning in read_ocr_dt(dt, 1, "morpho"): The following morpho positions may
#> have bad OCR: 4
#>   state                          name county storet_code lake_type
#> 1    IN FOOLS'HOLLOH LAKE (EUTROPHIC) NAVAJO        0402         _
#>   drainage_area surface_area mean_depth total_inflow retention_time
#> 1          <NA>        282.3       <NA>            7           0.08
#>   alkalinity conductivity sechhi    tp   po4  tin   tn
#> 1         81          152    0.8 0.059 0.014 0.09 0.66
```
