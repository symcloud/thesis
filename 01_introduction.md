# Einleitung

In Zeiten der NSA und anderen Geheimdiensten ist es immer mehr Menschen wichtig die Kontrolle über die eigenen Daten
zu behalten. Aufgrund dessen wecken Projekte wie Diaspora[^1], ownCloud[^2] und ähnliche Software Lösungen immer mehr
Aufmerksamkeit. Die beiden genannten Software Lösungen decken zwei sehr wichtige Bereiche der Datenkontrolle ab.

Das eine "Diaspora" ist ein dezentralles soziales Netzwerk ohne der Nutzer von einem Betreiber abhängig ist. Es bietet
also die Möglichkeit seinen Freunden bzw. Familie eine private Platform anzubieten. Das interresante daran ist, das
sich sogannte Pods (dezentrale Knoten) beliebig verknüpfen lassen und damit ein P2P Netzwerk einrichten lassen. Der
Betreiber jedes Pods bestimmt damit wer in sein Netzwerk eintretten und damit wer seine Daten sehen kann. Die
verbundenen Pods tauschen ohne einen Zentralen Knoten Daten aus und sind dadurch unabhängig. Dies garantiert die volle
Kontrolle über seine Daten im Netzwerk.

Das Projekt "ownCloud" ist eine Software, die es ermöglicht Daten in einer Privaten Cloud zu verwalten. Mittels
Endgeräte-Clients können die Daten synchronisiert und über die Platform auch geteilt werden. Insgesamt bietet die
Software einen ähnlichen Funktionsumfang gängiger Kommerzieller Lösungen an. Zusätzlich bietet es allerdings
wie z.B. Google Drive einen online Editor, über den mehrere Nutzer gleichzeitig ein Dokument bearbeiten können.
Diese Technologie basiert auf der JavaScript Library WebODF[^3].

## Projektbeschreibung

Symcloud ist eine private Cloud-Software, die es ermöglicht über dezentrale Knoten (ähnlich wie Diaspora) Daten
über die Grenzen der eigenen Cloud hinweg zu teilen. Verbundene Knoten tauschen über sichere Kanäle Daten aus, die
dann über einen GIT-Client mit dem Endgerät synchronisiert werden können.

Die Software baut auf modernen Technologien auf und verwendet als Basis das Framework Symfony2[^4]. Dieses Framework
ist eines der beliebstesten PHP-Frameworks und bietet neben der Abstraktion von HTTP-Anfragen auch einen DI-Container,
Event-Dispatcher, Routing uvm. Dies erleichtert die Entwicklung von großen PHP-Projekten.

Als Basis für die Platform verwendet Symcloud das Content-Management-Framework der Vorarlberger Firma MASSIVE ART
WebServices aus Dornbirn. Es bietet ein erweiterbares Admin-UI, eine Benutzerverwaltung und ein Rechtesystem. Diese
Features ermöglichen Symcloud eine schnelle Entwicklung der Oberfläche und deren zugrundeliegenden Services.

## Überblick

Die Abbildung \ref{overview} beschreibt die Abhängigkeiten auf denen Symcloud aufsetzt.

![Überblick über die Komponenten\label{overview}](diagrams/overview.png)

TODO diagram erweitern

## Wissenschaftliche Relevanz



[^1]: <https://diasporafoundation.org/>
[^2]: <https://owncloud.org/>
[^3]: <http://webodf.org/>
[^4]: <http://symfony.com/>
