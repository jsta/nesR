
createdir:
	-mkdir -p $(PDFSOURCE)

$(PDFSOURCE)/Makefile: createdir Maketemplate
	cp Maketemplate $(PDFSOURCE)/Makefile

$(PDFSOURCE)/pages.txt: createdir
	Rscript -e 'nesR::generate_page_list($(PDFSOURCE), $(PDFSOURCE))'

pagelist: $(PDFSOURCE)/pages.txt

runmakefile: $(PDFSOURCE)/Makefile pagelist
	make -C $(PDFSOURCE) all

all: runmakefile
