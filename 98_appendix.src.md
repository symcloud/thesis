\appendix

# \label{appendix_s3_metadata}Amazon S3 System-spezifische Metadaten

| Name | Description |
|------|-----|
| Date | Object creation date. |
| Content-Length | Object size in bytes. |
| Last-Modified | Date the object was last modified. |
| Content-MD5 | The base64-encoded 128-bit MD5 digest of the 
|  | object. |
| x-amz-server- | Indicates whether server-side encryption
| side-encryption | is enabled for the object, and whether 
|  | that encryption is from
|  | the AWS Key Management Service (SSE-KMS)
|  | or from AWS-Managed Encryption (SSE-S3).
| x-amz-version-id | Object version. When you enable
|  | versioning on a bucket, Amazon S3 assigns
|  | a version number to objects added to the
|  | bucket. |
| x-amz-delete-marker | In a bucket that has versioning enabled,
|  | this Boolean marker indicates whether the object is a
|  | delete marker. |
| x-amz-storage-class | Storage class used for storing the object. |
| x-amz-website- | Redirects requests for the
| redirect-location | associated object to another object in the same bucket
|  | or an external URL. |
| x-amz-server- | If the x-amz-server-side-encryption 
| side-encryption- | is present and has the value of aws:kms, this indicates
| aws-kms-key-id | the ID of the Key Management Service (KMS) master
|  | encryption key that was used for the object. |
| x-amz-server- | Indicates whether server-side encryption
| side-encryption- | with customer-provided encryption keys (SSE-C) is enabled.
| customer-algorithm 

  : Objekt Metadaten [@amazon2015b]\label{awz_object_metadata}

# \label{implementation_oauth}Exkurs: OAuth2

Für die Authentifizierung wurde das Protokoll OAuth in der Version 2 implementiert. Dieses offene Protokoll erlaubt eine standardisierte, sichere API-Autorisierung für Desktop, Web und Mobile-Applikationen. Initiiert wurde das Projekt von Blaine Cook und Chris Messina [@hammer2010oauth].

Die BenutzerIn kann einer Applikation den Zugriff auf seine Daten autorisieren, die von einer anderen Applikation zur Verfügung gestellt wird. Dabei werden nicht alle Details seiner Zugangsdaten preisgegeben. Typischerweise wird die Weitergabe eines Passwortes an Dritte vermieden [@hammer2010oauth].

## Begriffe

In OAuth2 werden folgende vier Rollen definiert:

Resource owner

:   BesitzerIn einer Ressource, die er für eine Applikation bereitstellen will [@hardt2012oauth, Seite 5].

Resource server

:   Der Server, der die geschützten Ressourcen verwaltet. Er ist in der Lage Anfragen zu akzeptieren und die geschützten Ressourcen zurückzugeben, wenn ein geeignetes und valides Token bereitgestellt wurde [@hardt2012oauth, Seite 5].

Client

:   Die Applikation stellt Anfragen im Namen des Ressourceneigentümers an den "resource server". Sie holt sich vorher die Genehmigung von einer berechtigten BenutzerIn [@hardt2012oauth, Seite 5].

Authorization server

:   Der Server, der die Zugriffs-Tokens nach der erfolgreichen Authentifizierung des Ressourceneigentümers bereitstellt [@hardt2012oauth, Seite 5].

Neben diesen Rollen spezifiziert OAuth2 folgende Begriffe:

Access-Token

:   Die Access-Tokens fungieren als Zugangsdaten zu geschützten Ressourcen. Es besteht aus einer Zeichenkette, die als Autorisierung für einen bestimmten Client ausgestellt wurde. Sie repräsentieren die "Scopes" und die Dauer der Zugangsberechtigung, die durch die BenutzerIn bestätigt wurde [@hardt2012oauth, Seite 9].

Refresh-Token

:   Diese Tokens werden verwendet, um neue Access-Tokens zu generieren, wenn das alte Access-Token abgelaufen ist. Wenn der Autorisierungsserver diese Funktionalität zur Verfügung stellt, liefert er es mit dem Access-Token aus. Der Refresh-Token besitzt eine längere Lebensdauer und berechtigt nicht den Zugang zu den anderen API-Schnittstellen [@hardt2012oauth, Seite 9].

Scopes

:   Mithilfe von Scopes, lassen sich Access-Token für bestimmte Bereiche der API beschränken. Dies kann sowohl auf Clientebene als auch auf Access-Token Ebene spezifiziert werden [@hardt2012oauth, Seite 22].

Die Interaktion zwischen Ressourcenserver und Autorisierungsserver ist nicht spezifiziert. Diese beiden Server können in der selben Applikation betrieben werden, aber auch eine verteilte Infrastruktur wäre möglich. Dabei würden die beiden auf verschiedenen Servern betrieben werden. Der Autorisierungsserver könnte in einer verteilten Infrastruktur Tokens für mehrere Ressourcenserver bereitstellen [@hardt2012oauth, Seite 5].

## Protokoll Ablauf

