---
nocite: |
  @lightcubesolutions2010gridfs
...

# \label{chapter_evaluation}Evaluation bestehender Technologien für Speicherverwaltung

Ein wichtiger Aspekt von Cloud-Anwendungen ist die Speicherverwaltung. Es bieten sich verschiedenste Möglichkeiten der Datenhaltung in der Cloud an. Dieses Kapitel beschäftigt sich mit der Evaluierung von verschiedenen Diensten bzw. Lösungen, mit denen Speicher verwaltet und möglichst effizient zur Verfügung gestellt werden kann.

Aufgrund der Anforderungen - siehe Kapitel \ref{specification} des Projektes - werden folgende Kriterien an die Speicherlösung gestellt.

Ausfallsicherheit

:   Die Speicherlösung ist das Fundament jeder Cloud-Anwendung. Ein Ausfall dieser Schicht bedeutet oft einen Ausfall der kompletten Anwendung.

Skalierbarkeit

:   Die Datenmengen einer Cloud-Anwendung sind oft schwer abschätzbar und können sehr große Ausmaße annehmen. Daher ist die Skalierbarkeit eine wichtige Anforderung an eine Speicherlösung.

Datenschutz

:   Der Datenschutz ist ein wichtiger Punkt beim Betreiben der eigenen Cloud-Anwendung. Meist gibt es eine kommerzielle Konkurrenz, die mit günstigen Preisen die AnwenderInnen anlockt, um dann ihre Daten zu verwenden. Damit SystemadministratorInnen nicht auf einen Provider angewiesen sind, sollte die Möglichkeit bestehen, Daten privat auf dem eigenen Server zu speichern.

Flexibilität

:   Um Daten flexibel speichern zu können, sollte es möglich sein, Verlinkungen und Metadaten direkt in der Speicherlösung abzulegen. Dies erleichtert die Implementierung der eigentlichen Anwendung.

Versionierung

:   Eine optionale Eigenschaft ist die integrierte Versionierung der Daten. Dies würde eine Vereinfachung der Anwendungslogik ermöglichen, da Versionen nicht in einem separaten Speicher abgelegt werden müssen.

Performance

:   Die Performance ist ein wichtiger Aspekt einer Speicherverwaltung. Sie kann zwar durch Caching-Mechanismen verbessert werden, jedoch ist es ziemlich aufwändig diese Caches immer aktuell zu halten. Daher sollten diese Caches nur für "nicht veränderbare" Daten verwendet werden, um den Aufwand für eine Aktualisierung zu reduzieren.

## Datenhaltung in Cloud-Infrastrukturen

Es gibt unzählige Möglichkeiten  die Datenhaltung in Cloud-Infrastrukturen umzusetzen. In diesem Kapitel werden drei grundlegende Technologien mit Hilfe von Beispielen analysiert.

Objekt-Speicherdienste

:   Speicherdienste wie zum Beispiel Amazon S3[^30], ermöglichen das Speichern von Objekten (Dateien, Ordner und Metadaten). Sie sind optimiert für den parallelen Zugriff von mehreren Instanzen einer Anwendung, die auf verschiedenen Hosts installiert sind. Erreicht wird dies durch eine webbasierte HTTP-Schnittstelle, wie bei Amazon S3 [@amazon2015d].

Verteilte Dateisysteme

:   Diese Dateisysteme fungieren als einfache Laufwerke und abstrahieren dadurch den komplexen Ablauf der darunter liegenden Services. Der Zugriff auf diese Dateisysteme erfolgt meist über system-calls wie zum Beispiel `fopen` oder `fclose`. Dies ergibt sich aus der Transparenz Anforderung [@coulouris2003verteilte, S. 369], die im Kapitel \ref{specification_distributed_fs} beschrieben werden.

Datenbank gestützte Dateisysteme

:   Erweiterungen zu Datenbanken wie zum Beispiel GridFS[^31] von MondoDB können verwendet werden, um große Dateien effizient und sicher in der Datenbank abzulegen [@gridfs2015a].

Aufgrund der vielfältigen Anwendungsmöglichkeiten werden zu jedem der drei Technologien ein oder zwei Beispiele als Referenz dargestellt.

## Amazon Simple Storage Service (S3)

Amazon Simple Storage Service bietet Entwicklern einen sicheren, beständigen und sehr gut skalierbaren Objektspeicher. Es dient der einfachen und sicheren Speicherung großer Datenmengen [@amazon2015a]. Daten werden in sogenannte "Buckets" gegliedert. Jeder Bucket kann unbegrenzt Objekte enthalten. Die Gesamtgröße der Objekte ist jedoch auf 5TB beschränkt. Sie können nicht verschachtelt werden, allerdings können sie Ordner enthalten, um die Objekte zu gliedern.

Die Kernfunktionalität des Services besteht darin, Daten in sogenannten Objekten zu speichern. Diese Objekte können bis zu 5GB groß werden. Zusätzlich wird zu jedem Objekt ca. 2KB Metadaten abgelegt. Bei der Erstellung eines Objektes werden automatisch vom System Metadaten erstellt. Einige dieser Metadaten können vom Benutzer überschrieben werden, wie zum Beispiel `x-amz-storage-class`, andere werden vom System automatisch gesetzt, wie zum Beispiel `Content-Length`. Diese systemspezifischen Metadaten werden beim Speichervorgang auch automatisch aktualisiert [@amazon2015b]. Für eine vollständige Liste dieser Metadaten siehe Anhang \ref{appendix_s3_metadata}.

Zusätzlich zu diesen systemdefinierten Metadaten ist es möglich, benutzerdefinierte Metadaten abzulegen. Das Format dieser Metadaten entspricht einer Key-Value Liste. Diese Liste ist auf 2KB limitiert.

### Versionierung

Die Speicherlösung bietet eine Versionierung der Objekte an. Diese kann über eine Rest-API, mit folgendem Inhalt (siehe Listing \ref{s3_versioning_lst}), in jedem Bucket aktiviert werden.

```{caption="\label{s3_versioning_lst}Aktiviert die Versionierung für ein Objekt {[}Amazon-Web-Services 2015c{]}" .xml}
<VersioningConfiguration
	xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <Status>Enabled</Status> 
</VersioningConfiguration>
```

Ist die Versionierung aktiviert, gilt diese für alle Objekte, die dieser Bucket enthält. Wird anschließend ein Objekt überschrieben, resultiert dies in einer neuen Version, dabei wird die Version-ID im Metadaten Feld `x-amz-version-id` auf einen neuen Wert gesetzt [@amazon2015c]. Dies veranschaulicht die Abbildung \ref{awz_object_versioning}.

![Versionierungsschema von Amazon S3 [@amazon2015c]\label{awz_object_versioning}](images/awz_versioning.png)

### Skalierbarkeit

Die Skalierbarkeit ist aufgrund der von Amazon verwalteten Umgebung sehr einfach. Es wird soviel Speicherplatz zur Verfügung gestellt, wie benötigt wird. Der Umstand, dass mehr Speicherplatz benötigt wird, zeichnet sich nur auf der Rechnung des Betreibers ab.

### Datenschutz

Amazon ist ein US-amerikanisches Unternehmen und ist daher an die Weisungen der Amerikanischen Geheimdienste gebunden. Aus diesem Grund wird es in den letzten Jahren oft kritisiert. Laut einem Bericht der ITWorld beteuerte Terry Wise[^36], dass jede gerichtliche Anordnung zur Einsicht in die Daten mit dem Kunden abgesprochen wird [@amazon2015e]. Dies gilt aber vermutlich nicht für Anfragen der NSA, da sich diese in der Regel auf die Anti-Terror Gesetze berufen. Diese verpflichten den Anbieter zur absoluten Schweigepflicht. Um dieses Problem zu umgehen, können Systemadministratoren sogenannte "Availability Zones" auswählen und damit steuern, wo die Daten gespeichert werden. Zum Beispiel werden Daten in einem Bucket mit der Zone Irland, auch wirklich in Irland gespeichert. Zusätzlich ermöglicht Amazon die Verschlüsselung der Daten [@t3n2015a].

Wer trotzdem Bedenken hat, seine Daten aus den Händen zu geben, kann auf verschiedene kompatible Lösungen zurückgreifen.

### Alternativen zu Amazon S3

Es gibt einige Amazon S3 kompatible Anbieter, die einen ähnlichen Dienst anbieten. Diese sind allerdings meist auch US-Amerikanische Firmen und daher an dieselben Gesetze wie Amazon gebunden. Wer daher auf Nummer sicher gehen will und seine Daten bzw. Rechner-Instanzen ganz bei sich behalten will, kommt nicht um die Installation einer privaten Cloud-Lösung herum.

Eucalyptus

:   Eucalyptus ist eine Open-Source-Infrastruktur zur Nutzung von Cloud-Computing auf einem Rechner Cluster. Der Name ist ein Akronym für "Elastic Utility Computing Architecture for Linking Your Programs To Useful Systems". Die hohe Kompatibilität macht diese Software-Lösung zu einer optimalen Alternative zu Amazon-Web-Services. Es bietet neben Objektspeicher auch andere AWS kompatible Dienste an, wie zum Beispiel EC2 (Rechnerleistung) oder EBS (Blockspeicher) [@hp1015a].

Riak Cloud Storage

:   Riak Cloud Storage ist eine Software, mit der es möglich ist einen verteilten Objekt-Speicherdienst zu betreiben. Diese implementiert die Schnittstelle von Amazon S3 und ist damit kompatibel zu der aktuellen Version [@basho2015riakcs]. Riak Cloud Storage unterstützt die meisten Funktionalitäten die Amazon bietet. Die Installation von Riak-CS ist im Gegensatz zu Eucalyptus sehr einfach und kann daher auf nahezu jedem System durchgeführt werden.

Beide vorgestellten Dienste bieten momentan keine Möglichkeit Objekte zu versionieren. Außerdem ist das Vergeben von Berechtigungen nicht so einfach möglich wie bei Amazon S3. Diese Aufgabe muss von der Applikation, die diese Dienste verwendet, übernommen werden.

### Performance

HostedFTP veröffentlichte im Jahre 2009 in einem Report ihre Erfahrungen mit der Performance zwischen EC2 (Rechner Instanzen) und S3 [@hostedftp2009amazons3]. Über ein Performance Modell wurde festgestellt, dass die Zeit für den Up- / Download einer Datei in zwei Bereiche aufgeteilt werden kann.

Feste Transaktionszeit

:   Die feste Transaktionszeit ist eine fixe Zeitspanne, die für die Bereitstellung bzw. Erstellung der Datei benötigt wird. Die Dateigröße beeinflusst diese Zeit kaum, allerdings kann es aufgrund schwankender Auslastung zu Verzögerungen kommen.

Downloadzeit

:   Die Downloadzeit ist linear abhängig zu der Dateigröße und kann aufgrund der Bandbreite schwanken.

Ausgehend von diesen Überlegungen kann davon ausgegangen werden, dass die Upload- bzw. Downloadzeit einen linearen Verlauf proportional zur Dateigröße aufweist. Diese These wird von den Daten unterstützt. Aus dem Diagramm (Abbildung \ref{performance_s3_upload}) kann die feste Transaktionszeit von ca. 140ms abgelesen werden.

![Upload Analyse zwischen EC2 und S3 [@hostedftp2009amazons3] \label{performance_s3_upload}](images/performance_s3_upload.png)

Für den Download von Dateien entsteht laut den Daten aus dem Auswertungen keine fixe Transaktionszeit. Die Zeit für den Download ist also nur von der Größe der Datei und der Bandbreite abhängig.

## \label{chapter_distibuted_fs}Verteilte Dateisysteme

Verteilte Dateisysteme unterstützen die gemeinsame Nutzung von Informationen in Form von Dateien. Sie bieten Zugriff auf Dateien, die auf einem entfernten Server abgelegt sind, wobei eine ähnliche Leistung und Zuverlässigkeit erzielt wird, wie für lokal gespeicherte Daten. Wohldurchdachte verteilte Dateisysteme erzielen oft sogar bessere Ergebnisse in Leistung und Zuverlässigkeit als lokale Systeme. Die entfernten Dateien werden genauso verwendet wie lokale Dateien, da verteilte Dateisysteme die Schnittstelle des Betriebssystems emulieren. Dadurch können die Vorteile von verteilten Systemen in einem Programm genutzt werden, ohne dieses anpassen zu müssen. Die Schreibzugriffe bzw. Lesezugriffe erfolgen über ganz normale "system-calls" [@coulouris2003verteilte S. 363ff].

Diese Abstraktion ist ein großer Vorteil der verteilten Dateisysteme im Vergleich zu Speicherdiensten wie Amazon S3. Da die Schnittstelle zu den einzelnen Systemen abstrahiert wird, muss die Software nicht angepasst werden, wenn das Dateisystem gewechselt wird.

### Anforderungen\label{specification_distributed_fs}

Die Anforderungen an verteilte Dateisysteme lassen sich wie folgt zusammenfassen.

Zugriffstransparenz

:   Client-Programme sollten, egal ob lokal oder verteilt, über dieselbe Operationsmenge verfügen. Es sollte irrelevant sein ob Daten aus einem verteilten oder lokalen Dateisystem stammen. Dadurch können Programme unverändert weiterverwendet werden, obwohl dessen Dateien verteilt werden [@coulouris2003verteilte, S. 369ff].

Ortstransparenz

:   Es sollte keine Rolle spielen, wo die Daten physikalisch gespeichert sind [@schuette2015a, S. 5]. Das Programm sieht immer denselben Namensraum, egal von wo aus es ausgeführt wird [@coulouris2003verteilte, S. 369ff].

Nebenläufige Dateiaktualisierungen

:   Dateiänderungen die von einem Client ausgeführt werden, sollten die Operationen anderer Clients, die dieselbe Datei verwenden, nicht stören. Um diese Anforderung zu erfüllen muss eine funktionierende Nebenläufigkeitskontrolle implementiert werden. Die meisten aktuellen Dateisysteme unterstützen freiwillige oder zwingende Sperren auf Datei- oder Datensatzebene.

Dateireplikationen

:   Unterstützt ein Dateisystem Dateireplikationen, kann ein Datensatz durch mehrere Kopien des Inhalts an verschiedenen Positionen dargestellt werden. Das bietet zwei Vorteile: Lastverteilung durch mehrere Server und Erhöhung der Fehlertoleranz. Nur wenige Dateisysteme unterstützen vollständige Replikationen, die meisten unterstützen jedoch ein lokales Caching von Dateien, welches eine eingeschränkte Art der Dateireplikation darstellt [@coulouris2003verteilte, S. 369ff].

Fehlertoleranz

:   Da der Dateidienst normalerweise der meist genutzte Dienst in einem Netzwerk ist, ist es unabdingbar, dass er auch dann weiter ausgeführt wird, wenn einzelne Server oder Clients ausfallen. Ein Fehlerfall sollte zumindest nicht zu Inkonsistenzen führen [@schuette2015a, S. 5].

Konsistenz

:   In konventionellen Dateisystemen werden Zugriffe auf Dateien auf eine einzige Kopie der Daten geleitet. Wird nun diese Datei auf mehreren Servern verteilt, müssen die Operationen an alle Server weitergeleitet werden. Die Verzögerung die dabei auftritt, führt in dieser Zeit zu einem inkonsistenten Zustand des Systems [@coulouris2003verteilte, S. 369ff].

Sicherheit

:   Fast alle Dateisysteme unterstützen eine Art Zugriffskontrolle auf die Dateien. Dies ist ungleich wichtiger, wenn viele Benutzer gleichzeitig auf Dateien zugreifen. In verteilten Dateisystemen besteht der Bedarf die Anforderungen des Clients auf korrekte Benutzer-IDs umzuleiten, die dem System bekannt sind [@coulouris2003verteilte, S. 369ff].

Effizienz

:   Verteilte Dateisysteme sollten sowohl in Bezug auf die Funktionalitäten als auch auf die Leistung, mit konventionellen Dateisystemen vergleichbar sein [@coulouris2003verteilte, S. 369ff].

Andrew Birrell und Roger Needham setzten sich folgende Entwurfsziele für Ihr Universal File System [@birrell1980a]:

> "We would wish a simple, low-level, file server in order to
> share an expensive resource, namely a disk, whilst leaving
> us free to design the filing system most appropriate to
> a particular client, but we would wish also to have
> available a high-level system shared between clients."

Aufgrund der Tatsache, dass Festplatten heutzutage nicht mehr so teuer wie in den 1980ern sind, ist das erste Ziel nicht mehr von zentraler Bedeutung. Die Vorstellung von einem Dienst, der die Anforderung verschiedenster Clients mit unterschiedlichen Aufgabenstellungen erfüllt, ist ein zentraler Aspekt der Entwicklung von verteilten (Datei-) Systemen [@coulouris2003verteilte, S. 369ff].

### NFS

Das verteilte Dateisystem Network File System wurde von Sun Microsystems entwickelt. Das grundlegende Prinzip von NFS ist, dass jeder Dateiserver eine standardisierte Dateischnittstelle implementiert. Über diese Schnittstelle werden Dateien des lokalen Speichers den BenutzerInnen zur Verfügung gestellt. Das bedeutet, dass es keine Rolle spielt welches System dahinter steht. Ursprünglich wurde es für UNIX Systeme entwickelt. Mittlerweile gibt es aber Implementierungen für verschiedenste Betriebssysteme [@tanenbaum2003verteilte, S. 645ff].

NFS ist dennoch weniger ein Dateisystem als eine Menge von Protokollen, die in der Kombination mit den Clients ein verteiltes Dateisystem ergeben. Die Protokolle wurden so entwickelt, dass unterschiedliche Implementierungen einfach zusammenarbeiten können. Auf diese Weise kann durch NFS eine heterogene Menge von Computern verbunden werden. Dabei ist es sowohl für die BenutzerInnen als auch für den Server irrelevant mit welcher Art von System er verbunden ist [@tanenbaum2003verteilte, S. 645ff].

__Architektur__

Das zugrundeliegende Modell von NFS ist das eines entfernten Dateidienstes. Dabei erhält ein Client den Zugriff auf ein transparentes Dateisystem, das von einem entfernten Server verwaltet wird. Dies ist vergleichbar mit RPC[^35]. Der Client erhält den Zugriff auf eine Schnittstelle, um auf Dateien zuzugreifen, die ein entfernter Server implementiert [@tanenbaum2003verteilte, S. 647ff].

![NFS Architektur [@tanenbaum2003verteilte, S. 647]\label{nfs_architecture}](images/nfs_architecture.png)

Der Client greift über die Schnittstelle des lokalen Betriebssystems auf das Dateisystem zu. Die lokale Dateisystemschnittstelle wird jedoch durch ein virtuelles Dateisystem ersetzt (VFS), die eine Schnittstelle zu den verschiedenen Dateisystemen darstellt. Das VFS entscheidet anhand der Position im Dateibaum, ob die Operation an das lokale Dateisystem oder an den NFS-Client weitergegeben wird (siehe Abbildung \ref{nfs_architecture}). Der NFS-Client ist eine separate Komponente, die sich um den Zugriff auf entfernte Dateien kümmert. Dabei fungiert der Client als eine Art Stub-Implementierung der Schnittstelle und leitet alle Anfragen an den entfernten Server weiter (RPC). Diese Abläufe werden aufgrund des VFS-Konzeptes vollkommen transparent für die BenutzerIn durchgeführt [@tanenbaum2003verteilte, S. 647ff].

### XtreemFS \label{chapter_xtreemfs}

Als Alternative zu konventionellen verteilten Dateisystemen bietet XtreemFS eine unkomplizierte und moderne Variante eines verteilten Dateisystems an. Es wurde speziell für die Anwendung in einem Cluster mit dem Betriebssystem XtreemOS entwickelt. Mittlerweile gibt es aber Server- und Client-Anwendungen für fast alle Linux Distributionen. Außerdem Clients für Windows und MAC.

Die Hauptmerkmale von XtreemFS sind:

Distribution

:   Eine XtreemFS Installation enthält eine beliebige Anzahl an Servern, die auf verschiedenen Maschinen betrieben werden können. Diese Server, sind entweder über einen lokalen Cluster oder über das Internet miteinander verbunden. Der Client kann sich mit einem beliebigen Server verbinden und mit ihm Daten austauschen. Es garantiert konsistente Daten, auch wenn verschiedene Clients mit verschiedenen Servern kommunizieren. Vorausgesetzt ist, dass alle Komponenten miteinander verbunden und erreichbar sind [@xtreemfs2015a, K. 2.3].

Replikation

:   Die drei Hauptkomponenten von XtreemFS, Directory Service, Metadata-Catalog und die Object-Storage-Devices (siehe Abbildung \ref{xtreemfs_architecture}) können redundant verwendet werden, dies führt zu einem fehlertoleranten System. Die Replikationen zwischen diesen Systemen erfolgen mit einem Hot-Backup (siehe Kapitel \ref{xtreemfs_replication}). Dieses Backup springt automatisch ein, wenn ein anderer Server ausfällt [@xtreemfs2015a, K. 2.3].

Striping

:   XtreemFS splittet Dateien in sogenannte "Stripes" (oder "Chunks"). Diese Chunks werden auf verschiedenen Servern gespeichert und können dann parallel von mehreren Servern gelesen werden. Die gesamte Datei kann mit der zusammengefassten Netzwerk- und Festplatten-Bandbreite mehrerer Server heruntergeladen werden. Die Größe der Chunks und die Anzahl der Server, auf denen die Chunks repliziert werden, kann pro Datei bzw. pro Ordner festgelegt werden [@xtreemfs2015a, K. 2.3].

Security

:   Um die Sicherheit der Dateien zu gewährleisten, unterstützt XtreemFS sowohl Authentifizierung als auch ein Berechtigungssystem. Der Netzwerkverkehr zwischen den Servern ist verschlüsselt. Die Standard Authentifizierung basiert auf lokalen Benutzernamen und ist auf die Vertrauenswürdigkeit der Clients bzw. des Netzwerkes angewiesen. Um mehr Sicherheit zu erreichen, unterstützt XtreemFS aber auch eine Authentifizierung mittels X.509 Zertifikaten[^34] [@xtreemfs2015a, K. 2.3].

__Architektur__

XtreemFS implementiert eine objektbasierte Datei-Systemarchitektur was bedeutet, dass die Dateien in Objekte mit einer bestimmten Größe aufgeteilt werden und die Objekte auf verschiedenen Servern gespeichert werden. Die Metadaten werden in separaten Datenbankservern gespeichert. Diese Server organisieren die Dateien in eine Menge von sogenannten "Volumes". Jedes Volume ist ein eigener Namensraum mit einem eigenen Dateibaum, vergleichbar mit den Buckets von Amazon S3. Die Metadaten speichern zusätzlich eine Liste von Chunk-IDs mit den jeweiligen Servern, auf denen dieser Chunk zu finden ist. Außerdem legt eine Richtlinie fest, wie diese Datei auf gesplittet und auf die Server verteilt werden soll. Daher kann die Größe der Metadaten von Datei zu Datei unterschiedlich sein [@xtreemfs2015a, K. 2.4].

Eine XtreemFS Installation besteht aus drei Komponenten (siehe Abbildung \ref{xtreemfs_architecture}):

DIR

:   Das "Directory-Service" ist das zentrale Register indem alle anderen Services aufgelistet werden. Die Clients oder andere Services verwenden diesen, um zum Beispiel die "Object-Storage-Devices" oder "Metadata- and Replica-Catalogs" zu finden [@xtreemfs2015a, K. 2.4].

MRC

:   Der "Metadata- and Replica-Catalog" verwaltet die Metadaten der Datei, wie zum Beispiel Dateiname, Dateigröße oder Bearbeitungsdatum. Zu jeder Datei kann außerdem spezifiziert werden, auf welchen "Object-Storage-Devices" die Chunks abgelegt wurden. Zusätzlich authentifiziert und autorisiert er dem Benutzer den Zugriff auf die Dateien bzw. Ordner [@xtreemfs2015a, K. 2.4].

OSD

:   Das "Object-Storage-Device" speichert die Objekte ("Strip", "Chunks" oder "Blobs") der Dateien. Die Clients schreiben und lesen Daten direkt von diesen Servern [@xtreemfs2015a, K. 2.4].

![XtreemFS Architektur [@xtreemfs2015b]\label{xtreemfs_architecture}](images/xtreemfs_architecture.png)

### Exkurs: Datei Replikation\label{xtreemfs_replication}

Ein wichtiger Aspekt von verteilten Dateisystemen ist die Replikation von Daten. Sie steigert sowohl die Zuverlässigkeit, als auch die Leistung der Lesezugriffe. Das größte Problem dabei ist allerdings, die Konsistenz der Repliken zu erhalten. Dabei muss bei jedem schreibenden Zugriff ein Update aller Repliken erfolgen, ansonsten ist die Konsistenz nicht mehr gegeben [@tanenbaum2003verteilte, S. 333ff].

Die Hauptgründe für Replikationen von Daten sind Zuverlässigkeit und Leistung [@Gray:1996:DRS:233269.233330]. Wenn Daten repliziert werden ist es unter Umständen möglich weiterzuarbeiten, wenn eine Replik ausfällt. Die BenutzerIn lädt sich die Daten von einem anderen Server herunter. Zusätzlich können durch Repliken fehlerhafte Dateien erkannt werden. Wenn eine Datei zum Beispiel auf drei Servern gespeichert wurde und auf allen drei Server Schreib- bzw. Lesezugriffe ausgeführt werden, kann durch den Vergleich der Antworten, erkannt werden ob eine Datei fehlerhaft ist. Dazu müssen nur zwei Antworten denselben Inhalt besitzen und es kann davon ausgegangen werden, dass es sich um die richtige Datei handelt [@tanenbaum2003verteilte, S. 333ff].

Der andere wichtige Grund für Replikationen ist die Leistung des Systems. Hier gibt es zwei Aspekte: Netzwerklast und die geographische Lage. Wenn ein System nur aus einem Server besteht, ist dieser Server der vollen Last der Zugriffe ausgesetzt. Teilt man diese Last auf, kann die Leistung des Systems gesteigert werden. Zusätzlich kann durch Repliken auch die Geschwindigkeit der Lesezugriffe gesteigert werden, indem dieser Zugriff über mehrere Server parallel erfolgt. Auch die geographische Lage der Daten spielt bei der Leistung des Systems eine entscheidende Rolle. Wenn Daten in der Nähe des Prozesses gespeichert werden, in dem sie erzeugt bzw. verwendet werden, ist sowohl der schreibende als auch der lesende Zugriff schneller möglich. Diese Leistungssteigerung ist allerdings nicht linear zu den verwendeten Servern. Es ist einiges an Aufwand zu betreiben, um diese Repliken synchron zu halten und dadurch die Konsistenz zu wahren [@tanenbaum2003verteilte, S. 333ff].

Damit ein Verbund von Servern die Konsistenz ihrer Daten gewährleisten kann, werden Konsistenzprotokolle eingesetzt. In XtreemFS wird ein sogenanntes primärbasiertes Protokoll verwendet [@xtreemfs2015a, K. 6]. In diesen Protokollen ist jedem Datenelement "x" ein primärer Server zugeordnet, der dafür verantwortlich ist Schreiboperationen für "x" zu koordinieren. Es gibt zwei Arten dieses Protokoll umzusetzen: Entferntes- und Lokales-Schreiben.

__Entferntes-Schreiben__

Es gibt zwei Arten zur Implementierung dieses Protokolls. Das eine ist ein nicht replizierendes Protokoll, bei dem alle Schreib- bzw. Lesezugriffe auf den primären Server des Objektes ausgeführt werden. Das andere ist das sogenannte "Primary-Backup" Protokoll, welches über einen festen primären Server für jedes Objekt verfügt. Dieser Server wird bei der Erstellung des Objektes festgelegt und nicht verändert. Zusätzlich wird festgelegt, auf welchen Servern Repliken für dieses Objekt angelegt werden. In XtreemFS werden diese Einstellungen "replication policy" genannt [@xtreemfs2015a, K. 6.1.3]. 

![Primary-Backup: Entferntes-Schreiben [@tanenbaum2003verteilte, S. 385]\label{primary_backup_remote_protocoll}](images/primary-backup-remote-protocoll.png)

Der Prozess, der eine Schreiboperation (siehe Abbildung \ref{primary_backup_remote_protocoll}) auf das Objekt ausführen will, gibt sie an den primären Server weiter. Dieser führt die Operation lokal an dem Objekt aus und gibt die Aktualisierungen an die Backup-Server weiter. Jeder dieser Server führt die Operation aus und gibt eine Bestätigung an den primären Server zurück. Nachdem alle Backups die Aktualisierung durchgeführt haben, sendet auch der primäre Server eine Bestätigung an den ausführenden Server. Dieser Server kann nun sicher sein, dass die Aktualisierung auf allen Servern ausgeführt und damit sicher im System gespeichert wurde. Durch diesen blockierenden Prozess, kann ein gravierendes Leistungsproblem entstehen. Für Programme, die lange Antwortzeiten nicht akzeptieren können, ist es eine Variante, das Protokoll nicht blockierend zu implementieren. Das bedeutet, dass der primäre Server die Bestätigung direkt nach dem lokalen Ausführen der Operation zurückgibt und erst danach die Aktualisierungen an die Backups weiter gibt [@xtreemfs2015c]. Aufgrund der Tatsache, dass alle Schreiboperationen auf einem Server ausgeführt werden, können diese einfach abgesichert und dadurch die Konsistenz gewahrt werden. Eventuelle Transaktionen oder Locks müssen nicht im Netzwerk verteilt werden [@tanenbaum2003verteilte, S. 384ff].

