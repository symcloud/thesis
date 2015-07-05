# \label{chapter_result_outlook}Ergebnisse und Ausblick

Ziel dieser Arbeit war es, ein Konzept für eine verteilte Speicherverwaltung aufzustellen. Aus diesem entstand ein einfacher Prototyp, mit dem die Umsetzbarkeit dieses Konzeptes bewiesen wurde.

Im ersten Teil der Arbeit wurde, neben der Motivation und der Projektbeschreibung, eine Liste der Anforderungen an das Konzept und das Projekt aufgestellt. Diese Anforderungen umfassten die Punkte Datensicherheit, Funktionalitäten und Architektur. Auf diese Anforderungen wurden in den darauf folgenden Kapiteln eingegangen und Lösungsansätze erarbeitet. Das vorliegende Konzept erfüllt alle Anforderungen und ist durch seine Flexibilität auf andere Plattformen portierbar.

Verschiedene Applikationen wurden auf die Erfüllbarkeit der Anforderung untersucht. Dabei wurden die Themen "verteilte Systeme", "Cloud-Datenhaltung", "verteilte Daten" und "verteilte Datenmodelle" jeweils anhand von Beispielen analysiert.

Um eine solide Grundlage für das Konzept zu erarbeiten, wurden im Evaluierungskapitel verschiedene Möglichkeiten der Datenhaltung in verteilten Systemen analysiert und auf die Tauglichkeit als Basis für das Konzept überprüft. Es wurde keine passende Technologie gefunden, jedoch konnten diverse Aspekte der evaluierten Technologien im Konzept verwendet und umgesetzt werden. Ein Beispiel dafür ist die Dateireplikation aus XtreemFS und das dort verwendete primärbasierte Protokoll. Eine vereinfachte Version dieses Protokolls wurde im Konzept eingebaut und später im Prototyp umgesetzt.

In der Konzeptionsphase wurde aus den Vorteilen der analysierten Anwendungen, Technologien und Dienste, auf Basis eines verteilten Datenmodells, das Konzept einer verteilten Anwendung für die Dateiverwaltung erstellt. Als Grundlage für dieses Datenmodell wurde die verteilte Versionsverwaltung GIT herangezogen. GIT ermöglicht eine sichere und effiziente Verteilung der Daten. Für die Datenspeicherung wurde eine eigene Datenbank konzipiert, die es ermöglicht Objekte anhand eines Hashwertes effizient in verschiedene Speichermedien abzulegen. Um diese Hashwerte schnell zu finden, werden die Metadaten dieser Objekte in einer Suchmaschine indexiert. Dadurch kann die Suche über die Daten effizient ausgeführt werden.

Die Implementierung des Prototypen wurde in drei Abschnitte untergliedert. Im ersten Teil wurde eine Bibliothek entwickelt, die das Datenmodell, die Datenbank und eine Zugriffsschicht implementiert. Diese Bibliothek ist unabhängig von der restlichen Anwendung und kann in alle PHP-Applikationen eingebunden werden, die mit dem Netzwerk von symCloud kommunizieren wollen. Der zweite Teil umfasst die Plattform, die als funktionierender Prototyp in die bestehende Plattform SULU eingebunden wurde. Neben der Rest-API bietet die Plattform auch eine einfache Benutzungsoberfläche, mit dem Änderungen an den Dateien möglich sind. Über die Authentifizierungsschicht können SULU-BenutzerInnen Dateien in symCloud ablegen und verwalten. Der dritte Teil ist als Beispiel für eine Dritt-Hersteller Applikation konzipiert. Dabei handelt es sich um eine Synchronisierungssoftware, die es ermöglicht Dateien von einem Rechner mit symCloud zu synchronisieren.

Auch wenn der entwickelte Prototyp nicht alle Facetten des Konzepts umsetzt, ist er ein Beweis für die Funktionstüchtigkeit dieses Konzepts. Einige Punkte wurden im Konzept (siehe \ref{chapter_specification_further_topics}) allerdings nicht betrachtet. Einer dieser Punkte ist die Performance des Systems, welcher in der aktuellen Implementierung die größten Herausforderungen darstellt. Hier könnten weiterführende Analysen und Entwicklungen gerade in der Verteilung der Replikationen erhebliche Fortschritte bringen. Zum Abschluss dieser Arbeit soll noch ein kurzer Ausblick gegeben werden.

## Performance von Replikationen

Die Performance der Replikationen ist stark von der Performance des Übertragungsmediums abhängig. Der Prototyp implementiert ein Prozess, der den eigentlichen Prozess blockiert und dadurch die Antwortzeit an den Client stark beeinflusst.

Um genau diese Verzögerungen zu vermeiden implementiert das verteilte Konfigurationsmanagement ZooKeeper[^90] das Protokoll Zab. Dieses basiert auf Broadcast Nachrichten, um die Änderungen in einem Netzwerk zu verteilen. Dabei können alle Replikationen abstimmen, ob die Änderung durchführbar ist. Dieses Votum und die Änderungen auf allen Replikationen laufen parallel ab. Bei Zookeeper kümmert sich ein eigener Prozess um diesen Broadcast, dies vermindert die Antwortzeit an die Clients und erhöht den Durchsatz des Systems [@Reed:2008:STO:1529974.1529978].

## \label{outlook_file_chunking}Rsync Algorithmus

