#' parse_nes
#' @param ocr_txt character vector of ocr'd text
#' @export
#' @importFrom purrr flatten
#' @examples \dontrun{
#' nes_file <- system.file("extdata/national-eutrophication-survey_477.PDF",
#'                      package = "nesR")
#' nes_page <- 11
#' tif_clean <- extract_nes_page(nes_file, nes_page)
#' raw_txt <- ocr_nes_page(tif_clean)
#' parse_nes(raw_txt)
#' }

parse_nes <- function(ocr_txt){

  # morpho_pos <- grep("MORPH", ocr_txt)
  morpho_pos <- grep("^1. |^I. ", ocr_txt)
  phys_chem_pos <- grep("PHYSICAL", ocr_txt)
  bio_pos <- grep("BIOLOGICAL", ocr_txt)
  nut_pos <- grep("iv\\.", tolower(ocr_txt))

  metadata <- parse_metadata(ocr_txt[1:(morpho_pos - 1)])

  morphometry <- parse_morpho(ocr_txt[morpho_pos:(phys_chem_pos - 1)])

  phys_chem <- parse_phys_chem(ocr_txt[phys_chem_pos:(bio_pos - 1)])

  # bio <- ocr_txt[bio_pos:(nut_pos - 1)]

  # nutrients <- parse_nuts(ocr_txt[nut_pos:length(ocr_txt)])


  res <- list(metadata = metadata,
              morphometry = morphometry,
              phys_chem = phys_chem
              # bio = bio,
              # nutrients = nutrients
  )

  data.frame(purrr::flatten(res), stringsAsFactors = FALSE)

}

parse_metadata <- function(meta_txt){
  state <- strsplit(meta_txt[1], " ")[[1]]
  state <- state[nchar(state) > 1]
  state <- state[length(state)]

  name <- strsplit(meta_txt[2], "-")[[1]][2]
  name <- strsplit(name, ",")[[1]][1]
  name <- strsplit(name, "\\(")[[1]][1]
  name <- gsub("\\.", "", name)
  name <- trimws(name)

  county <- strsplit(meta_txt[3], "-")[[1]][2]
  county <- trimws(county)
  county <- gsub(":", ",", county)

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

parse_nuts <- function(nut_txt){

  handle_nutrient <- function(dt, prefix){

    pnt_source_muni       <- dt[2]
    pnt_source_industrial <- dt[3]
    pnt_source_septic     <- dt[4]
    nonpnt_source         <- dt[5]
    total                 <- dt[6]


  }

  phosphorus <- read_ocr_dt(strsplit(nut_txt, " ")[[5]], section_name = "nuts")
  phosphorus <- handle_nutrient(phosphorus, prefix = "p")
  nitrogen   <- read_ocr_dt(strsplit(nut_txt, " ")[[6]], section_name = "nuts")

  dt <- cbind(phosphorus, nitrogen)

  list(pnt_source_muni = pnt_source_muni, pnt_source_industrial = pnt_source_industrial, pnt_source_septic = pnt_source_septic, nonpnt_source = nonpnt_source, total = total)
}

parse_morpho <- function(morpho_txt){

  dt <- strsplit(morpho_txt, " ")

  if(length(dt) < 4){ # see if morpho numbers are missing
    dt <- c(dt, paste0(rep(NA, 6), collapse = " "))
  }

  dt <- dt[[4]]

  # coerce appropriate data to numerics
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

  dt <- dt[dt != "_"]
  dt <- dt[dt != "-"]

  # check nes_get(nes_file, 15) preserves tp?

  dt[1:length(dt) %in% grep("9.{3}", dt)] <- NA # set multiple 9s to NA
  # dt[1:length(dt) %in% grep("(9){2}", dt)] <- NA # set multiple 9s to NA

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
