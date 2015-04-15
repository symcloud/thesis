# Konzept für Symcloud

__TODO nur Notizen__
Dieses Kapitel befasst sich mit der Konzeption des Konzeptes für Symcloud. Symcloud wird als eigenständige Server-Applikation gestalltet. Es baut auf einer vertelilten Datenbank RIAK auf und ist dadurch für sich gesehen sehr sicher. Als ganzes gesehen, fungiert Symcloud als eigenständiges Storage System. Allerdings kann es bei verbindung mit anderen Symcloud-Servern als komplettes verteiltes System fungieren, mit des es möglich ist konfigurierbare Replikationen von Nutzdaten bzw. Metadaten durchzufürhren. Konzeptionell gibt es bei Symcloud auch eine Suchmaschine mit der es möglich sein sollte Daten verteilt zu suchen.

Die Sulu-Oberfläche wird über eine Rest-Schnittstellt mit Symcloud Kommunizieren. Bestenfalls könnten Benutzerdaten über den UserProvider von Sulu mitverwendet werden und mittels Cookie Authentifizierung könnte direkt JavaScript mit der Schnittstelle kommunizieren ohne sich erneut anzumelden. 

## Überblick

```
			+---------------------------------+                      |
			|      PHP Stream & rest API      | <--------------------|
			+---------------------------------+                      |
    				|						|                        |
			+-------------------+       +--------------+		     |
			| StorageController | -+--- | SearchEngine | <-----------|
			+-------------------+  |    +--------------+		     |    +----------------+
					|			   |		|   				     |--> | Other Symcloud |
					|              |    +-----------------------+    |    +----------------+
					|              +--- | ReplicationController | <--|
					|                   +-----------------------+	 |
					|												 |
			+--------------------+      +--------------+             |
			| SecurityController | ---- | UserProvider |             |
			+--------------------+      +--------------+             |
					|
		+-----------+---------------+
		|							|
+--------------+			+-----------------+
| FilebStorage |			| MetadataStorage |
+--------------+       		+-----------------+
   |							|
   |							|
   v 							v
+------+					+-----------------+
| RIAK |					| MySQL oder RIAK |
+------+					+-----------------+
```

### PHP Stream & Rest API

__TODO nur Notizen__

Evtl. zugriff über PHP Stream wenn die Library in die Applikation eingebettet ist oder eine RestAPI falls dies als eigenständige Applikation (long runningg process) umgesetzt wird.

### StorageController

__ TODO nur Notizen__

Zentrale zugriffsschnittstelle

### SecurityController

__ TODO nur Notizen__

Bearbeitet und überprüft datei berechtigungen.

### Metadaten Storage

__TODO nur Notizen__

Entweder auch auf RIAK oder MySQL je nach dem wo unstruckturierte Daten abgelegt werden. Hier werden die Daten zum File abgelegt. Zum einen die Struktur / ACL / Größe / Name / Replikationen (auf welchen Servern) / ... Strukturele zugriffe wie `ls` / `mkdir` / `prop` gehen nur über diese Schnittstelle und die Daten müssen nicht gelesen werden. 

Später können hier unstrukturierte Daten wie titel / beschreibung / referenzen und includes (aus xanadu) zusätzlich abgelegt werden. 

"Buckets" (evtl. anderer Name) dienen zur Gruppierung. Diese Gruppierungen können gemeinsame Optionen und Benutzerrechte besitzen. Benutzerrechte auf einzelne Objekte ist nicht vorgesehen, da es nicht in den Anforderungen benötigt wird.

### FileStorage

__TODO nur Notizen__

Evtl. Speicherkonzept aufbauend auf einem Blob storage. Dateien werden in z.b. 8MB große blöcke geteilt und anhand ihres hash-wertes in eine Datei geschrieben. Der Hash fungiert hier als eine art ID. Diese Daten könnten dann in einer Objekt-Datenbank wie RIAK gespeichert werden. Ein Zusätzliches Objekt mit einem Array aus Blob-IDs würde dann eine Datei darstellen. Diese bekäme dann die hen hash-wert der Datei als eine ID.

Diese Schicht übernimmt auch die Versionierung der Dateien. Dies geschiet im zusammenspiel mit dem Metadatenstorage, da die Informationen zu einer Version ebenfalls dort abgelegt werden.

## Zusammenfassung

Symcloud verwendet nicht nur ein verteiltes System (RIAK) es ist auch selbst ein verteiltes System, das die Metadaten/Nutzdaten trennt und diese über eine Schnittstelle Replikationen und Suchen zur verfügung stellt.

Es kann pro Bucket festgellegt werden welcher Benutzer zugriff auf diesen hat bzw. ob er diesen Durchsuchen darf. Dies bestimmt die einstellungen des Replicators, der die Daten anhand dieser Einstellungen über die Verbundenen Instanzen verteilt.

Beispiel:

* Bucket 1 hat folgende Policies:
 * SC1 User1 gehört der Bucket
 * SC2 User2 hat lese rechte
 * SC3 User3 hat lese und schreibrechte

Der Replikator wird nun folgendermassen vorgehen.

1. Die Metadaten des Buckets werden auf die Server SC2 und SC3 repliciert.
2. Die Nutzdaten (aktuellste Version) des Buckets werden auf den Server SC3 repliciert und automatisch.
3. Beides wird automatisch bei änderungen durchgeführt.
4. Beim lesen der Datei wird SC2 bei SC1 oder SC3 (je nach verfügbarkeit) die Daten holen und bei sich persistieren. Diese Kopy wird nicht automatisiert von SC3 upgedated, sie wird nur bei bedarf (aktualisiert) geholt.
5. Bei änderungen einer Datei des Buckets auf SC3 werden die änderungen automatisch auf den Server S1 gespielt.

Die Suchschnittstelle wird bei der suche nach dateien für den User2 oder User3 auf das Bucket durchsuchen. Jedoch wird der User3 die Daten in seinem eigenen Server suchen und nicht bei S1 nachfragen. Da S2 nicht immer aktuelle Daten besitzt frägt er bei der Schnittstelle S1 nach um die Suche bei sich zu verfolständigen.

Dieses Konzept vereint die größten Vorteile, die im Vorherigen Kapitel beschrieben wurden.
