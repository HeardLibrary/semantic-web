# Learning SPARQL book group, chapter 3, part 1

Steve Baskauf 2015-10-26

## SPARQL Queries: A deeper dive

EasyRdf Graph dumper (thanks Jacob Shelby, Parks Library, Iowa State University!):
[http://jacobshelby.org/easyrdf/examples/dump.php](http://jacobshelby.org/easyrdf/examples/dump.php)

Explore: http://bioimages.vanderbilt.edu/vanderbilt/7-314

LodLive visualizer.  Bubbles=IRI-identified resources, "text" bubble shows images/text/links
[http://en.lodlive.it/](http://en.lodlive.it/)

Endpoint:

[http://rdf.library.vanderbilt.edu/sparql?view](http://rdf.library.vanderbilt.edu/sparql?view)

Queries can be run from the paste-in box.  
## Starter query to find the properties (predicates) used to describe the dcterms:Location instance:
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX  prov: <http://www.w3.org/ns/prov#>

PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX  viaf: <http://viaf.org/viaf/>
PREFIX  orcid: <http://orcid.org/>

PREFIX dbpedia: <http://dbpedia.org/>
PREFIX dbres: <http://dbpedia.org/resource/>
PREFIX dbp: <http://dbpedia.org/property/>
PREFIX dbo: <http://dbpedia.org/ontology/>

PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX dsw: <http://purl.org/dsw/>
PREFIX gn: <http://www.geonames.org/ontology#>

SELECT DISTINCT ?prop ?value
WHERE {
      <http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> ?prop ?value.
      }
Limit 30
```
### 1. Find the GeoNames features that are associated with this Location and present human-readable names:
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:name ?name.
      }
```
### 2. Distinguish between places that are administrative subdivisions (gn:featureClass gn:A) and those that are "spots" (gn:featureClass gn:S):
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:featureClass gn:S.
      ?place gn:name ?name.
      }
```
### 3. Find the parent feature of this place:
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:featureClass gn:S.
      ?place gn:parentFeature ?parent.
      ?parent gn:name ?name.
      }
```
### 4. Find ALL parent features of this place:
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:featureClass gn:S.
      ?place gn:parentFeature+ ?parent.
      ?parent gn:name ?name.
      }
```
Try also * and two levels up: ?place gn:parentFeature/gn:parentFeature ?parent.

### 5. Find alternative names:
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:featureClass gn:S.
      {?place gn:name ?name.}
          UNION
      {?place gn:alternateName ?name.}
      }
```
### 6. Note different behavior with OPTIONAL:
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:featureClass gn:S.
      OPTIONAL {?place gn:name ?name.}
      OPTIONAL {?place gn:alternateName ?name.}
      }
```
### 7. or shortcut way using logical OR (with the pipe "|" symbol):
```
SELECT DISTINCT ?name
WHERE {
<http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14loc> dwciri:inDescribedPlace ?place.
      ?place gn:featureClass gn:S.
      {?place (gn:name|gn:alternateName) ?name.}
      }
```
### 8. Linking across the graph
Find things that occur at Vanderbilt University:
```
SELECT DISTINCT ?thing
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:name "Vanderbilt University".
      }
Limit 30
```
### 9. Limit the things to Living Specimens (rdf:type dwc:LivingSpecimen):
```
SELECT DISTINCT ?thing
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?thing a dwc:LivingSpecimen.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:name "Vanderbilt University".
      }
Limit 30
```
### 10. Give the common names for the things (remove Living Specimen requirement):
```
SELECT DISTINCT ?commonName
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:name "Vanderbilt University".
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      }
Limit 30
```
### 11. Give common names and IRIs for things occurring in Canada, Alaska, Beaman Park:
```
SELECT DISTINCT ?commonName ?thing
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:parentFeature* ?parent.
      ?parent gn:name "Canada".
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      }
Limit 30
```
### 12. Try filter for Smoky Mountain:
```
SELECT DISTINCT ?commonName
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:parentFeature* ?parent.
      ?parent gn:name ?name.
      FILTER (CONTAINS(str(?name),"Great Smoky"))
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      }
Limit 30
```
### 13. Find pictures of bears and say what state they are in (note: states are 1st level administrative jurisdictions and coded as gn:featureCode gn:A.ADM1:
```
SELECT DISTINCT ?name ?commonName
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:parentFeature* ?parent.
      ?parent gn:featureCode gn:A.ADM1.
      ?parent gn:name ?name.
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      FILTER (CONTAINS(str(?commonName),"bear"))
      }
Limit 30
```
Better to try:
```
SELECT DISTINCT ?name ?commonName
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:parentFeature* ?parent.
      ?parent gn:featureCode gn:A.ADM1.
      ?parent gn:name ?name.
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      ?ID dwc:genus "Ursus".
      }
Limit 30
```
### 14. List place name in all languages:
```
SELECT DISTINCT ?name ?commonName
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:parentFeature* ?parent.
      ?parent gn:featureCode <http://www.geonames.org/ontology#A.ADM1>.
      {?parent (gn:name|gn:alternateName) ?name.}
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      ?ID dwc:genus "Ursus".
      }
Limit 30
```
### 15. Filter the place names to only Japanese:
```
SELECT DISTINCT ?name ?commonName
WHERE {
      ?thing dsw:hasOccurrence ?occur.
      ?occur dsw:atEvent ?event.
      ?event dsw:locatedAt ?loc.
      ?loc dwciri:inDescribedPlace ?place.
      ?place gn:parentFeature* ?parent.
      ?parent gn:featureCode <http://www.geonames.org/ontology#A.ADM1>.
      {?parent (gn:name|gn:alternateName) ?name.}
      ?thing dsw:hasIdentification ?ID.
      ?ID dwc:vernacularName ?commonName.
      ?ID dwc:genus "Ursus".
      FILTER (lang(?name)="ja")
      }
Limit 30
```

NOTE: GeoNames RDF has rdfs:seeAlso link to DBpedia IRIs.  Good for federated queries!
