#' generate_page_list
#' @param pdfsource numeric designation of the nes pdf source
#' @param outdir file.path to output directory
#' @export
#' @importFrom pdftools pdf_info
#' @examples \dontrun{
#' generate_page_list(477)
#' }
generate_page_list <- function(pdfsource, outdir = "."){
  flist <- list.files(system.file("extdata", package = "nesR"),
                      pattern = paste0(pdfsource, ".PDF"),
                      include.dirs = TRUE,
                      full.names = TRUE)

  pages <- 11:pdftools::pdf_info(flist)$pages
  write(paste0(pages, ".csv"), file.path(outdir, "pages.txt"))
  write(paste0(pages, "_clean.csv"), file.path(outdir, "pages_clean.txt"))
}
