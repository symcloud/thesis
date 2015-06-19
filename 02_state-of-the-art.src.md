# \label{chapter_state_of_the_art}Stand der Technik

In diesem Kapitel werden moderne Anwendungen und ihre Architektur analysiert. Dazu werden zunächst die Begriffe verteilte Systeme und verteilte Dateisysteme definiert. Anschließend werden drei Anwendungen beschrieben, die als Inspiration für das Projekt Symcloud verwendet werden.

## \label{verteilte_systeme}Verteilte Systeme

Andrew Tanenbaum definiert verteilte Systeme in seinem Buch folgendermaßen:

> "Ein verteiltes System ist eine Menge voneinander unabhängiger
> Computer, die dem Benutzer wie ein einzelnes kohärentes
> System erscheinen"

Diese Definition beinhaltet zwei Aspekte. Der eine Aspekt besagt, dass die einzelnen Maschinen in einem verteilten System autonom sind. Der zweite Aspekt bezieht sich auf die Software, die die Systeme miteinander verbinden. Durch die Software glaubt der Benutzer, dass er es mit einem einzigen System zu tun hat [@tanenbaum2003verteilte, p. 18]. 

Eines der besten Beispiele für verteilte Systeme sind Cloud-Computing Dienste. Diese Dienste bieten verschiedenste Technologien an und umfassen Rechnerleistungen, Speicher, Datenbanken und Netzwerke. Der Anwender kommuniziert hierbei immer nur mit einem System, allerdings verbirgt sich hinter diesen Anfragen ein komplexes System aus vielen Hard- und Softwarekomponenten, welches sehr stark auf Virtualisierung setzt.

Gerade im Bereich der verteilten Dateisysteme, bietet sich die Möglichkeit, Dateien über mehrere Server zu verteilen. Dies ermöglicht eine Verbesserung von Datensicherheit, durch Replikation über verschiedene Server und Steigerung der Effizienz, durch paralleles Lesen der Daten. Diese Dateisysteme trennen meist die Nutzdaten von ihren Metadaten und halten diese, als Daten zu den Daten, in einer effizienten Datenbank gespeichert. Um zum Beispiel Informationen zu einer Datei zu erhalten, wird die Datenbank nach den Informationen durchsucht und direkt an den Benutzer weitergeleitet. Dies ermöglicht schnellere Antwortzeiten, da nicht auf die Nutzdaten zugegriffen werden muss und steigert die Effizienz der Anfragen [@linux2013dateisystem]. Das Kapitel \ref{chapter_distibuted_fs} befasst sich genauer mit verteilten Dateisystemen.

## Cloud-Datenhaltung

Es gibt verschiedene Applikationen, die es erlauben, seine Dateien in einer Cloud-Umgebung zu verwalten. Viele dieser Applikationen sind Kommerzielle Produkte, wie Dropbox[^22] oder Google Drive[^23]. Andere jedoch sind frei verfügbar und wie zum Beispiel ownCloud[^24] sogar Open-Source. Zwei dieser Applikationen werden hier etwas genauer betrachtet und soweit es möglich ist die Speicherkonzepte analysiert. 

### Dropbox

Dropbox-Nutzer können jederzeit von ihrem Desktop aus, über das Internet,  mobile Geräte oder mit Dropbox verbundene Anwendungen auf Dateien und Ordner zugreifen.

Alle diese Clients stellen Verbindungen mit sicheren Servern her, über die sie Zugriff auf Dateien haben und Dateien für andere Nutzer freigeben können. Wenn Daten auf einem Client geändert werden, werden diese automatisch mit dem Server synchronisiert. Verknüpfte Geräte aktualisieren sich automatisch. Dadurch werden Dateien, die hinzugefügt, verändert oder gelöscht werden, auf allen Clients aktualisiert bzw. gelöscht.

Der Dropbox-Service betreibt verschiedenste Dienste, die sowohl für die Handhabung und Verarbeitung von Metadaten, als auch für die Verwaltung des Blockspeichers verantwortlich sind [@dropbox2015a].

![Blockdiagramm der Dropbox Services [@dropbox2015a]\label{db_archtecture}](images/db_archtecture.png)

In der Abbildung \ref{db_archtecture} werden die einzelnen Komponenten in einem Blockdiagramm dargestellt. Wie im Kapitel \ref{verteilte_systeme} beschrieben, trennt Dropbox intern die Dateien von ihren Metadaten. Der Metadata Service speichert die Metadaten und Informationen zu ihrem Speicherort in einer Datenbank, aber der Inhalt der Daten liegt in einem separaten Storage Service. Dieser Service verteilt die Daten wie ein "Load Balancer" über viele Server.

