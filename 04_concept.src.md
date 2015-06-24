# \label{chapter_concept}Konzeption von Symcloud

Dieses Kapitel befasst sich mit der Erstellung eines Speicher- und Architekturkonzeptes für Symcloud. Das zentrale Element dieses Konzeptes ist die Objekt-Datenbank. Diese Datenbank unterstützt die Verbindung zu anderen Servern. Damit ist Symcloud, als Ganzes gesehen ein verteiltes Dateiverwaltungssystem. Es unterstützt dabei die Replikation von Nutz- und Metadaten unter den verbundenen Servern. Die Datenbank beinhaltet eine Suchmaschine, mit der es möglich ist, die Metadaten effizient zu durchsuchen. Die Grundlagen zu dieser Architektur wurden im Kapitel \ref{chapter_xtreemfs} beschrieben. Es ist eine Abwandlung der Architektur, die in XtreemFS verwendet wird.

## Überblick

![Architektur für "Symcloud-Distributed-Storage"\label{architecture}](diagrams/architecture.png)

Die Architektur ist gegliedert in Kern- und optionale Komponenten. In der Abbildung \ref{architecture} sind die Abhängigkeiten der Komponenten untereinander zu erkennen. Die Schichten sind jeweils über ein Interface entkoppelt, um den Austausch einzelner Komponenten zu vereinfachen. Über den "StorageAdapter" bzw. über den "SearchAdapter", lassen sich die Speichermedien der Daten anpassen. Für eine einfache Installation ist es ausreichend, wenn die Daten direkt auf die Festplatte geschrieben werden. Es ist allerdings auch denkbar, die Daten in eine verteilte Datenbank wie Riak oder MongoDB zu schreiben, um die Datensicherheit zu erhöhen.

Durch die Implementierung (siehe Kapitel \ref{chapter_implementation}) als PHP-Bibliothek ist es möglich, diese Funktionalitäten in jede beliebige Applikation zu integrieren. Durch eine Abstraktion der Benutzerverwaltung ist Symcloud vom eigentlichen System komplett entkoppelt.

## \label{chapter_concept_datamodel}Datenmodell

Das Datenmodell wurde speziell für Symcloud entwickelt, um die Anforderungen (siehe Kapitel \ref{specification}) zu erfüllen. Dabei wurde großer Wert darauf gelegt, optimale und effiziente Datenhaltung zu gewährleisten. Abgeleitet wurde das Modell (siehe Abbildung \ref{data_model}) aus dem Modell, welches dem Versionskontrollsystem GIT (siehe Kapitel \ref{chapter_distributed_datamodel}) zugrunde liegt. Dieses Modell unterstützt viele Anforderungen, welche Symcloud an seine Daten stellt.

![Datenmodel für "Symcloud-Distributed-Storage"\label{data_model}](diagrams/data-model.png)

### GIT

Das Datenmodell von GIT erfüllt folgende Anforderungen von Symcloud:

Versionierung

:   Durch die Commits können Versionshistorien einfach abgebildet und diese effizient durchsucht werden. Will ein Benutzer sehen, wie sein Dateibaum vor ein paar Wochen ausgesehen hat, kann das System nach einem geeigneten Commit durchsucht werden (anhand der Erstellungszeit) und anstatt den neuesten Commit, diesen Commit für die weiteren Datenbankabfragen verwenden.

Namensräume

:   Mit den Referenzen können für jeden Benutzer mehrere Namensräume geschaffen werden. Jeder dieser Namensräume erhält einen eigenen Dateibaum und kann von mehreren Benutzern verwendet werden. Damit können Shares einfach abgebildet werden. Jede Referenz kann für Benutzer eigene Berechtigungen erhalten. Dadurch kann ein Zugriffsberichtigungssystem implementiert werden.