![Ablaufdiagramm des OAuth\label{oauth_flow} [@hardt2012oauth, Seite 7]](diagrams/oauth2/flow.png)

Der Ablauf einer Autorisierung [@hardt2012oauth, Seiten 7ff] mittels Oauth2, der in der Abbildung \ref{oauth_flow} abgebildet ist, enthält folgende Schritte:

A) Der Client fordert die Genehmigung des Ressourcenbesitzers. Diese Anfrage kann direkt an die BenutzerIn gestellt werden (wie in der Abbildung dargestellt) oder vorzugsweise indirekt über den Autorisierungsserver (wie zum Beispiel bei Facebook).
B) Der Client erhält einen "authorization grant". Er repräsentiert die Genehmigung des Ressourcenbesitzers, die geschützten Ressourcen zu verwenden.
C) Der Client fordert einen Token beim Autorisierungsserver mit dem "authorization grant" an.
D) Der Autorisierungsserver authentifiziert den Client, validiert den "authorization grant" und gibt einen Token zurück.
E) Der Client fordert eine geschützte Ressource und autorisiert die Anfrage mit dem Token.
F) Der Ressourcenserver validiert den Token und gibt die Ressource zurück.

## Zusammenfassung

OAuth2 wird verwendet, um es externen Applikationen zu ermöglichen, auf die Dateien der BenutzerIn zuzugreifen. Das Synchronisierungsprogramm Jibe verwendet dieses Protokoll, um die Autorisierung zu erhalten, die Dateien der BenutzerInnen zu verwalten.

# Installation

Dieses Kapitel enthält eine kurze Anleitung wie symCloud (inklusive JIBE) installiert und konfiguriert werden kann. Es umfasst eine einfache Methode auf einem System und ein verteiltes Setup mit beliebig vielen verbundenen Installationen.

## Systemanforderungen

Folgende Anforderungen werden an den Server und die Endgeräte gestellt, auf denen symCloud verwendet wird:

* Betriebssystem: Mac OSX oder Linux
* Webserver: apache oder nginx[^990] mit aktiviertem "URL rewriting"
* PHP: 5.5 oder höher
* Datenbank: MySQL oder PostgreSQL
* Tools: git, composer

Diese Anforderungen werden in weiterer Folge an das System gestellt. Die Installation dieser Komponenten werden in diesem Kapitel nicht beschrieben.

## Lokal

Um eine nicht verteilte Installation von symCloud durchzuführen, müssen folgende Schritte (siehe Listing \ref{install_symcloud_clone}) ausgeführt werden:

```{caption="Herunterladen von symCloud\label{install_symcloud_clone}"}
git clone git@github.com:symcloud/symcloud-standard.git
cd symcloud-standard
git checkout 0.1
cp app/config/admin/symcloud.yml.dist app/config/admin/symcloud.yml
cp app/Resources/pages/overview.xml.dist app/Resources/pages/overview.xml
```

Die Konfiguration der Installation erfolgen über die Dateien `app/admin/config/admin/symcloud.yml` und `app/Resources/webspaces/symcloud.io.xml`[^991]. Diese beiden Dateien enthalten die Informationen über die URLs und die verbundenen Installationen.

```{caption="Installieren von symCloud\label{install_symcloud_composer_install}"}
composer install
```

Diese beiden Scripts (Listing \ref{install_symcloud_clone} und \ref{install_symcloud_composer_install}) laden die nötigen Quellcode herunter und installiert die Abhängigkeiten. Um die Installation abzuschließen werden je nach System folgende Scripts ausgeführt, um die richtigen Rechte zu setzen.

Verwende folgendes Script um die Rechte auf Linux (siehe Listing \ref{install_symcloud_rights_linux}) zu setzen:

```{caption="Berechtigungen setzen in Linux\label{install_symcloud_rights_linux}"}
rm -rf app/cache/*
rm -rf app/logs/*
mkdir app/data
mkdir app/data/symcloud
sudo setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs uploads/media web/uploads/media app/data
sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs uploads/media web/uploads/media app/data
```

Für Mac OSX (siehe Listing \ref{install_symcloud_rights_mac}) folgendes Script:

```{caption="Berechtigungen setzen in Mac OSX\label{install_symcloud_rights_mac}"}
rm -rf app/cache/*
rm -rf app/logs/*
mkdir app/data
mkdir app/data/symcloud
APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd' | grep -v root | head -1 | cut -d\  -f1`
sudo chmod +a "$APACHEUSER allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs uploads/media web/uploads/media app/data
sudo chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs uploads/media web/uploads/media app/data
```

Anschließend werden über folgendes Kommando (siehe Listing \ref{install_symcloud_sulu}) die Datenbank initialisiert, eine Administrator BenutzerIn eingerichtet und der Speicher für die AdministratorIn vorbereitet.

```{caption="SULU und symCloud konfigurieren\label{install_symcloud_sulu}"}
app/console doctrine:database:create
app/console sulu:build dev
app/console symcloud:storage:init admin
```

Die Ausgabe des letzten Befehls sollte notiert werden, da dies für die Einrichtung des Synchronisierunsclient gebraucht wird. Abschließend kann sich die AdministratorIn über `http://symcloud.lo/admin` einloggen (Benutzername: "admin", Passwort: "admin") und das System benutzen.