Der Storage Service ist wiederum von außen durch einen Application Service abgesichert. Die Authentifizierung erfolgt über das OAuth2 Protokoll [@dropbox2015b]. Diese Authentifizierung wird für alle Services verwendet, auch für den Metadata Service, Processing-Servers und den Notification Service.

Der Processing- oder Application-Block dient als Zugriffspunkt zu den Daten. Eine Applikation, die auf Daten zugreifen möchte, muss sich an diesen Servern anmelden und bekommt dann Zugriff auf die angefragten Daten. Dies ermöglicht auch Dritthersteller Anwendungen zu entwickeln, die mit Daten aus der Dropbox arbeiten. Für diesen Zweck gibt es im Authentifizierungsprotokoll OAuth2 sogenannte Scopes (siehe Kapitel \ref{implementation_oauth}). Eine weitere Aufgabe, die diese Schicht erledigt, ist die Verschlüsselung der Anwendungsdaten [@dropbox2015a].

Die Nachteile von Dropbox im Bezug auf die im Kapitel \ref{specification} aufgezählten Anforderungen sind:

Closed Source

:   Der Source-Code von Dropbox ist nicht verfügbar, daher sind eigene Erweiterungen auf die API des Herstellers angewiesen.

Datensicherheit

:  Da Dropbox ausschließlich als "Software as a Service" angeboten wird und nicht auf eigenen Servern installiert werden kann, ist die Datensicherheit im Bezug auf den Schutz vor Fremdzugriff nicht gegeben.

Alles in allem ist Dropbox als Grundlage für symCloud aufgrund der fehlenden Erweiterbarkeit nicht geeignet. Dieser Umstand ist der Tatsache geschuldet, dass der Source-Code nicht frei zugänglich ist und es nicht gestattet wird die Software auf eigenen Servern zu verwenden.

### ownCloud

Nach den neuesten Entwicklungen arbeitet ownCloud an einem ähnlichen Feature wie Symcloud. Unter dem Namen "Remote shares" wurde in der Version 7 eine Erweiterung in den Core übernommen, mit dem es möglich sein soll, sogenannte "Shares" mittels einem Link auch in einer anderen Installation einzubinden. Dies ermöglicht es, Dateien auch über die Grenzen des eigenen Servers hinweg zu teilen [@bizblokes2015a].

Die kostenpflichtige Variante von ownCloud geht hier noch einen Schritt weiter. In Abbildung \ref{owncloud_architecture} ist abgebildet, wie ownCloud als eine Art Verbindungsschicht zwischen verschiedenen Lokalen- und Cloud-Speichersystemen dienen soll [@owncloud2015architecture, S. 1].

![ownCloud Enterprise Architektur Übersicht [@owncloud2015architecture]\label{owncloud_architecture}](images/owncloud_architecture.png)

Um die Integration in ein Unternehmen zu erleichtern, bietet es verschiedenste Services an. Unter anderem ist es möglich, Benutzerdaten über LDAP oder ActiveDirectory zu verwalten und damit ein doppeltes Verwalten der Benutzer zu vermeiden [@owncloud2015architecture, S. 2].

![Bereitstellungsszenario von ownCloud [@owncloud2015architecture]\label{owncloud_deployment}](images/owncloud_deployment.png)

Für einen produktiven Einsatz wird eine skalierbare Architektur, wie in Abbildung \ref{owncloud_deployment}, vorgeschlagen. An erster Stelle steht ein Load-Balancer, der die Last der Anfragen an mindestens zwei Webserver verteilt. Diese Webserver sind mit einem MySQL-Cluster verbunden, in dem die User-Daten, Anwendungsdaten und Metadaten der Dateien gespeichert sind. Dieser Cluster besteht wiederum aus mindestens zwei redundanten Datenbankservern. Dies ermöglicht auch bei stark frequentierten Installationen eine horizontale Skalierbarkeit. Zusätzlich sind die Webserver mit dem File-Storage verbunden. Auch hier ist es möglich, diesen redundant bzw. skalierbar aufzubauen, um die Effizienz und Sicherheit zu erweitern [@owncloud2015architecture, S. 3-4].

Die Nachteile von ownCloud im Bezug auf die im Kapitel \ref{specification} aufgezählten Anforderungen sind:

Architektur

