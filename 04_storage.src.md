# Speicherverwaltung

Ein wichtiger Aspekt von Cloud-Anwendungen ist die Speicherverwaltung. Es bieten sich verschiedenste Möglichkeiten der Datenhaltung in der Cloud an. Dieses Kapitel beschäftigt sich mit der Evaluierung von verschiendenen Diensten bzw. Lösungen, mit denen Speicher verwaltet und möglichst effizient zur Verfügung gestellt werden kann.

Aufgrund der Anforderungen des Projektes werden folgende Anforderungen an die Speicherlösung gestellt.

Ausfallsicherheit

:   Die Speicherlösung ist das Fundament einer jeder Cloud-Anwendung. Ein Ausfall dieser Schicht bedeutet oft ein Ausfall der kompletten Anwendung. ???

Skalierbar

:   Die Datenmengen einer Cloud-Anwendung sind oft schwer abschätzbar und können sehr große Ausmaße annehmen. Daher ist eine wichtige Anforderung an eine Speicherlösung die Skalierbarkeit. ??? 

Datenschutz

:   Der Datenschutz ist ein wichtiger Punkt beim betreiben der eigenen Cloud-Anwendung. Meist gibt es eine kommerzielle Konkurrenz, die mit günstigen Preisen die Anwender anlockt, um ihre Daten zu verwerten. Die Möglichkeit Daten privat auf dem eigenen Server zu speichern, sollte somit gegeben sein. Damit Systemadministratoren nicht auf einen Provider angewiesen sind.

Flexibilität

:   Um Daten flexibel speichern zu können, sollte es möglich sein, Verlinkungen und Metadaten direkt in der Speicherlösung abzulegen. Dies erleichtert die Implementierung der eigentlichen Anwendung.

Versionierung

:   Ein optionale Eigenschaft ist die integrierte Versionierung der Daten. Dies würde eine Vereinfachung der Anwendungslogik ermöglichen, da Versionen nicht in einem separaten Speicher abgelegt werden müssen.

Performance

:   ???

## Datenhaltung in Cloud-Infrastrukturen

Wenn man Speicherstrukturen in der Cloud genauer betrachtet, gibt es grundsätzlich drei Möglichkeiten. 

Objekt-Speicherdienste

:   wie zum Beispiel Amazon S3[^30], ermöglichen das Speichern von sogenannten Objekten (Dateien, Ordner und Metadaten). Sie sind optimiert for den parallelen zugriff von mehreren Instanzen einer Anwendung.

Verteilte Dateisysteme

:   fungieren als einfache Laufwerke und abstrahieren dadurch den komplexen Ablauf der darunter liegenden Services. Der Zugriff auf die meisten dieser Dateisysteme erfolgt über system-calls wie zum Beispiel `fopen` oder `fclose`.

Datenbank gestützte Dateisysteme

:   wie zum Beispiel GridFS[^31] von MondoDB, erweitern Datenbanken um große Dateien effizient und sicher abzuspeichern.

## Amazon Simple Storage Service (S3)

Amazon Simple Storage Service bietet Entwicklern einen sicheren, beständigen und sehr gut skalierbaren Objektspeicher an. Es dient der einfachen und sicheren Speicherung großer Datenmengen [siehe @amazon2015a]. Daten werden in sogenannten Buckets gegliedert. Jeder Bucket kann unbegrenzt Objekte enthalten. Die Gesamtgröße der Objekte ist jedoch auf 5TB beschränkt. Sie können nicht verschachtelt werden, allerdings können sie Ordner enthalten, um die Objekte zu gliedern.

Die Kernfunktionalität des Services besteht darin, Daten in sogenannten Objekten zu speichern. Diese Objekte können bis zu 5GB groß werden. Zusätzlich wird zu jedem Objekt ca. 2KB Metadaten abgelegt. Die Tabelle \ref{awz_object_metadata} enthält eine Liste von systemdefinierten Metadaten. Einige dieser Metadaten können vom Benutzer überschrieben werden, wie zum Beispiel `x-amz-storage-class`, andere werden vom System automatisch gesetzt, wie zum Beispiel `Content-Length` [siehe @amazon2015b].

