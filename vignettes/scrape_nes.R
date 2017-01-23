args <- commandArgs(trailingOnly = TRUE)

print(args)
library(nesR)
nes_file <- nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
                                    package = "nesR")

res <- nes_get(nes_file, as.numeric(args))

if(as.numeric(args) == 11){
  write.table(res, file = "res.csv", append = TRUE, row.names = FALSE, col.names = TRUE, sep = ",")
}else{
  write.table(res, file = "res.csv", append = TRUE, row.names = FALSE, col.names = FALSE, sep = ",")
}


