# Speicherverwaltung

Ein wichtiger Aspekt von Cloud-Anwendungen ist die Speicherverwaltung. Es bieten sich verschiedenste Möglichkeiten der Datenhaltung in der Cloud an. Dieses Kapitel beschäftigt sich mit der Evaluirung der verschienden Dienste bzw. Lösungen, mit denen Speicher verwaltet und möglichst effizient zur Verfügung gestellt werden können.

Aufgrund der Anforderungen des Projektes werden folgende Anforderungen an die Speicherlösung gestellt.

Ausfallsicherheit

:   Die Speicherlösung ist das Fundament einer jeder Cloud-Anwendung. Ein Ausfall dieser Schicht bedeutet oft ein Ausfall der kompletten Anwendung. ???

Skalierbar

:   Die Datenmengen einer Cloud-Anwendung sind of schwer abzuschätzbar und können sehr große Ausmasse annehmen. Daher ist eine wichtige Anforderung an eine Speicherlösung die Skalierbarkeit. ??? 

Datenschutz

:   Der Datenschutz ist ein wichtiger Punkt beim betreiben der eigenen Cloud-Anwendung. Meist gibt es eine kommerzielle Konkurenz die mit günstigen Preisen die Anwender anlockt um ihre Daten zu verwerten. Die möglichkeit die Daten privat auf eigenen Server zu speichern sollte also gegeben sein. Damit Systemadministratoren nicht auf einen Provider angewiesen sind.

Flexibilität

:   Um Daten flexibel zu speichern sollte es möglich sein Verlinkungen und Metadaten direkt in der Speicherlösung zu speichern. Dies erleichtert die Implementierung der eigentlichen Anwendung.

Versionierung

:   Ein optionale Eigenschaft ist die Integrierte Versioning der Daten. Dies würde eine Vereinfachung der Anwendungslogik ermöglichen, da Versionen nicht in einem seperaten Speicher abgelegt werden müssen.

Performance

:   ???

## Datenhaltung in Cloud-Infrastrukturen

Wenn man Speicherstrukturen in der Cloud genauer betrachtet gibt es Grundsätzlich drei Möglichkeiten. Zum einen sind dies Objekt Speicherdienste, wie zum Beispiel Amazon S3[^30], die es ermöglichen, dass mehrere Instanzen einer Anwendungen gleichzeitig den Speicher verwenden. Eine andere Möglichkeit sind verteilte Dateisysteme oder Datenbank gestützt wie zum Beispiel GridFS[^31] von MongoDB. 

## Amazon Simple Storage Service (S3)

Amazon Simple Storage Service bietet Entwicklern einen sicheren, beständigen und sehr gut Skalierbaren Objektspeicher an. Es dient der einfachen und sicheren Speicherung großer Datenmengen [siehe @amazon2015a]. Daten werden in sogenannten Buckets gegliedert. Jeder Bucket kann unbegrenzt Objekte enthalten. Die gesamtgröße der Objekte ist jedoch auf 5TB beschränkt. Sie können nicht verschachtelt werden, allerdings können sie Ordner enthalten um die Objekte zu gliedern.

Die Kernfunktionalität des Services besteht darin Daten in sogenannten Objekten zu speichern. Diese Objekte können bis zu 5 GB groß werden. Zusätzlich wird zu jedem Objekt ca. 2kB Metadaten abgelegt. Die Tabelle \ref{awz_object_metadata} enthät eine Liste von Systemdefinierten Metadaten. Einige dieser Metadaten können vom Benutzer überschrieben werden, wie zum Beispiel `x-amz-storage-class`, andere werden vom System automatisch gesetzt, wie zum Beispiel `Content-Length` [siehe @amazon2015b].

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

Zusätzlich zu diesen Systemdefinierten Metadaten ist es möglich Benutzerdefinierte Metadaten zu speichern. Das Format dieser Metadaten entspricht einer Key-Value Liste. Sie sind  2KB limitiert.

### Versionierung

Die Speicherlösung bietet eine Versionierung der Dateien. Diese kann über ein Konfigurationsfile in jedem Bucket aktiviert werden.

```xml
<VersioningConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <Status>Enabled</Status> 
</VersioningConfiguration>
```

