# Konzept für Symcloud\label{chapter_concept}

Dieses Kapitel befasst sich mit der Erstellung eines Speicherkonzeptes für Symcloud. Das zentrale Element dieses Konzeptes ist die Objekt-Datenbank. Diese Datenbank unterstützt eine die Verbindung zu anderen Servern. Damit ist Symcloud, als ganzes gesehen ein verteiltes Storage-System. Es unterstützt dabei die Replikation von Nutz- und Metadaten unter den verbundenen Servern. Die Datenbank beinhaltet eine Suchmaschine, mit der es möglich ist, die Daten nach Metadaten zu durchsuchen.

__TODO nur Notizen__

Symcloud wird sowohl als eigenständige Server-Applikation als auch als Library für die Verwendung in einer bestehenden Applikation gestaltet. Es baut auf einer verteilten Datenbank RIAK auf und ist dadurch für sich gesehen sehr sicher. Als Ganzes gesehen, fungiert Symcloud als eigenständiges Storage-System. Bei der Verbindung mit anderen Symcloud-Servern fungiert dieses Netzwerk als verteiltes System, mit dem es möglich ist, konfigurierbare Replikationen von Nutz- und Metadaten durchzuführen. Konzeptionell gibt es bei Symcloud auch eine Suchmaschine, mit der es möglich sein sollte, Daten verteilt zu suchen.

Die Sulu-Oberfläche wird über eine Rest-Schnittstelle mit Symcloud kommunizieren. Bestenfalls könnten Benutzerdaten über den `UserProvider` von Sulu mitverwendet werden. Mittels Cookie Authentifizierung könnte JavaScript direkt mit der Schnittstelle kommunizieren ohne sich erneut anzumelden.

Ebenfalls denkbar wäre auch eine Authentifizierung mittels Key und Secret, wie es auch bei Amazon S3 implementiert wurde. Diese Kompatibilität könnte auch auf die REST-Schnittstelle ausgeweitet werden.

__TODO nur Notizen ende__

## Überblick

![Architektur für "Symcloud-Distributed-Storage"\label{architecture}](diagrams/architecture.png)

Die Architektur ist gegliedert in Kern-Komponenten und optionale Komponenten. In der Abbildung \ref{architecture} sind die Abhängigkeiten der Komponenten untereinander zu erkennen. Die Schichten sind jeweils über ein Interface entkoppelt, um den Austausch einzelner Komponenten zu vereinfachen. Über den `StorageAdaper` bzw. über den `SearchAdapter`, lassen sich die Speicher der Daten anpassen. Für eine einfache Installation reicht es die Daten direkt auf die Festplatte zu schreiben. Es ist allerdings auf denkbar die Daten in eine Datenbank wie Riak oder MogoDB zu schreiben, um die Sicherheit zu erhöhen.

__TODO verschieben in die Implementierung__

Im Rahmen dieser Arbeit entstand eine Prototyp Implementierung mit der verteilten Datenbank Riak für die Speicherung aller Informationen. Zusätzlich entstand ein Adapter um die Daten direkt in einen Ordner zu schreiben. Mithilfe diesem, ist Symcloud ohne weitere Abhängigkeiten zu installieren.

### Datenmodell

Das Datenmodell wurde speziell für Symcloud entwickelt, um seine Anforderungen zu erfüllen. Es sollte alle Anforderungen an das Projekt erfüllen, um eine optimale und effiziente Datenhaltung zu gewährleisten. Abgeleitet wurde das Model (siehe \ref{data_model}) aus dem Model, dass dem Versionskontrollsystem GIT zugrunde liegt. Dieses Model unterstützt viele Anforderungen, welche Symcloud benötigt.

![Datenmodel für "Symcloud-DistributedStorage"\label{data_model}](diagrams/data-model.png)

#### Exkurs: GIT

GIT[^41] ist ein verteilte Versionsverwaltung, das ursprünglich entwickelt wurde, um den Source-Code des Linux Kernels zu verwalten.

![GIT-Logo](images/git-logo.png)

Die Software ist im Grunde eine Key-Value Datenbank. Es werden Objekte in Form einer Datei abgespeichert, in dem jeweils der Inhalt des Objekts abgespeichert wird. Der Name der Datei enthält den Key des Objektes. Dieser Key wird berechnet indem ein sogenannter SHA berechnet wird. Der SHA ist ein mittels Secure-Hash-Algorith berechneter Hashwert der Daten. Das Listing \ref{git:calc_hash} zeigt, wie ein SHA in einem Terminal berechnet werden kann.

