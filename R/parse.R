#' parse_nes
#' @param ocr_txt character vector of ocr'd text
#' @export
#' @importFrom purrr flatten
#' @examples \dontrun{
#' parse_nes(read.csv(system.file(
#' "extdata/477_page-012.csv", package = "nesR"),
#'  stringsAsFactors = FALSE)[,1])
#' }

parse_nes <- function(ocr_txt){

  morpho_pos <- grep("^1. |^I. |^I.-|\\sI\\.\\s|^\\'I\\.|^l\\.", ocr_txt)
  phys_chem_pos <- grep("^II\\. | PHYSICAL|^11\\.|^I\\]\\.", ocr_txt)
  bio_pos <- grep("III\\. | BIOLOGICAL |111\\.|III\\.", ocr_txt)
  nut_pos <- grep("iv\\.|1v\\.| nutrient loading", tolower(ocr_txt))
  # c(morpho_pos, phys_chem_pos, bio_pos, nut_pos)

  if(length(morpho_pos) == 0 | any(morpho_pos > 8) | length(morpho_pos) > 1){
  	morpho_pos <- 5
  }
  if(length(phys_chem_pos) > 1){
  	phys_chem_pos <- 9
  }
  if(length(bio_pos) == 0 | length(bio_pos) > 1){
  	bio_pos <- 13
  }


  metadata <- parse_metadata(ocr_txt[1:(morpho_pos - 1)])

  morphometry <- parse_morpho(ocr_txt[morpho_pos:(phys_chem_pos - 1)])

  phys_chem <- parse_phys_chem(ocr_txt[phys_chem_pos:(bio_pos - 1)])

  # bio <- ocr_txt[bio_pos:(nut_pos - 1)]

  nutrients <- parse_nuts(ocr_txt[nut_pos:length(ocr_txt)])


  res <- list(metadata = metadata,
              morphometry = morphometry,
              phys_chem = phys_chem,
              # bio = bio,
              nutrients = nutrients
  )

  data.frame(purrr::flatten(res), stringsAsFactors = FALSE)

}

parse_metadata <- function(meta_txt){

	meta_txt <- gsub(")", "", meta_txt)
	meta_txt <- gsub(",", "", meta_txt)
	meta_txt <- gsub("_", "", meta_txt)
	meta_txt <- gsub("'", "", meta_txt)
	meta_txt <- gsub("\u2018", "", meta_txt) #stylized single quote
	meta_txt <- gsub("\\.", "", meta_txt)
	meta_txt <- gsub(":", ",", meta_txt)
	meta_txt <- gsub("\\|", "", meta_txt)

  state <- strsplit(meta_txt[1], " ")[[1]]
  state <- state[nchar(state) > 1]
  in_position <- grep("^1N$|^IN$", state)
  if(length(in_position) > 0){
  	if(in_position < (length(state) - 1)){
  		state <- paste(state[(length(state)-1):length(state)], collapse = " ")
  		state_length <- 2
  	}else{
  		state <- state[length(state)]
  		state_length <- 1
  	}
  }else{
  	state <- state[length(state)]
  	state_length <- 1
  }
  state <- gsub("-", "", state)
	state <- fuzzy_replace_word(toupper(state.name), state, state_length)

  name <- strsplit(meta_txt[2], "-")[[1]][2]
	name <- strsplit(name, " ")[[1]]

	fuzzy_strip_word <- function(txt, dt){
		bad_word_pos <- agrep(txt, tolower(dt))
		if(length(bad_word_pos) > 0){
			dt <- dt[-bad_word_pos]
		}
		dt
	}

	name <- fuzzy_strip_word("eutrophic", name)
	name <- fuzzy_strip_word("mesotrophic", name)
	name <- fuzzy_strip_word("oligotrophic", name)
	name <- trimws(paste(name, collapse = " "))
  name <- strsplit(name, ",")[[1]][1]
  name <- strsplit(name, "\\(")[[1]][1]
  name <- gsub("\\.", "", name)
  name <- trimws(name)
  name <- toupper(name)

  county <- strsplit(meta_txt[3], "-")[[1]][2]
  county <- trimws(county)

  storet_code <- substring(meta_txt[4], 0, 30)
  storet_code <- gsub("\u2014", "-", storet_code) # long dash
 	storet_candiates <- c(strsplit(storet_code, "-")[[1]][2],
 												strsplit(storet_code, "\\*")[[1]][2])
 	if(all(is.na(storet_candiates))){
		storet_candiates <- strsplit(storet_code, " ")[[1]][4]
 	}
 	storet_code <- storet_candiates[!is.na(storet_candiates)]
  storet_code <- strsplit(storet_code, " ")[[1]][2]
  # storet_code <- as.numeric(storet_code)

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

  handle_input_nutrient <- function(dt, prefix){
  	dt <- unlist(dt)
    pnt_source_muni       <- dt[2]
    pnt_source_industrial <- dt[3]
    pnt_source_septic     <- dt[4]
    nonpnt_source         <- dt[5]
    total                 <- dt[6]

    res <- list(pnt_source_muni = pnt_source_muni,
                pnt_source_industrial = pnt_source_industrial,
                pnt_source_septic = pnt_source_septic,
                nonpnt_source = nonpnt_source,
                total = total)
    names(res) <- paste0(prefix, "_", names(res))
    res
  }

  handle_output_nutrient <- function(dt, prefix){
  	dt <- unlist(dt)
    total_out            <- dt[2]
    percent_retention    <- dt[3]
    surface_area_loading <- dt[4]

    res <- list(total_out = total_out,
                percent_retention = percent_retention,
                surface_area_loading = surface_area_loading)
    names(res) <- paste0(prefix, "_", names(res))
    res
  }

  phosphorus_in <- read_ocr_dt(strsplit(nut_txt, " ")[[5]],
                               section_name = "nuts")
  phosphorus_out <- read_ocr_dt(strsplit(nut_txt, " ")[[10]],
                               section_name = "nuts")
  nitrogen_in   <- read_ocr_dt(strsplit(nut_txt, " ")[[6]],
                            section_name = "nuts")
  nitrogen_out <- read_ocr_dt(strsplit(nut_txt, " ")[[11]],
                                section_name = "nuts")

  phosphorus_in  <- handle_input_nutrient(phosphorus_in, prefix = "p")
  nitrogen_in    <- handle_input_nutrient(nitrogen_in, prefix = "n")
  phosphorus_out <- handle_output_nutrient(phosphorus_out, prefix = "p")
  nitrogen_out   <- handle_output_nutrient(nitrogen_out, prefix = "n")

  c(phosphorus_in, nitrogen_in, phosphorus_out, nitrogen_out)
}

