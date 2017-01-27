flist <- list.files(pattern  = "clean")

res <- lapply(flist, function(x) read.csv(x, stringsAsFactors = FALSE))
res <- do.call("rbind", res)

write.csv(res, "res.csv", row.names = FALSE)