```{caption="Berechnung des SHA eines Objektes\label{git:calc_hash}" .bash}
$ OBJECT='blob 46\0{"name": "Johannes Wachter", "job": "Web-Developer"}'
$ echo -e $OBJECT | shasum
6c01d1dec5cf5221e86600baf77f011ed469b8fe -
```

Im Listing \ref{git:create_object_blob} wird ein GIT-Objekt vom Typ BLOB erstellt und in den `objects` Ordner geschrieben. 

```{caption="Erzeugung eines GIT-BLOB\label{git:create_object_blob}" .bash}
$ OBJECT='blob 46\0{"name": "Johannes Wachter", "job": "Web-Developer"}'
$ echo -e $OBJECT | git hash-object -w --stdin
6c01d1dec5cf5221e86600baf77f011ed469b8fe
$ find .git/objects -type f
    .git/objects/6c/01d1dec5cf5221e86600baf77f011ed469b8fe
```

Die Objekte in GIT sind immutable, also nicht veränderbar. Ein einmal erstelltes Objekt wird nicht mehr aus der Datenbank gelöscht. Bei der Änderung eines Objektes wird ein neues Objekt mit einem neuen Key erstellt.

##### Objekt Typen {.unnumbered}

GIT kennt folgende Typen:

Ein BLOB

:   repräsentiert eine einzelne Datei in GIT. Der Inhalt der Datei wird in einem Objekt gespeichert. Bei Änderungen ist GIT auch in der Lage Inkrementelle DELTA-Dateien zu speichern. Beim wiederherstellen werden diese DELTAs der Reihe nach aufgelöst. Ein BLOB besitzt für sich gesehen keinen Namen.

Der TREE

:   beschreibt ein Ordner im Repository. Ein TREE enthält andere TREE bzw. BLOB Objekte und definiert damit eine Ordnerstruktur. In einem TREE werden auch die Namen zu BLOB und TREE Objekten festgelegt.

Der COMMIT

:   ist ein Zeitstempel eines einzelnen TREE Objektes. Im folgenden Listing \ref{git:commit_listing} ist der Inhalt eines COMMIT Objektes auf einem Terminal ausgegeben.

```{caption="Inhalt eines COMMIT Objektes\label{git:commit_listing}" .bash .numberLines}
$ git show -s --pretty=raw 6031a1aa
commit 6031a1aa3ea39bbf92a858f47ba6bc87a76b07e8
tree 601a62b205bb497d75a231ec00787f5b2d42c5fc
parent 8982aa338637e5654f7f778eedf844c8be8e2aa3
author Johannes Wachter <johannes.wachter@massiveart.at> 1429190646 +0200
committer Johannes Wachter <johannes.wachter@massiveart.at> 1429190646 +0200

    added short description gridfs and xtreemfs
```

Das Objekt enthält folgende Werte:

| Zeile | Name | Beschreibung |
|------|-----|-----|
| 2 | commit | SHA des Objektes |
| 3 | tree | TREE-SHA des Stammverzeichnisses |
| 4 | parent(s) | Ein oder mehrere Vorgänger |
| 5 | author | Verantwortlicher für die Änderungen |
| 6 | committer | Ersteller des COMMITs |
| 8 | comment | Beschreibung des COMMITs |

__Anmerkungen:__

* Ein COMMIT kann mehrere Vorgänger haben wen sie zusammengeführt werden. Zum Beispiel würde dies bei einem MERGE verwendet werden.
* Der Autor und Ersteller des COMMITs können sich unterscheiden, wenn zum Beispiel ein Benutzer einen PATCH erstellt ist er der Verantwortliche für die Änderungen. Der Benutzer, der den Patch nun auflöst und den `git commit` Befehl ausführt, ist der Ersteller.

REFERENCE

:   ist ein Verweis auf einen bestimmten COMMIT. Aufbauend auf diese Verweise, ist das Branching-Model von GIT aufgebaut.

![Beispiel eines Repositories\label{git:data-model-example} [@chacon2015git]](images/git-data-model-example.png)

##### Anforderungen {.unnumbered}

Das Datenmodell von GIT erfüllt folgende Anforderungen von Symcloud:

Versionierung

:   Durch die Commits können Versionshistorien einfach abgebildet werden und diese effizient durchsucht werden. Will ein Benutzer sehen, wie sein Dateibaum vor ein paar Wochen ausgehen hat, kann das System nach einem geeigneten Commit durchsuchen (anhand der Erstellungszeit) und anstatt des neuesten Commits, diesen Commit für die weiteren Datenbankabfragen verwenden.

Namensräume

:   Mit den Referenzen, können für jeden Benutzer mehrere Namensräume geschaffen werden. Jeder dieser Namensräume erhält einen eigenen Dateibaum und kann von mehreren Benutzern verwendet werden. Damit können Shares (__TODO Name__) einfach abgebildet werden. Jede Referenz kann für Benutzer eigene Berechtigungen erhalten und dadurch eine ACL eingerichtet werden.

Symlinks

:   Ebenfalls mit den Referenzen, können sogenannte Symlinks erstellt werden. Diese Symlinks werden im System verwendet, um Shares an einer bestimmten Stelle des Dateibaums eines Benutzers zu platzieren[^40].

##### Zusammenfassung {.unnumbered}

__TODO Zusammenfassung GIT Datenmodel__

Ein großer Vorteil der immutable (nicht veränderbaren) Datenpakete ist das Caching, das auf jeder Maschine durchgeführt werden kann, ohne ein PURGE (invalidierung von Cache-Einträgen) zu benötigen, da sich Objekte in der Datenbank nicht ändern sondern nur neue dazu kommen. Dies gilt für alle Objekte in diesem Model außer Referenzen. Diese müsse bei jedem Zugriff aus der Datenbank geladen werden.

#### Symcloud

Für Symcloud wurde das Datenmodell angepasst und erweitert.

Blobs

:   Dateien werden nicht komplett in einen Blob geschrieben sondern werden in sogenannte Blobs aufgeteilt. Dieses Konzept wurde aus den Systemen GridFS (siehe Kapitel \ref{chapter_gridfs}) oder XtreemFS (siehe Kapitel \ref{chapter_xtreemfs}) übernommen. Es ermöglicht das Übertragen von einzelnen Dateiteilen, die sich geändert haben. Dieses Feature wurde allerdings in der Prototyp Implementierung nicht vorgesehen. Allerdings würde das System ein solches Verhalten unterstützen.

Zugriffsrechte

:   Nicht berücksichtigt wurde im Datenmodel von GIT die Zuordnung der Referenzen zu einem Benutzer. Diese Zuordnung wird von Symcloud verwendet, um die Zugriffsrechte zu realisieren. Ein Benutzer kann einem anderen Benutzer die Rechte auf eine Referenz übertragen, auf die er Zugriff besitzt. Dadurch können Dateien geteilt und zusammen verwendet werden.

Symlinks

:   Die dritte Erweiterung ist die Verbindung zwischen Tree und Referenz. Diese Verbindung verwendet Symcloud um Symlinks (zu Referenzen) in einem Dateibaum zu modellieren und dadurch die Einbettung von Shares (__TODO Name__) in den Dateibaum zu ermöglichen. Diese Verbindung ist unabhängig von dem aktuellen Commit der Referenz und dadurch ist die gemeinsame Verwendung der Dateien zwischen den Benutzern sehr einfach umzusetzen[^40]. 

Policies (__TODO fehlt im Diagram__)
 
:   Die Policies wurden verwendet, um Zusätzliche Informationen zu den Benutzerrechten bzw. Replikationen zu einem Objekt zu speichern. Es beinhaltet im Falle der Replikationen zum Beispiel den Primary-Server bzw. eine Liste von Backup-Servern, auf denen das Objekt gespeichert wurde.

### Datenbank

Die Datenbank ist eine einfache "Hash-Value" Datenbank, der mithilfe des `Replicators` zu einer verteilen Datenbank ausgebaut werden kann. Die Datenbank serialisiert die Objekte und speichert Sie mithilfe des Adapters in einem Speichermedium. Dieses Speichermedium kann mithilfe des Adapters verschiedene Ziele besitzen. Jedes Objekt spezifiziert welche Daten als Metadaten in einer Suchmaschine indiziert werden. Dies ermöglicht eine schnelle suche innerhalb dieser Metadaten, ohne auf das eigentliche Speichermedium zuzugreifen.

__TODO bessere beschreibung zur Datenbank, Replikationen und Zugriffsrechte__

Nähere Informationen zu der Implementierung dieser Datenbank und des Replikationsmechanismuses werden in Kapitel \ref{distributed_database} gegeben. (__TODO wie schreiben__)

### Metadatastorage

Der Metadatastorage verwaltet die Struktur der Daten. Es beinhaltet folgende Punkte:

Dateibaum (Tree)

:   beschreibt wie die Dateien zusammenhängen. Diese Struktur ist vergleichbar mit einem Dateibaum in einem lokalen Dateisystem. Es gibt einen Root-Verzeichnis, dieses besitzt Verzeichnisse und Dateien. Dadurch lassen sich beliebig Tiefe Strukturen abbilden. In diesem Baum können zu einer Datei auch andere Werte, wie zum Beispiel Titel, Beschreibung und Vorschaubilder hinterlegt werden.

Versionen (Commit)

: Über die Zusammenhängenden Commits kann der Dateiänderungsverlauf abgebildet werden. Jede Änderungen im Baum bewirkt das erstellen eines Commits. Dabei wird der aktuelle Baum in die Datenbank geschrieben und ein neuer Commit erstellt.

Referenzen

:   Um den aktuellen Commit und damit der aktuelle Dateibaum, des Benutzers, nicht zu verlieren, werden Referenzen immer auf den neuesten Commit gesetzt. Dies erfordert das aufbrechen des Konzepts der Immutable Objekte. Dies unterstützt die implementierte Datenbank dadurch, dass diese Objekte auf keinem Server gecached werden und die Backup-Server automatische Updates zu Änderungen erhalten.

### Filestorage

Der Filestorage verwaltet die abtrakten Dateien im System. Diese Dateien werden als reine Datencontainer angesehen und besitzen daher keinen Namen oder Pfad. Eine Datei besteht nur aus Datenblöcken (Blobs), einer Länge, dem Mimetype und einem Hash für die Identifizierung. Dieser Hash wird im Metadatastorage verwendet, um die Daten zu einer Datei zu finden. Dazu wird der Hash der Datei zu einem TreeNode abgelegt. Diese Trennung von Daten und Metadaten macht es möglich zu erkennen, wenn eine Datei an verschiedenen Stellen des Systems vorkommt und dadurch wiederverwendet werden kann. Dabei spielt es keine Rolle, ob diese Datei von dem selben Benutzer wiederverwendet wird oder von einem anderen. Wen der Hash übereinstimmt, besitzen beide Benutzer die selbe Datei und dürfen dadurch darauf zugreifen.

### Session

Als zentraler Zugriff auf die Daten steht für den High-Level Zugriff die Session zur Verfügung. Diese Session ermöglicht den Zugriff auf alle Teile des Systems über eine einfache Schnittstelle. Es ermöglicht mit dem Filestorage mittels Hash zu kommunizieren aber auch die Metadaten mittels Dateipfad zu traversieren. Damit ist dies die Zwischenschicht zwischen Filestorage, Metdatastorage und Rest API.


__TODO Ab hier nur Notizen__




### Rest API

Die Rest-API ist die zentrale Schnittstelle um mit Symcloud zu kommunizieren. Die einzelnen Schnittstellen sind für High-Level zugriffe gedacht und verbirgt die Komplexität des Datenmodells und Speicherstruktur. Der Zugriff erfolgt über die Ordnerstruktur des Benutzers. Zusätzlich gibt der Benutzer die Identifikation der Referenz an, welcher er durchsuchen will.

__TODO nur Notizen__
Eventuell Zugriff über PHP Stream wenn die Library in die Applikation eingebettet ist oder eine Rest-API, falls dies als eigenständige Applikation (long running process) umgesetzt wird. Die REST-API könnte, bis zu einem gewissen grade, kompatibel zu der S3 Schnittstelle sein.

### StorageController

__TODO nur Notizen__
Zentrale Zugriffsschnittstelle

### SecurityController

__TODO nur Notizen__
Bearbeitet und überprüft Datei Berechtigungen.

### Metadaten Storage

