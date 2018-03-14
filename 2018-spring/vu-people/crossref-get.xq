declare namespace search="http://www.orcid.org/ns/search";
declare namespace common="http://www.orcid.org/ns/common";
declare namespace http="http://expath.org/ns/http-client";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";

(: the initial response to dereferencing the DOI is a 303 redirect that returns the actual URL :)
declare function local:get-redirect($uri as xs:string) as xs:string
{
let $response := local:query-endpoint($uri)
return if (string($response[1]/@status)="303")
       then $response[2]/html/body/a/text()
       else "error"
};

declare function local:query-endpoint($endpoint as xs:string)
{
let $acceptType := "application/rdf+xml"
let $request := <http:request href='{$endpoint}' method='get'><http:header name='Accept' value='{$acceptType}'/></http:request>
return http:send-request($request)
};

let $uri := "http://dx.doi.org/10.1002/0470007745.ch15"
(: let $uri := "http://dx.doi.org/10.1002/(SICI)1096-8628(19960809)64:2&lt;278::AID-AJMG9&gt;3.0.CO;2-Q" :)
let $redirectUri := local:get-redirect($uri)

return if ($redirectUri = "error")
then $uri
else local:query-endpoint($redirectUri)[2]/rdf:RDF/rdf:Description
