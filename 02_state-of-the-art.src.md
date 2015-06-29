# \label{chapter_state_of_the_art}Stand der Technik

In diesem Kapitel werden moderne Anwendungen und ihre Architektur analysiert. Dazu werden zunächst die beiden Begriffe verteilte Systeme und verteilte Dateisysteme definiert. Anschließend werden vier Anwendungen beschrieben, die als Inspiration für das Projekt symCloud verwendet werden.

## \label{verteilte_systeme}Verteilte Systeme

Andrew Tanenbaum definiert den Begriff der "verteilten Systeme" in seinem Buch folgendermaßen:

> "Ein verteiltes System ist eine Menge voneinander unabhängiger
> Computer, die dem Benutzer wie ein einzelnes kohärentes
> System erscheinen"

Diese Definition beinhaltet zwei Aspekte. Der erste Aspekt besagt, dass die einzelnen Maschinen in einem verteilten System autonom sind. Der zweite Aspekt bezieht sich auf die Software, die die Systeme miteinander verbinden. Durch die Software glaubt der Benutzer, dass er es mit einem einzigen System zu tun hat [@tanenbaum2003verteilte, p. 18]. 

Eines der besten Beispiele für verteilte Systeme sind Cloud-Computing Dienste. Diese Dienste bieten verschiedenste Technologien von umfassen Rechnerleistungen, Speichern, Datenbanken bis hin zu Netzwerken an. Der Anwender kommuniziert hierbei immer nur mit einem System, allerdings verbirgt sich hinter der Oberfläche ein komplexes System aus vielen Hard- und Softwarekomponenten, welches sehr stark auf Virtualisierung setzt.

Gerade im Bereich der verteilten Dateisysteme, bietet sich die Möglichkeit, Dateien über mehrere Server zu verteilen an. Dies ermöglicht die Verbesserung von Datensicherheit, durch Replikation über verschiedene Server und steigert die Effizienz, durch paralleles Lesen der Daten. Diese Dateisysteme trennen meist die Nutzdaten von ihren Metadaten und halten diese, als Daten zu den Daten, in einer effizienten Datenbank gespeichert. Um Informationen zu einer Datei zu erhalten, wird die Datenbank nach den Informationen durchsucht und direkt an den Benutzer weitergeleitet. Dies ermöglicht schnellere Antwortzeiten, da nicht auf die Nutzdaten zugegriffen werden muss und steigert dadurch die Effizienz des Systems [@linux2013dateisystem]. Das Kapitel \ref{chapter_distibuted_fs} befasst sich genauer mit verteilten Dateisystemen.

## Cloud-Datenhaltung

Es gibt verschiedene Applikationen, die es erlauben, seine Dateien in einer Cloud-Umgebung zu verwalten. Viele dieser Applikationen sind kommerzielle Produkte, wie zum Beispiel Dropbox[^22] oder Google Drive[^23]. Andere jedoch sind frei verfügbar wie zum Beispiel ownCloud[^24], welches darüber hinaus sogar einen offenen Quellcode besitzt. Zwei dieser Applikationen sollen hier etwas genauer betrachtet werden und, soweit es möglich ist, die Speicherkonzepte analysiert. 

### Dropbox

Dropbox-Nutzer können jederzeit von ihrem Desktop aus, über das Internet,  mobile Geräte oder mit Dropbox verbundene Anwendungen auf ihre Dateien und Ordner zugreifen.

Alle diese Clients stellen Verbindungen mit sicheren Servern her, über die sie Zugriff auf Dateien haben und diese für andere Nutzer freigeben können. Wenn Dateien auf einem Client geändert werden, werden diese automatisch mit dem Server synchronisiert. Alle verknüpften Geräte aktualisieren sich automatisch. Dadurch werden Dateien, die hinzugefügt, verändert oder gelöscht werden, auf allen Clients aktualisiert bzw. gelöscht.

Der Dropbox-Service betreibt verschiedenste Dienste, die sowohl für die Handhabung und Verarbeitung von Metadaten, als auch für die Verwaltung des Blockspeichers verantwortlich sind [@dropbox2015a].

![Blockdiagramm der Dropbox Services [@dropbox2015a]\label{db_archtecture}](images/db_archtecture.png)

In der Abbildung \ref{db_archtecture} werden die einzelnen Komponenten in einem Blockdiagramm dargestellt. Wie im Kapitel \ref{verteilte_systeme} beschrieben, trennt Dropbox intern die Dateien von ihren Metadaten. Der Metadata Service speichert die Metadaten und die Informationen zu ihrem Speicherort in einer Datenbank, der Inhalt der Daten liegt jedoch in einem separaten Storage Service. Dieser Service verteilt die Daten wie ein "Load Balancer" über viele Server.