## Jibe

Für den Client muss zuerst folgender Schritte (siehe \ref{install_symcloud_auth2}) auf dem Server ausgeführt werden:

```{caption="OAuth2 Client erstellen\label{install_symcloud_auth2}"}
app/console symcloud:oauth2:create-client jibe www.example.com
```

An die Endgeräte werden die selben Anforderungen wie an den Server gestellt. Der PHAR Container kann unter der URL <???> heruntergeladen werden. Die Ausgabe der Kommandos aus Listing \ref{install_symcloud_auth2} und \ref{install_symcloud_sulu} werden benötigt, um den Client zu Konfigurieren (siehe \ref{install_symcloud_jibe}). Die beiden Platzhalter `<hash-algorithm>` und `<hash-key>` werden ersetzt mit den in der Installation (siehe Listing \ref{install_symcloud_composer_install}) angegeben werden.

```{caption="Jibe konfigurieren und starten\label{install_symcloud_jibe}"}
php jibe.phar configure --hash-algorithm <hash-algorithm> --hash-key <hash-key>
php jibe.phar sync
```

Das zweite Kommando startet direkt eine Synchronisierung des aktuellen Ordners.

## Verteilt

Um eine verteilte Installation durchzuführen, werden die Schritte auf den vorangegangen Abschnitt auf mindestens zwei verschiedenen Servern durchgeführt (oder der selbe Server mit verschiedenen VHosts). Um die Installationen zu verbinden wird in der Konfigurationsdatei `app/admin/config/admin/symcloud.yml` die verbunden Server abgelegt.

```{caption="Verteilung in symCloud konfigurieren\label{install_symcloud_distribution}"}
symcloud_storage:
    servers:
        primary: {host: my.symcloud.lo}
        backups:
            - {host: your-1.symcloud.lo}
            - {host: your-2.symcloud.lo}
```

Im Listing \ref{install_symcloud_distribution} werden die verbundenen Server angegeben. Wobei für den primary Server die URL des aktuellen Servers und unter den Backups eine Liste von weiteren Servern angegeben werden.

## Beispiel von der beiliegenden CD

Um symCloud möglichst schnell auszuprobieren, liegt auf der beiliegenden CD (`/example`) eine Beispiel Installation von zwei Knoten, die ohne weitere Abhängigkeiten verwendet werden können. Um die Installationen zu initialisieren sollte der Ordner `/example` an einen beschreibbaren Ort (zum Beispiel der Benutzerordner) kopiert werden. Beide Installationen enthalten eine Konfigurationsdatei, in der die Zugangsdaten zur Datenbank angepasst werden sollten.

Das folgende Script initialisiert den ersten Knoten im Ordner `my.symcloud.lo`:

```{caption="my.symcloud.lo initialisieren"}
cd my.symcloud.lo
app/console doctrine:database:create
app/console sulu:build dev
app/console symcloud:storage:init admin
app/console symcloud:oauth2:create-client jibe www.example.com
```

Das folgende Script initialisiert den ersten Knoten `your.symcloud.lo`:

```{caption="your.symcloud.lo initialisieren"}
cd your.symcloud.lo
app/console doctrine:database:create
app/console sulu:build dev
```

Die beiden Server können mit dem Kommando `app/console server:run my.symcloud.lo:8000 --router=app/config/router_admin.php` und `app/console server:run your.symcloud.lo:8001 --router=app/config/router_admin.php` gestartet werden.

Das Beispiel enthält auch einen Ordner `/test-data` indem der Client `jibe.phar` und zwei Testdateien vorbereitet sind. Der Ordner kann mit dem folgenden Script synchronisiert werden:

```{caption="Jibe ausführen"}
php jibe.phar configure -s http://my.symcloud.lo:8000 -u admin -p admin
php jibe.phar sync
```

Die Daten werden mit dem Server `my.symcloud.lo` synchronisiert und die Daten mit dem zweiten Server geteilt. Dies kann mit dem folgenden Kommandos überprüft werden:

```{caption="Datenbank Größen ausgeben"}
cd my.symcloud.lo
du -sh app/data/symcloud/database/*
cd ../your.symcloud.lo
du -sh app/data/symcloud/database/*
```

Beide Ordner enthalten den Eintrag `app/data/symcloud/database/chunk`, indem die `chunks` der Dateien abgelegt sind.

## Zusammenfassung

Dieses Kapitel beschreibt den Installationsprozess von symCloud. Es zeigt, dass die Installation ohne große Abhängigkeiten und zeitlicher Aufwand erledigt werden kann. Auch die Konfiguration in einer verteilten Umgebung ist mit nur wenigen Schritten möglich.

[^990]: <http://docs.sulu.io/en/latest/book/getting-started/vhost.html>
[^991]: <http://docs.sulu.io/en/latest/book/getting-started/setup.html#webspaces>
