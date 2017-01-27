PAGES := vignettes/pages.txt
FNAMES := $(shell cat ${PAGES})
CLEANPAGES := vignettes/pages_clean.txt
CLEANNAMES := $(shell cat ${CLEANPAGES})

dg:
	cat $(PAGES)

csvs: $(FNAMES)
	echo ocr done

cleancsvs: $(CLEANNAMES)
	echo parse done

%.csv:
	Rscript -e 'write.csv(nesR::nes_get(system.file("extdata/national-eutrophication-survey_477.PDF", package = "nesR"), $(basename $@)), "$@", row.names = FALSE)'

%_clean.csv: %.csv
	Rscript -e 'nesR::parse_nes(read.csv("$<", stringsAsFactors = FALSE)[,1])'
