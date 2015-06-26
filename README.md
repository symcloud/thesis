# Symcloud thesis

This repository contains my master thesis which i will write about the symcloud project.

The following content is german.

## Einleitung

Seit dem Aufkommen von Cloud-Diensten, befinden sich immer mehr AnwenderInnen in einem Konflikt zwischen Datensicherheit und Datenschutz. Cloud-Dienste ermöglichen es, Daten sicher zu speichern und mit seinen Mitmenschen zu teilen. Jedoch gibt es große Bedenken der  BenutzerInnen im Bezug auf den Datenschutz, wenn sie Ihre Daten aus der Hand geben. Diese Problematik veranschaulichen auch verschiedene Studien. Sie beweisen, dass es immer mehr NutzerInnen in die Cloud zieht (siehe Abbildung \ref{dropbox_usage}), dabei aber die Bedenken gegen genau diese Anwendungen, zunehmen (siehe Abbildung \ref{cloud_services_concerns}).

![Anzahl der Dropbox-Nutzer weltweit zwischen Januar 2010 und Mai 2014 (in Millionen) [@statista2014dropbox]\label{dropbox_usage}](images/statista/dropbox-usage.png)

Die Statistik aus der Abbildung \ref{dropbox_usage} zeigt, wie die Nutzerzahlen des kommerziellen Cloud-Dienstes Dropbox[^4], in den Jahren 2010 bis 2014 von anfänglich 4 Millionen auf 300 Millionen NutzerInnen im Jahre 2014 angestiegen sind.

![Hauptbedenken der Nutzer von Cloud-Diensten in Österreich im Jahr 2012 [@statista2012concerns]\label{cloud_services_concerns}](images/statista/cloud-services-concerns.png)

Im Gegensatz dazu wurde im Jahre 2012 in Österreich erhoben (siehe \ref{cloud_services_concerns}), dass nur etwa 17% der AnwenderInnen diese Dienste ohne Bedenken verwenden. Das meistgenannte Bedenken dieser Studie ist: __Fremdzugriff auf die Daten ohne informiert zu werden__.

Dieses Bedenken ist seit den Abhörskandalen, durch verschiedenste Geheimdienste wie zum Beispiel die NSA, noch verstärkt worden. Dies zeigt eine Umfrage aus dem Jahre 2014, die in Deutschland durchgeführt wurde (Abbildung \ref{cloud_services_concerns_nsa}). Dabei gaben 71% an, dass das Vertrauen zu Cloud-Diensten durch diese Skandale beschädigt worden ist.

![Zustimmung zu der Aussage: "Der NSA-Skandal hat das Vertrauen in Cloud-Dienste beschädigt." [@statista2014nsa]\label{cloud_services_concerns_nsa}](images/statista/cloud-services-concerns-nsa.png)

Diese Statistiken zeigen, dass immer mehr Menschen das Bedürfnis verspüren, die Kontrolle über ihre Daten zu behalten, aber trotzdem die Vorzüge solcher Dienste nutzen wollen. Aufgrund dessen erregen Projekte wie Diaspora[^1], ownCloud[^2] und ähnliche Softwarelösungen immer mehr Aufmerksamkeit.

__Diaspora__ Diaspora ist ein dezentrales soziales Netzwerk. Die BenutzerInnen von diesem sozialen Netzwerk sind durch die verteilte Infrastruktur nicht von einem Dienstleister abhängig. Es ermöglicht, seinen Freunden bzw. der Familie, eine private "social-media" Plattform anzubieten und diese nach seinen Wünschen zu gestalten. Das Interessante daran sind die sogenannten Pods (dezentrale Knoten), die sich beliebig untereinander vernetzen lassen. Dies ermöglicht es auch Benutzern, die nicht auf demselben Server registriert sind, miteinander zu kommunizieren. Pods können von jedem installiert und betrieben werden; dabei kann der Betreiber bestimmen, wer in sein Netzwerk eintreten darf und welche Server mit dem eigenen Kontakt aufnehmen dürfen. Die verbundenen Pods tauschen die Daten ohne einen zentralen Knoten aus. Dies garantiert die volle Kontrolle über seine Daten im Netzwerk [@diaspora2015about]. Entwickelt wurde dieses Projekt in der Programmiersprache Ruby.

__ownCloud__ Das Projekt ownCloud ist eine Software, die es ermöglicht, Dateien in einer privaten Cloud zu verwalten. Mittels Endgeräte-Clients können die Dateien synchronisiert und über die Plattform auch geteilt werden. Insgesamt bietet die Software einen ähnlichen Funktionsumfang gängiger kommerzieller Lösungen [@owncloud2015features]. Zusätzlich bietet es eine Kollaborationsplattform, mit der zum Beispiel Dokumente über einen online Editor, von mehreren Benutzern gleichzeitig, bearbeitet werden können. Implementiert ist dieses Projekt hauptsächlich in den Programmiersprachen PHP und JavaScript.

Beide Software-Pakete ermöglichen es den NutzerInnen, Ihre Daten in einer vertrauenswürdigen Umgebung zu verwalten. Diese Umgebung wird nur ungern verlassen, um seine Daten anderen zur Verfügung zu stellen. Aufgrund dieses Umstandes, ist es für Anwendungen oft sehr schwer, sich für die breite Masse zu etablieren. In dieser Arbeit wird speziell auf die Anforderungen von Anwendungen eingegangen, die es ermöglichen soll, Dateien zu verwalten, zu teilen und in einem definierbaren Netzwerk zu verteilen. Speziell wird der Fall betrachtet, wenn zwei BenutzerInnen die auf verschiedenen Servern registriert sind, Dateien zusammen verwenden wollen. Dabei sollen die Vorgänge, die nötig sind, um die Dateien zwischen den Servern zu übertragen, transparent für die NutzerInnen gehandhabt werden.

[^1]: <https://diasporafoundation.org/>
[^2]: <https://owncloud.org/>
[^4]: <https://www.dropbox.com/>
[^5]: <http://hyperland.com/TBLpage>
