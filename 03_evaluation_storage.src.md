# Evaluation bestehender Technologien in Bezug auf Speicherverwaltung

Ein wichtiger Aspekt von Cloud-Anwendungen ist die Speicherverwaltung. Es bieten sich verschiedenste Möglichkeiten der Datenhaltung in der Cloud an. Dieses Kapitel beschäftigt sich mit der Evaluierung von verschiedenen Diensten bzw. Lösungen, mit denen Speicher verwaltet und möglichst effizient zur Verfügung gestellt werden kann.

Aufgrund der Anforderungen, siehe Kapitel \ref{specification} des Projektes werden folgende Anforderungen an die Speicherlösung gestellt.

Ausfallsicherheit

:   Die Speicherlösung ist das Fundament einer jeder Cloud-Anwendung. Ein Ausfall dieser Schicht bedeutet oft einen Ausfall der kompletten Anwendung.

Skalierbarkeit

:   Die Datenmengen einer Cloud-Anwendung sind oft schwer abschätzbar und können sehr große Ausmaße annehmen. Daher ist eine wichtige Anforderung an eine Speicherlösung die Skalierbarkeit.

Datenschutz

:   Der Datenschutz ist ein wichtiger Punkt beim Betreiben der eigenen Cloud-Anwendung. Meist gibt es eine kommerzielle Konkurrenz, die mit günstigen Preisen die Anwender anlockt, um ihre Daten zu verwerten. Die Möglichkeit, Daten privat auf dem eigenen Server zu speichern, sollte somit gegeben sein. Damit Systemadministratoren nicht auf einen Provider angewiesen sind.

Flexibilität

:   Um Daten flexibel speichern zu können, sollte es möglich sein, Verlinkungen und Metadaten direkt in der Speicherlösung abzulegen. Dies erleichtert die Implementierung der eigentlichen Anwendung.

Versionierung

:   Eine optionale Eigenschaft ist die integrierte Versionierung der Daten. Dies würde eine Vereinfachung der Anwendungslogik ermöglichen, da Versionen nicht in einem separaten Speicher abgelegt werden müssen.

Performance

:   ist ein wichtiger Aspekt an eine Speicherverwaltung. Sie kann zwar durch Caching-Mechanismen verbessert werden, jedoch ist es ziemlich aufwändig diese Caches immer aktuell zu halten. Daher sollten diese Caches nur für "nicht veränderbare" Daten verwendet werden. Um den Aufwand zu reduzieren, der getrieben werden muss um diese aktuell zu halten.

## Datenhaltung in Cloud-Infrastrukturen

Wenn man Speicherstrukturen in der Cloud genauer betrachtet, gibt es grundsätzlich drei Möglichkeiten. 

Objekt-Speicherdienste,

:   wie zum Beispiel Amazon S3[^30], ermöglichen das Speichern von sogenannten Objekten (Dateien, Ordner und Metadaten). Sie sind optimiert für den parallelen Zugriff von mehreren Instanzen einer Anwendung, die auf verschiedenen Hosts installiert sind. Erreicht wird dies durch eine Webbasierte HTTP-Schnittstellen, wie bei Amazon S3 [@amazon2015d].

Verteilte Dateisysteme

:   ,fungieren als einfache Laufwerke und abstrahieren dadurch den komplexen Ablauf der darunter liegenden Services. Der Zugriff auf diese Dateisysteme erfolgt meist über system-calls wie zum Beispiel `fopen` oder `fclose`. Dies ergibt sich aus der Transparenz Anforderung [@coulouris2003verteilte, S. 369], die im Kapitel \ref{specification_distributed_fs} beschrieben wird.

Datenbank gestützte Dateisysteme,

:   wie zum Beispiel GridFS[^31] von MondoDB, erweitern Datenbanken, um große Dateien effizient und sicher abzuspeichern. [@gridfs2015a]

## Amazon Simple Storage Service (S3)

Amazon Simple Storage Service bietet Entwicklern einen sicheren, beständigen und sehr gut skalierbaren Objektspeicher. Es dient der einfachen und sicheren Speicherung großer Datenmengen [@amazon2015a]. Daten werden in sogenannte Buckets gegliedert. Jeder Bucket kann unbegrenzt Objekte enthalten. Die Gesamtgröße der Objekte ist jedoch auf 5TB beschränkt. Sie können nicht verschachtelt werden, allerdings können sie Ordner enthalten, um die Objekte zu gliedern.

Die Kernfunktionalität des Services besteht darin, Daten in sogenannten Objekten zu speichern. Diese Objekte können bis zu 5GB groß werden. Zusätzlich wird zu jedem Objekt ca. 2KB Metadaten abgelegt. Bei der Erstellung eines Objektes werden automatisch vom System Metadaten erstellt. Einige dieser Metadaten können vom Benutzer überschrieben werden, wie zum Beispiel `x-amz-storage-class`, andere werden vom System automatisch gesetzt, wie zum Beispiel `Content-Length`. Diese symstespezifischen Metadaten werden beim speichern auch automatisch aktualisiert [@amazon2015b]. Für eine vollständige List dieser Metadaten siehe Anhang \ref{appendix_s3_metadata}.

Zusätzlich zu diesen systemdefinierten Metadaten ist es möglich, benutzerdefinierte Metadaten zu speichern. Das Format dieser Metadaten entspricht einer Key-Value Liste. Diese Liste ist auf 2KB limitiert.

### Versionierung

Die Speicherlösung bietet eine Versionierung der Objekte an. Diese kann über eine Rest-API, mit folgendem Inhalt, in jedem Bucket aktiviert werden.

```xml
<VersioningConfiguration
	xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <Status>Enabled</Status> 
</VersioningConfiguration>
```

Ist die Versionierung aktiviert, gilt diese für alle Objekte, die dieser enthält. Wird anschließend ein Objekt überschrieben, resultiert dies in einer neuen Version, dabei wird die Version-ID im Metadaten Feld `x-amz-version-id` auf einen neuen Wert gesetzt [@amazon2015c]. Dies veranschaulicht die Abbildung \ref{awz_object_versioning}.

![Versionierungsschema von Amazon S3 [@amazon2015c]\label{awz_object_versioning}](images/awz_versioning.png)

### Skalierbarkeit

Die Skalierbarkeit ist aufgrund der von Amazon verwalteten Umgebung sehr einfach. Es wird soviel Speicherplatz zur Verfügung gestellt, wie benötigt wird. Der Umstand, dass mehr Speicherplatz benötigt wird, zeichnet sich nur auf der Rechnung des Betreibers ab.

### Datenschutz

Amazon ist ein US-Amerikanisches Unternehmen und ist daher an die Weisungen der Amerikanischen Geheimdienste gebunden. Aus diesem Grund wird es in den letzten Jahren oft kritisiert. Laut einem Bericht der ITWorld beteuerte Terry Wise, er ist bei Amazon zuständig für die Zusammenarbeit zwischen den Partner ist, dass jede Gerichtliche Anordnung mit dem Kunden abgesprochen wird [@amazon2015e]. Dies gilt aber vermutlich nicht für Anfragen der NSA, den diese beruhen in der Regel auf den Anti-Terror Gesetzen und verpflichten daher den Anbieter zu absolutem Stillschweigen. Um dieses Problem zu kompensieren, können Systemadministratoren sogenannte "Availability Zones" auswählen und damit steuern, wo ihre Daten gespeichert werden. Zum Beispiel werden Daten aus einem Bucket mit der Zone Irland, auch wirklich in Irland gespeichert. Zusätzlich ermöglicht Amazon die Verschlüsselung der Daten [@t3n2015a].

Wer bedenken hat, seine Daten aus den Händen zu geben, kann auf verschiedene kompatible Lösungen zurückgreifen.

### Alternativen zu Amazon S3

Es gibt einige Amazon S3 kompatible Anbieter, die einen ähnlichen Dienst bieten. Diese sind allerdings meist auch US-Amerikanische Firmen und daher an die selben Gesetzen gebunden wie Amazon. Wer daher auf Nummer sicher gehen will und seine Daten bzw. Rechner-Instanzen ganz bei sich behalten will, kommt nicht um eine Installation von einer privaten Cloud-Lösungen herum.

Eucalyptus

:   ist eine Open-Source-Infrastruktur zur Nutzung von Cloud-Computing auf einem Rechner Cluster. Der Name ist ein Akronym für "Elastic Utility Computing Architecture for Linking Your Programs To Useful Systems". Die hohe Kompatibilität macht diese Software-Lösung zu einer optimalen Alternative zu Amazon-Web-Services. Es bietet neben Objektspeicher auch andere AWS kompatible Dienste an, wie zum Beispiel EC2 (Rechnerleistung) oder EBS (Blockspeicher) [@hp1015a]. Dieser S3 kompatible Dienst bietet allerdings keine Versionierung.

Riak Cloud Storage

:   ist eine Software, mit der es möglich ist, einen verteilten Objekt-Speicherdienst zu betreiben. Es implementiert die Schnittstelle von Amazon S3 und ist damit kompatibel zu der aktuellen Version [@basho2015riakcs]. Es unterstützt die meisten Funktionalitäten, die Amazon bietet. Die Installation von Riak-CS ist im Gegensatz zu Eucalyptus sehr einfach und kann daher auf nahezu jedem System durchgeführt werden.

Beide vorgestellten Dienste bieten momentan keine Möglichkeit, Objekte zu versionieren. Außerdem ist das Vergeben von Berechtigungen nicht so einfach möglich wie bei Amazon S3. Diese Aufgabe muss von der Applikation, die diese Dienste verwendet, übernommen werden.

### Performance

HostedFTP veröffentlichte im Jahre 2009 in einem Perfomance Report über ihre Erfahrungen mit der Performance zwischen EC2 (Rechner Instanzen) und S3 [@hostedftp2009amazons3]. Über ein Performance Modell wurde festgestellt, dass die Zeit für den Download einer Datei in zwei Bereiche aufgeteilt werden kann.

Feste Transaktionszeit

:   ist ein fixer Zeitabschnitt, der für die Bereitstellung oder Erstellung der Datei benötigt wird. Beeinflusst wird diese Zeit kaum, allerdings kann es aufgrund schwankender Auslastung zu Verzögerungen kommen.

Downloadzeit

:   ist linear abhängig zu der Dateigröße und kann aufgrund der Bandbreite schwanken.

Ausgehend von diesen Überlegungen kann davon ausgegangen werden, dass die Upload- bzw. Downloadzeit einen linearen Verlauf über die Dateigröße aufweist. Diese These wird von den Daten unterstützt. Aus dem Diagramm (Abbildung \ref{performance_s3_upload}) kann die feste Transaktionszeit von ca. 140ms abgelesen werden.

![Upload Analyse zwischen EC2 und S3 [@hostedftp2009amazons3] \label{performance_s3_upload}](images/performance_s3_upload.png)

Für den Download von Dateien entsteht laut den Daten aus dem Report keine fixe Transaktionszeit. Die Zeit für den Download ist also nur von der Größe der Datei und der Bandbreite abhängig. 

## \label{chapter_distibuted_fs}Verteilte Dateisysteme

Verteilte Dateisysteme unterstützen die gemeinsame Nutzung von Informationen in Form von Dateien. Sie bieten Zugriff auf Dateien, die auf einem entfernten Server abgelegt sind, wobei eine ähnliche Leistung und Zuverlässigkeit erzielt wird, wie für lokal gespeicherte Daten. Wohldurchdachte verteilte Dateisysteme erzielen oft bessere Ergebnisse in Leistung und Zuverlässigkeit als lokale Systeme. Die entfernten Dateien werden genauso verwendet wie lokale Dateien, da verteilte Dateisysteme die Schnittstelle des Betriebssystems emulieren. Dadurch können die Vorteile von verteilten Systemen in einem Programm genutzt werden, ohne dieses anzupassen. Die Schreibzugriffe bzw. Lesezugriffe erfolgen über ganz normale `system-calls` [@coulouris2003verteilte S. 363ff.].

Dies ist auch ein großer Vorteil zu Speicherdiensten wie Amazon S3. Da die Schnittstelle zu den einzelnen Systemen abstrahiert werden, muss die Software nicht angepasst werden, wenn das Dateisystem gewechselt wird.

### Anforderungen\label{specification_distributed_fs}

Die Anforderungen an Verteilte Dateisysteme lassen sich wie folgt zusammenfassen.

Zugriffstransparenz

:   Client-Programme sollten, egal ob verteilt oder lokal, über die selbe Operationsmenge verfügen können. Es sollte also egal sein ob Daten aus einem verteilten oder lokalem Dateisystem stammen. Dadurch können Programme unverändert weiterverwendet werden, wenn seine Dateien verteilt werden [@coulouris2003verteilte, S. 369ff].

Ortstransparenz

:   Es sollten keine Rolle spielen, wo die Daten physikalisch gespeichert werden [@schuette2015a, S. 5]. Das Programm sieht immer den selben Namensraum, egal wo er ausgeführt wird [@coulouris2003verteilte, S. 369ff].

Nebenläufige Dateiaktualisierungen

:   Dateiänderungen, die von einem Client ausgeführt werden sollten die Operationen anderer Clients, die die selbe Datei verwenden, nicht stören. Um dieses Anforderung zu erreichen, muss ein funktionierende Nebenläufigkeitskontrolle implementiert werden. Die meisten aktuellen Dateisysteme unterstützen freiwillige oder zwingende Sperren auf Datei oder Datensatzebene.

Dateireplikationen

:   Unterstützt ein Dateisystem Dateireplikationen, kann ein Datensatz durch mehrere Kopien des Inhalts an verschiedenen Positionen dargestellt werden. Das bietet zwei Vorteile - Lastverteilung durch mehrere Server und es erhöht die Fehlertoleranz. Wenige Dateisysteme unterstützen vollständige Replikationen, aber die meisten unterstützen ein lokales Caching von Dateien, was eine eingeschränkte Art der Dateireplikation darstellt [@coulouris2003verteilte, S. 369ff].

Fehlertoleranz

:   Da der Dateidienst normalerweise der meist genutzte Dienst in einem Netzwerk ist, ist es unabdingbar, dass er auch dann weiter ausgeführt wird, wenn einzelne Server oder Clients ausfallen. Ein Fehlerfall sollte zumindest nicht zu Inkonsistenzen führen [@schuette2015a, S. 5].

Konsistenz

:   In konventionellen Dateisystemen werden Zugriffe auf Dateien auf eine einzige Kopie der Daten geleitet. Wird nun diese Datei auf mehrere Server verteilt, müssen die Operationen, an alle Server weitergeleitet werden. Die Verzögerung, die dabei auftritt, führt in dieser Zeit zu einem Inkonsistenten Zustand des Systems [@coulouris2003verteilte, S. 369ff].

Sicherheit

:   Fast alle Dateisysteme unterstützen eine Art Zugriffskontrolle auf die Dateien. Dies ist ungleich wichtiger, wenn viele Benutzer gleichzeitig auf Dateien zugreifen. In verteilten Dateisystemen besteht der Bedarf die Anforderungen des Clients auf korrekte Benutzer-IDs umzuleiten, die dem System bekannt sind [@coulouris2003verteilte, S. 369ff].

Effizienz

:   Verteilte Dateisysteme sollten, sowohl in Bezug auf die Funktionalitäten, als auch auf die Leistung, mit konventionellen Dateisystemen vergleichbar sein [@coulouris2003verteilte, S. 369ff].

Andrew Birrell und Roger Needham setzten sich folgende Entwurfsziele für Ihr Universal File System [@birrell1980a]:

	We would wish a simple, low-level, file server in order to
	share an expensive resource, namely a disk, whilst leaving
	us free to design the filing system most appropriate to
	a particular client, but we would wish also to have
	available a high-level system shared between clients.

Aufgrund der Tatsache, dass Festplatten heutzutage nicht mehr so teuer sind, wie in den 1980ern, ist das erste Ziel nicht mehr von zentraler Bedeutung. Jedoch ist die Vorstellung von einem Dienst, der die Anforderung verschiedenster Clients, mit unterschiedlichen Aufgabenstellungen, erfüllt, ein zentraler Aspekt der Entwicklung von verteilten (Datei-)Systemen [@coulouris2003verteilte, S. 369ff].

### NFS

Das verteilte Dateisystem Network File System wurde von Sun Microsystems entwickelt. Das grundlegende Prinzip von NFS ist, dass jeder Dateiserver eine standardisierte Dateischnittstelle implementiert und über diese Dateien des lokalen Speichers den Benutzern zur Verfügung stellt. Das bedeutet, dass es keine Rolle spielt, welches System dahinter steht. Ursprünglich wurde es für UNIX Systeme entwickelt. Mittlerweile gibt es aber Implementierungen für verschiedenste Betriebssysteme [@tanenbaum2003verteilte, S. 645ff.].

NFS ist also weniger ein Dateisystem als eine Menge von Protokollen, die in der Kombination mit den Clients ein verteiltes Dateisystem ergeben. Die Protokolle wurden so entwickelt, dass unterschiedliche Implementierungen einfach zusammenarbeiten können. Auf diese Weise können durch NFS eine heterogene Menge von Computern verbunden werden. Dabei ist es sowohl für den Benutzer als auch für den Server irrelevant mit welcher Art von System er verbunden ist [@tanenbaum2003verteilte, S. 645ff.].

__Architektur__

Das zugrundeliegende Modell von NFS ist, das eines entfernten Dateidienstes. Dabei erhält ein Client den Zugriff auf ein transparentes Dateisystem, dass von einem entfernten Server verwaltet wird. Dies ist vergleichbar mit RPC[^35]. Der Client erhält den Zugriff auf eine Schnittstelle um auf Dateien zuzugreifen, die ein entfernter Server implementiert [@tanenbaum2003verteilte, S. 647ff].

![NFS Architektur[@tanenbaum2003verteilte, S. 647]\label{nfs_architecture}](images/nfs_architecture.png)

Der Client greift über die Schnittstelle des lokalen Betriebssystems auf das Dateisystem zu. Die lokale Dateisystemschnittstelle wird jedoch durch ein Virtuelles Dateisystem ersetzt (VFS), die jetzt als Schnittstelle zu den verschiedenen Dateisystemen darstellt. Das VFS entscheidet anhand der Position im Dateibaum, ob die Operation an das lokale Dateisystem oder an den NFS-Client weitergegeben wird (siehe Abbildung \ref{nfs_architecture}). Der NFS-Client ist eine separate Komponente, die sich um den Zugriff auf entfernte Dateien kümmert. Dabei fungiert der Client als eine Art Stub-Implementierung der Schnittstelle und leitet alle Anfragen an den entfernten Server weiter (RPC). Diese Abläufe werden aufgrund des VFS-Konzeptes vollkommen transparent für den Benutzer durchgeführt [@tanenbaum2003verteilte, S. 647ff].

### XtreemFS

Als Alternative zu konventionellen verteilten Dateisystemen bietet XtreemFS eine unkomplizierte und moderne Variante eines verteilten Dateisystems. Es wurde speziell für die Anwendung in einem Cluster mit dem Betriebssystem XtreemOS entwickelt. Mittlerweile gibt es aber Server- und Client-Anwendungen für fast alle Linux Distributionen. Außerdem Clients für Windows und MAC.

Die Hauptmerkmale von XtreemFS sind:

Distribution

:   Eine XtreemFS Installation enthält eine beliebige Anzahl von Servern, die auf verschiedenen Physikalischen Maschinen betrieben werden können. Diese Server, sind entweder über einen lokalen Cluster oder über das Internet miteinander verbunden. Der Client kann sich mit einem beliebigen Server verbinden und mit ihm Daten austauschen. Es Garantiert konsistente Daten, auch wenn verschiedene Clients mit verschiedenen Server kommunizieren, vorausgesetzt, alle Komponenten sind miteinander verbunden und erreichbar [@xtreemfs2015a, Kapitel 2.3].

Replication

:   Die drei Hauptkomponenten von XtreemFS, Directory Service, Metadata Catalog und die Object Storage Devices (siehe Kapitel \ref{xtreemfs_architecture}), können repliziert redundant verwendet werden, dies führt zu einem Fehlertoleranten System. Die Replikationen zwischen diesen Systemen erfolgt mit einem Hot-Backup (siehe Kapitel \ref{xtreemfs_replication}), welche Automatisch verwendet werden, wenn ein Server ausfällt [@xtreemfs2015a, Kapitel 2.3].

Striping

:   XtreemFS splittet Dateien in sogenannte "stripes" (oder "chunks"). Diese chunks werden dann auf verschiedenen Servern gespeichert und können dann parallel von mehreren Servern gelesen werden. Die gesamte Datei kann dann mit der zusammengefassten Netzwerk- und Festplatten-Bandbreite mehrerer Server heruntergeladen werden. Die Größe und Anzahl der Server kann pro Datei bzw. pro Ordner festgelegt werden [@xtreemfs2015a, Kapitel 2.3].

Security

:   Um die Sicherheit der Dateien zu gewährleisten, unterstützt XtreemFS sowohl Benutzer Authentifizierung als auch Berechtigungen. Der Netzwerkverkehr zwischen den Servern ist Verschlüsselt. Die Standarad Authentifizierung basiert auf lokalen Benutzernamen und ist auf die Vertrauenswürdigkeit der Clients bzw. des Netzwerkes angewiesen. Um mehr Sicherheit zu erreichen unterstützt XtreemFS aber auch eine Authentifizierung mittels X.509 Zertifikaten [^34] [@xtreemfs2015a, Kapitel 2.3].

#### Architektur\label{xtreemfs_architecture}

XtreemFS implementiert eine Objekt-Basierte Datei-Systemarchitektur, was bedeutet, dass die Dateien in Objekte mit einer bestimmten Größe aufgeteilt werden und auf verschiedenen Servern gespeichert werden. Die Metadaten werden in separaten Servern gespeichert. Diese Server organisieren die Dateien in eine Menge von sogenannten "volumes". Jedes Volume ist ein eigener Namensraum mit einem eigenen Dateibaum. Die Metadaten speichern zusätzlich eine Liste von chunk-IDs mit den jeweiligen Servern, auf denen dieser Chunk zu finden ist und eine Richtlinie, wie diese Datei aufgeteilt und auf Server verteilt werden soll. Dadurch kann die Größe der Metadaten von Datei zu Datei unterschiedlich sein. [@xtreemfs2015a, Kapitel 2.4]

![XtreemFS Architektur [@xtreemfs2015b]\label{xtreemfs_architecture}](images/xtreemfs_architecture.png)

Eine XtreemFS Installation besteht aus drei Komponenten:

DIR - Directory Service

:   ist das zentrale Register für alle Services. Andere Services bzw. Client verwenden ihn um zum Beispiel alle Object-Storage-Devices zu finden. [@xtreemfs2015a, Kapitel 2.4]

MRC - Metadata and Replica Catalog

:   verwaltet die Metadaten der Datei, wie zum Beispiel Dateiname, Dateigröße oder Bearbeitungsdatum. Zusätzlich Authentifiziert und Autorisiert er Benutzer den Zugriff auf die Dateien bzw. Ordner. [@xtreemfs2015a, Kapitel 2.4]

OSD - Object Storage Device

:   speichert die Objekte ("strip" oder "chunks") der Dateien. Die Clients schreiben und lesen Daten direkt von diesen Servern. [@xtreemfs2015a, Kapitel 2.4]

#### Exkurs: Datei Replikation\label{xtreemfs_replication}

Ein wichtiger Aspekt von verteilten Dateisystemen ist die Replikation von Daten. Sie steigert sowohl die Zuverlässigkeit, als auch Leistung der Lesezugriffe. Das größte Problem dabei ist allerdings die Konsistenz der Repliken zu erhalten. Dabei muss bei jedem schreiben Zugriff ein Update aller Repliken erfolgen, ansonsten ist die Konsistenz nicht mehr gegeben. [@tanenbaum2003verteilte, S. 333ff]

Die Hauptgründe für Replikationen von Daten sind Zuverlässigkeit und Leistung. Wenn Daten repliziert werden ist es unter Umständen möglich, weiterzuarbeiten, wenn eine Replika ausfällt. Der Benutzer lädt sich die Daten dann von einem anderen Server. Zusätzlich dazu können durch Repliken Fehlerhafte Dateien erkannt werden. Wenn eine Datei also zum Beispiel auf drei Servern gespeichert wurde und alle Schreib- bzw. Lesezugriffe auf alle drei Server ausgeführt werden, kann durch den Vergleich der Antworten, erkannt werden ob eine Datei fehlerhaft ist oder nicht. Dazu müssen nur zwei Antworten den selben Inhalt besitzen und es kann davon auszugehen sein, dass es sich um die richtige Datei handelt. [@tanenbaum2003verteilte, S. 333ff]

Der andere wichtige Grund für Replikationen ist die Leistung des Systems. Hier gibt es zwei Aspekte, der eine bezieht sich auf die gesamt Last eines einzigen Servers und der andere auf Geographische Lage. Wenn also ein System nur aus einem Server besteht, ist dieser Server der vollen Last der Zugriffe ausgesetzt. Teilt man diese Last auf, kann die Leistung des Systems gesteigert werden. Zusätzlich können durch Repliken auch der Lesezugriff gesteigert werden indem dieser Zugriff über mehrere Server parallel erfolgt. Auch die Geographische Lage der Daten spielt bei der Leistung des Systems eine Entscheidende Rolle. Wenn Daten in der Nähe des Prozesses gespeichert werden in dem Sie erzeugt bzw. verwendet werden, ist sowohl der schreibende als auch der lesende Zugriff schneller umzusetzen. Diese Leistungssteigerung ist allerdings nicht linear zu den verwendeten Servern. Den es ist einiges an Aufwand zu treiben, diese Repliken synchron zu halten und dadurch die Konsistenz zu wahren. [@tanenbaum2003verteilte, S. 333ff]

Damit ein Verbund von Servern die Konsistenz ihrer Daten gewährleisten kann, werden Konsistenzprotokolle eingesetzt. In XtreemFS wir ein sogenanntes Primärbasiertes Protokoll eingesetzt [@xtreemfs2015a, Kapitel 6]. In diesen Protokollen, ist jedem Datenelement "x" ein primärer Server zugeordnet, der dafür verantwortlich ist, Schreiboperationen für "x" zu koordinieren. Es gibt zwei Arten dieses Protokoll umzusetzen.

__Entferntes-Schreiben__

Es gibt auch hier zwei Arten zur Implementierung des Protokolls. Das eine, ist ein nicht replizierendes Protokoll, bei dem alle Schreib- und Lesezugriffe auf den Primären Server des Objekte ausgeführt werden. Und das andere, ist das sogenannte "Primary-Backup" Protokoll, verfügt über einen festen Primären Server für jedes Objekt. Dieser Server wird bei der Erstellung des Objektes festgelegt und nicht verändert. Zusätzlich wird festgelegt, auf welchen Servern Repliken für dieses Objekt angelegt werden. In XtreemFS werden diese Einstellungen "replication policy" genannt [@xtreemfs2015a, Kapitel 6.1.3]. 

![Primary-Backup-Protokoll: Entferntes-Schreiben[@tanenbaum2003verteilte, S. 385]\label{primary_backup_remote_protocoll}](images/primary-backup-remote-protocoll.png)

Der Prozess, der eine Schreiboperation (siehe \ref{primary_backup_remote_protocoll}) auf das Objekt ausführen will, gibt sie an den Primären Server weiter. Dieser führt die Operation lokal an dem Objekt aus und gibt die Aktualisierungen an die Backup-Server weiter. Jeder dieser Server führt die Operation aus und gibt eine Bestätigung an den Primären Server weiter. Nachdem alle Backups die Aktualisierung durchgeführt haben, gibt auch der Primäre Server eine Bestätigung an den Ausführenden Server weiter. Dieser Server kann nun sicher sein, dass die Aktualisierung auf allen Servern ausgeführt wurde und damit sicher im System gespeichert wurde. Aus der Tatsache, das dieses Protokoll blockierend ist, kann ein gravierendes Leistungsproblem entstehen. Für Programme, die lange Antwortzeiten nicht akzeptieren können, ist es eine Variante, das Protokoll nicht blockierend zu implementieren. Das bedeutet, dass der Primäre Server die Bestätigung direkt nach dem lokalen ausführen der Operation zurückgibt und erst danach die Aktualisierungen an die Backups weitergibt [@xtreemfs2015c]. Aufgrund der Tatsache, dass alle Schreiboperationen auf einem Server ausgeführt werden, können diese einfach gesichert werden und dadurch die Konsistenz gesichert werden. Eventuelle Transaktionen oder Locks müssen nicht im Netzwerk verteilt werden [@tanenbaum2003verteilte, S. 384ff].

__Lokales-Schreiben__

Auch in dieser Implementierung gibt es zwei Möglichkeiten es zu implementieren. Die eine ist ein nicht replizierendes Protokoll, bei dem vor einem Schreibzugriff das Objekt auf den Ausführenden Server verschoben wird und dadurch der Primäre Server des Objekts geändert wird. Nachdem die Schreiboperation ausgeführt wurde, bleibt das Objekt auf diesem Server solange, bis ein anderer Server Schreibend auf das Objekt zugreifen will. Die andere Möglichkeit, ist ein Primäres-Backup Protokoll (siehe Abbildung \ref{primary_backup_local_protocoll}), bei dem der Primäre-Server des Objektes zu dem ausführenden Server migriert wird [@tanenbaum2003verteilte, S. 386ff].

![Primary-Backup-Protokoll: Lokales-Schreiben[@tanenbaum2003verteilte, S. 387]\label{primary_backup_local_protocoll}](images/primary-backup-local-protocoll.png)

Dieses Protokoll ist auch für mobile Computer geeignet, die in einem Offline Modus verwendet werden können. Dazu wird es zum primären Server für die Objekte, die er vermutlich während seiner Offline-Phase bearbeiten wird. Während der Offline-Phase können nun Aktualisierungen lokal ausgeführt werden und die anderen Clients können lesend auf eine Replik zugreifen. Sie bekommen zwar keine Aktualisierungen können aber sonst ohne Einschränkungen weiterarbeiten. Nachdem die Verbindung wiederhergestellt wurde, werden die Aktualisierungen an die Backup-Server weitergegeben, sodass der Datenspeicher wieder in einen Konsistenten Zustand übergehen kann [@tanenbaum2003verteilte, S. 386ff].

### Speichergeschwindigkeit

__TODO überhaupt notwendig?__

* <http://member.wide.ad.jp/~shima/publications/20120924-dfs-performance.pdf>

### Zusammenfassung (??evtl. Evaluierung??)

Im Bezug auf die Anforderungen (siehe Kapitel \ref{specification}) bieten, die analysierten, verteilten Dateisysteme von Haus aus keine Versionierung. Es gab Versuche der Linux-Community, mit Wizbit[^33], ein auf GIT-basierendes Dateisystem zu entwerfen, das Versionierung mitliefern sollte [@arstechnica2008a]. Dieses Projekt wurde allerdings seit ende 2009 nicht mehr weiterentwickelt [@openhub2015a]. Die benötigten Zugriffsberechtigungen werden zwar auf der Systembenutzerebene durch ACL unterstützt. Jedoch müsste dann, die Anwendungen für jeden Anwendungsbenutzer einen Systembenutzer anlegen [@xtreemfs2015a, Kapitel 7.2]. Dies wäre zwar auf einer einzelnen Installation machbar, jedoch macht es eine Verteilte Verwendung komplizierter und eine Installation aufwändiger. Allerdings können gute Erkenntnisse aus der Analyse der Fehlertoleranz in NFS und den Replikationen bzw. der Konsistenzprotokollen von XtreemFS, gezogen werden und in ein Gesamtkonzept miteinbezogen werden.

## Datenbank gestützte Dateiverwaltungen

Einige Datenbanksysteme, wie zum Beispiel MongoDB[^31], bieten eine Schnittstelle an, um Dateien abzuspeichern. Viele dieser Systeme sind meist nur begrenzt für große Datenmengen geeignet. MongoDB und GridFS sind jedoch genau für diese Anwendungsfälle ausgelegt, daher wird diese Technologie im folgenden Kapitel genauer betrachtet.

### MongoDB & GridFS

MongoDB bietet von Haus aus die Möglichkeit, BSON-Dokumente in der Größe von 16MB zu speichern. Dies ermöglicht die Verwaltung kleinerer Dateien ohne zusätzlichen Layer. Für größere Dateien und zusätzliche Features bietet MongoDB mit GridFS eine Schnittstelle an, mit der es möglich ist, größere Dateien und ihre Metadaten zu speichern. Dazu teilt GridFS die Dateien in Chunks einer bestimmten Größe auf. Standardmäßig ist die Größe von Chunks auf 255Byte gesetzt. Die Daten werden in der Kollektion `chunks` und die Metadaten in der Kollektion `files` gespeichert.

Durch die verteilte Architektur von MongoDB werden die Daten automatisch auf allen Systemen synchronisiert. Außerdem bietet das System die Möglichkeit, über Indexes schnell zu suchen und Abfragen auf die Metadaten durchzuführen.

__Beispiel:__

```php
$mongo = new Mongo(); 					  // connect to database
$database = $mongo->selectDB("example");  // select mongo database  
  
$gridFS = $database->getGridFS();		  // use GridFS class for
                                          //handling files  
  
$name = $_FILES['Filedata']['name']; 	  // optional - capture the
										  // name of the uploaded file  
$id = $gridFS->storeUpload('Filedata', $name);
										  // load file into MongoDB  
```

Bei der Verwendung von MongoDB ist es sehr einfach, Dateien in GridFS abzulegen. Die fehlenden Funktionen wie zum Beispiel, ACL oder Versionierung, machen den Einsatz in Symcloud allerdings schwierig. Auch der starre Aufbau mit nur einem Dateibaum macht die Anpassung der Datenstruktur nahezu unmöglich. Allerdings ist das Chunking der Dateien auch hier zentraler Bestandteil, daher wäre es möglich MongoFS für einen Teil des Speicher-Konzeptes zu verwenden.

## Performance

__TODO überhaupt notwendig?__

## Zusammenfassung

Am Ende dieses Abschnittes, werden die Vor- und Nachteile der jeweiligen Technologien zusammengefasst. Dies ist notwendig, um am Ende ein optimales Speicherkonzept für Symcloud zu entwickeln.

Speicherdienste, wie Amazon S3,

:   sind für einfache Aufgaben bestens geeignet. Sie bieten alles an, was für ein schnelles Setup der Applikation benötigt wird. Jedoch haben gerade die Open-Source Alternativen zu S3 wesentliche Mankos, die gerade für das aktuelle Projekt unbedingt notwendig sind. Zum einen ist es bei den Alternativen die fehlenden Funktionalitäten, wie zum Beispiel ACLs oder Versionierung, zum anderen ist auch Amazon S3 wenig flexibel, um eigene Erweiterungen hinzuzufügen. Jedoch können wesentliche Vorteile bei der Art der Datenhaltung beobachtet werden. Wie zum Beispiel:

* Rest-Schnittstelle
* Versionierung
* Gruppierung durch Buckets
* Berechtigungssysteme

Diese Punkte werden im Kapitel \ref{chapter_concept} berücksichtigt werden.

Verteilte Dateisysteme

:    bieten durch ihre einheitliche Schnittstelle einen optimalen Abstraktionslayer für datenintensive Anwendungen. Die Flexibilität, die diese Systeme verbindet, bietet sich für Anwendungen wie Symcloud an. Jedoch sind fehlende Zugriffsrechte auf Anwendungsbenutzerebene (ACL) und die fehlende ein Problem, das auf Speicherebene nicht gelöst wird. Aufgrund dessen könnte ein solches verteiltes Dateisystem nicht als Ersatz für eine eigene Implementierung, sondern lediglich als Basis hergenommen werden.

Datenbankgestützte Dateiverwaltung

:   sind für den Einsatz in Anwendungen geeignet, die die darunterliegende Datenbank verwendet. Die nötigen Erweiterungen, um Dateien in eine Datenbank zu schreiben, sind aufgrund der Integration sehr einfach umzusetzen. Sie bieten eine gute Schnittstelle, um Dateien zu verwalten. Die fehlenden Möglichkeiten von ACL und Versionierung macht jedoch die Verwendung von GridFS sehr aufwändig. Aufgrund des Aufbaues von GridFS gibt es in der Datenbank einen Dateibaum, indem alle Benutzer ihre Dateien ablegen. Die Anwendung müsste dann dafür sorgen, dass jeder Benutzer nur seine Dateien sehen bzw. bearbeiten kann. Allerdings kann, gerade aus GridFS, mit dem Datei-Chunking (siehe Kapitel \ref{concept_file_storage} __TODO evtl. Nummer anpassen__) ein sehr gutes Konzept für eine effiziente Dateihaltung entnommen werden.

Da aufgrund verschiedenster Schwächen keine der Technologien eine adäquate Lösung für die Datenhaltung in Symcloud bietet, wird im nächsten Kapitel versucht ein optimales Speicherkonzept für das aktuelle Projekt zu entwickeln.

[^30]: <http://aws.amazon.com/de/s3/>
[^31]: <http://docs.mongodb.org/manual/core/gridfs/>
[^32]: <http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html>
[^33]: <https://www.openhub.net/p/wizbit>
[^34]: <http://tools.ietf.org/html/rfc5280>
[^35]: Remote Procedure Calls <http://www.cs.cf.ac.uk/Dave/C/node33.html>