Dieses Datenmodell ist aufgrund seiner Flexibilität eine gute Grundlage für ein verteiltes Dateiverwaltungssystem. Es ist auch in seiner ursprünglichen Form für die Verteilung ausgelegt [@chacon2009pro, Kapitel 1.1]. Dies macht es für Symcloud interessant es als Grundlage für die Weiterentwicklung zu verwenden. Aufgrund der immutable Objekte können die Operationen Update und Delete komplett vernachlässigt werden, da Daten nicht aus der Datenbank gelöscht werden. Diese Art von Objekten bringt auch große Vorteile mit sich, wenn es um die Zwischenspeicherung (cachen) von Daten geht. Diese können auf allen Servern gecached werden, da diese nicht mehr verändert werden. Eine Einschränkung hierbei sind die Referenzen, die einen Veränderbaren Inhalt aufweisen. Diese Einschränkung muss bei der Implementierung des Datenmodells berücksichtigt werden, wenn die Daten verteilt werden.

### Symcloud

Für Symcloud wurde das Datenmodell von GIT angepasst und erweitert.

Chunks (Blobs)

:   Der Inhalt von Dateien wird nicht an einem Stück in den Speicher geschrieben, sondern er wird in sogenannte Chunks aufgeteilt. Dieses Konzept wurde aus den Systemen GridFS (siehe Kapitel \ref{chapter_gridfs}) oder XtreemFS (siehe Kapitel \ref{chapter_xtreemfs}) übernommen. Es ermöglicht das Übertragen von einzelnen Dateiteilen, die sich geändert haben[^40]. Andere Vorteile für eine Unterteilung der Dateien in Chunks werden im Kapitel \ref{chapter_concept_file_storage} aufgezählt.

Zugriffsrechte

:   Nicht berücksichtigt wurde, im Datenmodel von GIT, die Zuordnung der Referenzen zu einem Benutzer. Diese Zuordnung wird von Symcloud verwendet, um die Zugriffsrechte zu realisieren. Ein Benutzer kann einem anderen Benutzer die Rechte auf eine Referenz übertragen, auf die er Zugriff besitzt. Dadurch können Dateien und Strukturen geteilt und zusammen verwendet werden (Shares).

Policies
 
:   Die Policies werden verwendet, um zusätzliche Informationen zu den Benutzerrechten bzw. Replikationen in einem Objekt zu speichern. Es beinhaltet im Falle der Replikationen den primary Server bzw. eine Liste von backup Servern, auf denen das Objekt gespeichert wurde.

## \label{chapter_concept_database}Datenbank

Die Datenbank ist eine einfache "Hash-Value" Datenbank, die mithilfe eines Replikators zu einer verteilen Datenbank erweitert wird. Dieses Prinzip wird auch von der Versionsverwaltung GIT als Datenspeicher verwendet (siehe Kapitel \ref{chapter_distributed_datamodel}). Die Datenbank serialisiert die Objekte und speichert sie mithilfe eines Adapters auf einem bestimmten Speichermedium. Zusätzlich spezifiziert jeder Objekt-Typ, welche Daten als Metadaten in einer Suchmaschine indiziert werden sollen. Dies ermöglicht eine schnelle Suche innerhalb dieser Metadaten, ohne auf das eigentliche Speichermedium zuzugreifen.

Symcloud verwendet einen ähnlichen Mechanismus für die Replikationen, wie in Kapitel \ref{xtreemfs_replication} beschrieben wurde. Es implementiert eine einfache Form des primärbasierten Protokolls. Dabei wird jedem Objekt der Server als primary zugewiesen, auf dem es erzeugt wurde. Aus einem Pool an Servern werden die Backupserver ermittelt. Dabei gibt es drei Arten diese zu ermitteln.

Full

:   Die Backupserver werden per Zufallsverfahren ausgewählt. Dabei kann konfiguriert werden, auf wie vielen Servern ein Backup verteilt wird. Dieser Typ wird verwendet um die Chunks gleichmäßig auf die Server zu verteilen. Dadurch lässt sich die Last auf alle Server verteilen. Dies gilt sowohl für den Speicherplatz, als auch die Netzwerkzugriffe. Hierbei könnten auch bessere Verfahren verwendet werden, um den Primary bzw. Backupserver zu ermitteln (siehe Kapitel \ref{outlook_distribution}).

Permissions

