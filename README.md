
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

parse_nes(nes_get(nes_file, 11))
#> Warning in read_ocr_dt(dt, 1, "morpho"): The following morpho positions may
#> have bad OCR: 3
#> Warning in read_ocr_dt(strsplit(nut_txt, " ")[[5]], section_name = "nuts"):
#> The following nuts positions may have bad OCR: 6
#>     state     name county storet_code lake_type drainage_area surface_area
#> 1 ARIZONA BIG LAKE APACHE        0401   NATURAL          <NA>         <NA>
#>   mean_depth total_inflow retention_time alkalinity conductivity sechhi
#> 1        4.4         <NA>           <NA>         77          101    2.9
#>      tp   po4  tin   tn p_pnt_source_muni p_pnt_source_industrial
#> 1 0.032 0.007 0.09 0.82              <NA>                    <NA>
#>   p_pnt_source_septic p_nonpnt_source p_total n_pnt_source_muni
#> 1                <NA>            <NA>    <NA>              <NA>
#>   n_pnt_source_industrial n_pnt_source_septic n_nonpnt_source n_total
#> 1                    <NA>                <NA>            <NA>    <NA>
#>   p_total_out p_percent_retention p_surface_area_loading n_total_out
#> 1        <NA>                <NA>                   <NA>        <NA>
#>   n_percent_retention n_surface_area_loading
#> 1                <NA>                   <NA>
```

### Build database

As written, building the NES database requires GNU Make and the ability to run `R` commands using the `Rscript` command-line utility (aka doesn't work on Windows).

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