Algorithmen wie Rsync sind darauf ausgelegt, die Effizienz der Daten Datenhaltung und Übertragung zu erhöhen. Wenn zwei Dateien auf verschiedenen, jedoch über ein Netzwerk verbundenen Rechner synchronisiert werden sollen, ermittelt der Rsync Algorithmus jene Teile der Datei die auf beiden Rechner identisch sind. Diese Teile müssen sich nicht an derselben Stelle in den Dateien befinden. Bei diesem Algorithmus erstellt einer der beiden Rechner eine sogenannte Signatur. Dies geschieht, indem die Datei in Blöcke einer bestimmten Länge unterteilt werden. Von diesen Blöcken werden die Prüfsummen ermittelt. Diese Summen werden in eine Datei geschrieben und an den zweiten Rechner gesendet. Dieser unterteilt nun seine Datei ebenfalls in Blöcke derselben Größe. Allerdings nicht nur der Reihe nach sondern von jeder beliebigen Stelle der Datei aus, um möglichst viele Treffer zu erzielen. Als Ergebnis sendet der zweite Rechner eine Liste von Operationen an seinen Partner. Mithilfe dieser kann der erste Rechner die Datei "nachbauen". Dieser Algorithmus erhöht nicht nur die Übertragungsgeschwindigkeit von Dateiänderungen, sondern auch die Speichernutzung von Version zu Version. Es müssen nur die Änderungen gespeichert werden, selbst dann wenn Änderungen in der Mitte der Datei durchgeführt wurden [@TR-CS-96-05].

## \label{lock_mechanism}Lock-Mechanismen

Es gibt diverse Lock-Mechanismen, die auf einem Server optimal funktionieren. Allerdings ist es ungleich schwerer diese Mechanismen über ein Netzwerk zu verteilen. Das Team von XtreemFS entwickelte den sogenannten "Flease"-Algorithmus. Dieser Algorithmus ist ein dezentraler und fehlertolerante Koordination von "lease" also Objekt-Locks in verteilten Systemen. Der Algorithmus arbeitet ohne zentrale Schnittstelle und gewährleistet einen exklusiven Zugriff auf eine Ressource in einem skalierbaren Umfeld [@kolbeck2010flease].

## \label{chapter_outlook_protocolls}Protokolle

Um die Kommunikation zwischen den Servern zu vereinheitlichen, gibt es einige offene Protokolle, die als Erweiterung zum Konzept von symCloud geeignet wären. Zwei dieser Protokolle sind:

Webfinger

:   Webfinger ist ein Protokoll um Informationen über Objekte zu übertragen, die über eine URL identifiziert werden. Als Medium für die Übertragung wird das Standard HTTP Protokoll verwendet. Die Antwort auf eine Anfrage ist ein JSON-Objekt mit dem Mimetyp "application/jrd+json". Dieses JRD (JSON Ressource Descriptor) enthält alle relevanten Informationen zu einem Objekt und weiterführende Links [@jones2013webfinger]. Dieses Protokoll wird von Diaspora verwendet und könnte daher als Bindeglied zwischen den beiden Applikationen dienen.

PubSubHubbub

:   Andere PubSub-Protokolle verlangen von den Clients, dass sie in regelmäßigen Abständen neue Beiträge abfragen. Dies führt zu einer Zeitdifferenz zwischen erstellen und anzeigen. Außerdem fällt, falls es keine neuen Beiträge gibt, viel Overhead an. PubSubHubbub integriert daher einen sogenannten Hub zwischen Server und Client. Die Feed-Server pingen bei einem neuen Beitrag die Hubs an, diese holen sich den Beitrag und leiten ihn via Push an die Clients weiter. Die Aufgabe die Nachrichten sicher an die Clients zu versenden übernimmt der Hub [@fitzpatrick2014hub]. In symCloud könnte ein solcher Hub das Bindeglied zwischen primary- und Backupserver sein. Dies würde die Performance des Erstellens und Verteilens eines Objektes enorm beschleunigen. Jedoch müssten sich die Hubs darum kümmern, die Änderungen und neue Objekte sicher an die Backupserver weiterzuleiten.

Neben der Interoperabilität zwischen verschiedenen Applikationen (Webfinger) bietet gerade das Protokoll PubSubHubbub eine enorme Steigerung der Datensicherheit und Performance.

## \label{outlook_conflict}Konfliktbehandlung

Sowohl die Erkennung von Konflikten als auch die sinnvolle Lösung des Konflikts ist eine wichtige Aufgabe. Unterschieden werden drei Stufen der Konfliktbehandlung [@bleiholder:techniken]:

Konflikte werden ignoriert

:   Es werden weder Unsicherheiten beseitigt, noch Widersprüche aufgelöst. Dabei gilt oft, dass die letzte Änderung übernommen wird, ohne die Änderungen davor zu betrachten.

Konflikte werden vermieden

:   Die Unsicherheiten werden beseitigt, Widersprüche können nicht gelöst werden, jedoch durch die geschickte Auswahl von Werten umgangen werden. Konflikte werden Teilweise zusammengeführt, wenn die Daten es zulassen.

Konflikte werden gelöst

:   Alle Unsicherheiten können beseitigt und die Widersprüche sinnvoll aufgelöst werden. Die Daten werden vollständig zusammengeführt.

Um die beiden Versionen zusammenzuführen, können verschiedene Operatoren (wie JOIN, UNION oder MERGE) verwendet werden. Diese Operatoren führen aber nur Objekte sinnvoll zusammen, wenn die Änderungen jeweils andere Eigenschaften betreffen [@bleiholder:techniken].

Den Inhalt einer Datei zusammenzuführen ist ungleich schwieriger. Um dies zu bewerkstelligen verwenden Anwendungen wie Dropbox oder ownCloud einen einfachen Mechanismus, bei dem beide Versionen nebeneinander erstellt werden. Dies geschieht mit einem Zusatz im Dateinamen. Somit werden die Konflikte nicht automatisch gelöst [@dropbox2015conflicts].

[^90]: <https://zookeeper.apache.org/>