:   Wenn ein Objekt auf Basis der Zugriffsrechte verteilt wird, wird es auf allen Servern erstellt, die mindestens einen Benutzer registriert haben, der Zugriff auf dieses Objekt besitzt. Dabei gibt es keine Maximalanzahl der Backupserver. Dieses Verfahren wird für kleinere Objekte, die zum Beispiel Datei- bzw. Ordnerstrukturen enthalten, verwendet. Die Verteilung kann sofort ausgeführt werden oder die Objekte werden beim ersten Zugriff jeden Backupservers "Lazy" nachgeladen. Der Vorteil der "Lazy" Technik ist es, dass die Server nicht immer erreichbar sein müssen, allerdings kann es zu Inkonsistenzen kommen, wenn ein Server nicht die neuesten Daten verwendet, bevor er Änderungen durchführt. Wichtig ist bei diesem Verfahren, dass Änderungen der Zugriffsrechte automatisch zu einem neuen Objekt führen, damit die Backupserver diese Änderung mitbekommen. Um die Datensicherheit für diese Objekte zu erhöhen, könnten aus dem Serverpool eine konfigurierbare Anzahl von Backupservern, wie bei dem Full Typen, ausgewählt werden. Allerdings müsste der Pool auf die zugriffsberechtigten Server beschränkt werden. Diese Methode wurde nicht vollständig implementiert, da der Prototyp keine Autorisierung für Objekte vorsieht. Allerdings werden Objekte, die nicht in der Lokalen Datenbank vorhanden sind, nachgeladen.

Stubs

:   Dieser Typ ist eigentlich kein Replikationsmechanismus, aber er ist wesentlicher Bestandteil des Verteilungsprotokolls von Symcloud. Objekte, die mit diesem Typ verteilt werden, werden als sogenannte Stubs an alle bekannten Server verteilt. Dies bedeutet, dass das Objekt als eine Art remote Objekt fungiert. Es besitzt keine Daten und darf nicht gecached werden. Bei jedem Zugriff erfolgt eine Anfrage an den primary Server, der die Daten zurückliefert, wenn die Zugriffsrechte zu dem Objekt gegeben sind. An dieser Stelle lassen sich Lock-Mechanismen implementieren, da diese Objekte immer nur auf dem primary Server geändert werden können. Falls es an dieser Stelle zu einem Konflikt kommt, betrifft es nur den einen Backupserver und nicht das komplette Netzwerk. Stubs können, wie auch der vorherige Typ, automatisch verteilt werden oder "Lazy" bei der ersten Verwendung nachgeladen werden. In der Implementierung, wurde dieser Typ nicht vorgesehen. Es wurde allerdings eine Methode implementiert, die es ermöglicht, Objekte im Netzwerk zu suchen und nachzuladen.

Im Kapitel \ref{chapter_implementation_distributed_storage} werden diese Vorgänge anhand von Ablaufdiagrammen genauer erläutert.

## Metadatastorage

Der Metadatastorage verwaltet die Struktur der Daten. Es beinhaltet folgende Punkte:

Dateibaum (Tree)

:   Diese Objekte beschreiben wie die Dateien zusammenhängen. Diese Struktur ist vergleichbar mit einem Dateibaum auf einem lokalen Dateisystem. Es gibt pro Namensraum jeweils ein Root-Verzeichnis, welches andere Verzeichnisse und Dateien enthalten kann. Dadurch lassen sich beliebig tiefe Strukturen abbilden. In diesem Baum können zu einer Datei auch andere Werte, wie zum Beispiel Titel, Beschreibung und Vorschaubilder hinterlegt werden.

Versionen (Commit)

:   Über die zusammenhängenden Commits kann der Dateiänderungsverlauf abgebildet werden. Jede Änderung im Baum bewirkt das Erstellen eines neuen Commits auf Basis des Vorherigen. Dabei wird der aktuelle Baum in die Datenbank geschrieben und ein neuer Commit mit einer Referenz auf das Root-Verzeichnis erstellt.

Referenzen

:   Um den aktuellen Commit und damit den aktuellen Dateibaum des Benutzers, nicht zu verlieren, werden Referenzen immer auf den neuesten Commit gesetzt. Dies erfordert das Aufbrechen des Konzepts der immutable Objekte. Um diese Objekt-Typen zu unterstützen werden diese Objekte auf keinem Server gecached werden und die Backupserver automatische Updates zu Änderungen erhalten.

