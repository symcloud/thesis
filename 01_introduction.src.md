# \label{chapter_introduction}Einleitung

Seit dem Aufkommen von Cloud-Diensten, befinden sich immer mehr AnwenderInnen in einem Konflikt zwischen Datensicherheit und Datenschutz. Cloud-Dienste ermöglichen es, Daten sicher zu speichern und mit anderen zu teilen. Jedoch gibt es große Bedenken der  BenutzerInnen im Bezug auf den Datenschutz, wenn sie Ihre Daten aus der Hand geben. Mit dieser Thematik beschäftigen sich auch verschiedene Studien. Sie beweisen, dass es immer mehr NutzerInnen in die Cloud zieht (siehe Abbildung \ref{dropbox_usage} - Beispiel Dropbox[^4]), allerdings gibt es sehr viele Benutzer die Bedenken gegen diese Anwendungen haben (siehe Abbildung \ref{cloud_services_concerns}).

![Anzahl der Dropbox NutzerInnen weltweit zwischen Januar 2010 und Mai 2014 (in Millionen) [@statista2014dropbox]\label{dropbox_usage}](images/statista/dropbox-usage.png)

Die Statistik aus der Abbildung \ref{dropbox_usage} zeigt, wie die Benutzungszahlen des kommerziellen Cloud-Dienstes Dropbox in den Jahren 2010 bis 2014 von anfänglich 4 Millionen auf 300 Millionen NutzerInnen im Jahre 2014 angestiegen sind.

![Hauptbedenken der NutzerInnen von Cloud-Diensten in Österreich im Jahr 2012 [@statista2012concerns]\label{cloud_services_concerns}](images/statista/cloud-services-concerns.png)

Entgegen dieses Trends wurde im Jahre 2012 in Österreich erhoben (siehe \ref{cloud_services_concerns}), dass nur etwa 17% der AnwenderInnen diese Dienste ohne Bedenken verwenden. Das in dieser Studie am häufigsten genannte Bedenken ist: __Fremdzugriff auf die Daten, ohne informiert zu werden__.

Dieses Bedenken ist seit den Abhörskandalen durch verschiedenste Geheimdienste, wie zum Beispiel die NSA, noch verstärkt worden. Dies zeigt eine Umfrage aus dem Jahre 2014, die in Deutschland durchgeführt wurde (Abbildung \ref{cloud_services_concerns_nsa}) deutlich. Dabei gaben 71% an, dass das Vertrauen zu Cloud-Diensten durch diese Skandale beschädigt worden ist.

![Zustimmung zu der Aussage: "Der NSA-Skandal hat das Vertrauen in Cloud-Dienste beschädigt." [@statista2014nsa]\label{cloud_services_concerns_nsa}](images/statista/cloud-services-concerns-nsa.png)

## Alternativen zu kommerziellen Cloud-Diensten

Diese Statistiken zeigen, dass immer mehr Menschen das Bedürfnis verspüren, die Kontrolle über ihre Daten zu behalten, aber trotzdem die Vorzüge solcher Dienste nutzen wollen. Aufgrund dessen erregen Projekte wie Diaspora[^1], ownCloud[^2] und ähnliche Softwarelösungen immer mehr Aufmerksamkeit.

Diaspora

:   Diaspora ist ein dezentrales soziales Netzwerk. Dieses soziale Netzwerk besteht aus dezentralen unabhängigen Servern bzw. Knoten (Pods genannt). Die BenutzerInnen sind durch die verteilte Infrastruktur nicht von einem Dienstleister gebunden. Das Netzwerk ermöglicht, Freunden bzw. der Familie, eine private "social-media" Plattform anzubieten und diese nach seinen Wünschen zu gestalten. Das Interessante an der Pods-Architektur ist es, dass sich die Knoten beliebig vernetzen lassen. Dies ermöglicht es BenutzerInnen, die nicht auf demselben Server registriert sind, miteinander zu kommunizieren. Pods können von jedem installiert und betrieben werden; dabei kann die BetreiberIn bestimmen, wer in sein Netzwerk eintreten darf und welche Server mit dem eigenen Server Kontakt aufnehmen dürfen. Die verbundenen Pods tauschen die Daten ohne einen zentralen Knoten aus. Dies garantiert die volle Kontrolle über seine Daten im Netzwerk [@diaspora2015about]. Entwickelt wurde dieses Projekt in der Programmiersprache Ruby.