parse_morpho <- function(morpho_txt){

  dt <- strsplit(morpho_txt, " ")

  if(length(dt) < 4){ # see if morpho numbers are missing
    dt <- c(dt, paste0(rep(NA, 6), collapse = " "))
  }

  dt <- dt[[4]]

  # coerce appropriate data to numerics
  dt <- read_ocr_dt(dt, 1, "morpho")

  lake_type <- fuzzy_replace_word(toupper(c("impoundment", "natural")), dt[1])
  if(nchar(lake_type) < 2){lake_type <- NA}

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

  dt[1:length(dt) %in% grep("999.{3}", dt)] <- NA # set multiple 9s to NA
  # dt[1:length(dt) %in% grep("(9){2}", dt)] <- NA # set multiple 9s to NA

  num_pos <- grep("[[:digit:]]", dt)
  dt[num_pos] <- sapply(dt[num_pos], letters_to_numbers)

  dt[!(1:length(dt) %in% char_pos)] <-
    suppressWarnings(as.numeric(dt[!(1:length(dt) %in% char_pos)]))
  bad_nums <- num_pos[num_pos %in% which(is.na(dt))]

  if(length(bad_nums > 0)){
    warning(paste0("The following ", section_name, " positions may have bad OCR: ",
                   bad_nums))
  }

  dt
}

fuzzy_replace_word <- function(txt, dt, len = 1){
	replace_word <- function(txt, dt){
		bad_word_pos <- agrep(txt, toupper(dt), max.distance = 0.23)
		if(length(bad_word_pos) > 0){
			txt
		}
	}
	res <- unlist(lapply(txt, function(x) replace_word(x, dt)))
	res <- res[which.min(abs(nchar(res) - nchar(dt)))]

	if(length(res) > 0){
		dt <- res
	}
	paste0(strsplit(dt, " ")[[1]][1:len], collapse = " ")
}

letters_to_numbers <- function(txt){
	key <- data.frame(letters = c("I"), numbers = c("1"), stringsAsFactors = FALSE)
	res <- stringr::str_replace(txt, key[1, 1], key[1, 2])
}
