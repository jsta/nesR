
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

nes_get(nes_file, 11)
#>  [1] "COMPENDIUM OF NATIONAL EUTROPHICATION SURVEY LAKES IN ARIZONA '"                                          
#>  [2] "NAME - BIG LAKE , (EUTRoPHIC) ."                                                                          
#>  [3] "COUNTY ‘ - APACHE"                                                                                        
#>  [4] "STORET N0. - 0401 ‘ HORKING PAPER NO. 726. NTIS ACCESSION No. Pa-279 ass/A8"                              
#>  [5] "I. MORPHOMETRY . - '"                                                                                     
#>  [6] "' - LAKE TYPE DRAINAGE AREA SURFACE AREA MEAN DEPTH ’ TOTAL INFLOM RETENTION TIME"                        
#>  [7] "' (50 KM) (50 KM) (METERS) (CMS) (YEARS)"                                                                 
#>  [8] "NATURAL Duuahogooo 1,Q4 4.4 ooanocoooé 999599"                                                            
#>  [9] "II. PHYSICAL AND CHEMICAL CHARACTERISTICS ."                                                              
#> [10] "MEDIAN MEDIAN MEAN SECCHI DISC MEDIAN MEDIAN MEDIAN . MEDIAN"                                             
#> [11] "- ALKALINITYIMG/L) CONDUCTIVITY(UMHOS) (METERS) ‘ TOTAL P(MG/L) ORTHO P(MG/L) INORG N(MG/L) TOTAL N(MG/L)"
#> [12] "77. 101. 2.9 0.032 0.007 0.090 0.820"                                                                     
#> [13] "III. BIOLOGICAL CHARACTERISTICS (LAKE)"                                                                   
#> [14] "MEAN CHLOROPHYLL A ALGAL ASSAY CONTROL YIELD LIMITING NUTRIENT AT SAMPLING TIME"                          
#> [15] "(UG/L) . (MG/L--ORY MT) ."                                                                                
#> [16] "2.9 0.2 - 9.5 ( 2) ( 6/19/75) N (10/ 6/75) N"                                                             
#> [17] "SUMMARY OF PHYTOPLANKTON DATA _"                                                                          
#> [18] "6/19/75 10/ 6/75 -"                                                                                       
#> [19] "GENERA . COUNT GENERA COUNT"                                                                              
#> [20] "CRYPTOMONAS 92 APHANOTHECE 430"                                                                           
#> [21] "SCHROEDERIA 23 MELOSIRA 137 '"                                                                            
#> [22] "CYSTS 23 CHROOMONAS 137 _ '"                                                                              
#> [23] "- TRACHELOMONAS 23 ASTERIONELLA 69"                                                                       
#> [24] "EUGLENA 23 COELOSPHAERIUM 69"                                                                             
#> [25] "OTHER 0 OTHER - 113 ."                                                                                    
#> [26] "- (:9"                                                                                                    
#> [27] "TOTAL 189 TOTAL 1005 '"                                                                                   
#> [28] "Iv. NUTRIENT LOADING CHARACTERISTICStLAME)"                                                               
#> [29] "A. INPUT — '"                                                                                             
#> [30] "- -. POINT SOURCE POINT SOURCE POINT SOURCE NON-POINT SOURCE TOTAL LOADING"                               
#> [31] "MUNICIPAL (KG/YR) INDUSTRIAL (KG/YR) SEPTIC TANKS (KG/YR) (KG/YR) (KG/YR)"                                
#> [32] "PHOSPHORUS ﬁiHHHHHHHH’ ﬁﬁﬁﬁﬁﬁﬂﬁﬁﬁ ﬁOGﬁdOOQGO . O§O§§609§O 09.90.9990"                                     
#> [33] "NITROGEN anguoaoaoa Raoaaooooa ooaooooooo Dooooaoooé . 9959960909"                                        
#> [34] "8. OUTPUT"                                                                                                
#> [35] "OUTLET(S) PERCENT LAKE SURFACE AREA LOADING RATE"                                                         
#> [36] "(KG/YR) RETENTION (G/SO M/YR) ."                                                                          
#> [37] "PHOSPHORUS ouoaooogoo Paaoa Raaoooonoa . ."                                                               
#> [38] "NITROGEN 96960159991} 9919915 QCHHHDOYH'DGG ."                                                            
#> [39] "9°99 LAKE SAMPLING ONLY «99* -"                                                                           
#> [40] ""
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
