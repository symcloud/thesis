diagrams = $(shell ls diagrams/*.txt)
mds = $(shell ls *.src.md)

diagram:
	$(foreach f,$(diagrams), ditaa -E -o $(f);)

pdf:
	pandoc --standalone --toc --number-sections --biblio sources.bib -o symcloud-thesis.pdf $(mds)

open: pdf
	open ./symcloud-thesis.pdf
