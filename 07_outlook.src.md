# Ausblick

Welche Teile des Konzeptes konnten umgesetzt werden und wie gut funktionieren diese?

## \label{outlook_conflict}Konfliktbehandlung

## \label{outlook_distribution}Verteilung von Blobs

Besseres Verfahren wie Zufall verwenden, dass den freien Speicher als Grundlage für die Auswahl stellt. Eventuell könnte der Primary Server ebenfalls (zumindest für FULL - also Blobs) Aufgrund des freien Speicherplatzes ermittelt werden (falls der erstellende Server schon sehr viel Objekte besitzt oder wenig Speicherplatz besitzt).

## Konsistenz

Wenn ein Server nicht erreichbar ist, bedeutet das potenziell, dass dieser nicht mehr Konsistent ist. Dieser sollte keine Changes mehr annehmen. Sobald er wider Online ist, muss er bei allen Servern den OPLog abholen und diesen ausführen.

Dieser OPlog beinhaltet alle Operationen die ausgeführt werden. Genauer beschrieben hier: <http://docs.mongodb.org/manual/core/replica-set-oplog/>

## \label{outlook_file_chunking}Datei chunking

Theoretisch ist es möglich, dass Dateien, nach bestimmten Chunks durchsucht werden, die bereits im Storagesystem abgelegt sind. Dazu könnte ein ähnliches Verfahren wie bei rsync verwendet werden (Rolling-Checksum-Algorithm).
