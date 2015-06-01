dots = $(shell find ./diagrams -type f -iname "*.dita")
seqdiags = $(shell find ./diagrams -type f -iname "*.seqdiag")
mds = $(shell ls *.src.md)

all: ditaa dot seqdiags pdf docx html

ditaa:
	$(foreach f,$(dots), ditaa -E -o $(f);)

dot:
	dot -Tpng -o diagrams/data-model.png diagrams/data-model.dot
	dot -Tpng -o diagrams/distributed-storage.png diagrams/distributed-storage.dot

seqdiags:
	$(foreach f,$(seqdiags), seqdiag $(f);)

formats: pdf docx html

pdf:
	pandoc --filter pandoc-citeproc --csl csl/FHV.csl --template templates/template.latex --standalone --toc --toc-depth 3 --number-sections --bibliography sources.bib -V lang=german -V mainlang=german -o symcloud-thesis.pdf $(mds) -f markdown+table_captions+pipe_tables+definition_lists+fenced_code_attributes+fenced_code_blocks

html:
	pandoc --standalone --toc --number-sections --biblio sources.bib -o symcloud-thesis.html $(mds) -f markdown+table_captions+pipe_tables+definition_lists

docx:
	pandoc --standalone --toc --number-sections --biblio sources.bib -o symcloud-thesis.docx $(mds) -f markdown+table_captions+pipe_tables+definition_lists

openpdf: pdf
	open ./symcloud-thesis.pdf

openhtml: html
	open ./symcloud-thesis.html

opendocx: docx
	open ./symcloud-thesis.docxs
