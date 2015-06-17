# Einleitung

Seit dem aufkommen von Cloud-Diensten befinden sich immer mehr AnwenderInnen in einem Konflikt zwischen Datensicherheit und Datenschutz. Diese Dienste ermöglichen es Daten sicher und einfach zu speichern und Gleichzeit mit seinem Mitmenschen zu teilen. Jedoch gibt es große Bedenken der  BenutzerInnen im Bezug auf den Datenschutz, wenn sie Ihre Daten aus der Hand geben. Dieser Konflikt zeigen auch verschiedene Studien. Sie zeigen, dass es immer mehr Nutzer in die Cloud zieht, wie das Beispiel in Abbildung \ref{dropbox_usage} zeigt, dabei aber die Bedenken gegen genau diese Anwendungen zunehmen (siehe Abbildung \ref{cloud_services_concerns}).

![Anzahl der Dropbox-Nutzer weltweit zwischen Januar 2010 und Mai 2014 (in Millionen) [@statista2014dropbox]\label{dropbox_usage}](images/statista/dropbox-usage.png)

Die Statistik aus der Abbildung \ref{dropbox_usage} zeigt wie die Nutzerzahlen der Kommerziellen Cloud-Anwendung Dropbox[^4] in den Jahren 2010 bis 2014 von anfänglich 4 Millionen auf 300 Millionen im Jahre 2014 angestiegen sind.

![Hauptbedenken der Nutzer von Cloud-Diensten in Österreich im Jahr 2012 [@statista2012concerns]\label{cloud_services_concerns}](images/statista/cloud-services-concerns.png)

Im Gegenzug wurde im Jahre 2012 in Österreich erhoben, dass nur etwa 17% der AnwenderInnen ohne Bedenken Cloud-Dienste verwendet. Das meistgenannte Bedenken ist: Fremdzugriff auf die Daten ohne Information.

Dieses Bedenken ist seit den Abhörskandalen, durch verschiedenste Geheimdienste wie die zum Beispiel NSA, noch verstärkt worden. Was auch eine Umfrage aus dem Jahre 2014 aus Deutschland (Abbildung \ref{cloud_services_concerns_nsa}) zeigt. Dabei gaben 71% an, dass das Vertrauen zu Cloud-Diensten durch diese Skandale beschädigt worden ist.

![Zustimmung zu der Aussage: "Der NSA-Skandal hat das Vertrauen in Cloud-Dienste beschädigt." [@statista2014nsa]\label{cloud_services_concerns_nsa}](images/statista/cloud-services-concerns-nsa.png)

Diese Statistiken zeigen, dass immer mehr Menschen das Bedürfnis verspüren, die Kontrolle über ihre Daten zu behalten. Aufgrund dessen erregen Projekte wie Diaspora[^1], ownCloud[^2] und ähnliche Softwarelösungen immer mehr Aufmerksamkeit.

Diaspora

:   Diaspora ist ein dezentrales soziales Netzwerk. Die Benutzer von diesem Netzwerk sind durch die verteilte Infrastruktur nicht von einem Betreiber abhängig. Es ermöglicht, seinen Freunden bzw. der Familie, eine private social-media Plattform anzubieten und diese nach seinen Wünschen zu gestalten. Das Interessante daran sind die sogenannten Pods (dezentrale Knoten), die sich beliebig untereinander vernetzen lassen. Damit baut Diaspora ein privates P2P Netzwerk auf. Pods können von jedem installiert und betrieben werden; dabei kann der Betreiber bestimmen, wer in sein Netzwerk eintreten darf und welche Server mit seinem verbunden sind. Die verbundenen Pods tauschen ohne einen zentralen Knoten, Daten aus und sind dadurch unabhängig. Dies garantiert die volle Kontrolle über seine Daten im Netzwerk [@diaspora2015a]. Dieses Projekt wurde in der Programmiersprache Ruby entwickelt.

ownCloud

:   Das Projekt ownCloud ist eine Software, die es ermöglicht, Daten in einer privaten Cloud zu verwalten. Mittels Endgeräte-Clients können die Daten synchronisiert und über die Plattform auch geteilt werden. Insgesamt bietet die Software einen ähnlichen Funktionsumfang gängiger kommerzieller Lösungen an [@owncloud2015a]. Zusätzlich bietet es eine Kollaborationsplattform, mit der zum Beispiel Dokumente über einen online Editor, von mehreren Benutzern gleichzeitig, bearbeitet werden können. Diese Technologie basiert auf der JavaScript Library WebODF[^3]. Implementiert ist dieses Projekt Hauptsächlich in der Programmiersprache PHP.

