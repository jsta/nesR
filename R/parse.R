#' parse_nes
#' @param tif_clean file.path to tif image for ocr
#' @export
#' @importFrom purrr flatten
#' @importFrom tesseract ocr
#' @examples \dontrun{
#' nes_file <- system.file("extdata/national-eutrophication-survey_1975.PDF",
#'                      package = "nesR")
#' nes_page <- 12
#' tif_clean <- extract_nes_page(nes_file, nes_page)
#' parse_nes(tif_clean)
#' }

parse_nes <- function(tif_clean){
  ocr_txt <- tesseract::ocr(tif_clean)
  ocr_txt <- strsplit(ocr_txt, "\n")[[1]]

  morpho_pos <- grep("MORPHOMETRY", ocr_txt)
  phys_chem_pos <- grep("PHYSICAL", ocr_txt)
  bio_pos <- grep("BIOLOGICAL", ocr_txt)
  nut_pos <- grep("NUTRIENT", ocr_txt)

  metadata <- parse_metadata(ocr_txt[1:(morpho_pos - 1)])

  morphometry <- parse_morpho(ocr_txt[morpho_pos:(phys_chem_pos - 1)])

  phys_chem <- parse_phys_chem(ocr_txt[phys_chem_pos:(bio_pos - 1)])

  # bio <- ocr_txt[bio_pos:(nut_pos - 1)]
  #
  # nutrients <- ocr_txt[nut_pos:length(ocr_txt)]


  res <- list(metadata = metadata,
              morphometry = morphometry,
              phys_chem = phys_chem
              # bio = bio,
              # nutrients = nutrients
  )

  data.frame(purrr::flatten(res))

}

parse_metadata <- function(meta_txt){

  state <- strsplit(meta_txt[1], " ")[[1]]
  state <- state[nchar(state) > 1]
  state <- state[length(state)]

  name <- strsplit(meta_txt[2], "-")[[1]][2]
  name <- strsplit(name, ",")[[1]][1]
  name <- strsplit(name, "\\(")[[1]][1]
  name <- trimws(name)

  county <- strsplit(meta_txt[3], "-")[[1]][2]
  county <- trimws(county)

  storet_code <- strsplit(meta_txt[4], "-")[[1]][2]
  storet_code <- strsplit(storet_code, " ")[[1]][2]

  list(state = state, name = name, county = county, storet_code = storet_code)
}

parse_phys_chem <- function(phys_chem_txt){
  dt <- strsplit(phys_chem_txt, " ")[[4]]
  dt <- read_ocr_dt(dt, section_name = "phys_chem")

  alkalinity <- dt[1]
  conductivity <- dt[2]
  sechhi <- dt[3]
  tp <- dt[4]
  po4 <- dt[5]
  tin <- dt[6]
  tn <- dt[7]

  list(alkalinity = alkalinity, conductivity = conductivity, sechhi = sechhi,
       tp = tp, po4 = po4, tin = tin, tn = tn)
}

parse_morpho <- function(morpho_txt){
  # coerce appropriate data to numerics
  dt <- strsplit(morpho_txt, " ")[[4]]
  dt <- read_ocr_dt(dt, 1, "morpho")

  lake_type <- dt[1]
  drainage_area <- dt[2]
  surface_area <- dt[3]
  mean_depth <- dt[4]
  total_inflow <- dt[5]
  retention_time <- dt[6]

  list(lake_type = lake_type, drainage_area = drainage_area,
       surface_area = surface_area, mean_depth = mean_depth,
       total_inflow = total_inflow, retention_time = retention_time)
}

read_ocr_dt <- function(dt, char_pos = NA, section_name){

  num_pos <- grep("[[:digit:]]", dt)

  dt[!(1:length(dt) %in% char_pos)] <-
    suppressWarnings(as.numeric(dt[!(1:length(dt) %in% char_pos)]))
  bad_nums <- num_pos[num_pos %in% which(is.na(dt))]

  if(length(bad_nums > 0)){
    warning(paste0("The following ", section_name, " positions may have bad OCR: ",
                   bad_nums))
  }

  dt
}
