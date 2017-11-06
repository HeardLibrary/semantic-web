declare default element namespace "http://www.w3.org/2005/sparql-results#";

declare function local:query-endpoint($endpoint,$query)
{ 
let $encoded := $endpoint||encode-for-uri($query)
let $request := <http:request href='{$encoded}' method='get'/>
return
  http:send-request($request)
};

let $query := 'prefix foaf: <http://xmlns.com/foaf/0.1/>
prefix dcterms: <http://purl.org/dc/terms/>
prefix gvp: <http://vocab.getty.edu/ontology#>
prefix grid: <http://www.grid.ac/ontology/>
prefix ex: <http://example.org/>

SELECT DISTINCT ?name ?startDate
FROM <http://pic.nypl.org/>
WHERE {
  ?person a dcterms:Agent.
  ?person foaf:name ?name.
  ?person gvp:estStart ?startDate.
  ?address ex:hasConstituent ?person.
  ?address grid:cityName "Paris".
        }'
let $endpoint := "https://sparql.vanderbilt.edu/sparql?query="
let $response := local:query-endpoint($endpoint,$query)
for $result in $response[2]/sparql/results/result
return ("Name: "||$result/binding[@name="name"]/literal/text()||"  Start date: "||$result/binding[@name="startDate"]/literal/text() )
