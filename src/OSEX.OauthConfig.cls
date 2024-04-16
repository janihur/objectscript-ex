/// Management Portal
///  > System Administration
///   > Security
///    > OAuth 2.0
///     > Client
/// 
/// https://docs.intersystems.com/irisforhealth20221/csp/docbook/DocBook.UI.Page.cls?KEY=GOAUTH_configprog#GOAUTH_configprog_client
Class OSEX.OauthConfig Extends %RegisteredObject
{

ClassMethod Ex1()
{
    new $namespace
    set $namespace="%SYS"

    #dim status as %Status = $$$OK

    // server definition ------------------------------------------------------
    
    #dim server = ##class(OAuth2.ServerDefinition).%New()
    set server.IssuerEndpoint = "https://example.com/auth/"
    set server.SSLConfiguration = "ISC.FeatureTracker.SSL.Config"
    set server.AuthorizationEndpoint = "-"
    set server.TokenEndpoint = "https://example.com/auth/oauth/token"

    // zw server

    set status = server.%Save()
    if ($$$ISERR(status)) {
        write "Error: ",$system.Status.GetErrorText(status),!
        return
    }

    // client definition ------------------------------------------------------

    #dim client = ##class(OAuth2.Client).%New()
    set client.ApplicationName = "MyApp"
    set client.ClientType = "confidential"
    set client.ClientId = "myapp"
    set client.ClientSecret = "secret"
    set client.DefaultScope = "read-write-scope"
    set client.Description = "MyApp Description"
    set client.Enabled = 1

    #dim metadata = ##class(OAuth2.Client.Metadata).%New()
    set metadata."access_token_encrypted_response_alg" = "none"
    set metadata."access_token_encrypted_response_enc" = "none"
    set metadata."access_token_signed_response_alg" = "none"
    set metadata."frontchannel_logout_session_required" = 0
    set metadata."grant_types" = $listbuild("client_credentials")
    set metadata."id_token_encrypted_response_alg" = "none"
    set metadata."id_token_encrypted_response_enc" = "none"
    set metadata."id_token_signed_response_alg" = "RS256"
    set metadata."request_object_encryption_alg" = "none"
    set metadata."request_object_encryption_enc" = "none"
    set metadata."request_object_signing_alg" = "none"
    set metadata."token_endpoint_auth_method" = "client_secret_basic"
    set metadata."userinfo_encrypted_response_alg" = "none"
    set metadata."userinfo_encrypted_response_enc" = "none"
    set metadata."userinfo_signed_response_alg" = "none"
    set client.Metadata = metadata

    #dim redirectionEndpoint = ##class(OAuth2.Endpoint).%New()
    set redirectionEndpoint.Host = "localhost"
    // zw redirectionEndpoint
    set client.RedirectionEndpoint = redirectionEndpoint

    set client.SSLConfiguration = "ISC.FeatureTracker.SSL.Config"
    set client.ServerDefinition = server

    // zw client

    set status = client.%Save()
    if ($$$ISERR(status)) {
        write "Error: ",$system.Status.GetErrorText(status),!
        return
    }
}

ClassMethod Ex2()
{
    new $namespace
    set $namespace="%SYS"

    #dim metadata = ##class(OAuth2.Client.Metadata).%New()
    set metadata."access_token_encrypted_response_alg" = "none"
    set metadata."access_token_encrypted_response_enc" = "none"
    set metadata."access_token_signed_response_alg" = "none"
    set metadata."frontchannel_logout_session_required" = "0"
    set metadata."grant_types" = $listbuild("client_credentials")
    set metadata."id_token_encrypted_response_alg" = "none"
    set metadata."id_token_encrypted_response_enc" = "none"
    set metadata."id_token_signed_response_alg" = "RS256"
    set metadata."request_object_encryption_alg" = "none"
    set metadata."request_object_encryption_enc" = "none"
    set metadata."request_object_signing_alg" = "none"
    set metadata."token_endpoint_auth_method" = "client_secret_basic"
    set metadata."userinfo_encrypted_response_alg" = "none"
    set metadata."userinfo_encrypted_response_enc" = "none"
    set metadata."userinfo_signed_response_alg" = "none"
    zw metadata
    zw metadata.%Save()
}

}