ownCloud

:   Das Projekt ownCloud ist eine Software, die es ermöglicht, Dateien in einer privaten Cloud zu verwalten. Mittels Endgeräte-Clients können die Dateien synchronisiert und über die Plattform auch geteilt werden. Insgesamt bietet die Software einen ähnlichen Funktionsumfang wie gängige kommerzielle Lösungen an [@owncloud2015features]. Zusätzlich bietet es eine Kollaborationsplattform, mit der zum Beispiel Dokumente über einen Online Editor, von mehreren BenutzerInnen gleichzeitig, bearbeitet werden können. Implementiert ist dieses Projekt hauptsächlich in den Programmiersprachen PHP und JavaScript.

Beide Software-Pakete ermöglichen es den NutzerInnen, Ihre Daten in einer vertrauenswürdigen Umgebung zu verwalten. Diese Umgebung wird nur ungern verlassen, um seine Daten anderen zur Verfügung zu stellen. In dieser Arbeit wird speziell auf die Anforderungen von Anwendungen eingegangen, die es ermöglichen sollen, Dateien zu verwalten, mit anderen zu teilen und in einem definierbaren Netzwerk zu verteilen. Speziell wird der Fall betrachtet, wenn zwei BenutzerInnen, die auf verschiedenen Servern registriert sind, Dateien zusammen verwenden wollen. Dabei sollen die Vorgänge, die nötig sind, um die Dateien zwischen den Servern zu übertragen, transparent für die NutzerInnen gehandhabt werden.

## Projektidee

SymCloud ist eine private Cloud-Software, die es ermöglicht, über dezentrale Knoten (ähnlich wie Diaspora) Dateien über die Grenzen des eigenen Servers hinweg zu teilen. Verbundene Knoten tauschen über sichere Kanäle Daten aus, die anschließend über einen Client mit dem Endgerät synchronisiert werden können. Dabei ist es für die BenutzerIn irrelevant, woher die Daten stammen.

Diese Arbeit beschäftigt sich weniger mit der Plattform, als mit die Konzepten, die es ermöglichen eine solche Plattform umzusetzen. Dabei wird im speziellen die Datenhaltung für solche Systeme betrachtet. Um diese Konzepte so unabhängig wie möglich von der Plattform zu gestalten, werden diese in einer eigenständigen Bibliothek entwickelt. Dieser Umstand ermöglicht eine Weiterverwendung in anderen Plattformen und Anwendungen, die ihren BenutzerInnen ermöglichen wollen, Dateien zu erstellen, zu verwalten, zu bearbeiten oder zu teilen. Damit kann das erstellte Konzept als Grundlage für eine "Spezifikation" von derartigen Prozessen ausgebaut werden.

In der ersten Phase, in der diese Arbeit entsteht, werden grundlegende Konzepte aufgestellt. Diese beginnen mit der Festlegung eines Datenmodells und der Implementierung einer Datenbank, die in der Lage ist die Daten mit anderen Servern zu teilen. Dieses Teilen von Daten soll voll konfigurierbar sein, was bedeutet, dass die AdministratorInnen die Freiheit haben zu entscheiden, welche Server welche Daten zur Verfügung gestellt bekommen. Dabei gibt es zwei Stufen der Konfiguration, zum einen über eine Liste von vertrauenswürdigen Servern, welche sozusagen eine "Whitelist" darstellt, mit denen die BenutzerInnen kommunizieren dürfen. Die zweite Stufe sind die Rechte auf ein einzelnes Objekt. Diese Rechte regeln zusätzlich, welche BenutzerInnen (und damit die Server, auf denen die BenutzerInnen registriert sind) das Objekt tatsächlich verwenden dürfen.