Der Storage Service ist wiederum von außen durch einen Application Service abgesichert. Die Authentifizierung erfolgt über das OAuth2 Protokoll [@dropbox2015b]. Diese Authentifizierung wird für alle Services verwendet, auch für den Metadata Service, den Processing-Servers und den Notification Service.

Der Processing- oder Application-Block dient als Zugriffspunkt zu den Daten. Eine Applikation, die auf Daten zugreifen möchte, muss sich an diesen Servern anmelden und bekommt dann Zugriff auf die angefragten Daten. Dies ermöglicht auch Drittherstellern Anwendungen zu entwickeln, die mit Daten aus der Dropbox arbeiten. Für diesen Zweck gibt es im Authentifizierungsprotokoll OAuth2 sogenannte Scopes (siehe Kapitel \ref{implementation_oauth}). Eine weitere Aufgabe, die diese Schicht erledigt, ist die Verschlüsselung der Anwendungsdaten [@dropbox2015a].

Die Nachteile von Dropbox im Bezug auf die im Kapitel \ref{specification} aufgezählten Anforderungen sind:

Closed Source

:   Der Source-Code von Dropbox ist nicht verfügbar, daher sind eigene Erweiterungen auf die API des Herstellers angewiesen.

Datensicherheit

:  Da Dropbox ausschließlich als "Software as a Service" angeboten wird und nicht auf eigenen Servern installiert werden kann, ist die Datensicherheit im Bezug auf den Schutz vor Fremdzugriff nicht gegeben.

Alles in allem ist Dropbox als Grundlage für symCloud aufgrund der fehlenden Erweiterbarkeit nicht geeignet. Dieser Umstand ist der Tatsache geschuldet, dass der Source-Code nicht frei zugänglich ist und es nicht gestattet wird die Software auf eigenen Servern zu installieren.

### ownCloud

Nach den neuesten Entwicklungen arbeitet ownCloud an einem ähnlichen Feature wie symCloud. Unter dem Namen "Remote shares" wurde in der Version sieben eine Erweiterung in den Core übernommen, mit dem es möglich sein sollte, sogenannte "Shares" mittels Link auch in einer anderen Installation einzubinden. Dies ermöglicht es, Dateien auch über die Grenzen des eigenen Servers hinweg zu teilen [@bizblokes2014ownCloud]. Jedoch ist diese Verteilung nicht in der Architektur verankert und nur über eine Systemerweiterung möglich.

Die kostenpflichtige Variante von ownCloud geht hier noch einen Schritt weiter. In Abbildung \ref{owncloud_architecture} ist dargestellt, wie ownCloud als eine Art Verbindungsschicht zwischen verschiedenen Lokalen- und Cloud-Speichersystemen dienen soll [@owncloud2015architecture, S. 1].

![ownCloud Enterprise Architektur Übersicht [@owncloud2015architecture]\label{owncloud_architecture}](images/owncloud_architecture.png)

Um die Integration in ein Unternehmen zu erleichtern, bietet ownCloud verschiedenste Dienste an. Unter anderem ist es möglich, Benutzerdaten über LDAP oder ActiveDirectory zu verwalten und damit ein Doppeltes führen der Benutzer zu vermeiden [@owncloud2015architecture, S. 2].

![Bereitstellungsszenario von ownCloud [@owncloud2015architecture]\label{owncloud_deployment}](images/owncloud_deployment.png)

Für einen produktiven Einsatz wird eine skalierbare Architektur, wie in Abbildung \ref{owncloud_deployment}, vorgeschlagen. An erster Stelle steht ein Load-Balancer, der die Last der Anfragen auf mindestens zwei Webserver verteilt. Diese Webserver sind mit einem MySQL-Cluster verbunden, in dem die User-Daten, Anwendungsdaten und Metadaten der Dateien gespeichert sind. Dieser Cluster besteht wiederum aus mindestens zwei redundanten Datenbankservern. Diese Architektur ermöglicht auch bei stark frequentierten Installationen eine horizontale Skalierbarkeit. Zusätzlich sind die Webserver mit dem File-Storage verbunden. Auch hier ist es möglich, diesen redundant bzw. skalierbar aufzubauen, um die Effizienz und Sicherheit zu gewährleisten [@owncloud2015architecture, S. 3-4].

