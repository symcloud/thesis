# \label{chapter_result_outlook}Ergebnisse und Ausblick

Ziel dieser Arbeit war es, ein Konzept für eine verteilte Speicherverwaltung aufzustellen. Aus diesem Konzept entstand ein einfacher Prototyp, mit dem die Umsetzbarkeit dieses Konzeptes bewiesen wurde.

Im ersten Teil der Arbeit wurde, neben der Motivation und der Projektbeschreibung, eine Liste der Anforderungen an das Konzept und das Projekt aufgestellt. Diese Anforderungen umfassten die Punkte Datensicherheit, Funktionalitäten und Architektur. Auf diese Anforderungen wurden in den darauf folgenden Kapiteln Stellung genommen und Lösungsansätze erarbeitet. Das vorliegende Konzept erfüllt alle Anforderungen und ist durch seine Flexibilität auf andere Plattformen portierbar.

Aus den Anforderungen heraus wurden verschiedene Applikationen auf ihre Tauglichkeit, diese Anforderungen zu erfüllen, untersucht. Dabei wurden die Themen verteilte Systeme, Cloud-Datenhaltung, verteilte Daten und verteilte Datenmodelle jeweils mit Beispielen analysiert.

Um eine solide Grundlage für das Konzept zu erarbeiten, wurden im Evaluierungskapitel,verschiedene Möglichkeiten der Datenhaltung in verteilten Systemen durchleuchtet und auf die Tauglichkeit als Basis für das Konzept zu dienen überprüft. Es wurde keine passende Technologie gefunden, jedoch konnten einige Konzepte der evaluierten Technologien im Konzept verwendet und umgesetzt werden. Eines davon ist das Konzept der Dateireplikationen aus XtreemFS und das dort verwendete Primärbasierte Protokoll. Eine vereinfachte Version dieses Protokolls wurde im Konzept eingebaut und später im Prototypen umgesetzt.

Aus den Vorteilen der analysierten Anwendungen, Technologien und Dienste wurde in der Konzeptionsphase, auf Basis eines verteilten Datenmodells, das Konzept einer verteilten Anwendung für die Dateiverwaltung geschaffen. Als solide Grundlage für das Datenmodell wurde die verteilte Versionsverwaltung GIT herangezogen. Es ermöglicht eine sichere und effiziente Verteilung der Daten. Für die Datenspeicherung wurden eine eigene Datenbank konzipiert, die es ermöglicht, Objekte anhand eines Hashwertes Daten effizient in verschiedenen Speichermedien abzulegen. Um diese Hashwerte schnell zu finden, werden die Metadaten dieser Objekte in einer Suchmaschine indexiert, die eine suche über die Daten effizient ausführen kann.

Die Implementierung des Prototypen wurde in drei Teile unterteilt. Im ersten Teil wurde eine Bibliothek entwickelt, die das Datenmodell, die Datenbank und eine Zugriffsschicht implementiert. Diese Bibliothek ist unabhängig von der restlichen Anwendung und kann daher von allen PHP-Applikationen eingebunden werden, die mit symCloud kommunizieren wollen. Der zweite Teil umfasst die Plattform, die als funktionierender Prototyp in die bestehende Plattform SULU eingebunden wurde. Neben der Rest-API bietet die Plattform auch ein einfaches UI, mit dem Änderungen an den Dateien möglich ist. Über die Authentifizierungsschicht können SULU-BenutzerInnen Dateien in symCloud ablegen und verwalten. Der dritte Teil ist als Beispiel für eine Dritt-Hersteller Applikation gedacht. Es ist eine Synchronisierungssoftware, die es ermöglicht Dateien von seinem Rechner mit symCloud zu synchronisieren.

Auch wenn der entwickelte Prototyp nicht alle Facetten des Konzepts umsetzt, ist er ein Beweis für die Funktionstüchtigkeit ebendieses. Einige Punkte wurden im Konzept nicht betrachtet. Einer dieser Punkte ist die Performance des Systems, dieser Punkt macht in der aktuellen Implementierung am meisten Probleme. Hier könnten weiterführende Analysen und Verbesserungen gerade in der Verteilung der Replikationen erhebliche Verbesserungen bringen. Dieser und andere Punkte werden in den folgenden Abschnitten etwas genauer betrachtet.

## \label{outlook_distribution}Verteilung von Chunks

Besseres Verfahren als Zufall verwenden, das den freien Speicher als Grundlage für die Auswahl stellt. Eventuell könnte der Primary Server ebenfalls (zumindest für FULL - also Blobs) Aufgrund des freien Speicherplatzes ermittelt werden (falls der erstellende Server schon sehr viele Objekte besitzt oder wenig Speicherplatz besitzt).
		
__TODO__

* Was wird sonst verwendet?
* Literaturrecherche
* Papers

## \label{outlook_conflict}Konfliktbehandlung

Neben der Erkennung von Konflikten, ist auch die sinnvolle Lösung des Konflikts er ernstes Problem. Unterschieden werden drei verschiedene Stufen der Konfliktbehandlung [@bleiholder:techniken]:

Konflikte werden ignoriert

:   Es werden weder Unsicherheiten beseitigt, noch Widersprüche aufgelöst. Als Beispiel hierfür gilt, dass die letzte Änderung übernommen wird, ohne die Änderungen davor zu betrachten.

Konflikte werden vermieden