Diese drei Objekt-Typen werden im Netzwerk mit unterschiedlichen Replikationstypen verteilt. Die Strukturdaten (Tree und Commit) verwenden den Typ "Permission". Das bedeutet, dass jeder Server, der Zugriff auf diesen Dateibaum besitzt, das Objekt in seine Datenbank ablegen kann. Im Gegensatz dazu werden Referenzen als Stub-Objekte im Netzwerk verteilt. Diese werden bei jedem Zugriff, auf dessen primary Server angefragt. Änderungen an einer Referenz werden ebenfalls an den primary Server weitergeleitet.

## \label{chapter_concept_file_storage}Filestorage

Der Filestorage verwaltet die abstrakten Dateien im System. Diese Dateien werden als reine Datencontainer angesehen und besitzen daher keinen Namen oder Pfad. Eine Datei besteht nur aus Datenblöcken (Chunks), einer Länge, dem Mimetype und einem Hash für die Identifizierung. Diese abstrakten Dateien werden in den Tree, des Metadatastorage, mit eingebettet und stehen daher nur konkreten Dateien zur Verfügung. Das bedeutet, dass eine konkrete Datei, eine Liste von Chunks besitzt, die die eigentlichen Daten repräsentieren. Diese Trennung von Daten und Metadaten macht es möglich, zu erkennen, wenn eine Datei an verschiedenen Stellen des Systems, vorkommt und dadurch wiederverwendet werden kann. Theoretisch können auch Teile einer Datei in einer anderen Datei vorkommen. Dies ist aber je nach Größe der Chunks sehr unwahrscheinlich. Da diese keine Zugriffsrechte besitzen, spielt es keine Rolle, ob dieser von dem selben oder von einem anderen Benutzer wiederverwendet wird. Wenn der Hash übereinstimmt, besitzen beide Dateien der Benutzer den selben Datenblock und dürfen diesen verwenden.

Für Symcloud bietet das Chunking von Dateien zwei große Vorteile:

Wiederverwendung

:   Durch das Aufteilen von Dateien in Daten-Blöcke, ist es theoretisch möglich, dass sich mehrere Dateien den selben Chunk teilen. Häufiger jedoch geschieht dies, wenn Dateien von einer Version zur nächsten nur leicht verändert werden. Nehmen wir an, dass eine große Text-Datei im Storage liegt, die die Größe eines Chunks übersteigt, wird an diese Datei nun weiterer Inhalt angehängt. Die neue Version besteht aus dem Chunk der ersten Version und aus einem neuen. Dadurch konnte sich das Storagesystem den Speicherplatz eines Chunks sparen. Mithilfe bestimmter Algorithmen könnte die Ersparnis optimiert werden[^40] (siehe Kapitel \ref{outlook_file_chunking}) [@anglin2011data].

Streaming

:   Um auch große Dateien zu verarbeiten, bietet das Chunking von Dateien die Möglichkeit, Daten immer nur Block für Block zu verarbeiten. Dabei können die Daten so verarbeitet werden, dass immer nur wenige Chunks im Speicher gehalten werden müssen. Zum Beispiel kann beim Streaming von Videodateien immer nur ein Chunk versendet und sofort wieder aus dem Speicher gelöscht werden, bevor der nächste Chunk aus der Datenbank geladen wird. Dies verkürzt die Zeit, um eine Antwort zu erzeugen. Moderne Video-Player machen sich dieses Verfahren zu Nutze und versenden viele HTTP-Request mit bestimmten Header-Werten, um den Response zu beschränken. Dabei wird der Request-Header `range` auf den Ausschnitt der Datei gelegt, die der Player gerade für die Ausgabe benötigt. Aus diesen Informationen kann das System die benötigten Chunks berechnen und genau diese aus dem Storage laden [@fielding2014a].

Im Filestorage werden zwei Arten von Objekten beschrieben. Zum einen sind dies die abstrakten Dateien, die nicht direkt in die Datenbank geschrieben werden, sondern primär der Kommunikation dienen und in den Dateibaum eingebettet werden können. Zum anderen sind es die konkreten Chunks, die direkt in die Datenbank geschrieben werden. Um die Chunks optimal zu verteilen, werden diese mit dem Replikationstyp "Full" persistiert. Dabei werden diese Objekte auf eine festgelegte Anzahl von Servern verteilt. Dadurch lässt sich der gesamte Speicherplatz des Netzwerkes, mit dem Hinzufügen neuer Server, erweitern und ist nicht beschränkt auf den Speicherplatz des kleinsten Servers. Die Chunk Objekte werden dann auf den Remoteservern in einem Cache gehalten, um den Traffic zwischen den Servern so minimal wie möglich zu halten. Dieser Cache kann diese Objekte unbegrenzt lange speichern, da diese Blöcke unveränderbar sind und nicht gelöscht werden können. Dateien werden nicht wirklich gelöscht, sondern nur aus dem Dateibaum entfernt. Alte Versionen der Datei können auch später wiederhergestellt werden, indem die Commit-Historie zurückverfolgt wird.