:   Die Software ist dafür ausgelegt, um die Anforderungen, auf einem einzigen Server zu erfüllen. Es ermöglicht zwar eine verteilte Architektur, allerdings nur, um die Last auf verschiedene Server zu verteilen. Im Gegensatz dazu versucht symCloud die Daten zwischen verschiedenen Instanzen zu verteilen um die Zusammenarbeit zwischen Benutzern zu ermöglichen, die auf verschiedenen Servern registriert sind.

Moderne Programmierung

:   Aufgrund der Tatsache, dass ownCloud schon im Jahre 2010 und sich die Programmiersprache PHP und die Community rasant weiterentwickelt, ist der Kern von ownCloud in einem überholten Stil programmiert.

Obwohl ownCloud viele Anforderungen, wie zum Beispiel Versionierung oder Zugriffsberechtigungen, erfüllen kann ist das Datenmodell nicht ausgelegt, um die Daten zu verteilen. Ein weiterer großer Nachteil ist die veraltete Codebasis.

## Verteilte Daten - Beispiel Diaspora

Diaspora ist ein gutes Beispiel für Applikationen, die ihre Daten über die Grenzen eines Servers hinweg verteilt. Diese Daten werden mithilfe von Standardisierten Protokollen über einen sicheren Transport-Layer versendet. Für diese Kommunikation zwischen den Diaspora Instanzen (Pods genannt) wird ein eigenes Protokoll namens "Federation protocol" verwendet. Es ist eine Kombination aus verschiedenen Standards, wie zum Beispiel Webfinger, HTTP und XML [@diaspora2015b]. In folgenden Situationen wird dieses Protokoll verwendet:

* Um Benutzerinformationen zu finden, die auf anderen Servern registriert sind.
* Erstellte Informationen an Benutzer zu versenden, mit denen sie geteilt wurden.

Diaspora verwendet das Webfinger Protokoll, um zwischen den Servern zu kommunizieren. Das Webfinger Protokoll wird verwendet, um Informationen über Benutzer oder anderen Objekte abfragen zu können. Identifiziert werden diese Objekte über eine eindeutige URI. Es verwendet den HTTP-Standard als Transport-Layer über eine sichere Verbindung. Als Format für die Antworten wird JSON verwendet [@jones2013webfinger, Kapitel 1].

 __Beispiel [@diaspora2015b]:__

Alice (alice@alice.diaspora.example.com) versucht mit Bob `bob@bob.diaspora.example.com` in Kontakt zu treten. Zuerst führt der Pod von Alice `alice.diaspora.example.com` einen Webfinger lookup auf den Pod von Bob (bob.diaspora.example.com) aus. Dazu führt Alice eine Anfrage auf die URL `https://bob.diaspora.example.com/.well-known/host-meta`[^21] (siehe Listing \ref{diaspora_host_meta}) aus und erhält einen Link zum LRDD ("Link-based Resource Descriptor Document"[^20]).

```{caption="Host-Meta Inhalt von Bob\label{diaspora_host_meta}" .xml}
<Link rel="lrdd"
      template="https://bob.diaspora.example.com/?q={uri}"
      type="application/xrd+xml" />
```

Unter diesem Link können Objekte auf dem Server von Bob gesucht werden. Als nächster Schritt führt der Server von Alice einen GET-Request auf den LRDD mit den kompletten Benutzernamen von Bob als Query-String aus. Der Response retourniert folgendes Objekt:

```{caption="LRDD Inhalt von Bob\label{diaspora_lrdd}" .xml}
<?xml version="1.0" encoding="UTF-8"?>
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Subject>acct:bob@bob.diaspora.example.com</Subject>
  <Alias>"http://bob.diaspora.example.com/"</Alias>
  <Link rel="http://microformats.org/profile/hcard" 
        type="text/html"
        href="http://bob.diaspora.example.com/hcard/users/((guid))"/>
  <Link rel="http://joindiaspora.com/seed_location" 
        type="text/html" href="http://bob.diaspora.example.com/"/>
  <Link rel="http://joindiaspora.com/guid" type="text/html"
        href="((guid))"/>
  <Link rel="http://schemas.google.com/g/2010#updates-from"
        type="application/atom+xml"
        href="http://bob.diaspora.example.com/public/bob.atom"/>
  <Link rel="diaspora-public-key" type="RSA"
        href="((base64-encoded rsa public key))"/>
</XRD>
```

Das Objekt enthält die Links zu weiteren, in Diaspora gespeicherten, Informationen des Benutzers, welcher im Knoten "Subject" angeführt wird.

