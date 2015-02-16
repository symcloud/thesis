# Notizen

Es bieten sich an dieser Stelle 2 große Themen (mit meiner Meinung nach Thesis Relevanz). Je nach Schwerpunkt der
Schriftlichen Arbeit würde ich den jeweils anderen Teil hinten anstellen.

In beiden Varianten würde ein File-Abstraction-Layer entstehen, der den Datei Zugriff abstrahieren würde und damit
den Storage der Daten verbirgt. Ebenfalls in beiden Fällen würde ich standardmässig auf GIT setzen, da ich es spannend
finde diese Technologie mal anders zu verwenden. Durch diese Abstraktion sollte es kein Problem sein später einen
anderen Storage zu verwenden (bsp.: Dateisystem und Webdav), falls sich herausstellt, dass git ungeeignet für das
Projekt ist.

Der große Vorteil, den ich an GIT sehe und warum ich daran festhalten will ist:

* Funktionierende komprimierung
* Automatische Versionierung
* Volle Kontrolle der Daten, da unabhängig von der Software
* HTTP-Schnittstelle
* Erweiterbar und daher gut geeignet um eigene Scripts einzubinden

Nachteile, die allerdings entstehen könnten:

* Große History durch unendliche Versionen
* Schwierigeres Teilen eines Teils der Daten
* Verschlüsselung Client seitig, daher keinen Zugriff auf die Daten am Server (wenn aktiviert)

## P2P File-Sharing und Groupware

Ein spannendes Thema wäre eine durchleuchtung von Diaspora und die ummünzung auf Symcloud. Wie in der Einleitung schon
erläutert, ermöglich Diaspora die vernetzung von Knoten untereinander. Dies wäre auch bei einer File-Sync Platform
sinnvoll.

Denkt man zum Beispiel an eine Firma mit mehreren Standorten, einige der Daten werden von beiden Standorten genutzt,
einige jeweils nur von einem. Teile dieser Daten werden aber unter den Nutzern beider Standorte geteilt. Da wäre es
doch sinnvoll, wenn die Nutzerdaten der Server synchronisiert und damit es ermöglichen jeweils den nächsten Server
zu verwenden um seine Daten zu verwalten. Ausserdem könnten gewisse Daten, die in beiden Standorten verwendet werden
synchroniert und damit ermöglichen immer schnell an seine Daten zu gelangen, auch wenn man zu Gast beim anderen
Standort ist. Dazu könnte dann das LAN verwendet werden.

GIT würde auch hier mit seinem dezentralen System helfen diese Möglichkeiten voll auszuschöpfen. Für die verteilung der
Nutzerdaten könnte ein sicherer Tunnel aufgebaut werden und die Daten dadurch sicher von A nach B Transportiert werden.

Interresante Themen wäre hier:

* Der sichere Austausch von Daten
* Die Anmeldung an einem fremden (verbundenen) Server der mein Passwort nicht wissen sollte (oAuth könnte eine Lösung
  sein)
* Damit verbunden könnte der Fokus mehr auf die Platform gelegt werden und dort eine Art Sozial Media, Colaboration
  aufgebaut werden.

Es wäre sicher eine Spannende Sache und damit verbunden eine Herausforderung in der Implementierung.

__Interresant Links:__

* <https://tent.io/>: protocol for personal data and communications ... Tent is an open protocol for personal evented data vaults and decentralized real-time communication. Tent has two APIs: one lets Tent apps talk to Tent servers, the other lets Tent servers talk to each other. A Tent server can have one or many users, and anyone can run their own Tent server. (<https://wiki.diasporafoundation.org/Diaspora_powered_by_Tent>)
* <http://xanadu.com/>: ???
* <https://github.com/depot/depot>: PHP-Library for tent
* <https://github.com/Cacauu/librejo>: -||-
* <http://florianjacob.de/tentio-new-hope.html>: Blog Post about tent.io
* <https://github.com/tent/tent.io/wiki/Related-projects>
* <https://wiki.diasporafoundation.org/Diaspora_powered_by_Tent#Missing_Tent_Features>: Diaspora powered by Tent
