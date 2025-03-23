$(imgdir)/het1.pdf \
$(imgdir)/het2.pdf \
$(imgdir)/het3.pdf \
$(imgdir)/het4.pdf: \
	unit-04_1027-het_plots.intermediate
	@:

.INTERMEDIATE: unit-04_1027-het_plots.intermediate
unit-04_1027-het_plots.intermediate: $(Rdir)/het_plots.R
	$(RSCRIPT) $<


# Local Variables:
# mode: makefile-gmake
# End:
