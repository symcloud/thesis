# Stand der Technik

In diesem Kapitel werden moderne Anwendungen und ihre Architektur analysiert.

__TODO bessere Einleitung (=__

## \label{verteilte_systeme}Verteilte Systeme

Andrew Tannenbaum definiert "verteilte Systeme" in seinem Buch folgendermaßen:

	"Ein verteiltes System ist eine Menge voneinander unabhängiger
	Computer, die dem Benutzer wie ein einzelnes kohärentes
	System erscheinen"

Diese Definition beinhaltet zwei Aspekte. Der eine Aspekt besagt, dass die einzelnen Maschinen in einem verteilten System autonom sind. Der zweite Aspekt bezieht sich auf die Software, die die Systeme miteinander verbinden. Durch die Software glaubt der Benutzer, dass er es mit einem einzigen System zu tun hat [@tanenbaum2003verteilte, p. 18]. 

Eines der besten Beispiele für verteilte Systeme sind Cloud-Computing Dienste. Diese Dienste bieten verschiedenste Technologien an. Sie umfassen Rechnerleistung, Speicher, Datenbanken und Netzwerke. Der Anwender kommuniziert hierbei immer nur mit einem System, allerdings verbirgt sich hinter diesen Anfragen ein komplexes System aus vielen Hard- und Softwarekomponenten, das sehr stark auf Virtualisierung setzt.

Gerade im Bereich der verteilten Dateisysteme, bietet sich die Möglichkeit, Dateien über mehrere Server zu verteilen. Dies ermöglicht eine Verbesserung von Datensicherheit, durch Replikation über verschiedene Server und Steigerung der Effizienz, durch paralleles Lesen der Daten. Diese Dateisysteme trennen meist die Nutzdaten von ihren Metadaten und halten diese, als Daten zu den Daten, in einer effizienten Datenbank gespeichert. Um zum Beispiel Informationen zu einer Datei zu erhalten, wird die Datenbank nach den Informationen durchsucht und direkt an den Benutzer weitergeleitet. Dies ermöglicht schnellere Antwortzeiten, da nicht auf die Nutzdaten zugegriffen werden muss. Dies steigert sehr stark die Effizienz der Anfrage [@linux2013dateisystem]. Das Kapitel \ref{chapter_distibuted_fs} befasst sich genauer mit verteilten Dateisystemen.

## Dropbox

Dropbox-Nutzer können jederzeit von ihrem Desktop aus, über das Internet,  mobile Geräte oder mit Dropbox verbundene Anwendungen auf Dateien und Ordner zugreifen.

Alle diese Clients stellen Verbindungen mit sicheren Servern her, über die sie Zugriff auf Dateien haben und Dateien für andere Nutzer freigeben können. Wenn Daten auf einem Client geändert werden, werden diese automatisch mit dem Server synchronisiert. Verknüpfte Geräte aktualisieren sich automatisch. Dadurch werden Dateien, die hinzugefügt, verändert oder gelöscht werden, auf allen Clients aktualisiert bzw. gelöscht.

Der Dropbox-Service betreibt verschiedenste Dienste, die sowohl für die Handhabung und Verarbeitung von Metadaten, als auch für die Verwaltung des Blockspeichers verantwortlich sind. [@dropbox2015a]

![Blockdiagramm der Dropbox Services [@dropbox2015a]\label{db_archtecture}](images/db_archtecture.png)

In der Abbildung \ref{db_archtecture} werden die einzelnen Komponenten in einem Blockdiagramm dargestellt. Wie im Kapitel \ref{verteilte_systeme} beschrieben, trennt Dropbox intern die Dateien von ihren Metadaten. Der Metadata Service speichert die Metadaten und Informationen zu ihrem Speicherort in einer Datenbank, aber der Inhalt der Daten liegt in einem separaten Storage Service. Dieser Service verteilt die Daten wie ein "Load Balancer" über viele Server.

Der Storage Service ist wiederum von außen durch einen Application Service abgesichert. Die Authentifizierung erfolgt über das OAuth2 Protokoll [@dropbox2015b]. Diese Authentifizierung wird für alle Services verwendet, auch für den Metadata Service, Processing-Servers und den Notification Service.

Der Processing- oder Application-Block dient als Zugriffspunkt zu den Daten. Eine Applikation, die auf Daten zugreifen möchte, muss sich an diesen Servern anmelden und bekommt dann Zugriff auf die angefragten Daten. Dies ermöglicht auch Dritt-Hersteller Anwendungen zu entwickeln, die mit Daten aus der Dropbox arbeiten. Für dieses Zweck gibt es im Authentifizierungsprotokoll OAuth2 sogenannte Scopes (siehe Kapitel \ref{implementation_oauth}). Es ermöglicht Anwendungen den Zugriff Teilbereiche der API zu autorisieren. Eine weitere Aufgabe, die diese Schicht erledigt, ist die Verschlüsselung der Anwendungsdaten [@dropbox2015a].

## ownCloud

Nach den neuesten Entwicklungen arbeitet ownCloud an einem ähnlichen Feature wie Symcloud. Unter dem Namen "Remote shares" wurde in der Version 7 eine Erweiterung in den Core übernommen, mit dem es möglich sein soll, sogenannte "Shares" mittels einem Link auch in einer anderen Installation einzubinden. Dies ermöglicht es, Dateien auch über die Grenzen des eigenen Servers hinweg zu teilen. [@bizblokes2015a]

Die kostenpflichtige Variante von ownCloud geht hier noch einen Schritt weiter. In Abbildung \ref{owncloud_architecture} ist abgebildet, wie ownCloud als eine Art Verbindungsschicht zwischen verschiedenen lokalen- und Cloud-Speichersystemen dienen soll. [@owncloudarchitecture2015, p. 1]

![ownCloud Enterprise Architektur Übersicht [@owncloudarchitecture2015]\label{owncloud_architecture}](images/owncloud_architecture.png)

Um die Integration in ein Unternehmen zu erleichtern, bietet es verschiedenste Services an. Unter anderem ist es möglich, Benutzerdaten über LDAP oder ActiveDirectory zu verwalten und damit ein doppeltes Verwalten der Benutzer zu vermeiden. [@owncloudarchitecture2015, p. 2]

![Bereitstellungsszenario von ownCloud [@owncloudarchitecture2015]\label{owncloud_deployment}](images/owncloud_deployment.png)

Für einen produktiven Einsatz wird eine skalierbare Architektur, wie in Abbildung \ref{owncloud_deployment}, vorgeschlagen. An erster Stelle steht ein Load-Balancer, der die Last der Anfragen an mindestens zwei Webserver verteilt. Diese Webserver sind mit einem MySQL-Cluster verbunden, in dem die User-Daten, Anwendungsdaten und Metadaten der Dateien gespeichert sind. Dieser Cluster besteht wiederum aus mindestens zwei redundanten Datenbankservern. Dies ermöglicht auch bei stark frequentierten Installationen eine horizontale Skalierbarkeit. Zusätzlich sind die Webserver mit dem File-Storage verbunden. Auch hier ist es möglich, diesen redundant bzw. skalierbar aufzubauen, um die Effizienz und Sicherheit zu erweitern. [@owncloudarchitecture2015, p. 3-4]

## Diaspora

__TODO kaum Infos gefunden, weitere suche notwendig__

## Zusammenfassung

__TODO Zusammenfassung state of the art Kapitel__
