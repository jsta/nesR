#' ocr_nes_page
#' @param tif_clean file.path to tif image for ocr
#' @export
#' @importFrom tesseract ocr tesseract
#' @examples \dontrun{
#' nes_file <- system.file("extdata/national-eutrophication-survey_477.PDF",
#'                      package = "nesR")
#' nes_page <- 11
#' tif_clean <- extract_nes_page(nes_file, nes_page)
#' ocr_nes_page(tif_clean)
#' }
ocr_nes_page <- function(tif_clean){
	bad_char_blacklist <- tesseract(
		options = list(tessedit_char_blacklist = "!;¢?-,—"))
  ocr_txt <- tesseract::ocr(tif_clean, engine = bad_char_blacklist)
  strsplit(ocr_txt, "\n")[[1]]
}