Dieses Beispiel zeigt, wie Diaspora auf einfachste Weise Daten auf einem sicheren Kanal austauschen kann.

## \label{chapter_distributed_datamodel}Verteilte Datenmodelle - Beispiel GIT

GIT[^25] ist eine verteilte Versionsverwaltung, welche ursprünglich entwickelt wurde, um den Source-Code des Linux Kernels zu verwalten.

Die Software ist im Grunde eine Key-Value Datenbank. Es werden Objekte in Form einer Datei abgespeichert, in der jeweils der Inhalt des Objekts abgespeichert wird, wobei der Name der Datei den Key des Objektes enthält. Dieser Key wird berechnet, indem ein sogenannter SHA berechnet wird. Der SHA ist ein mittels "Secure-Hash-Algorithm" berechneter Hashwert der Daten [@chacon2009pro, Kapitel 9.2]. Das Listing \ref{git_calc_hash} zeigt, wie ein SHA in einem Unix-Terminal berechnet werden kann [@keepers2012git].

```{caption="Berechnung des SHA eines Objektes\label{git_calc_hash}"}
$ OBJECT='blob 46\0{"name": "Johannes Wachter", \
  "job": "Web-Developer"}'
$ echo -e $OBJECT | shasum
6c01d1dec5cf5221e86600baf77f011ed469b8fe -
```

Im Listing \ref{git_create_object_blob} wird ein GIT-Objekt vom Typ BLOB erstellt und in den "objects" Ordner geschrieben. 

```{caption="Erzeugung eines GIT-BLOB\label{git_create_object_blob}"}
$ git init
$ OBJECT='blob 46\0{"name": "Johannes Wachter", \
  "job": "Web-Developer"}'
$ echo -e $OBJECT | git hash-object -w --stdin
6c01d1dec5cf5221e86600baf77f011ed469b8fe
$ find .git/objects -type f
    .git/objects/6c/01d1dec5cf5221e86600baf77f011ed469b8fe
```

Die Objekte in GIT sind immutable, was soviel Bedeutet, dass sie nicht veränderbar sind. Ein einmal erstelltes Objekt wird nicht mehr aus der Datenbank gelöscht oder geändert. Bei der Änderung eines Objektes wird ein neues Objekt mit einem neuen Key erstellt [@keepers2012git].

__Objekt Typen__

GIT kennt folgende Typen:

BLOB

:   Ein BLOB repräsentiert eine einzelne Datei in GIT. Der Inhalt der Datei wird in einem Objekt gespeichert. Bei Änderungen ist GIT auch in der Lage, inkrementelle DELTA-Dateien zu speichern. Beim Wiederherstellen werden diese DELTAs der Reihe nach aufgelöst. Ein BLOB besitzt für sich gesehen keinen Namen [@chacon2009pro, Kapitel 9.2].

TREE

:   Der TREE beschreibt einen Ordner im Repository. Ein TREE enthält Referenzen  auf andere TREE bzw. BLOB Objekte und definiert damit eine Ordnerstruktur. Wie auch der BLOB besitzt ein TREE für sich keinen Namen. Dieser Name wird zu jeder Referenz auf einen TREE oder auf einen BLOB gespeichert (siehe Listing \ref{git_tree_listing}) [@chacon2009pro, Kapitel 9.2].

```{caption="Inhalt eines TREE Objektes\label{git_tree_listing}"}
$ git cat-file -p 601a62b205bb497d75a231ec00787f5b2d42c5fc
040000 tree f4f5562f575ac208eac980a0cd1c46d874e37298  images
040000 tree 61e121cc69e523a68212227f5642fe9b692f5639  diagrams
100644 blob d4ada98ad3542643a3c6bb8d25ccce0bc85614fb  00_title.src.md
100644 blob 5c14fdfdebc8a52b74b529689714a1a6d7d2f4d1  01_introduction.src.md
...
```

COMMIT

:   Der COMMIT enthält einen den ROOT-TREE des Repositories zu einem bestimmten Zeitpunkt.

```{caption="Inhalt eines COMMIT Objektes\label{git_commit_listing}"}
$ git show -s --pretty=raw 6031a1aa
commit 6031a1aa3ea39bbf92a858f47ba6bc87a76b07e8
tree 601a62b205bb497d75a231ec00787f5b2d42c5fc
parent 8982aa338637e5654f7f778eedf844c8be8e2aa3
author Johannes <johannes.wachter@example.at> 1429190646 +0200
committer Johannes <johannes.wachter@example.at> 1429190646 +0200

    added short description gridfs and xtreemfs
```

