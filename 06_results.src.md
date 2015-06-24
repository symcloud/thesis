# \label{chapter_result_outlook}Ergebnisse und Ausblick

## Ergebnisse


## Ausblick

???

### \label{outlook_conflict}Konfliktbehandlung

Neben der Erkennung von Konflikten, ist auch die sinnvolle Lösung des Konflikts er ernstes Problem. Unterschieden werden drei verschiedene Stufen der Konfliktbehandlung [@bleiholder:techniken]:

Konflikte werden ignoriert

:   Es werden weder Unsicherheiten beseitigt, noch Widersprüche aufgelöst. Als Beispiel hierfür gilt, dass die letzte Änderung übernommen wird, ohne die Änderungen davor zu betrachten.

Konflikte werden vermieden

:   Die Unsicherheiten werden beseitigt, jedoch können die Widersprüche nicht gelöst werden, jedoch durch die geschickte Auswahl von Werten umgangen.

Konflikte werden gelöst

:   Alle Unsicherheiten können beseitigt und die Widersprüche sinnvoll aufgelöst werden.

Um die beiden Versionen zusammenzuführen, können verschiedene Operatoren (wie JOIN, UNION oder MERGE) verwendet werden. Diese Operatoren führen aber nur Objekte sinnvoll zusammen, wenn die Änderungen jeweils andere Eigenschaften betreffen [@bleiholder:techniken].

Den Inhalt einer Datei zusammenzuführen ist ungleich schwieriger. Dabei verwenden Anwendungen wie Dropbox oder ownCloud einen einfachen Mechanismus, bei denen beide Versionen nebeneinander erstellt werden (mit einem Zusatz im Dateinamen) und die Konflikte werden nicht automatisch aufgelöst [@dropbox2015conflicts].

### \label{outlook_distribution}Verteilung von Blobs

Besseres Verfahren als Zufall verwenden, das den freien Speicher als Grundlage für die Auswahl stellt. Eventuell könnte der Primary Server ebenfalls (zumindest für FULL - also Blobs) Aufgrund des freien Speicherplatzes ermittelt werden (falls der erstellende Server schon sehr viele Objekte besitzt oder wenig Speicherplatz besitzt).

__TODO__

* Was wird sonst verwendet?
* Literaturrecherche
* Papers

### Konsistenz

Wenn ein Server nicht erreichbar ist, bedeutet das potenziell, dass dieser nicht mehr Konsistent ist. Dieser sollte keine Changes mehr annehmen. Sobald er wieder Online ist, muss er bei allen Servern den OPLog abholen und diesen ausführen.

Dieser OPlog beinhaltet alle Operationen die ausgeführt werden. Genauer beschrieben hier: <http://docs.mongodb.org/manual/core/replica-set-oplog/>

### \label{outlook_file_chunking}Datei chunking

Theoretisch ist es möglich, dass Dateien, nach bestimmten Chunks durchsucht werden, die bereits im Storagesystem abgelegt sind. Dazu könnte ein ähnliches Verfahren wie bei rsync verwendet werden (Rolling-Checksum-Algorithm).

### \label{lock_mechanism}Lock-Mechanismen

__TODO kurze Beschreibung und Ansätze__ 

### \label{chapter_outlook_protocolls}Protokolle

Welche Protokolle wären möglich um die Replikation zu vereinheitlichen:

* Webfinger (Kommunikation zwischen diespora und symCloud)
* PubSubHubbub
