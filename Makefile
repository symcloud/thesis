dots = $(shell find ./diagrams -type f -iname "*.dita")
seqdiags = $(shell find ./diagrams -type f -iname "*.seqdiag")
mds = $(shell ls *.src.md)
pdf_params = --listings --filter pandoc-citeproc --csl csl/fhv.csl --template templates/template.latex --standalone --toc --toc-depth 3 --number-sections --bibliography sources.bib

pdf_vars = -V lang=german -V mainlang=german -V documentclass=scrbook -V classoption=oneside -V biblio-title=Literaturverzeichnis
lol = -V lol=true 
lof = -V lof=true
lot = -V lot=true
assertion = -V assertion=true

format = markdown+table_captions+pipe_tables+definition_lists+fenced_code_blocks+fenced_code_attributes+backtick_code_blocks

all: ditaa dot seqdiags pdf

ditaa:
	$(foreach f,$(dots), ditaa -E -o $(f);)

dot:
	dot -Tpng -o diagrams/data-model.png diagrams/data-model.dot
	dot -Tpng -o diagrams/distributed-storage.png diagrams/distributed-storage.dot

seqdiags:
	$(foreach f,$(seqdiags), seqdiag $(f);)

pdf:
	pandoc $(pdf_params) $(lol) $(lot) $(lof) $(assertion) $(pdf_vars) -o symcloud-thesis.pdf $(mds) -f $(format)