Kurz gesagt, symCloud ist eine Kombination der beiden Applikationen ownCloud und Diaspora. Dabei sollte es die Dateiverwaltungsfunkionen von ownCloud und die Pods-Architektur von Diaspora kombinieren, um eine optimale Alternative zu kommerziellen Lösungen, wie Dropbox anzubieten.

## \label{chapter_inspiration}Inspiration

Als Inspirationsquelle für das Konzept von symCloud dienten neben den schon erwähnten Applikationen auch das Projekt Xanadu[^5]. Dieses Projekt wurde im Jahre 1960 von Ted Nelson initiiert, allerdings nie finalisiert. Er arbeitet seit der Gründung an einer Implementierung an der Software [@atwood2009xanadu]. Ted Nelson prägte den Begriff des Hypertext mit der Veröffentlichung eines wissenschaftlichen Artikels "The Hypertext. Proceedings of the World Documentation Federation" im Jahre 1965. Darin beschrieb er Hypertext als Lösung für die Probleme, die normales Papier mit sich bringt [@Nelson:2007:BFH:1286240.1286303].

Die darin beschriebenen Probleme sind unter Anderem:

Verbindungen

:   Text besteht oft aus einer Menge von anderen Texten, wie zum Beispiel Zitaten oder Querverweisen. Diese Verbindungen lassen sich mithilfe von normalem Papier nur schwer abbilden bzw. visualisieren.

Form

:   Ein Blatt Papier ist begrenzt in seiner Größe und Form. Es zwingt den Text daher in eine bestimmte Form, welche später weder verändert noch erweitert werden kann.

Hypertext sollte nicht das Medium, sondern die BenutzerInnen in den Vordergrund stellen. Durch verschiedenste Mechanismen sollte Xanadu die Möglichkeit schaffen, dass BenutzerInnen Dokumente verlinken und zusammensetzen können. Jedes Dokument wäre im Netzwerk eindeutig auffindbar und versioniert (also in verschiedenen Versionen abrufbar). Damit ist Xanadu ein nie zu Ende gebrachtes Konzept einer digitalen Bibliothek [@Nelson:2007:BFH:1286240.1286303].

1981 veröffentlichte Ted Nelson in seinem Buch "Literary Machines" 17 Thesen, die die Grundsätze des Projekts Xanadu beschreiben sollten [@nelson1981literary]. Einige davon wurden durch Tim Berners-Lee in der Erfindung des "World Wide Webs" umgesetzt, andere jedoch vernachlässigt [@atwood2009xanadu]. Einige dieser Thesen, die vernachlässigt wurden, sind konkrete Denkanstöße für ein Projekt wie symCloud.

1. Every Xanadu server can be operated independently or in a network.
2. Every user is uniquely and securely identified.
3. Every user can search, retrieve, create and store documents.
4. Every document can have secure access controls.
5. Every document can be rapidly searched, stored and retrieved without user knowledge of where it is physically stored.
6. Every document is automatically stored redundantly to maintain availability even in case of a disaster.

Diese Thesen werden in den folgenden Anforderungen an ein System wie symCloud zusammengefasst.

## \label{specification}Anforderungen

Aufgrund der beschriebenen Projekte, die als Inspirationsquelle dienen, werden in diesem Abschnitt die Anforderungen an symCloud beschrieben. Diese Anforderungen sind unterteilt in:

Datensicherheit

:   In diesen Abschnitt der Anforderungen fallen Gebiete wie Datenschutz und der Schutz vor Fremdzugriff.

Funktionalitäten

:   Ein System wie symCloud sollte Funktionen mit sich bringen, die es erlauben, sich gegen andere Cloud-Lösungen behaupten zu können.

Architektur

:   Aufgrund der Inspiration durch Diaspora und Xanadu ist diese Anforderung von der verteilten Architektur von Diaspora inspiriert.

Neben diesen funktionalen Anforderungen gelten allgemeine Anforderungen an die Software wie zum Beispiel:

Stand der Technik

:   Die Entwicklung der Software entspricht dem Stand der Technik. 

