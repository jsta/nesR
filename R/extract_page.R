
#' extract_nes_page
#' @export
#' @param nes_file file.path to NES pdf
#' @param nes_page numeric page number
#' @importFrom pdftools pdf_render_page
#' @importFrom tiff writeTIFF
#' @importFrom png writePNG
#' @importFrom magick image_read image_background image_flatten image_write
#' @examples \dontrun{
#' nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
#'                      package = "nesR")
#' nes_page <- 11
#' tif_clean <- extract_nes_page(nes_file, nes_page)
#' }

extract_nes_page <- function(nes_file, nes_page){

  pdf_page <- pdftools::pdf_render_page(nes_file, page = nes_page, dpi = 600)

  # tif_out <- paste0(tempfile(), ".tif")
  # tiff::writeTIFF(pdf_page, tif_out)
  tif_out <- paste0(tempfile(), ".png")
  png::writePNG(pdf_page, tif_out)

  res <- magick::image_read(tif_out)
  res <- magick::image_background(res, "white")
  res <- magick::image_flatten(res)

  magick::image_write(res, tif_out)

  tif_clean <- paste0(tempfile(), ".tif")
  system(paste0("convert ", tif_out, " -alpha Off -lat 30x30-2% ", tif_clean))

  res <- magick::image_read(tif_clean)
  res <- magick::image_contrast(magick::image_contrast(res))
  res <- magick::image_blur(res, radius = 1, sigma = 50)
  magick::image_write(res, tif_clean)
  # res <- magick::image_enhance(res)

  tif_clean
}
