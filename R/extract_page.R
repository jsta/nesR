
#' extract_nes_page
#' @export
#' @importFrom pdftools pdf_render_page
#' @importFrom tiff writeTIFF
#' @importFrom magick image_read image_background image_flatten image_write
#' @examples \dontrun{
#' nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
#'                      package = "nesR")
#' nes_page <- 11
#' tif_clean <- extract_nes_page(nes_file, nes_page)
#' }

extract_nes_page <- function(nes_file, nes_page){

  pdf_page <- pdftools::pdf_render_page(nes_file, page = nes_page, dpi = 600)

  tif_out <- paste0(tempfile(), ".tif")
  tiff::writeTIFF(pdf_page, tif_out)

  res <- magick::image_read(tif_out)
  res <- magick::image_background(res, "white")
  res <- magick::image_flatten(res)
  magick::image_write(res, tif_out)

  tif_clean <- paste0(tempfile(), ".tif")

  system(paste0("convert ", tif_out, " -alpha Off ", tif_clean))

  tif_clean
}