Die Nachteile von ownCloud im Bezug auf die im Kapitel \ref{specification} aufgezählten Anforderungen sind:

Architektur

:   Die Software ist dafür ausgelegt die Anforderungen, auf einem einzigen Server zu erfüllen. Es ermöglicht zwar eine verteilte Architektur, allerdings nur, um die Last auf verschiedene Server aufzuteilen. Im Gegensatz dazu versucht symCloud die Daten zwischen verschiedenen Instanzen zu verteilen um die Zusammenarbeit zwischen Benutzern zu ermöglichen, die auf verschiedenen Servern registriert sind.

Stand der Technik

:   Aufgrund der Tatsache, dass die Entwicklung von ownCloud schon im Jahre 2010 begann und sich die Programmiersprache PHP bzw. dessen Community rasant weiterentwickelt, ist der Kern von ownCloud in einem Stil programmiert der nicht mehr dem heutigen Stand der Technik entspricht.

Obwohl ownCloud viele Anforderungen, wie zum Beispiel Versionierung oder Zugriffsberechtigungen, erfüllen kann ist das Datenmodell nicht dafür ausgelegt, Daten zu verteilen. Ein weiterer großer Nachteil ist die bereits angesprochene veraltete Codebasis, die eine Erweiterung erschwert.

## Verteilte Daten - Beispiel Diaspora

Diaspora (genauere Beschreibung in Kapitel \ref{chapter_introduction}) ist ein gutes Beispiel für Applikationen, die ihre Daten über die Grenzen eines Servers hinweg verteilen können. Diese Daten werden mithilfe von Standardisierten Protokollen über einen sicheren Transportlayer versendet. Für diese Kommunikation zwischen den Diaspora Instanzen (Pods genannt) wird ein eigenes Protokoll namens "Federation protocol" verwendet. Es ist eine Kombination aus verschiedenen Standards, wie zum Beispiel Webfinger, HTTP und XML [@diaspora2014protocol]. In folgenden Situationen wird dieses Protokoll verwendet:

* Um Benutzerinformationen zu finden, die auf anderen Servern gespeichert sind.
* Erstellte Informationen an Benutzer zu versenden, mit denen sie geteilt wurden.

Diaspora verwendet das Webfinger Protokoll, um zwischen den Servern zu kommunizieren. Dieses Protokoll wird verwendet, um Informationen über Benutzer oder anderen Objekte abfragen zu können. Identifiziert werden diese Objekte über eine eindeutige (TODO; URI oder URL danach schreibst du nur noch von URL) URI. Es verwendet den HTTPS-Standard als Transportlayer für eine sichere Verbindung. Als Format für die Antworten wird JSON verwendet [@jones2013webfinger, K. 1].

 __Beispiel [@diaspora2014protocol]:__

Alice versucht mit Bob in Kontakt zu treten. Um die nötigen URLs für die weitere Kommunikation zwischen den Servern zu ermitteln führt der Pod von Alice einen Webfinger lookup auf den Pod von Bob aus. Der Response enthält einen ähnlichen Inhalt, wie in Listing \ref{diaspora_host_meta} dargestellt. Dieser Response wird LRDD ("Link-based Resource Descriptor Document"[^20]) genannt und enthält die URL um die Daten von dem Server abzufragen.

```{caption="Host-Meta Inhalt von Bob\label{diaspora_host_meta}" .xml}
<Link rel="lrdd"
      template="https://bob.diaspora.example.com/?q={uri}"
      type="application/xrd+xml" />
```

Um Informationen über den Benutzer Bob zu erhalten, führt der Pod von Alice einen Request auf die angeführte URL mit dem Benutzernamen von Bob aus. Dieser Response enthält alle relevanten Informationen über Bob und weitere Links für nähere Details oder Aktionen, die auf den gesuchten BenutzerInnen ausgeführt werden können. Der Response kann bei nicht eindeutigem Suchbegriff auch mehrere Entitäten enthalten.

Über dieses Protokoll lassen sich die Pods von Alice und Bob verbinden. Die Daten die dabei verteilt werden, werden auf jedem Pod in einer Relationalen Datenbank abgelegt [@diaspora2015installation].

Diaspora ist ein gutes Beispiel, wie Daten in einem Dezentralen Netzwerk verteilt werden können. Da allerdings das gesamte Konzept dafür ausgelegt ist, Benutzer miteinander kommunizieren zu lassen, ist die Erweiterung auf ein Dateimodell sehr schwierig. Jedoch könnte eine Kommunikation zwischen Diaspora und symCloud, durch die Abstraktion der API des Webfinger Protokoll, ermöglicht werden (siehe Kapitel \ref{chapter_outlook_protocolls}).

