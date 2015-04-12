# Einleitung

Seit den Abhörskandalen durch die NSA und anderen Geheimdiensten ist es immer mehr Menschen wichtig, die Kontrolle über die eigenen Daten zu behalten. Aufgrund dessen erregen Projekte wie Diaspora[^1], ownCloud[^2] und ähnliche Software Lösungen immer mehr Aufmerksamkeit. Die beiden genannten Software Lösungen decken zwei sehr wichtige Bereiche der persönlichen Datenkontrolle ab.

Diaspora ist ein dezentrales soziales Netzwerk. Die Benutzer von diesem Netzwerk sind durch die verteilte Infrastruktur nicht von einem Betreiber abhängig. Es bietet die Mög-lichkeit, seinen Freunden bzw. der Familie, eine private Plattform anzubieten. Das Interes-sante daran ist, dass sich sogenannten Pods (dezentrale Knoten), beliebig untereinander vernetzen lassen und damit ein P2P Netzwerk aufbauen lässt. Pods können von jedem in-stalliert und betrieben werden; dabei kann der Betreiber bestimmen, wer in sein Netzwerk eintreten darf und welche Server mit seinem verbunden sind. Die verbundenen Pods tau-schen ohne einen zentralen Knoten Daten aus und sind dadurch unabhängig. Dies garan-tiert die volle Kontrolle über seine Daten im Netzwerk [siehe @diaspora2015a].

Das Projekt “ownCloud” ist eine Software, die es ermöglicht, Daten in einer privaten Cloud zu verwalten. Mittels Endgeräte-Clients können die Daten synchronisiert und über die Plattform auch geteilt werden. Insgesamt bietet die Software einen ähnlichen Funktion-sumfang gängiger kommerzieller Lösungen an [siehe @owncloud2015a]. Zusätzlich bietet es eine Kollaborationsplattform, mit der zum Beispiel Dokumente über einen online Editor, von mehreren Benutzern gleichzeitig, bearbeitet werden können. Diese Technologie basiert auf der JavaScript Library WebODF[^3].

## Projektbeschreibung

Symcloud ist eine private Cloud-Software, die es ermöglicht über dezentrale Knoten (ähnlich wie Diaspora) Daten über die Grenzen des eigenen Servers hinweg zu teilen. Verbundene Knoten tauschen über sichere Kanäle Daten aus, die dann über einen Client mit dem Endgerät synchronisiert werden können.

__TODO genauere Beschreibung__

Die Software baut auf modernen Web-Technologien auf und verwendet als Basis das PHP-Framework Symfony2[^4]. Dieses Framework ist eines der beliebtesten in der Open-Source Community. Es bietet neben der Abstraktion von HTTP-Anfragen auch einen Dependency-Injection-Container und viele weitere Komponenten wie zum Beispiel Routing und Event Dispatcher. Zusätzlich erleichtert es die Entwicklung von großen PHP-Projekten, durch die Möglichkeit den Code in Komponenten, sogenannten Bundles, zu gliedern. Diese können dann mit der Community geteilt werden.

Als Basis für die Plattform verwendet Symcloud das Content-Management-Framework SULU[^5] der Vorarlberger Firma MASSIVE ART WebServices[^6] aus Dornbirn. Es bietet ein erweiterbares Admin-UI, eine Benutzerverwaltung und ein Rechtesystem. Diese Features ermöglichen Symcloud eine schnelle Entwicklung der Oberfläche und deren zugrundeliegenden Services. 

## Inspiration

__TODO Noch einmal ownCloud - Diaspora und Ted Nelson mit dem Xanadu Projekt__

## Technologie

__TODO überarbeiten phpcr ersetzt durch S3__

Dieses Kapitel beschreibt die verwendeten Technologie etwas genauer. In Abbildung \ref{overview} zeigt die Abhängigkeiten als Schichten Diagramm. Ganz oben ist zum einen die Oberfläche von Symcloud, die in die Sulu Umgebung eingebettet ist. Sulu selbst ist eine "One-Page application", die verschiedene Javascript Komponenten zur Verfügung stellt, um die Anwendung erweitern zu können. Die andere Schnittstelle ganz oben ist der Synchronisierung Client, der es ermöglich Daten über ein Kommandozeilen Programm zu synchronisieren. Beide "Oberflächen" sprechen das Backend über eine gesicherte REST-API an. Diese API wird verwendet um Daten zu empfangen aber auch daten an den Server zu senden. Zum Beispiel sendet der Synchronisierungs Client einen POST-Request an den Server um eine Datei hochzuladen.

![Überblick über die Komponenten\label{overview}](diagrams/overview.png)

Auf der Server-Seite gibt es zum einen die standard API-Schnittstellen von Sulu und zum anderen die Erweiterung durch Symcloud mit der File-API. Als Persistence-Schicht für die Metadaten, der Dateien in der Symcloud, wird die Abstraktionsschicht PHPCR verwendet. Diese Schnittstelle bietet einen Zugriff auf verschiedenste Content-Repositories an.


### Sulu CMF



### Symfony2



### PHP



### S3


## Anforderungen



[^1]: <https://diasporafoundation.org/>
[^2]: <https://owncloud.org/>
[^3]: <http://webodf.org/>
[^4]: <http://symfony.com/>
[^5]: <http://www.sulu.io>
[^6]: <http://www.massiveart.com/de>