Wartbarkeit und Erweiterbarkeit

:   Wartbarkeit bezeichnet den Grad der Effektivität mit der eine Software, durch einen Entwickler angepasst werden kann [@iso25010]. Gleiches gilt für die Erweiterbarkeit.

### Datensicherheit

Sinngemäß versteht man nach DIN44300, Teil 1,

- unter __Datensicherheit__ die Bewahrung von Daten vor Beeinträchtigung, insbesondere durch Verlust, Zerstörung oder Verfälschung und vor Missbrauch.
- unter __Datenschutz__ die Bewahrung schutzwürdiger Belange von Betroffenen oder Beeinträchtigung durch die Verarbeitung ihrer Daten, wobei es sich bei den Betroffenen um natürliche oder juristische Personen handeln kann.

Ausgedrückt in einer weniger formalen Sprache bedeutet Datenschutz den Schutz von Daten und Programmen vor unzulässiger Benutzung [@stahlknecht2013einführung].

Die internationalen Kriterien für die Bewertung der Sicherheit von Systemen gehen von drei grundsätzlichen Gefahren aus [@stahlknecht2013einführung]:

Verlust der Verfügbarkeit

:   Benötigte Daten sind, durch einen Ausfall oder Zerstörung (zum Beispiel durch einen Benutzerfehler), nicht mehr verfügbar.

Verlust der Integrität

:   Die Daten sind unabsichtlich oder bewusst verfälscht worden.

Verlust der Vertraulichkeit

:   Unbefugte erhalten Zugriff auf Daten, die nicht für sie bestimmt sind.

Konkrete Bedrohungen, die eine dieser drei Gefahren auslösen können, sind Katastrophen, technische Defekte oder menschliche Handlungen (ob unbewusst oder bewusst spielt hierbei keine Rolle) [@stahlknecht2013einführung].

Drei der im vorherigen Abschnitt genannten Thesen des Projekts Xanadu bieten Ansätze, wie diese Anforderungen umgesetzt werden können. Durch die Redundanz (These 6) der Daten kann sowohl der Verlust der Verfügbarkeit oder Integrität in vielen Fällen verhindert werden. Wenn das System sich vergewissern will, ob die Daten valide sind, fordert es alle Kopien der Daten an und vergleicht sie. Sind alle Versionen identisch, kann eine Verfälschung ausgeschlossen werden. Nicht mehr verfügbar sind Daten erst dann, wenn alle Kopien der Daten verloren gegangen sind. Aus diesem Grund können Replikationen helfen die Datensicherheit des Systems zu erhöhen. Die Thesen 2 und 4 bieten einen Schutz vor dem Verlust der Vertraulichkeit, indem die BenutzerIn eindeutig identifiziert werden kann und ein Zugriffsberechtigungssystem die Berechtigung überprüft. Dadurch kann ausgeschlossen werden, dass sich Dritte über die Schnittstellen des Systems, Zugriff auf Daten verschaffen, die sie nicht sehen dürften.

### Funktionalitäten

Um ein System wie symCloud konkurrenzfähig zu vergleichbaren Systemen wie Dropbox oder ownCloud [@owncloud2015features] zu machen, sind drei Kernfunktionalitäten unerlässlich:

Versionierung von Dateien

:   Die Versionierung ist ein wesentlicher Bestandteil von vielen Filehosting-Plattformen. Es ermöglicht nicht nur das Wiederherstellen von alten Dateiversionen, sondern auch das Wiederherstellen von gelöschten Dateien.

Zusammenarbeit zwischen BenutzerInnen

:   Um eine grundlegende Zusammenarbeit zwischen BenutzerInnen zu ermöglichen, ist es unerlässlich die Dateien bzw. Ordner teilen zu können.

Zugriffsberechtigungen vergeben

:   Um die Transparenz des Systems zu steigern, sollten die BenutzerInnen entscheiden können, welche Dateien bzw. Ordner von wem bzw. wie verwendet werden können.

