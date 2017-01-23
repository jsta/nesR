args <- commandArgs(trailingOnly = TRUE)

print(args)
library(nesR)
nes_file <- nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
                                    package = "nesR")
nes_get(nes_file, args)
