# Ausblick

Welche Teile des Konzeptes konnten umgesetzt werden und wie gut funktionieren diese?

## \label{outlook_conflict}Konfliktbehandlung

## \label{outlook_distribution}Verteilung von Blobs

Besseres Verfahren als Zufall verwenden, das den freien Speicher als Grundlage für die Auswahl stellt. Eventuell könnte der Primary Server ebenfalls (zumindest für FULL - also Blobs) Aufgrund des freien Speicherplatzes ermittelt werden (falls der erstellende Server schon sehr viele Objekte besitzt oder wenig Speicherplatz besitzt).

__TODO__

* Was wird sonst verwendet?
* Literaturrecherche
* Papers

## Konsistenz

Wenn ein Server nicht erreichbar ist, bedeutet das potenziell, dass dieser nicht mehr Konsistent ist. Dieser sollte keine Changes mehr annehmen. Sobald er wieder Online ist, muss er bei allen Servern den OPLog abholen und diesen ausführen.

Dieser OPlog beinhaltet alle Operationen die ausgeführt werden. Genauer beschrieben hier: <http://docs.mongodb.org/manual/core/replica-set-oplog/>

## \label{outlook_file_chunking}Datei chunking

Theoretisch ist es möglich, dass Dateien, nach bestimmten Chunks durchsucht werden, die bereits im Storagesystem abgelegt sind. Dazu könnte ein ähnliches Verfahren wie bei rsync verwendet werden (Rolling-Checksum-Algorithm).

## \label{lock_mechanism}Lock-Mechanismen

__TODO kurze Beschreibung und Ansätze__ 

## \label{chapter_outlook_protocolls}Protokolle

Welche Protokolle wären möglich um die Replikation zu vereinheitlichen:

* Webfinger (Kommunikation zwischen diespora und symCloud)
* PubSubHubbub
