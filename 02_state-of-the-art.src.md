# Stand der Technik

In diesem Kapitel werden moderne Anwendungen anhand ihrer Architektur durchläuchtet, um die jeweilige Vorteile für Symcloud zusammenzufassen.

## \label{verteilte_systeme}Verteilte Systeme

Ein verteiltes System ist laut Andrew Tanenbaum [siehe @tanenbaum2008verteilte, pp. ???]:

	"Ein verteiltes System ist eine Menge voneinander unabhängiger
	Computer, die dem Benutzer wie ein einzelnes kohärentes
	System erscheinen"

Ein nicht mehr ganz neues aber immer noch sehr aktuelles Verteiltes System ist das Netzwerk-Protokoll NFS (Network File Service). 

TODO überprüfen ob dieses zitat echt ist
TODO beschreibung eines netzwerk protokolles
TODO trennung metadaten und inhalt

## Dropbox

Dropbox-Nutzer können jederzeit von ihrem Desktop aus über das Internet, über mobile Geräte oder über mit Dropbox verbundene Anwendungen auf Dateien und Ordner zugreifen. Alle diese Clients stellen Verbindungen mit sicheren Servern her, über die Sie Zugriff auf Dateien haben, Dateien für andere Nutzer freigeben können, und verknüpfte Geräte aktualisieren können, wenn Dateien hinzugefügt, verändert oder gelöscht werden. Der Dropbox-Service betreibt verschiedene Dienste, die sowohl für die Handhabung und Verarbeitung von Metadaten als auch von unformatiertem Blockspeicher verantwortlich sind. [siehe @dropbox2015a]

![Blockdiagram der Dropbox Services (Quelle <https://www.dropbox.com/help/1968>)\label{db_archtecture}](images/db_archtecture.png)

In der Abbildung \ref{db_archtecture} werden die einzelnen Komponenten in einem Blockdiagram dargestellt. Es gliedert sich in drei größere Blöcke:

* Metadata Servers
* Storage Servers
* Processing Servers
 
Wie im Kapitel \ref{verteilte_systeme} beschrieben trennt Dropbox intern die Dateien von ihren Metadaten. Der Metadata Service speichert die Metadaten und informationen zu ihrem Speicherort in einer Datenbank aber der Inhalt der Daten liegt in einem seperaten Storage Service. Dieser Service verteilt die Daten wie ein "Load Balancer" über viele Server.

Der Storage Service ist wiederum von aussen durch einen Application Service abgesichert. Die Authentifizierung erfolgt über das OAuth2 Protokoll [siehe @dropbox2015b]. Diese Authentifizierung wird für alle Services verwendet, also auch für den Metadata Service und der Notification Service.

## ownCloud

## Diaspora



## Zusammenfassung