Ein COMMIT Objekt enthält folgende Werte (siehe Listing \ref{git_commit_listing}):

| Zeile | Name | Beschreibung |
|------|-----|-----|
| 2 | commit | SHA des Objektes |
| 3 | tree | TREE-SHA des Stammverzeichnisses |
| 4 | parent(s) | Ein oder mehrere Vorgänger |
| 5 | author | Verantwortlicher für die Änderungen |
| 6 | committer | Ersteller des COMMITs |
| 8 | comment | Beschreibung des COMMITs |

  : Eigenschaften eines COMMIT [@chacon2009pro, Kapitel 9.2]\label{commit_properties}

__Anmerkungen (zu der Tabelle \ref{commit_properties}):__

* Ein COMMIT kann mehrere Vorgänger haben, wenn sie zusammengeführt werden. Zum Beispiel würde dieser Mechanismus bei einem MERGE verwendet werden, um die beiden Vorgänger zu speichern.
* Autor und Ersteller des COMMITs können sich unterscheiden: Wenn zum Beispiel ein Benutzer einen PATCH erstellt, ist er der Verantwortliche für die Änderungen und damit der Autor. Der Benutzer, der den Patch nun auflöst und den `git commit` Befehl ausführt, ist der Ersteller bzw. der Committer.

REFERENCE

:   ist ein Verweis auf ein bestimmtes COMMIT-Objekt. Diese Referenzen sind die Grundlage für das Branching-Modell von GIT [@chacon2015git].

![Beispiel eines Repositories\label{git_data_model} [@chacon2015git]](images/git-data-model-example.png)

In der Abbildung \ref{git_data_model} wird ein kurzes Beispiel für ein Repository visualisiert. Die Ordnerstruktur, die dieses Beispiel enthält, ist im Listing \ref{git_data_model_structure}

```{caption="Ordernstruktur zum Repository Beispiel\label{git_data_model_structure}"}
|-- README
|-- lib
    |-- inc
    |   |-- tricks.rb
    |-- mylib.rb
```

Wobei `README`, `tricks.rb` und `mylib.rb` Dateien und die beiden anderen `lib` und `lib/inc` Ordner sind. Der COMMIT enthält eine Referenz auf den ROOT-TREE, der wiederum auf den ein TREE-Objekt mit dem Namen `lib`, welcher schlussendlich eine Referenz auf das TREE-Objekt mit dem Namen `inc` enthält. Jeder dieser drei TREE-Objekte enthält jeweils eine Referenz auf einen BLOB mit den jeweiligen Namen der Datei.

Die Nachteile von GIT im Bezug auf die im Kapitel \ref{specification} aufgezählten Anforderungen sind:

Architektur

:   Die Architektur von GIT ist im Grunde ein ausgezeichnetes Beispiel für die Verteilung der Daten. Auch das Datenmodell ist optimal für die Verteilung ausgelegt. Jedoch besitzt GIT keine Mechanismen um die Verteilung zu Automatisieren. Ein weiteres Problem, dass bei der Verwendung von GIT entstehen würde, ist die fehlende Möglichkeit Zugriffsberechtigungen festzulegen.

Da die Anwendung GIT für die Verwendung als Datenspeicher, aufgrund der Fehlenden Verteilungsmechanismen, für das Projekt ungeeignet ist, aber das Datenmodell die meisten der Anforderungen erfüllen würde, wird dieses Datenmodell, in Kapitel \ref{chapter_concept_datamodel}, als Grundlage für das Datenmodell von symCloud herangezogen. 

## Zusammenfassung

In diesem Kapitel wurden zuerst die Begriffe verteilte Systeme und verteilte Dateisysteme definiert. Diese Begriffe werden in den folgenden Kapiteln in dem hier beschriebenen Kontext verwendet. Anschließend wurden aktuelle Systeme anhand der Kriterien betrachtet, die für symCloud von Interesse sind. Jedes dieser Systeme bietet Ansätze, die bei der Konzeption von symCloud berücksichtigt werden kann.

[^20]: <https://tools.ietf.org/html/rfc6415#section-6.3>
[^21]: <https://tools.ietf.org/html/rfc6415#section-2>
[^22]: <https://www.dropbox.com>
[^23]: <https://www.google.com/intl/de_at/drive>
[^24]: <https://owncloud.org/>
[^25]: <http://git-scm.com/>