## \label{chapter_distributed_datamodel}Verteilte Datenmodelle - Beispiel GIT

GIT[^25] ist eine verteilte Versionsverwaltung, welche ursprünglich entwickelt wurde, um den Source-Code des Linux Kernels zu verwalten.

Die Software ist im Grunde eine Key-Value Datenbank. Die Objekte werden in Form einer Datei abgespeichert wobei der Name den Key des Objektes enthält. In der Datei wird der jeweilige der Inhalt des Objekts abgelegt. Dieser Key wird ermittelt, indem ein sogenannter SHA berechnet wird. Der SHA ist ein mittels "Secure-Hash-Algorithm" berechneter Hashwert der Daten [@chacon2009pro, K. 9.2]. Das Listing \ref{git_calc_hash} zeigt, wie ein SHA in einem Unix-Terminal berechnet werden kann [@keepers2012git].

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

Die Objekte in GIT sind immutable, das bedeutet, dass sie nicht veränderbar sind. Ein einmal erstelltes Objekt wird nicht mehr aus der Datenbank gelöscht oder geändert. Bei der Änderung eines Objektes wird ein neues Objekt mit einem neuen Key erstellt [@keepers2012git].

__Objekt Typen__

GIT kennt folgende Typen:

BLOB

:   Ein BLOB repräsentiert eine einzelne Datei in GIT. Der Inhalt der Datei wird in einem Objekt gespeichert. Bei Änderungen ist GIT auch in der Lage, inkrementelle DELTA-Dateien zu speichern. Beim Wiederherstellen werden diese DELTAs der Reihe nach aufgelöst. Ein BLOB besitzt für sich gesehen keinen Namen [@chacon2009pro, K. 9.2].

TREE

:   Der TREE beschreibt einen Ordner im Repository. Ein TREE enthält Referenzen  auf andere TREE bzw. BLOB Objekte und definiert damit eine Ordnerstruktur. Wie auch der BLOB besitzt ein TREE für sich gesehen keinen Namen. (TODO: da steht kein besitzt keine Name und dann DIESER NAME…) Dieser Name wird zu jeder Referenz auf einen TREE oder auf einen BLOB gespeichert (siehe Listing \ref{git_tree_listing}) [@chacon2009pro, K. 9.2].

```{caption="Inhalt eines TREE Objektes\label{git_tree_listing}"}
$ git cat-file -p 601a62b205bb497d75a231ec00787f5b2d42c5fc
040000 tree f4f5562f575ac208eac980a0cd1c46d874e37298  images
040000 tree 61e121cc69e523a68212227f5642fe9b692f5639  diagrams
100644 blob d4ada98ad3542643a3c6bb8d25ccce0bc85614fb  00_title.src.md
100644 blob 5c14fdfdebc8a52b74b529689714a1a6d7d2f4d1  01_introduction.src.md
...
```

COMMIT

:   Der COMMIT enthält eine Referenz auf den TREE des Stammverzeichnisses zu einem bestimmten Zeitpunkt.

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

  : Eigenschaften eines COMMIT [@chacon2009pro, K. 9.2]\label{commit_properties}

__Anmerkungen (zu der Tabelle \ref{commit_properties}):__

* Ein COMMIT kann mehrere Vorgänger haben, wenn sie zusammengeführt werden. (TODO: Verstehe ich gar nicht)Dieser Mechanismus würde zum Beispiel bei einem MERGE verwendet werden, um die beiden Vorgänger zu speichern.
* Autor und Ersteller des COMMITs können sich unterscheiden: Wenn zum Beispiel ein Benutzer einen PATCH erstellt, ist dieser der Autor und damit der Verantwortliche für die Änderungen. Der Benutzer, der den Patch nun auflöst und den `git commit` Befehl ausführt, ist der Ersteller bzw. der Committer.

REFERENCE

:   ist ein Verweis auf ein bestimmtes COMMIT-Objekt. Diese Referenzen sind die Grundlage für das Branching-Modell von GIT [@chacon2015git].

![Beispiel eines Repositories\label{git_data_model} [@chacon2015git]](images/git-data-model-example.png)

In der Abbildung \ref{git_data_model} wird ein einfaches Beispiel für ein Repository visualisiert. Die Ordnerstruktur die dieses Beispiel enthält, ist im Listing \ref{git_data_model_structure} dargestellt.

