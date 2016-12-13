library(pdftools)
library(tesseract)

nes_file <- "national-eutrophication-survey_1975"

# https://gist.github.com/benmarwick/11333467
system(paste0("pdftoppm ", nes_file, " -f 11 -l 170 -r 600 ocrbook"))


i <- "011"
tif_base <- paste0("ocrbook-", i)
tif_file <- paste0(tif_base, ".tif")
system(paste0("convert ", list.files(pattern = "ppm")[1], " ", tif_file))

tif_clean <- paste0(tif_base, "_clean", ".tif")
# http://www.fmwconcepts.com/imagemagick/textcleaner/index.php
im_cmds <- paste0(" -colorspace gray -type grayscale -contrast-stretch 0 -clone 0 -deskew 40% -sharpen 0x1 -lat 15x25+2%", " ")

im_cmds <- paste0(" -lat 30x30-2%", " ")

# "-c "0,50,0,0" -g -e normalize -f 15 -o 10 -u -s 2 -T -p 20 "
# 
# "convert \( $infile -colorspace gray -type grayscale -contrast-stretch 0 \) \
# \( -clone 0 -colorspace gray -negate -lat ${filtersize}x${filtersize}+${offset}% -contrast-stretch 0 \) \
# -compose copy_opacity -composite -fill "$bgcolor" -opaque none +matte \
# -deskew 40% -sharpen 0x1 \ $outfile "

system(paste0("convert ", tif_file, im_cmds, tif_clean))


parse_nes <- function(tif_clean){
  ocr_txt <- tesseract::ocr(tif_clean)
  ocr_txt <- strsplit(ocr_txt, "\n")[[1]]
  
  morpho_pos <- grep("MORPHOMETRY", ocr_txt)
  phys_chem_pos <- grep("PHYSICAL", ocr_txt)
  bio_pos <- grep("BIOLOGICAL", ocr_txt)
  nut_pos <- grep("NUTRIENT", ocr_txt)
  
  metadata <- parse_metadata(ocr_txt[1:(morpho_pos - 1)])
    
  morphometry <- parse_morpho(ocr_txt[morpho_pos:(phys_chem_pos - 1)])
    
  phys_chem <- ocr_txt[phys_chem_pos:(bio_pos - 1)]
    
  bio <- ocr_txt[bio_pos:(nut_pos - 1)]
    
  nutrients <- ocr_txt[nut_pos:length(ocr_txt)]
  
  
  list(metadata = metadata, morphometry = morphometry, phys_chem = phys_chem,
       bio = bio, nutrients = nutrients)
}

parse_metadata <- function(meta_txt){
  state <- strsplit(meta_txt[1], " ")[[1]]
  state <- state[length(state) - 1]
  
  name <- strsplit(meta_txt[2], "-")[[1]][2]
  name <- strsplit(name, ",")[[1]][1]
  name <- trimws(name)
  
  county <- strsplit(meta_txt[3], "-")[[1]][2]
  county <- trimws(county)
  
  storet_code <- strsplit(meta_txt[4], "-")[[1]][2]
  storet_code <- strsplit(storet_code, " ")[[1]][2]
  
  list(state = state, name = name, county = county, storet_code = storet_code)
}

parse_phys_chem <- function(){
  
  
}

parse_morpho <- function(morpho_txt){
  # coerce appropriate data to numerics
  dt <- strsplit(morpho_txt, " ")[[4]]
  num_pos <- grep("[[:digit:]]", dt)
  dt[2:length(dt)] <- suppressWarnings(as.numeric(dt[2:length(dt)]))
  bad_nums <- num_pos[num_pos %in% which(is.na(dt))]
  
  if(length(bad_nums > 0)){
    warning(paste0("The following morpho positions may have bad OCR: ",
                   bad_nums))
  }
  
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

parse_nes(tif_clean)