## Session

Als zentrale Schnittstelle auf die Daten fungiert die "Session". Sie ist als eine Art "High-Level-Interface" konzipiert und ermöglicht den Zugriff auf alle Teile des Systems über eine zentrale Schnittstelle. Zum Beispiel können Dateien hoch- bzw. heruntergeladen werden oder die Metadaten mittels Dateipfad abgefragt werden. Damit fungiert es als Zwischenschicht zwischen "Filestorage", "Metdatastorage" und Rest-API.

## \label{chapter_concept_rest_api}Rest-API

Die Rest-API ist als zentrale Schnittstelle nach außen gedacht. Sie wird zum Beispiel verwendet, um Daten für die Oberfläche in der Plattform zu laden oder Dateien mit einem Endgerät zu synchronisieren. Diese Rest-API ist über ein Benutzersystem gesichert. Die Zugriffsrechte können sowohl über Form-Login und Cookies, für Javascript Applikationen, als auch über OAuth2 für externe Applikationen überprüft werden. Dies ermöglicht eine einfache Integration in andere Applikationen, wie es zum Beispiel in der Prototypen-Implementierung (siehe Kapitel \ref{chapter_implementation_platform}) passiert ist. Die OAuth2 Schnittstelle ermöglicht es auch, externe Applikationen mit Daten aus Symcloud zu versorgen.

Die Rest-API ist in vier Bereiche aufgeteilt:

Directory

:   Diese Schnittstelle bietet den Zugriff auf die Ordnerstruktur einer Referenz über den vollen Pfad: `/directory/<reference-name>/<directory>`. Bei einem GET-Request auf diese Schnittstelle, wird der angeforderte Ordner als JSON-Objekt zurückgeliefert. Enthalten sind dabei unter anderem der Inhalt des Ordners (Dateien oder andere Ordner).

File

:   Unter dem Pfad `/file/<reference-name>/<directory>/<filename>.<extension>` können Dateien heruntergeladen werden oder ihre Informationen abgefragt werden.

Reference

:   Die Schnittstelle für die Referenzen erlaubt das Erstellen und Abfragen von Referenzen. Zusätzlich können mittels PATCH-Requests Dateien, aus dem Namensraum einer bestimmten Referenz, geändert und diese gesammelt versioniert werden.

Objekts

:   Diese Objektschnittstelle verwendet der Replikator um die Objekte zwischen den Servern zu verteilen. Dabei werden die HTTP-Befehle GET und POST verwendet, um Daten abzufragen oder zu erstellen.

Die genaue Funktion der Rest-API wird im Kapitel \ref{chapter_implementation_platform} beschrieben.

## Zusammenfassung

Das Konzept von Symcloud baut sehr stark auf der Verteilung der Daten innerhalb eines Netzwerkes auf. Dies ermöglicht eine effiziente und sichere Datenverwaltung. Allerdings kann die Software auch ohne dieses Netzwerk ihr volles Potenzial entfalten. Es erfüllt die in Kapitel \ref{specification} angeführten Anforderungen und bietet durch die erweiterbare Architektur die Möglichkeit andere Systeme und Plattformen zu verbinden. Über die verschiedenen Replikationstypen lassen sich verschiedene Objekte auf verschiedenste Weise im Netzwerk verteilen. Die einzelnen Server sind durch eine definierte Rest-API verbunden und daher unabhängig von der darunterliegenden Technologie.

Dieses Konzept vereint viele der im vorherigen Kapitel beschriebenen Vorzüge der beschriebenen Technologien.

[^40]: Dieses Feature wurde in der Implementierung, die während dieser Arbeit entstanden ist, nicht umgesetzt.
