diagram:
	for txt in diagrams/*.txt
	do
		ditaa -E $txt
	done

pdf:
	pandoc --standalone --toc --number-sections --biblio sources.bib src/*.md -o symcloud-thesis.pdf