| Name | Description |
|------|-----|
| Date | Object creation date. |
| Content-Length | Object size in bytes. |
| Last-Modified | Date the object was last modified. |
| Content-MD5 | The base64-encoded 128-bit MD5 digest of the 
|  | object. |
| x-amz-server- | Indicates whether server-side encryption
| side-encryption | is enabled for the object, and whether 
|  | that encryption is from
|  | the AWS Key Management Service (SSE-KMS)
|  | or from AWS-Managed Encryption (SSE-S3).
| x-amz-version-id | Object version. When you enable
|  | versioning on a bucket, Amazon S3 assigns
|  | a version number to objects added to the
|  | bucket. |
| x-amz-delete-marker | In a bucket that has versioning enabled,
|  | this Boolean marker indicates whether the object is a
|  | delete marker. |
| x-amz-storage-class | Storage class used for storing the object. |
| x-amz-website- | Redirects requests for the
| redirect-location | associated object to another object in the same bucket
|  | or an external URL. |
| x-amz-server- | If the x-amz-server-side-encryption 
| side-encryption- | is present and has the value of aws:kms, this indicates
| aws-kms-key-id | the ID of the Key Management Service (KMS) master
|  | encryption key that was used for the object. |
| x-amz-server- | Indicates whether server-side encryption
| side-encryption- | with customer-provided encryption keys (SSE-C) is enabled.
| customer-algorithm 

  : Objekt Metadaten \label{awz_object_metadata}

Zusätzlich zu diesen systemdefinierten Metadaten ist es möglich benutzerdefinierte Metadaten zu speichern. Das Format dieser Metadaten entspricht einer Key-Value Liste. Sie sind auf 2KB limitiert.

### Versionierung

Die Speicherlösung bietet eine Versionierung der Objekte an. Diese kann über eine Rest-API, mit folgendem Inhalt, in jedem Bucket aktiviert werden.

```xml
<VersioningConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <Status>Enabled</Status> 
</VersioningConfiguration>
```

Ist die Versionierung aktiviert, gilt diese für alle Objekte, die dieser enthält. Wird anschließend ein Objekt überschrieben, resultiert dies in einer neuen Version, dabei wird die Version-ID im Metadaten Feld `x-amz-version-id` auf einen neuen Wert gesetzt [siehe @amazon2015c]. Dies veranschaulicht die Abbildung \ref{awz_object_versioning}.

![Versionierungsschema von Amazon S3 [Quelle @amazon2015c] \label{awz_object_versioning}](images/awz_versioning.png)

### Skalierbarkeit

Die Skalierbarkeit ist aufgrund der, von Amazon,verwalteten Umgebung, sehr einfach. Es wird soviel Speicherplatz zur Verfügung gestellt, wie benötgit wird. Der Umstand, das mehr Speicherplatz benötigt wird, zeichnet sich nur auf der Rechnung des Betreibers ab.

### Datenschutz

Amazon ist ein US-Amerikanisches Unternehmen und wir aus diesem Grund, wie andere Dienste, seit Jahren kritisiert. Um dieses Problem zu kompensieren, können Systemadministratoren sogenannte "Availability Zones" auswählen und damit steuern, wo ihre Daten gespeichert werden. Zum Beispiel werden Daten aus einem Bucket mit der Zone Irland, auch wirklich in Irland gespeichert. Zusätzlich gewährt Amazon die Verschlüsselung der Daten [siehe @wikiaws].

Wer bedenken hat, seine Daten aus den Händen zu geben, kann auf verschiedene kompatible Lösungen zurückgreifen.

### Alternativen zu Amazon S3

Es gibt einige Amazon S3 kompatible Anbieter, die einen ähnlichen Dienst bieten. Diese sind allerdings meist auch US-Amerikanische Firmen und daher gleich vertrauenswürdig wie Amazon. Wer daher auf Nummer sicher gehen will und seine Daten bzw. Rechner-Instanzen ganz bei sich behalten will, kommt um eine Installation von Cluster Lösungen nicht herum.

Eucalyptus

:   ist eine Open-Source-Infrastruktur zur Nutzung von Cloud-Computing auf Rechner Cluster. Der Name ist ein Akronym für "Elastic Utility Computing Architecture for Linking Your Programs To Useful Systems". Die hohe Kompatibilität macht diese Software-Lösung zu einer optimalen Alternative zu Amazon-Web-Services [siehe @wikieucalyptus]. Dieser Dienst bietet keine Versionierung 

Riak Cloud Storage

:   ist eine Software, mit der es möglich ist, ein verteilter Objekt-Speicherdienst zu betreiben. Es implementiert die Schnittstelle von Amazon S3 und ist damit kompatibel zu der aktuellen Version [siehe @basho2015riakcs]. Es unterstützt die meisten Funktionalitäten, die Amazon bietet. Die Installation von Riak-CS ist im gegensatz zu Eucalyptus sehr einfach und kann daher auf nahezu jedem System durchgeführt werden.