Ist die Versionierung aktiviert gilt diese für alle Objekte, die dieser enthält. Wird anschließend ein Objekt überschrieben, resultiert dies in einer neuen Version, dabei wird die Versions-ID im Metadaten Feld `x-amz-version-id` auf einen neuen Wert gesetzt [siehe @amazon2015c]. Dies veranschaulicht die Abbildung \ref{awz_object_versioning}.

![Versionierungs Schema Amazon S3 [Quelle @amazon2015c] \label{awz_object_versioning}](images/awz_versioning.png)

### Skalierbarkeit

Die Skalierbarkeit ist aufgrund der, von Amazon, verwalteten Umgebung sehr einfach. Es wird soviel Speicherplatz zur verfügung gestellt wie benötgit wird. Der Umstand, das mehr Speicherplatz benötigt wird, spiegelt sich nur auf der Rechnung des Betreibers ab.

### Datenschutz

Amazon ist ein US-Amerikanisches Unternehmen und steht aus diesem, wie andere Dienste, seit Jahren in der Kritik. Um dieses Problem zu kompensieren, können Systemadministratoren sogenannte "Availability Zones" auswählen und damit steuern wo ihre Daten gespeichert werden. Zum Beispiel werden Daten aus einem Bucket mit der Zone Irland, auch wirklich in Irland gespeichert. Zusätzlich gewährt Amazon die Verschlüsselung der Daten [siehe @wikiaws].

Wer bedenken hat seine Daten aus den Händen zu geben kann auf verschiedene kompatible Lösungen zurückgreifen.

### Alternativen zu Amazon S3

Es gibt einige Amazon S3 kompatible Services die einen ähnlichen Service bieten. Diese sind allerdings meist auch US-Amerikanische Firmen und daher gleich vertrauenswürdig wie Amazon. Wer also auf Nummer sicher gehen will und seine Daten bzw. Rechner-Instanzen ganz bei sich behalten will, kommt um eine Installation von Cluster Lösungen nicht herum.

Eucalyptus

:   Eucalyptus ist eine Open-Source-Infrastruktur zur Nutzung von Cloud-Computing auf Rechner Cluster. Der Name ist ein Akronym für "Elastic Utility Computing Architecture for Linking Your Programs To Useful Systems". Die hohe kompatibilität macht diese Software-Lösung zu einer optimalen Alternative zu Amazon-Web-Services [siehe @wikieucalyptus].

Riak Cloud Storage

:   ???

### Performance

HostedFTP veröffentlichte im Jahre 2009 in einem Perfomance Report ihre Erfahrungen mit der Performance zwischen EC2 (Rechner Instancen) und S3 [siehe @hostedftp2009amazons3]. Über ein Performance Model wurde festgestellt, das die Zeit für den Download einer Datei in zwei Bereiche aufgeteilt werden kann.

Feste Transaktionszeit

:   Eine fixe Zeiteinheit, die für die bereitstellung order erstellung der Datei benötigt wird. Beeinflusst wird diese Zeit kaum, allerdings kann es aufgrund schwankender Auslastung zu Verzögerungen kommen.

Downloadzeit

:   Ist liniar abhängig zu der Dateigröße und kann aufgrund der Bandbreite schwanken.

Ausgehend von diesen Überlegungen kann davon ausgegangen werden, dass die Upload- bzw. Downloadzeit einen linearen Verlauf über die Dateigröße aufweist. Diese These wird von den Daten unterstützt. Aus dem Diagram (Abbildung \ref{performance_s3_upload}) kann die feste Transaktionszeit von ca. 140ms abgelesen werden.

![Upload Analyse zwischen EC2 und S3 [Quelle @hostedftp2009amazons3] \label{performance_s3_upload}](images/performance_s3_upload.png)

Für den Download von Dateien ensteht laut den Daten aus dem Report keine fixe Transaktionszeit. Die Zeit für den Download ist also nur von der Größe der Datei und der Bandbreite anbhängig. 

## Verteilte Dateisysteme

* <http://member.wide.ad.jp/~shima/publications/20120924-dfs-performance.pdf>

### NFS

### Ceph

### Sheepdog

### GlusterFS

### XtreemFS

### Speichergeschwindigkeit

## Datenbank gestützte Dateiverwaltungen

### MongoDB & GridFS

### Crate

## Performance

## Evaluation

[^30]: <http://aws.amazon.com/de/s3/>
[^31]: <http://docs.mongodb.org/manual/core/gridfs/>
[^32]: <http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html>