Beide Software-Pakete ermöglichen es den NutzerInnen Ihre Daten in einer Vertrauenswürdigen Umgebung zu verwalten. Diese Umgebung wird nur ungern verlassen, um seine Daten anderen zur Verfügung zu stellen. Aufgrund dieses Umstandes, ist es für Anwendungen oft sehr schwer sich für die breite Masse zu etablieren. In dieser Arbeit wird speziell auf die Anforderungen von Anwendungen eingegangen, die es ermöglichen soll, Dateien zu verwalten und zu teilen. Speziell wird der Fall betrachtet, wenn zwei BenutzerInnen die auf verschiedenen Servern registriert sind, Dateien zusammen verwenden wollen. Dabei sollen die Vorgänge, die nötig sind um die Daten zwischen den Servern zu Übertragen, transparent für die NutzerInnen gehandhabt werden.

## Projektbeschreibung

Symcloud ist eine private Cloud-Software, die es ermöglicht, über dezentrale Knoten (ähnlich wie Diaspora) Daten über die Grenzen des eigenen Servers hinweg zu teilen. Verbundene Knoten tauschen über sichere Kanäle Daten aus, die anschließend über einen Client mit dem Endgerät synchronisiert werden können. Dabei ist es für den Benutzer irrelevant, woher die Daten stammen.

Wobei es bei der Arbeit weniger um die Plattform, als um die Konzepte geht, die es ermöglichen an eine solche Plattform umzusetzen. Dabei wird im speziellen die Datenhaltung für solche Systeme bedacht. Um diese Konzepte, so unabhängig wie möglich von der Plattform zu gestalten, wird die Implementierung dieser Konzepte in einer eigenständigen Library entwickelt. Dieser Umstand ermöglicht eine Weiterverwendung in anderen Plattformen und Anwendungen, die ihren BenutzerInnen ermöglichen wollen, Daten zu erstellen, verwalten, bearbeiten oder teilen. Damit kann das erstellte Konzept als Grundlage für eine "Spezifikation" von derartigen Prozessen weiterverwendet werden.

In der ersten Phase, in der diese Arbeit entsteht, werden Grundlegende Konzepte aufgestellt. Diese beginnen mit der Festlegung eines Datenmodells und der Implementierung einer Datenbank, die diese Daten mit anderen Server teilen kann. Dieses teilen von Daten soll voll konfigurierbar sein, was bedeutet, das die AdministratorInnen die Freiheit haben, zu entscheiden, welche Server welche Daten zu sehen bekommen. Dabei gibt es zwei Stufen der Konfiguration, zum einen über eine Liste von vertrauten Server, diese Server sind sozusagen eine "Whitelist" von Servern, mit denen die BenutzerInnen kommunizieren dürfen. Die zweite Stufe sind die Rechte auf ein Objekt, darf ein Objekt nur von einem Server gesehen werden, wird dieses Objekt nur auf andere Server verteilt, wenn die BenutzerInnen dies aus Gründen der Datensicherheit wünscht. Daten, die nur auf einem Server gespeichert sind, sind tendenziell gefährdet, irgendwann durch unvorhergesehene Ereignisse verloren zu gehen.

Kurz gesagt, symCloud sollte eine Kombination der beiden Applikationen ownCloud und Diaspora sein. Dabei sollte es die Dateiverwaltungsfunkionen von ownCloud und die Architektur von Diaspora kombinieren, um eine optimale Alternative zu kommerziellen Lösungen, wie Dropbox zu bieten.

## Inspiration

Als Inspirationsquelle für eine Architektur dienten neben den schon erwähnten Applikationen auch das Projekt Xanadu[^5]. Dieses Projekt wurde im Jahre 1960 von Ted Nelson gegründet und wurde nie finalisiert. Er arbeitet seit der Gründung an einer Implementierung an verschiedenen Universitäten an der Software [@???]. Ted Nelson prägte den Begriff des Hypertext mit der Veröffentlichung eines wissenschaftlichen Artikels "The Hypertext. Proceedings of the World Documentation Federation" im Jahre 1965. Darin beschrieb er Hypertext als Lösung für die Probleme, die Normales Papier mit sich bringt [@Nelson:2007:BFH:1286240.1286303]. 

Verbindungen

:   Text besteht oft aus einer Menge von anderen Texten wie zum Beispiel Zitate oder Querverweise. Dies lässt sich mithilfe von normalem Papier nur schwer abbilden und visualisieren.

Form

:   Ein Blatt Papier ist begrenzt in seiner Größe und Form. Es zwingt den Text in eine bestimmte Form und es kann nicht erweitert werden.

Hypertext sollte nicht das Medium sondern die BenutzerInnen in den Vordergrund stellen. Durch verschiedene Mechanismen sollte Xanadu die Möglichkeit schaffen, dass BenutzerInnen Dokument verlinken und Zusammensetzen können. Jedes Dokument wäre im Netzwerk eindeutig auffindbar, versioniert und verwendbar. Damit ist Xanadu ein nie zu Ende gebrachtes Konzept einer Digitalen Bibliothek [@Nelson:2007:BFH:1286240.1286303].

Ursprünglich wurden 17 Thesen in dem Buch "Literary Machines" 1981 veröffentlicht. Sie beschrieben die Grundsätze, auf denen das Projekt Xanadu aufgebaut sind [@nelson1981literary]. Einige davon wurden durch Tim Berners-Lee in der Erfindung des Internets umgesetzt, andere jedoch vernachlässigt [@atwood2009xanadu]. Einige der Thesen, die vernachlässigt wurden, sind interrsante Denkanstöße für ein Projekt wie Symcloud.

__Every Xanadu server can be operated independently or in a network.__

Xanadu Server können für sich alleine oder in einem Netzwerk interagieren. 

__Every user is uniquely and securely identified.__

Jeder Benutzer ist eindeutig und sicher identifizierbar.

__Every user can search, retrieve, create and store documents.__

Jeder Benutzer kann Dokumente durchsuchen herunterladen, erstellen und speichern.

__Every document can have secure access controls.__

Jede Dokument besitzt Benutzerrechte, die steuern, wer welche Rechte bei diesem Dokument besitzt.

__Every document can be rapidly searched, stored and retrieved without user knowledge of where it is physically stored.__

Jedes Dokument kann schnell durchsucht, gespeichert und heruntergeladen werden, ohne das der Benutzer weiß wo das Dokument Physikalisch gespeichert ist.

__Every document is automatically stored redundantly to maintain availability even in case of a disaster.__

Jedes Dokument wird redundant gespeichert, um den Verlust bei unvorhergesehenen Ereignissen zu verhindern.

Diese Thesen werden in den folgenden Anforderungen an ein System wie symCloud zusammengefasst.

## \label{specification}Anforderungen

__TODO Anforderungen an das Projekt (auch in Bezug auf xanadu)__

* Datensicherheit
  * Datenschutz
  * Ausfallsicherheit
  * Fremdzugriff
* Funktionen
  * Versionierung
  * Zusammenarbeit (Dateien teilen)
  * Zugriffsberechtigungen
  * Namensräume
* Architektur
  * Verteilte Architektur (um Zusammenarbeit zwischen Servern zu ermöglichen)
  * Datenverteilung nicht Lastverteilung
  * Moderne Programmierung
* Nicht Ziele (aber Anforderungen)
  * Effizienz
  * Performance
  * ???

__TODO genauere Ausformulierung__

## Kapitelübersicht

Im Kapitel \ref{chapter_state_of_the_art} wird ein Überblick über den aktuellen Stand der Technik gegeben. Dabei werde zuerst einige Begriffe für die weitere Arbeit definiert und danach Anwendungen und Technologien durchleuchtet, die die Bereiche Cloud-Datenhaltung, verteilte Daten und verteilte Datenmodell umfassen.

Anschließend werden in einem Evaluierungskapitel (Kapitel \ref{chapter_evaluation}) Technologien betrachtet, die es ermöglichen Daten in einer verteilten Architektur zu verwalten. Dazu wurden die Bereiche Objekt-Speicherdienste, Verteilte Dateisysteme und Datenbank gestützte Dateisysteme mit Beispielen analysiert und auf ihre Tauglichkeit als Basis für ein Speicherkonzept evaluiert.

Das Kapitel \ref{chapter_concept} befasst sich mit der Konzeption von symCloud. Dabei geht es zentral um das Datenmodell und die Datenbank, die diese Daten speichert und verteilt.

Dieses Konzept wurde dann in einer Prototypen Implementierung umgesetzt. Die Details der Implementierung und die verwendeten Technologien werden im Kapitel \ref{chapter_implementation} beschrieben.

Abschließend (Kapitel \ref{chapter_result_outlook}) werden die Ergebnisse der Arbeit zusammengefasst und analysiert. Zusätzlich wird ein Ausblick über die ZUkunft des Projektes und mögliche Erweiterungen vorgestellt.

[^1]: <https://diasporafoundation.org/>
[^2]: <https://owncloud.org/>
[^3]: <http://webodf.org/>
[^4]: <https://www.dropbox.com/>
[^5]: <http://hyperland.com/TBLpage>