Beide vorgestellten Dienste bieten momentan keine Möglichkeit Objkte zu versionieren. Ausserdem ist das vergeben von Berechtigungen für andere Benutzer ebenfalls nur mit Amazon S3 möglich.

### Performance

HostedFTP veröffentlichte im Jahre 2009 in einem Perfomance Report ihre Erfahrungen mit der Performance zwischen EC2 (Rechner Instancen) und S3 [siehe @hostedftp2009amazons3]. Über ein Performance Modell wurde festgestellt, dass die Zeit für den Download einer Datei in zwei Bereiche aufgeteilt werden kann.

Feste Transaktionszeit

:   ist ein fixer Zeitabschnitt, der für die Bereitstellung oder Erstellung der Datei benötigt wird. Beeinflusst wird diese Zeit kaum, allerdings kann es aufgrund schwankender Auslastung zu Verzögerungen kommen.

Downloadzeit

:   ist liniar abhängig zu der Dateigröße und kann aufgrund der Bandbreite schwanken.

Ausgehend von diesen Überlegungen kann davon ausgegangen werden, dass die Upload- bzw. Downloadzeit einen linearen Verlauf über die Dateigröße aufweist. Diese These wird von den Daten unterstützt. Aus dem Diagramm (Abbildung \ref{performance_s3_upload}) kann die feste Transaktionszeit von ca. 140ms abgelesen werden.

![Upload Analyse zwischen EC2 und S3 [Quelle @hostedftp2009amazons3] \label{performance_s3_upload}](images/performance_s3_upload.png)

Für den Download von Dateien ensteht laut den Daten aus dem Report keine fixe Transaktionszeit. Die Zeit für den Download ist also nur von der Größe der Datei und der Bandbreite abhängig. 

## \label{chapter_distibuted_fs}Verteilte Dateisysteme

Verteilte Dateisysteme unterstützen die gemeinsame Nutzung von Informationen in Form von Dateien. Es bietet zugriff auf Dateien, die auf einem entfernten Server abgelegt sind, wobei eine ähnliche Leistung und Zuverlässigkeit erzielt werden, wie für lokal gespeicherte Daten. Wohldurchdachte Dateisysteme erziehlen oft bessere Ergebnisse in Leistung und Zuverlässigkeit als lokale Systeme. Die entferneten Dateien werden genauso verwendet wie lokale Dateien, da verteilte Dateisysteme die Schnittstelle des Betriebsystems emulieren. Dadurch können die Vorteile von verteilten Systemen in einem Programm genutzt werden ohne dieses Anzupassen. Die Schreibzugriffe auf erfolgen über ganz normale `system-calls` [siehe @coulouris2003verteilte S. 363ff.].

Dies ist auch ein großer Vorteil zu Speicherdiensten wie Amazon S3. Da die Schnittstelle zu den einzelnen Systemen abstrahiert werden, muss die Software nicht agepasst werden, wenn das Dateisystem gewechselt wird.

__TODO Anforderungen an ein verteiltes Dateisystem?__

### NFS

Network File System wurde von Sun Microsystem entwickelt. Das Grundlegende Prinzip von NFS ist, dass jeder Dateiserver ein standardisierte Dateischnittstelle und Dateien des lokeln Speicher den Benutzern zur verfügung zu stellen. Das bedeutet, dass es keine Rolle spielt welches System dahinter steht. Ursprünglich wurde es für UNIX Systeme entwickelt. Mittlerweile gibt es aber implementierungen für verschiedenste Betriebssysteme [siehe @tanenbaum2003verteilte S. 645ff.].

NFS ist also weniger ein Dateisystem als eine Menge von Protokollen, die in der Kombination mit den Clients ein verteiltes Dateisystem ergeben. Die Protokolle wurden so entwickelt, dass unterschiedliche Implementierungen einfach zusammenarbeiten können. Auf diese Weise können durch NFS eine heterogene Menge von Computern verbunden werden. Dies gilt sowohl für Benutzer- als auch für die Serverseite [siehe @tanenbaum2003verteilte S. 645ff.].

#### Architektur

### Ceph

### XtreemFS

### Speichergeschwindigkeit

## Datenbank gestützte Dateiverwaltungen

### MongoDB & GridFS

### Crate

## Performance

## Evaluation

* <http://member.wide.ad.jp/~shima/publications/20120924-dfs-performance.pdf>

[^30]: <http://aws.amazon.com/de/s3/>
[^31]: <http://docs.mongodb.org/manual/core/gridfs/>
[^32]: <http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html>