:   Die Unsicherheiten werden beseitigt, jedoch können die Widersprüche nicht gelöst werden, jedoch durch die geschickte Auswahl von Werten umgangen.

Konflikte werden gelöst

:   Alle Unsicherheiten können beseitigt und die Widersprüche sinnvoll aufgelöst werden.

Um die beiden Versionen zusammenzuführen, können verschiedene Operatoren (wie JOIN, UNION oder MERGE) verwendet werden. Diese Operatoren führen aber nur Objekte sinnvoll zusammen, wenn die Änderungen jeweils andere Eigenschaften betreffen [@bleiholder:techniken].

Den Inhalt einer Datei zusammenzuführen ist ungleich schwieriger. Dabei verwenden Anwendungen wie Dropbox oder ownCloud einen einfachen Mechanismus, bei denen beide Versionen nebeneinander erstellt werden (mit einem Zusatz im Dateinamen) und die Konflikte werden nicht automatisch aufgelöst [@dropbox2015conflicts].

## \label{outlook_file_chunking}Rsync Algorithmus

Um die Effizienz der gespeicherten Chunks zu erhöhen sind Algorithmen, wie der Rsync ausgelegt. Wenn zwei Dateien auf verschiedenen, über ein Netzwerk verbundene, Rechner synchronisiert werden sollten, ermittelt der Rsync Algorithmus Teile der Datei, die auf beiden Rechner identisch sind. Dabei muss dieser Teil nicht an der selben Stelle in den Dateien auf den Rechner befinden. Dafür erstellt einer der beiden Rechner eine sogenannte Signatur Datei. Dies geschieht, indem die Datei in Blöcke einer bestimmte Länge durchsucht wird und von diesen Blöcken die Prüfsummer ermittelt wird. Diese Prüfsummen werden in die Signatur Datei geschrieben und an den zweiten Rechner versendet. Dieser unterteilt nun seine Datei ebenfalls in Blöcke der selben Größe. Allerdings nicht der Reihe nach sondern an jeder beliebigen Stelle der Datei, um möglichst viele Treffer zu erzielen. Als Ergebnis sendet der zweite Rechner eine Liste von Operationen an den Server, mithilfe dieser er die Datei "nachbauen" kann. Dieser Algorithmus erhöht nicht nur die Übertragungsgeschwindigkeit von Dateiänderungen, sondern auch die Speichernutzung von Version zu Version, da nur die Änderungen gespeichert werden, selbst dann, wenn in der Mitte der Datei die Änderung durchgeführt wurde [@TR-CS-96-05].

## \label{lock_mechanism}Lock-Mechanismen

Es gibt diverse Lock-Mechanismen, die auf einem Server optimal funktionieren. Allerdings ist es sehr viel schwerer diese Mechanismen über ein Netzwerk zu verteilen. Das Team XtreemFS entwickelte daher einen sogenannten "Flease"-Algorithmus. Dieser Algorithmus ist ein dezentraler und fehlertolerante Koordination von "lease" also Objekt-Locks in verteilten Systemen. Der Algorithmus arbeitet ohne zentrale Schnittstelle und gewährleistet einen exklusiven Zugriff auf eine Ressource in einem skalierbaren Umfeld [@kolbeck2010flease].

## \label{chapter_outlook_protocolls}Protokolle

Um die Kommunikation zwischen den Servern zu vereinheitlichen, gibt es einige Offene Protokolle, die als Erweiterung zum Konzept von symCloud geeignet wären. Zwei dieser Protokolle sind:

Webfinger

:   Webfinger ist ein Protokoll um Informationen über Objekte, die über eine URI identifiziert werden, zu übertragen. Als Medium für die Übertragung wird das Standard HTTP Protokoll verwendet. Die Antwort auf eine Anfrage ist ein JSON-Objekt mit dem Mimetyp "application/jrd+json". Dieses JRD (JSON Ressource Descriptor), enthält alle relevanten Informationen zu einem Objekt und weiterführende Links [@jones2013webfinger]. Dieses Protokoll wird von Diaspora verwendet und könnte daher als Bindeglied zwischen den beiden Applikationen dienen.

PubSubHubbub

:   Andere PubSub-Protokolle verlangen von den Clients, dass sie in regelmäßigen Abständen neue Beiträge abfragen. Dies führt zu einer Zeitdifferenz zwischen Erstellen und anzeigen. Außerdem fällt viel Overhead an falls es keine neuen Beiträge gibt. PubSubHubbub integriert daher einen sogenannten Hub zwischen Server und Client. Die Feed-Server pingen bei eine neuen Beitrag die Hubs an, diese holen sich daraufhin den Beitrag und leiten ihn via Push an die Clients weiter. Die Aufgabe, die Nachrichten sicher an die Clients zu versenden, bleibt dem Hub über [@fitzpatrick2014hub]. In symCloud könnte ein solcher Hub das Bindeglied zwischen primary- und Backupserver sein. Dies würde die Performance des Erstellens und Verteilens eines Objektes enorm beschleunigen. Jedoch müssten sich die Hubs darum kümmern, die Änderungen und neuen Objekte sicher an die Backupserver weiterzuleiten.

Neben der Interoperabilität zwischen verschiedenen Applikationen (Webfinger) bietet gerade das Protokoll PubSubHubbub eine enorme Steigerung der Datensicherheit und Performance.
