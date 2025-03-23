$(imgdir)/het1.pdf \
$(imgdir)/het2.pdf \
$(imgdir)/het3.pdf \
$(imgdir)/het4.pdf: \
	unit-04_1027-het_plots.intermediate
	@:

.INTERMEDIATE: unit-04_1027-het_plots.intermediate
unit-04_1027-het_plots.intermediate: $(Rdir)/het_plots.R
	$(RSCRIPT) $<


unit-08a-data-files := \
	$(datadir)/pib.xlsx \
	$(datadir)/IPCa.xlsx \
	$(datadir)/IComMinor.xlsx

$(figdir)/fig-08a_1027-infl.pdf \
$(figdir)/fig-08a_1027-gdp.pdf \
$(figdir)/fig-08a_1027-retail.pdf: \
	unit-08a_1027-figures.intermediate
	@:

.INTERMEDIATE: unit-08a_1027-figures.intermediate
unit-08a_1027-figures.intermediate: $(Rdir)/unit-08a_1027.R $(unit-08a-data-files)
	$(RSCRIPT) $<


$(datadir)/unit-08b_1027-sim.csv \
$(datadir)/unit-08b_1027-acf.csv \
$(datadir)/unit-08b_1027-int.csv: \
	unit-08b_1027-data-files.intermediate
	@:

.INTERMEDIATE: unit-08b_1027-data-files.intermediate
unit-08b_1027-data-files.intermediate: $(Rdir)/unit-08b_1027.R $(datadir)/IPCa.xlsx
	$(RSCRIPT) $<



# Local Variables:
# mode: makefile-gmake
# End:
