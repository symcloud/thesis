# Konzept für Symcloud\label{chapter_concept}

__TODO nur Notizen__
Dieses Kapitel befasst sich mit der Erstellung eines Speicherkonzeptes für Symcloud. Symcloud wird sowohl als eigenständige Server-Applikation als auch als Library für die Verwendung in einer bestehenden Applikation gestaltet. Es baut auf einer verteilten Datenbank RIAK auf und ist dadurch für sich gesehen sehr sicher. Als Ganzes gesehen, fungiert Symcloud als eigenständiges Storage-System. Bei der Verbindung mit anderen Symcloud-Servern fungiert dieses Netzwerk als verteiltes System, mit dem es möglich ist, konfigurierbare Replikationen von Nutz- und Metadaten durchzuführen. Konzeptionell gibt es bei Symcloud auch eine Suchmaschine, mit der es möglich sein sollte, Daten verteilt zu suchen.

Die Sulu-Oberfläche wird über eine Rest-Schnittstelle mit Symcloud kommunizieren. Bestenfalls könnten Benutzerdaten über den `UserProvider` von Sulu mitverwendet werden. Mittels Cookie Authentifizierung könnte JavaScript direkt mit der Schnittstelle kommunizieren ohne sich erneut anzumelden.

Ebenfalls denkbar wäre auch eine Authentifizierung mittels Key und Secret, wie es auch bei Amazon S3 implementiert wurde. Diese Kompatibilität könnte auch auf die REST-Schnittstelle ausgeweitet werden.

__TODO was wird implementiert__

## Überblick

![Architektur für "Symcloud-DistributedStorage"\label{architecture}](diagrams/architecture.png)

Die Architektur ist gegliedert in Kern-Komponenten und optionale Komponenten. In der Abbildung \ref{architecture} ist die Kopplung der Komponenten zu erkennen. Die Schichten sind jeweils über ein Interface entkoppelt und ein Adapter entkoppelt den jeweiligen Datenbankzugriff.

Im Rahmen dieser Arbeit entstand eine Beispiel Implementierung mit der verteilten Datenbank Riak für die Speicherung aller Informationen.

### PHP Stream & Rest API

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
