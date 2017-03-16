
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
nes_file <- system.file("extdata/national-eutrophication-survey_477.PDF", 
                        package = "nesR")
res <- nes_get(nes_file, 89)
parse_nes(res)
#>    state      name              county storet_code   lake_type
#> 1 NEVADA LAKE MEAD CLARK NY; MOHAVE Az        3201 IMPOUNDMENT
#>   drainage_area surface_area mean_depth total_inflow retention_time
#> 1      434601.8       592.88       59.1       377.34            3.5
#>   alkalinity conductivity sechhi    tp   po4  tin   tn p_pnt_source_muni
#> 1        136          815    5.9 0.016 0.005 0.34 0.55            322055
#>   p_pnt_source_industrial p_pnt_source_septic p_nonpnt_source p_total
#> 1                    <NA>                <NA>              10 3370770
#>   n_pnt_source_muni n_pnt_source_industrial n_pnt_source_septic
#> 1            961520                    <NA>                 375
#>   n_nonpnt_source  n_total p_total_out p_percent_retention
#> 1        25918510 26880405      247325                  93
#>   p_surface_area_loading n_total_out n_percent_retention
#> 1                   6.23    11996385                  55
#>   n_surface_area_loading
#> 1                   45.3
```

### Build database

As written, building the NES database requires GNU Make and the ability to run `R` commands using the `Rscript` command-line utility (aka doesn't work on Windows). For best results, use a machine with at least 4 GB RAM.

``` bash
make PDFSOURCE=474 all
make PDFSOURCE=475 all
make PDFSOURCE=476 all
make PDFSOURCE=477 all
```

References
==========

Brett, M. T., and M. M. Benjamin. 2007. A review and reassessment of lake phosphorus retention and the nutrient loading concept. Freshwater Biology.

Reckhow, K. H. 1988. Empirical models for trophic state in southeastern US lakes and reservoirs.
