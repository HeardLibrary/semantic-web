# Acquiring Data using SPARQL

Notes for the 2017-11-06 meeting

##SWWG SPARQL endpoint

human form interface: http://sparql.vanderbilt.edu/

machine endpoint URI: http://sparql.vanderbilt.edu/sparql

## Download Postman

Download and install Postman, a client for making HTTP requests and retrieving the responses.  It's available for Mac, PC, and Linux.  It used to be a Chrome plugin, but now is a standalone application.  If you've previously used the Chrome plugin, I recommend that you disable it and download the standalone application because it has greater capabilities.  

https://www.getpostman.com/

## Example query: photography constituents in Paris

The following query restricts constituents (people or studios) to those that have at least one address in Paris.  It reports the name and start date of the constituent:

```
prefix foaf: <http://xmlns.com/foaf/0.1/>
prefix dcterms: <http://purl.org/dc/terms/>
prefix gvp: <http://vocab.getty.edu/ontology#>
prefix grid: <http://www.grid.ac/ontology/>
prefix ex: <http://example.org/>

SELECT DISTINCT ?name ?startDate
FROM <http://pic.nypl.org/>
WHERE {
  ?constituent a dcterms:Agent.
  ?constituent foaf:name ?name.
  ?constituent gvp:estStart ?startDate.
  ?address ex:hasConstituent ?constituent.
  ?address grid:cityName "Paris".
        }
```

It's a minor modification of one we did earlier (https://gist.github.com/baskaufs/56e1b35480fd53757ca41dc138f934a8).  You can try it by pasting it in the human-readable form interface.  It should produce 52 results.

## Making a query using HTTP POST

It is relatively easy to make a SPARQL query using Postman.  However, there are several details you must be careful about in order to get it to work:

1. To send a plain text query (the easiest way), you MUST set the Content-Type header as application/sparql-query.  In Postman, click on the Headers tab just below the URL box.  In the Key column, enter "Content-Type" (it should autofill) and in the Value column enter "application/sparql-query".  See the SPARQL 1.1 Protocol (https://www.w3.org/TR/sparql11-protocol/) for details.

2. The SWWG SPARQL endpoint guards against unauthorized modifications of the triplestore by requiring authorization to perform an HTTP POST.  Not every endpoint has this restriction.  To make a POST request, click on the Authorization tab, select Basic Auth in the Type dropdown, and enter the Username and Password that you should know if you are a regular SWWG attendee.  When you make the request, Postman will automatically generate an Authorization header that will show up in the list of headers.

3. Under the Body tab, you should click on the "raw" radio button.  The type of text will default to "Text" and that's fine.

If you have done these three things, you are ready to go.  With the Body tab clicked, there will be a box under the radio buttons, and you can paste the query from above into the box.  Click the Send button and see what happens.

Below the box where you pasted the query is the results section.  The Status should show an HTTP response code of 200 (OK).  If you click on the headers tab (below the query you sent, not above it), you will see the Content-Type of the response.  The default is application/sparql-results+xml.  If you click on the Body tab (below your query, not above), you will see the response body, which by default is in a particular XML format specified by https://www.w3.org/TR/rdf-sparql-XMLres/. You can copy the results body to your computer's clipboard by clicking on the little papers icon (just to the left of the magnifying glass icon) above the response body.

You can get the results in other forms by a request header.  Under the top Headers tab (above the request, not below it), in the Key column, enter "Accept" and in the Value column, enter "application/json".  Click the Send button and look at the response body.  The response Content-Type header will now say "application/sparql-results+json".  See https://www.w3.org/TR/sparql11-results-json/ for details on the JSON response format.

Now try an Accept header of text/csv.  The response will be in CSV format, and the response Content-Type header will be "text/csv".  See https://www.w3.org/TR/sparql11-results-csv-tsv/ for details on the CSV response format.  By copying and pasting the results into a text editor and saving them, the results can be opened in Excel in tabular form.  

## Making a query using HTTP GET

Making a query using HTTP GET is in some ways simpler that using POST.  There is no Content-Type header required and the SWWG SPARQL endpoint does not require any authorization for HTTP GET, since only read requests can be made with it.  However, when HTTP GET is used, the query is sent to the endpoint as a query string appended to the URI, not as the body of the request.  Because of this, the query must be URL encoded to eliminate characters that aren't allowed as part of a URL.  

The easiest way to URL-encode a query manually is by using a website that will do the encoding for you.  My preferred one is https://meyerweb.com/eric/tools/dencoder/.  To use it, just copy the query, paste it into the box, and click the Encode button.  The resulting gibberish can be copied and pasted as the query string.  

Here's how to perform the operation using Postman.  Open a new request tab by clicking on the + (plus) sign.  Change the dropdown from POST to GET if necessary.  In the URL box, paste this:

```
https://sparql.vanderbilt.edu/sparql?query=
```

followed by the URL-encoded gibberish copied from the URL-encoding website box.  There is no need to do anything else if you are OK with receiving the XML response format.  Just click the Send button and examine the response body.  

If you would prefer one of the other response formats (JSON or CSV), set the request Accept header to application/json or text/csv as with the POST method.

## Wikidata as RDF triples

The Wikidata home page is at https://www.wikidata.org/

You can search for a thing by typing in the search box at the top of the page.  We will be looking for presidents.  We want "leader of a country or part of a country, usually in republics".  Selecting that takes you to the page https://www.wikidata.org/wiki/Q30461, which describes the entity "president".  Wikidata has a data model that is somewhat weird from the Linked Data/Semantic Web perspective.  

There is generally only one kind of thing they describe: an "Item".  An item is basically anything that one would describe in a Wikipedia article.  So rather than typing resources as members various well-known classes, everything is rdf:type wikibase:Item (http://wikiba.se/ontology-beta#Item).  Wikidata "items" are identified by URIs like wd:Q11696 (http://www.wikidata.org/entity/Q11696).  wd:Q11696 represents the position "President of the United States of America".  wd:Q23 represents the person whose name is "George Washington".  wd:Q316 represents the emotion "love".  An emotion, a person, and a position are all instances of "wikibase:Item".

Properties are identified by URIs like wdt:P39 (http://www.wikidata.org/prop/direct/P39).  wdt:P39 is the property "position held".  Some other properties are wdt:P31 (instance of), wdt:P19 (place of birth), wdt:P21 (sex or gender), and many others.  The property wdt:P31 is a bit fuzzy, because usually we would think that the object of "instance of" would be a class.  But the object of wdt:P31 is just another item (since pretty much everything is a nebulous "item").

So items in wikidata are linked in triples as is the case in conventional RDF, but the wikidata predicates generally don't correspond to any "standard" Linked Data properties, and items are not typed as instances of standard Linked Data classes.  So it is not really feasible to directly export Wikidata triples and expect them to merge seamlessly with other Linded Data RDF.  However, because they are modeled as RDF triples, they can be queried using SPARQL in the conventional manner using the Wikidata SPARQL endpoint.

## The Wikidata SPARQL endpoint

The Wikidata SPARQL endpoint human interface is at https://query.wikidata.org/.  Queries can be pasted into the box as with the SWWG SPARQL endpoint, but the Wikidata interface is much fancier, with built-in label display and special ways of displaying the results.  We won't explore those features today, but you should check them out.  

Note that the Wikidata SPARL endpoint lets you get away with omitting the namespace declarations for wd: and wdt:.

Try this query:

```
SELECT DISTINCT ?president
WHERE
{
  ?president wdt:P39 wd:Q11696.
}
```

The query looks for values of ?president where ?president "position held" "President of the United States of America".   It produces 76 results, which is more than the 44.  To see why, try this one:

```
SELECT DISTINCT ?president ?name
WHERE
{
  ?president wdt:P39 wd:Q11696.
  ?president rdfs:label ?name.
  FILTER (lang(?name)="en")
}
```

We need to filter out fictional presidents like "Josiah Bartlet" and "Gonzo the Mechanical Bastard".  We can add the triple pattern
```
  ?president wdt:P31 wd:Q5.
```
which requires that ?president be an instance of "human".  

We could get some more information about the presidents, like their birth dates (wdt:P569) and VIAF identifiers (wdt:P214) like this:

```
SELECT DISTINCT ?president ?name ?birth ?viaf
WHERE
{
  ?president wdt:P39 wd:Q11696.
  ?president rdfs:label ?name.
  FILTER (lang(?name)="en")
  ?president wdt:P31 wd:Q5.
  ?president wdt:P569 ?birth.
  ?president wdt:P214 ?viaf.
}
```

## Querying the Wikidata SPARQL endpoint using Postman

We can query the Wikidata SPARQL endpoint using Postman using POST just as we did for the SWWG endpoint, except that no password is required (remember to set the Content-Type as application/sparql-query).  The machine-accessible endpoint URI is https://query.wikidata.org/sparql.  Using an Accept header of text/csv, we can retrieve the data in a form that we could treat as an Excel table.  

## SPARQL construct

We have been using the SPARQL SELECT query form so far.  There is another query form that allows you to construct RDF triples based on the pattern matching specified in a particular graph pattern.  If we wanted to use the Wikidata data as conventional RDF, it would be good to map the Wikidata properties to properties from well-known Linked Data vocabularies.  Here are some suggestions:

for the name use foaf:name (http://xmlns.com/foaf/0.1/name)

for the birth date use schema:birthDate (http://schema.org/birthDate)

for the VIAF identifier use dcterms:identifier (http://purl.org/dc/terms/identifier)

Here is a CONSTRUCT query that would accomplish this mapping:

```
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
CONSTRUCT {
  ?president foaf:name ?name.
  ?president a foaf:Person.
  ?president schema:birthDate ?birth.
  ?president dcterms:identifier ?id.
}
WHERE
{
  ?president wdt:P39 wd:Q11696.
  ?president rdfs:label ?name.
  FILTER (lang(?name)="en")
  ?president wdt:P31 wd:Q5.
  ?president wdt:P569 ?birth.
  ?president wdt:P214 ?viaf.
  BIND (CONCAT("http://viaf.org/viaf/",?viaf) AS ?id)
}
```

In the Wikidata human interface, the results are shown in a subject, predicate, object table.  If the query is sent by Postman to https://query.wikidata.org/sparql with an Accept: header of text/turtle, the results will be returned in RDF/Turtle serialization, which can be saved in a file and loaded into a triplestore like ours.  

## Pulling data from a SPARQL endpoint programmatically

### Web page (Javascript/jQuery)

For an example showing how to retrieve data using Javascript/jQuery and use it in a web page, see "Step 6" of http://baskauf.blogspot.com/2017/07/how-and-why-we-set-up-sparql-endpoint.html

### XQuery

Here is an example showing how to retrieve data using XQuery (downloadable from https://github.com/HeardLibrary/semantic-web/blob/master/2017-fall/data-from-sparql.xq):

```
declare default element namespace "http://www.w3.org/2005/sparql-results#";

declare function local:query-endpoint($endpoint,$query)
{
(: Assumes default response is XML, if not then figure out how to send an Accept request header :)
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
```
