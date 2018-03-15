(: Note: this takes a really lon time to run because it has to make 17,000+ HTTP calls.  The input file may need to be broken into smaller pieces :)

declare namespace search="http://www.orcid.org/ns/search";
declare namespace common="http://www.orcid.org/ns/common";
declare namespace http="http://expath.org/ns/http-client";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rdfs = "http://www.w3.org/2000/01/rdf-schema#";
declare namespace prism = "http://prismstandard.org/namespaces/basic/2.1/";
declare namespace bibo = "http://purl.org/ontology/bibo/";

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


(: let $textDoi := http:send-request(<http:request method='get' href='https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2018-spring/vu-people/vanderbilt-doi.csv'/>)[2] :)
let $textDoi := file:read-text('file:///c:/test/vanderbilt-doi.csv')
let $xmlDoi := csv:parse($textDoi, map { 'header' : true(),'separator' : "," })

return (file:write("c:\test\orcid\doi.rdf",<rdf:RDF>{
      for $doiRecord in $xmlDoi/csv/record
      let $uri := $doiRecord/work/text()
      
      (: let $uri := "http://dx.doi.org/10.1002/0470007745.ch15"
      let $uri := "http://dx.doi.org/10.1002/(SICI)1096-8628(19960809)64:2&lt;278::AID-AJMG9&gt;3.0.CO;2-Q" :)
      
      let $redirectUri := local:get-redirect($uri)
      
      return if ($redirectUri = "error")
             then element rdf:Description { 
                           attribute rdf:about {$uri},
                           <prism:doi>{substring-after($uri,"http://dx.doi.org/")}</prism:doi>,
                           <bibo:doi>{substring-after($uri,"http://dx.doi.org/")}</bibo:doi>,
                           <rdfs:comment>bad doi</rdfs:comment>
                           }
             else local:query-endpoint($redirectUri)[2]/rdf:RDF/rdf:Description
}</rdf:RDF>
))