Diese drei Anforderungen sind auch Bestandteil des Xanadu Projektes. Durch die Versionierung kann sichergestellt werden, dass Dokumente, wenn sie einmal veröffentlicht wurden über dieselbe URL erreichbar sind. Eine neue Version der Datei besitzt eine neue URL. Dies ist speziell für Zitierungen wichtig. Die Möglichkeit Dateien zusammen zu verwenden und die Zugriffsberechtigungen sind ebenfalls zentrale Bestandteile von Xanadu.

### Architektur

Inspiriert von der Pods-Architektur von Diaspora sollte es möglich sein, verschiedene Installationen von symCloud zu einem Netzwerk zusammenschließen zu können. Dabei liegt der Fokus auf der Datenverteilung. Dadurch können Daten gezielt im Netzwerk verteilt werden. Damit sie dort vorhanden sind, wo sie gebraucht werden. Aufgrund der Datensicherheitsanforderungen sollten die Daten nicht wahllos im Netzwerk verteilt, sondern Konzepte ausgearbeitet werden, um Daten aufgrund der Zugriffsberechtigungen auf das Netzwerk zu verteilen.

Eine Architektur, wie die von Diaspora, erfüllt die These eins von Xanadu, indem ein Server sowohl für sich alleine arbeiten, als auch in einem Netzwerk mit anderen Servern interagieren kann.

### \label{chapter_specification_further_topics}Abgrenzung

Wichtige, aber in dieser Arbeit nicht betrachtete Anforderungen, sind:

Effizienz und Performance

:   Die Effizienz und die Performance eines Systems ist meist nicht der Grund für einen Erfolg, allerdings meist eines der wichtigsten Gründe bei einem Misserfolg.

Verschlüsselung

:   Um die Datensicherheit zu gewährleisten, sollten die Daten auf dem Speichermedium und bei der Übertragung zwischen den einzelnen Stationen, verschlüsselt werden, um den Schutz vor Fremdzugriff auch außerhalb des Systems zu gewährleisten.

Diese Anforderungen sind, wie schon erwähnt, außerhalb des Fokuses dieser Arbeit und des Konzeptes, das in dieser Arbeit beschrieben wird. Sie sind allerdings wichtige Anforderungen an ein produktiv eingesetztes System und sollten daher zumindest eine Erwähnung in dieser Arbeit finden. Sie sind vor allem als Anregung für weiterführende Entwicklungen oder Untersuchungen gedacht.

## Kapitelübersicht

Im Kapitel \ref{chapter_state_of_the_art} wird ein Überblick über den aktuellen Stand der Technik gegeben. Dabei werden zuerst einige Begriffe für die weitere Arbeit definiert. Danach werden Anwendungen und Technologien durchleuchtet, die die Bereiche "Cloud-Datenhaltung", "verteilte Daten" und "verteilte Datenmodelle" umfassen.

Anschließend werden in einem Evaluierungskapitel (Kapitel \ref{chapter_evaluation}) Technologien betrachtet, die es ermöglichen, Daten in einer verteilten Architektur zu speichern. Dazu wurden die Bereiche "Objekt-Speicherdienste", "verteilte Dateisysteme" und "Datenbankgestützte Dateisysteme" mit Hilfe von Beispielen analysiert und auf ihre Tauglichkeit als Basis für ein Speicherkonzept evaluiert.

Das Kapitel \ref{chapter_concept} befasst sich mit der Konzeption von symCloud. Dabei geht es zentral um das Datenmodell und die Datenbank, die diese Daten speichert und verteilt.

Dieses Konzept wurde in einem Prototypen implementiert. Die Details der Implementierung und die verwendeten Technologien werden in Kapitel \ref{chapter_implementation} beschrieben.

Abschließend (Kapitel \ref{chapter_result_outlook}) werden die Ergebnisse der Arbeit zusammengefasst und analysiert. Zusätzlich wird ein Ausblick über die Zukunft des Projektes und mögliche Erweiterungen vorgestellt.

[^1]: <https://diasporafoundation.org/>
[^2]: <https://owncloud.org/>
[^4]: <https://www.dropbox.com/>
[^5]: <http://hyperland.com/TBLpage>
