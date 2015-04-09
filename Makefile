diagrams = $(shell find ./diagrams -type f -iname "*.txt")
mds = $(shell ls *.src.md)

all: diagram pdf docx

diagram:
	$(foreach f,$(diagrams), ditaa -E -o $(f);)

pdf:
	pandoc --standalone --toc --number-sections --biblio sources.bib --csl=FHV.csl -V lang=german -V mainlang=german -o symcloud-thesis.pdf $(mds)

html:
	pandoc --standalone --toc --number-sections --biblio sources.bib -o symcloud-thesis.html $(mds)

docx:
	pandoc --standalone --toc --number-sections --biblio sources.bib -o symcloud-thesis.docx $(mds)

openpdf: pdf
	open ./symcloud-thesis.pdf

openhtml: html
	open ./symcloud-thesis.html

opendocx: docx
	open ./symcloud-thesis.docxs
