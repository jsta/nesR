#' nes_get
#'
#' @export
#' @param nes_file file.path to NES pdf
#' @param nes_page numeric page number
#' @examples \dontrun{
#' nes_file <- system.file("extdata/national-eutrophication-survey_477.PDF",
#'                      package = "nesR")
#' nes_page <- 11
#' nes_get(nes_file, nes_page)
#' }

nes_get <- function(nes_file, nes_page){
  tif_clean <- extract_nes_page(nes_file, nes_page)
  raw_txt   <- ocr_nes_page(tif_clean)
  parse_nes(raw_txt)
}


