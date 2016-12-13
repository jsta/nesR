
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

### Prep a pdf page

``` r
nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
                      package = "nesR")
nes_page <- 11
nes_page_path <- extract_nes_page(nes_file, nes_page)
```

``` r
parse_nes(nes_page_path)
#> Warning in read_ocr_dt(dt, 1, "morpho"): The following morpho positions may
#> have bad OCR: 3The following morpho positions may have bad OCR: 4
#>     state     name county storet_code lake_type drainage_area surface_area
#> 1 ARIZONA BIG LAKE APACHE        0401   NATURAL          <NA>         <NA>
#>   mean_depth total_inflow retention_time alkalinity conductivity  tp   po4
#> 1       <NA>         <NA>         990999         77          101 2.9 0.032
#>     tin   tn
#> 1 0.007 0.09
```