__Lokales-Schreiben__

Auch dieses Protokoll kann in zwei verschiedenen Arten implementiert werden. Die erste Variante ist ein nicht replizierendes Protokoll, bei dem das Objekt vor einem Schreibzugriff auf den ausführenden Server verschoben und dadurch der primäre Server des Objekts geändert wird. Nachdem die Schreiboperation ausgeführt wurde, bleibt das Objekt solange auf diesem Server bis ein anderer Server schreibend auf das Objekt zugreifen will. Die andere Variante ist ein "Primäres-Backup Protokoll" (siehe Abbildung \ref{primary_backup_local_protocoll}), bei dem der primäre Server des Objektes auf den ausführenden Server migriert wird [@tanenbaum2003verteilte, S. 386ff].

![Primary-Backup: Lokales-Schreiben [@tanenbaum2003verteilte, S. 387]\label{primary_backup_local_protocoll}](images/primary-backup-local-protocoll.png)

Dieses Protokoll ist auch für mobile Computer geeignet, die in einem Offline-Modus betrieben werden können. Dazu wird dieser zum primären Server für die Objekte, die er vermutlich während seiner Offline-Phase bearbeiten wird. Während der Offline-Phase können nun Aktualisierungen lokal ausgeführt werden und die anderen Clients können lesend auf eine Replik zugreifen. Sie bekommen zwar keine Aktualisierungen, können aber sonst ohne Einschränkungen weiterarbeiten. Nachdem die Verbindung wiederhergestellt wurde, werden die Aktualisierungen an die Backup-Server weitergegeben, sodass der Datenspeicher wieder in einen konsistenten Zustand übergehen kann [@tanenbaum2003verteilte, S. 386ff].

### Zusammenfassung

Im Bezug auf die Anforderungen (siehe Kapitel \ref{specification}) bieten die analysierten verteilten Dateisysteme von Haus aus keine Versionierung. Es gab Versuche der Linux-Community, mit Wizbit[^33], ein auf GIT-basierendes Dateisystem zu entwerfen, dass die Versionierung mitliefern sollte [@arstechnica2008a]. An diesem Projekt wurde allerdings seit Ende 2009 nicht mehr weiterentwickelt [@openhub2015a].

Die benötigten Zugriffsberechtigungen werden zwar auf der Systembenutzerebene durch ACL unterstützt, jedoch müsste die Anwendung für alle BenutzerInnen eine SystembenutzerIn anlegen [@xtreemfs2015a, K. 7.2]. Dies wäre zwar mit einer einzelnen Installation machbar, jedoch macht es eine verteilte Anwendung komplizierter und eine Installation aufwändiger. Allerdings können gute Erkenntnisse aus der Analyse der Replikationsmechanismen bzw. der Konsistenzprotokolle von XtreemFS gezogen und in ein Gesamtkonzept mit eingebunden werden.

Die hier beschriebenen Protokolle und Konzepte werden im Kapitel \ref{chapter_concept_database} aufgegriffen, um die Daten effizient und sicher zwischen den Servern zu verteilen. Dabei werden wesentliche Konzepte des Lokalen-Schreibens verwendet, um das Protokoll für symCloud zu definieren. 

## Datenbankgestützte Dateiverwaltungen

Einige Datenbanksysteme, wie zum Beispiel MongoDB[^31], bieten eine Schnittstelle um Dateien abzuspeichern. Viele dieser Systeme sind meist nur begrenzt für große Datenmengen geeignet. MongoDB und GridFS sind jedoch genau für diese Anwendungsfälle ausgelegt, daher soll diese Technologie im folgenden Abschnitt genauer betrachtet werden.

### MongoDB & GridFS \label{chapter_gridfs}

MongoDB bietet die Möglichkeit BSON-Dokumente in der Größe von bis zu 16MB zu speichern. Dies ermöglicht die Verwaltung kleinerer Dateien ohne zusätzliche Layer. Für größere Dateien und zusätzliche Features bietet MongoDB mit GridFS eine Schnittstelle, mit der es möglich ist größere Dateien und die dazugehörigen Metadaten zu speichern. Dazu teilt GridFS die Dateien in Chunks einer bestimmten Größe auf. Standardmäßig ist die Größe von Chunks auf 255Byte gesetzt. Die Daten werden in der Kollektion `chunks` und die Metadaten in der Kollektion `files` gespeichert. Durch die verteilte Architektur von MongoDB werden die Daten automatisch auf allen Systemen synchronisiert. Zusätzlich bietet das System die Möglichkeit über Indexe schnell zu suchen und Abfragen auf die Metadaten durchzuführen [@gridfs2015a].

__Beispiel:__

```{caption="\label{gridfs_example_code}GridFS Beispielcode {[}Lightcubesolutions 2010{]}" .php}
$mongo = new Mongo();
		// connect to database
$database = $mongo->selectDB('example');
		// select mongo database
$gridFS = $database->getGridFS();
		// use GridFS class for handling files
$name = $_FILES['Filedata']['name'];
		// optional - capture the name of the uploaded file
$id = $gridFS->storeUpload('Filedata', $name);
		// load file into MongoDB
```

Bei der Verwendung von MongoDB ist es sehr einfach, Dateien in GridFS (siehe Beispielcode in Listing \ref{gridfs_example_code}) abzulegen. Die fehlenden Funktionen wie zum Beispiel, ACL oder Versionierung machen den Einsatz in symCloud allerdings schwierig. Auch der starre Aufbau mit nur einem Dateibaum macht die Anpassung der Datenstruktur nahezu unmöglich. Allerdings ist das Chunking der Dateien auch hier zentraler Bestandteil, daher wäre es möglich MongoFS für einen Teil des Speicher-Konzeptes zu verwenden.

## Zusammenfassung

Am Ende dieses Abschnittes, werden die Vor- und Nachteile der jeweiligen Technologien zusammengefasst. Dies ist notwendig, um am Ende ein optimales Speicherkonzept für symCloud zu entwickeln.

Amazon S3

:   Speicherdienste, wie Amazon S3 sind für einfache Aufgaben bestens geeignet. Sie bieten alles an, was für ein schnelles Setup der Applikation benötigt wird. Jedoch haben gerade die Open-Source Alternativen wesentliche Mankos in Bereichen, die für das Projekt unbedingt notwendig sind. Zum einen sind es bei den Alternativen die fehlenden Funktionalitäten, wie zum Beispiel ACLs oder Versionierung, zum anderen ist auch Amazon S3 wenig flexibel, um eigene Erweiterungen hinzuzufügen. Jedoch können wesentliche Vorteile bei den Objekt-Speicherdiensten beobachtet werden. Wie zum Beispiel:

* Rest-Schnittstelle
* Versionierung
* Gruppierung durch Buckets
* Berechtigungssysteme

Diese Punkte werden im Kapitel \ref{chapter_concept} berücksichtigt.

Verteilte Dateisysteme

:    Die verteilten Dateisysteme bieten durch ihre einheitliche Schnittstelle einen optimalen Abstraktionslayer für datenintensive Anwendungen. Die Flexibilität, die diese Systeme verbindet, kommen der Anwendung in symCloud entgegen. Jedoch sind fehlende Zugriffsrechte auf Anwendungsbenutzerebene (ACL) und die fehlende Versionierung ein Problem das auf Speicherebene nicht gelöst wird. Daher kann ein solches verteiltes Dateisystem nicht als Ersatz für eine eigene Implementierung, sondern lediglich als Basis dafür herangezogen werden.

Datenbankgestützte Dateiverwaltung

:   Systeme wie zum Beispiel GridFS sind für den Einsatz in Anwendungen geeignet, die die darunterliegende Datenbank verwenden. Die nötigen Erweiterungen, um Dateien in eine Datenbank zu schreiben, sind aufgrund der Integration sehr einfach umzusetzen. Sie bieten eine gute Schnittstelle, um Dateien zu verwalten. Die fehlenden Möglichkeiten von ACL und Versionierung macht jedoch die Verwendung von GridFS sehr aufwändig. Aufgrund des Aufbaues von GridFS gibt es in der Datenbank einen Dateibaum, indem alle BenutzerInnen ihre Dateien ablegen. Die Anwendung müsste selbst dafür sorgen, dass jede BenutzerIn nur seine Dateien sehen bzw. bearbeiten kann. Allerdings kann, gerade aus GridFS, mit dem Chunking von Dateien (siehe Kapitel \ref{chapter_concept_file_storage}) ein sehr gutes Konzept für eine effiziente Dateihaltung entnommen werden.

Da aufgrund verschiedenster Schwächen keine der Technologien eine umfassende Lösung für die Datenhaltung in symCloud bietet, wird im nächsten Kapitel versucht ein optimales Speicherkonzept für das Projekt zu entwickeln.

[^30]: <http://aws.amazon.com/de/s3/>
[^31]: <http://docs.mongodb.org/manual/core/gridfs/>
[^32]: <http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html>
[^33]: <https://www.openhub.net/p/wizbit>
[^34]: <http://tools.ietf.org/html/rfc5280>
[^35]: Remote Procedure Calls <http://www.cs.cf.ac.uk/Dave/C/node33.html>
[^36]: Amazons Zuständiger für die Zusammenarbeit zwischen den Partner
