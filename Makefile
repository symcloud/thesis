diagrams = $(shell ls diagrams/*.txt)

diagram:
	$(foreach f,$(diagrams), ditaa -E -o $(f);)

pdf: diagram
	pandoc --standalone --toc --number-sections --biblio sources.bib *.md -o symcloud-thesis.pdf
