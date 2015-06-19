# Anhang {.unnumbered}

## \label{appendix_s3_metadata}Amazon S3 System-spezifische Metadaten {.unnumbered}

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

## \label{implementation_oauth}Exkurs: OAuth2 {.unnumbered}

Für die Authentifizierung wurde das Protokoll OAuth in der Version 2 implementiert. Dieses offene Protokoll erlaubt eine standardisierte, sichere API-Autorisierung für Desktop, Web und Mobile-Applikationen. Initiiert wurde das Projekt von Blaine Cook und Chris Messina [@hammer2010oauth].

Der Benutzer kann einer Applikation den Zugriff auf seine Daten autorisieren, die von einer anderen Applikation zur Verfügung gestellt wird. Dabei werden nicht alle Details seiner Zugangsdaten preisgegeben. Typischerweise wird die Weitergabe eines Passwortes an Dritte vermieden [@hammer2010oauth].

### Begriffe {.unnumbered}

In OAuth2 werden folgende vier Rollen definiert:

Resource owner

:   Besitzer einer Ressource, die er für eine Applikation bereitstellen will [@hardt2012oauth, Seite 5].

Resource server

:   Der Server, der die geschützten Ressourcen verwaltet. Er ist in der Lage Anfragen zu akzeptieren und die geschützten Ressourcen zurückzugeben, wenn ein geeignetes und valides Token bereitgestellt wurde [@hardt2012oauth, Seite 5].

Client

:   Die Applikation stellt Anfragen im Namen des Ressourceneigentümers an den "resource server". Sie holt sich vorher die Genehmigung von einem berechtigten Benutzer [@hardt2012oauth, Seite 5].

Authorization server

:   Der Server, der die Zugriffs-Tokens nach der erfolgreichen Authentifizierung des Ressourceneigentümers bereitstellt [@hardt2012oauth, Seite 5].

Neben diesen Rollen spezifiziert OAuth2 folgende Begriffe:

Access-Token

:   Die Access-Tokens fungieren als Zugangsdaten zu geschützten Ressourcen. Es besteht aus einer Zeichenkette, die als Autorisierung für einen bestimmten Client ausgestellt wurde. Sie repräsentieren die "Scopes" und die Dauer der Zugangsberechtigung, die durch den Benutzer bestätigt wurde [@hardt2012oauth, Seite 9].

Refresh-Token

:   Diese Tokens werden verwendet, um neue Access-Tokens zu generieren, wenn das alte Access-Token abgelaufen ist. Wenn der Autorisierungsserver diese Funktionalität zur Verfügung stellt, liefert er es mit dem Access-Token aus. Der Refresh-Token besitzt eine längere Lebensdauer und berechtigt nicht den Zugang zu den anderen API-Schnittstellen [@hardt2012oauth, Seite 9].

Scopes

:   Mithilfe von Scopes, lassen sich Access-Token für bestimmte Bereiche der API beschränken. Dies kann sowohl auf Clientebene als auch auf Access-Token Ebene spezifiziert werden [@hardt2012oauth, Seite 22].

Die Interaktion zwischen Ressourcenserver und Autorisierungsserver ist nicht spezifiziert. Diese beiden Server können in der selben Applikation betrieben werden, aber auch eine verteilte Infrastruktur wäre möglich. Dabei würden die beiden auf verschiedenen Servern betrieben werden. Der Autorisierungsserver könnte in einer verteilten Infrastruktur Tokens für mehrere Ressourcenserver bereitstellen [@hardt2012oauth, Seite 5].

### Protokoll Ablauf {.unnumbered}

![Ablaufdiagramm des OAuth\label{oauth_flow} [@hardt2012oauth, Seiten 7]](diagrams/oauth2/flow.png)

Der Ablauf einer Autorisierung [@hardt2012oauth, Seiten 7 ff] mittels Oauth2, der in der Abbildung \ref{oauth_flow} abgebildet ist, enthält folgende Schritte:

A) Der Client fordert die Genehmigung des Ressourcenbesitzers. Diese Anfrage kann direkt an den Benutzer gestellt werden (wie in der Abbildung dargestellt) oder vorzugsweise indirekt über den Autorisierungsserver (wie zum Beispiel bei Facebook).
B) Der Client erhält einen "authorization grant". Er repräsentiert die Genehmigung des Ressourcenbesitzers, die geschützten Ressourcen zu verwenden.
C) Der Client fordert einen Token beim Autorisierungsserver mit dem "authorization grant" an.
D) Der Autorisierungsserver authentifiziert den Client, validiert den "authorization grant" und gibt einen Token zurück.
E) Der Client fordert eine geschützte Ressource und autorisiert die Anfrage mit dem Token.
F) Der Ressourcenserver validiert den Token und gibt die Ressource zurück.

### Zusammenfassung {.unnumbered}

OAuth2 wird verwendet, um es externen Applikationen zu ermöglichen, auf die Dateien der Benutzer zuzugreifen. Das Synchronisierungsprogramm Jibe verwendet dieses Protokoll, um die Autorisierung zu erhalten, um die Dateien des Benutzers zu verwalten.


## Installation {.unnumbered}

Dieses Kapitel enthält eine kurze Dokumentation wie Symcloud (inklusive JIBE) installiert und deployed werden kann. Es umfasst eine einfache Methode auf einem System und ein verteiltes Setup.

### Lokal {.unnumbered}

### Verteilt {.unnumbered}

# Literaturverzeichnis {.unnumbered}