__TODO nur Notizen__
Entweder auch auf RIAK oder MySQL je nach dem wo unstrukturierte Daten abgelegt werden. Hier werden die Daten zum File abgelegt. Zum einen die Struktur / ACL / Größe / Name / Replikationen (auf welchen Servern) / ... Strukturelle Zugriffe wie `ls` / `mkdir` / `prop` gehen nur über diese Schnittstelle und die Daten müssen nicht gelesen werden. 

Später können hier unstrukturierte Daten wie Titel / Beschreibung / Referenzen und Includes (aus xanadu) zusätzlich abgelegt werden. 

"Buckets" (evtl. anderer Name) dienen zur Gruppierung. Diese Gruppierungen können gemeinsame Optionen und Benutzerrechte besitzen. Benutzerrechte auf einzelne Objekte ist nicht vorgesehen, da es nicht in den Anforderungen benötigt wird.

### FileStorage\label{concept_file_storage}

__TODO nur Notizen__
Eventuell Speicherkonzept aufbauend auf einem Blob Storage. Dateien werden in z.b. 8MB große Blöcke geteilt und anhand ihres Hash-wertes in eine Datei geschrieben. Der Hash fungiert hier als eine Art ID. Diese Daten könnten dann in einer Objekt-Datenbank wie RIAK gespeichert werden. Alternativ wäre auch eine Speicherung auf dem Filesystem möglich. Dies könnte durch XtreemFS ebenfalls verteilt aufgebaut sein. Ein zusätzliches Objekt mit einem Array aus Blob-IDs würde dann eine Datei darstellen. Diese bekäme dann die den Hash-wert der Datei als seine ID.

Diese Schicht übernimmt auch die Versionierung der Dateien. Dies geschieht im Zusammenspiel mit dem Metadaten-Storage, da die Informationen zu einer Version ebenfalls dort abgelegt werden.

__TODO Beschreibung Chunking! Vorteile, Nachteile, ...__

__TODO warum RIAK und nicht GridFS oder XtreemFS__

Ein mögliches Datenmodell wäre das von GIT.

![Git Datenmodell [Quelle <http://git-scm.com/book/it/v2/Git-Internals-Git-References>]](images/git-data-model.png)

## Zusammenfassung

Symcloud verwendet nicht nur ein verteiltes System (RIAK), es ist auch selbst ein verteiltes System, das die Metadaten/Nutzdaten trennt und diese über eine Schnittstelle zur Verfügung stellt. Zusätzlich bietet es die Möglichkeit Replikationen zu konfigurieren und eine Suche über alle Verknüpften Server durchzuführen.

Es kann pro Bucket festgelegt werden, welcher Benutzer Zugriff auf diesen hat bzw. ob er diese durchsuchen darf. Dies bestimmt die Einstellungen des Replikators, der die Daten anhand dieser Einstellungen über die verbundenen Instanzen verteilt.

Beispiel:

* Bucket 1 hat folgende Policies:
 * SC1 User1 gehört der Bucket
 * SC2 User2 hat Leserechte
 * SC3 User3 hat Lese- und Schreibrechte

Der Replikator wird nun folgendermaßen vorgehen.

1. Die Metadaten des Buckets werden auf die Server SC2 und SC3 repliciert.
2. Die Nutzdaten (aktuellste Version) des Buckets werden auf den Server SC3 repliciert und aktuell gehalten.
3. Beides wird automatisch bei Änderungen durchgeführt.
4. Beim lesen der Datei wird SC2 bei SC1 oder SC3 (je nach Verfügbarkeit) die Daten holen und bei sich persistieren. Diese Kopie wird nicht automatisiert von SC3 upgedated, sie wird nur bei Bedarf aktualisiert.
5. Bei Änderung einer Datei des Buckets auf SC3 werden die Änderungen automatisch auf den Server S1 gespielt.

Die Suchschnittstelle wird bei der Suche nach Dateien für den User2 oder User3 auf das Bucket durchsuchen. Jedoch wird der User3 die Daten in seinem eigenen Server suchen und nicht bei S1 nachfragen. Da S2 nicht immer aktuelle Daten besitzt, setzt er bei der Schnittstelle S1 eine Anfrage ab, um die Suche bei sich zu Vervollständigen.

Dieses Konzept vereint die größten Vorteile, die im vorherigen Kapitel beschrieben wurden.

[^40]: Dieses Feature wurde in der Implementierung, die während dieser Arbeit entstanden ist, nicht umgesetzt.
[^41]: <http://git-scm.com/>
