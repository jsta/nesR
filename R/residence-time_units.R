
#' get_residence_units
#' @param f_name character file name of raw data
#' @importFrom utils read.csv
#' @export
#' @examples \dontrun{
#' f_name <- "474/100.csv"
#' get_residence_units(f_name)
#' }

get_residence_units <- function(f_name){
	dt <- read.csv(f_name, stringsAsFactors = FALSE)

	if(length(grep("year", tolower(dt))) > 0){
		return("years")
	}

	if(length(grep("day", tolower(dt))) > 0){
		return("days")
	}

	NA
}