```{caption="Ordernstruktur zum Repository Beispiel\label{git_data_model_structure}"}
|-- README (Datei)
|-- lib (Ordner)
    |-- inc (Ordner)
    |   |-- tricks.rb (Datei)
    |-- mylib.rb (Datei)
```

Der COMMIT (98ca9..) enthält eine Referenz auf den ROOT-TREE (0de24..). Dieser TREE enthält weitere Referenzen zu einem TREE-Objekt (10af9..) mit dem Namen `lib` und dem BLOB-Objekt (e8455..) mit dem Namen README. Diese Struktur wird bis zum TREE-Objekt (b70f8..) fortgesetzt, welches eine Referenz auf den BLOB (0ad1a..) mit dem Namen tricks.rb enthält. Das Beispiel visualisiert, wie Komplexe Ordnerstrukturen in GIT verwaltet und gespeichert werden können.

Die Nachteile von GIT im Bezug auf die im Kapitel \ref{specification} aufgezählten Anforderungen sind:

Architektur

:   Die Architektur von GIT ist im Grunde ein ausgezeichnetes Beispiel für die Verteilung der Daten. Auch das Datenmodell ist optimal für die Verteilung ausgelegt. Jedoch besitzt GIT keine Mechanismen um die Verteilung zu automatisieren. Ein weiteres Problem ist die fehlende Möglichkeit Zugriffsberechtigungen festzulegen.

Da die Anwendung GIT für die Verwendung als Datenspeicher, aufgrund der Fehlenden Verteilungsmechanismen, für das Projekt ungeeignet ist, jodoch viele der Anforderungen erfüllt, wird dieses Datenmodell als Grundlage für symCloud herangezogen, siehe Kapitel \ref{chapter_concept_datamodel}. Außerdem wird die Idee der Key-Value Datenbank bei der Konzeption der Datenbank im Kapitel \ref{chapter_concept_database} aufgegriffen.

(TODO: Alternativer Absatz
Aufgrund der Fehlenden Verteilungsmechanismen ist die Anwendung GIT für die Verwendung als Datenspeicher für das Projekt ungeeignet. Da es jedoch viele der Anforderungen erfüllt, wird dieses Datenmodell als Grundlage für symCloud herangezogen, siehe dazu Kapitel \ref{chapter_concept_datamodel}. Außerdem wird die Idee der Key-Value Datenbank bei der Konzeption der Datenbank im Kapitel \ref{chapter_concept_database} aufgegriffen.)



## Zusammenfassung

In diesem Kapitel wurden zuerst die Begriffe verteilte Systeme und verteilte Dateisysteme definiert. Diese Begriffe werden in den folgenden Kapiteln in dem hier beschriebenen Kontext verwendet. Anschließend wurden aktuelle Systeme anhand der Kriterien betrachtet, die für symCloud von Interesse sind. Jedes dieser Systeme bietet Ansätze, die bei der Konzeption von symCloud berücksichtigt werden.

Dropbox

:   Kommerzielles Produkt mit gewünschtem Funktionsumfang hinsichtlich der Dateisynchronisierung und Benutzerinteraktion. Allerdings im Bezug auf das Projekt symCloud, aufgrund des nicht verfügbaren Quellcodes, nur als Inspirationsquelle verwendbar.

ownCloud

:   Dieses quelloffene Projekt ist eine gute alternative zu kommerziellen Lösungen wie zum Beispiel Dropbox. Es ist eine der Inspirationsquellen für symCloud, jedoch aufgrund des überholten Programmierstils und der fehlenden verteilten Architektur, nicht als Grundlage für symCloud verwendbar.

Diaspora

:   Das quelloffene Social-Media Projekt ist ein Pionier in Sachen verteilter Architektur. Das Protokoll, welches von Diaspora eingesetzt wird, dient als weitere Inspiration für die Entwicklung von symCloud.

GIT

:   Aufgrund des Datenmodells von GIT ist diese Versionsverwaltung für die verteilte Anwendung optimal ausgerüstet. Daher wird es als Grundlage für symCloud dienen. Es ermöglicht den verbundenen Servern (Clients) eine schnelle und einfache Synchronisation der Daten.

Jedes dieser vier Systeme bieten Ansätze, die für die Entwicklung von symCloud relevant sind. 

[^20]: <https://tools.ietf.org/html/rfc6415#section-6.3>
[^21]: <https://tools.ietf.org/html/rfc6415#section-2>
[^22]: <https://www.dropbox.com>
[^23]: <https://www.google.com/intl/de_at/drive>
[^24]: <https://owncloud.org/>
[^25]: <http://git-scm.com/>
