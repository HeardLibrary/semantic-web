#Learning SPARQL Chapter 3 - part 2 (answers)

Steve Baskauf 2015-11-02

## Background

To get to lodlive and start with the Bicentennial Oak:
[http://en.lodlive.it/?http://bioimages.vanderbilt.edu/vanderbilt/7-314](http://en.lodlive.it/?http://bioimages.vanderbilt.edu/vanderbilt/7-314)

Traverse the graph to Feature by: 

- dsw:hasOccurrence to http://bioimages.vanderbilt.edu/vanderbilt/7-314#2002-06-14
- dsw:atEvent
- dsw:locatedAt 
- dwciri:inDescribedPlace
- Then traverse the graph to the Identification via dsw:hasIdentification.

![lodlive graph](media/lodlive-graph.png)

### Why is this graph more complicated than it seems like it needs to be?
Different RDF data providers may have differing degrees of normalization in their underlying databases. Some may track many events at a location, with each event recording many occurrences.  Others may not care about events and simply link many occurrences to a location.  Darwin-SW assumes the most normalized model that providers are likely to need.  

For more on the Darwin-SW model that underlies this graph, see:
[http://www.semantic-web-journal.net/content/darwin-sw-darwin-core-based-terms-expressing-biodiversity-data-rdf-1](http://www.semantic-web-journal.net/content/darwin-sw-darwin-core-based-terms-expressing-biodiversity-data-rdf-1)

For more on the Darwin Core RDF Guide, see this in-press Semantic Web Journal article:
[http://www.semantic-web-journal.net/content/lessons-learned-adapting-darwin-core-vocabulary-standard-use-rdf](http://www.semantic-web-journal.net/content/lessons-learned-adapting-darwin-core-vocabulary-standard-use-rdf)

##Linking across the graph: challenge questions

[Go to the Heard Library SPARQL endpoint (rdf.library.vanderbilt.edu)](http://rdf.library.vanderbilt.edu/sparql?view) and paste in the following query.

###1. Find things that occur at Vanderbilt University (click on the resulting URIs to see what they are).
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX prov: <http://www.w3.org/ns/prov#>

PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX viaf: <http://viaf.org/viaf/>
PREFIX orcid: <http://orcid.org/>

PREFIX dbpedia: <http://dbpedia.org/>
PREFIX dbres: <http://dbpedia.org/resource/>
PREFIX dbp: <http://dbpedia.org/property/>
PREFIX dbo: <http://dbpedia.org/ontology/>

PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX dsw: <http://purl.org/dsw/>
PREFIX gn: <http://www.geonames.org/ontology#>

SELECT DISTINCT ?thing
WHERE {
      ?location dwciri:inDescribedPlace <http://sws.geonames.org/4664532/>.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      }
Limit 30
```

###2. Limit the things to Living Specimens (rdf:type dwc:LivingSpecimen; this will be trees in the Arboretum)
```
SELECT DISTINCT ?thing
WHERE {
      ?location dwciri:inDescribedPlace <http://sws.geonames.org/4664532/>.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing a dwc:LivingSpecimen.
      }
```

###3. Give the common names for the things (remove LivingSpecimen requirement; dwc:vernacularName property of Identification).
```
SELECT DISTINCT ?name
WHERE {
      ?location dwciri:inDescribedPlace <http://sws.geonames.org/4664532/>.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?name.
      }
```

###4. Give common names and IRIs for things occurring in Beaman Park:
```
SELECT DISTINCT ?name ?thing
WHERE {
      ?place gn:name "Beaman Park".
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?name.
      }
```
in Alaska:
```
SELECT DISTINCT ?name ?thing
WHERE {
      ?parent gn:name "Alaska".
      ?place gn:parentFeature ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?name.
      }
```
in Canada:
```
SELECT DISTINCT ?name ?thing
WHERE {
      ?parent gn:name "Canada".
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?name.
      }
```

###5. Try filter for "Smoky Mountain".
```
SELECT DISTINCT ?organismName ?thing
WHERE {
      ?parent gn:name ?placeName.
      FILTER (CONTAINS(?placeName,"Great Smoky"))
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      }
```

###6. Try filter for Catalan "Grans Muntanyes".  Note: str(?var) function strips off language tags.
```
SELECT DISTINCT ?taglessName ?thing
WHERE {
      ?parent (gn:name|gn:alternateName) ?placeName.
      FILTER (CONTAINS(str(?placeName),"Grans Muntanyes"))
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      BIND (str(?organismName) AS ?taglessName)
      }
```

###7. Find pictures of bears and say what state they are in (note: states are 1st level administrative jurisdictions and coded as gn:featureCode gn:A.ADM1
```
SELECT DISTINCT ?placeName ?taglessName ?picture
WHERE {
      ?parent gn:name ?placeName.
      ?parent gn:featureCode gn:A.ADM1.
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      BIND (str(?organismName) AS ?taglessName)
      FILTER (CONTAINS(?taglessName,"bear"))
      ?picture foaf:depicts ?thing.
      }
Limit 30
```
Better to try:
```
SELECT DISTINCT ?placeName ?taglessName ?picture
WHERE {
      ?parent gn:name ?placeName.
      ?parent gn:featureCode gn:A.ADM1.
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      BIND (str(?organismName) AS ?taglessName)
      ?id dwc:genus "Ursus".
      ?picture foaf:depicts ?thing.
      }
Limit 30
```

###8. Find pictures of bears that were photographed in parks, give the name of the species of bear, and find the DBpedia URI for the park (parks are gn:featureCode L.PRK and dbpedia URIs are linked via rdfs:seeAlso)
```
SELECT DISTINCT ?taglessName ?picture ?dbp
WHERE {
      ?parent gn:featureCode gn:L.PRK.
      ?parent rdfs:seeAlso ?dbp.
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      BIND (str(?organismName) AS ?taglessName)
      ?id dwc:genus "Ursus".
      ?picture foaf:depicts ?thing.
      }
```
 
###9. Query remote DBpedia endpoint to find properties/values of the referent of the Yellowstone IRI
```
SELECT DISTINCT ?p ?o
WHERE {

SERVICE <http://DBpedia.org/sparql>
      {
      dbres:Yellowstone_National_Park ?p ?o.
      }

}

LIMIT 100
```

###10. Conduct a federated query to find the home page of "Yellowstone National Park"@en in DBpedia, and from Bioimages, all of the things that occurred there and their common names.
```
SELECT DISTINCT ?taglessName ?thing ?page
WHERE {

     {
      ?parent rdfs:seeAlso ?dbp.
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      BIND (str(?organismName) AS ?taglessName)
      }

SERVICE <http://DBpedia.org/sparql>
      {
      ?dbp rdfs:label "Yellowstone National Park"@en.
      ?dbp foaf:homepage ?page.
      }

}

LIMIT 30
```
 
###11. (#FAIL) Conduct a federated query to find pictures of bears that were photographed in parks, give the name of the species of bear, find the homepage of the park, and the Spanish abstract about the park.  [Times out - asks too much across endpoints, I guess.  Many URIs will be bound to ?dbp and have to be transmitted across the Internet to complete the query on the Heard Library side.  In the previous query, only a few URIs were bound to ?dbp.]
```
SELECT DISTINCT ?taglessName ?picture ?page ?abstract
WHERE {

     {
      ?parent gn:featureCode gn:L.PRK.
      ?parent rdfs:seeAlso ?dbp.
      ?place gn:parentFeature* ?parent.
      ?location dwciri:inDescribedPlace ?place.
      ?event dsw:locatedAt ?location.
      ?occurrence dsw:atEvent ?event.
      ?thing dsw:hasOccurrence ?occurrence.
      ?thing dsw:hasIdentification ?id.
      ?id dwc:vernacularName ?organismName.
      BIND (str(?organismName) AS ?taglessName)
      ?id dwc:genus "Ursus".
      ?picture foaf:depicts ?thing.
      }

SERVICE <http://DBpedia.org/sparql>
      {
      ?dbp foaf:homepage ?page.
      ?dbp dbo:abstract ?abstract.
      FILTER (lang(?abstract)="es")
      }

}
```
##If there is time...

### Power of Linked Data to make actual discoveries (things not apparent in a provider's own data)

Evidence graph from Darwin-SW paper:

![evidence graph](media/evidence-graph.png)

Example in Section 3.3.2:

Expressed explicitly in RDF:
```
<http://herbarium.unc.edu/image/089765> dsw:derivedFrom <http://bioimages.vanderbilt.edu/specimen/ncu592804>.

<http://bioimages.vanderbilt.edu/specimen/ncu
592804> dsw:derivedFrom <http://bioimages.vanderbilt.edu/uncg/39>.
```

Entailed from transitivity of dsw:derivedFrom:
```
<http://herbarium.unc.edu/image/089765> dsw:derivedFrom <http://bioimages.vanderbilt.edu/uncg/39>.
```

Query using property paths to find all derived resources, even though the image isn't linked directly to the tree:
```
SELECT DISTINCT ?resource
WHERE {
 ?resource dsw:derivedFrom+ <http://bioimages.vanderbilt.edu/uncg/39>.
 }
```

### Datatyping problems
```
SELECT DISTINCT ?resource ?type
WHERE {
?resource dsw:derivedFrom
<http://bioimages.vanderbilt.edu/uncg/39>.
?resource a ?type.
?resource dcterms:created ?date.
FILTER(?date >= xsd:date("2000-01-01"))
}
```
1. Why does this not work?!  
Callimachus doesn't support xsd:date() function.

2. Does this work?

```
SELECT DISTINCT ?resource ?type
WHERE {
?resource dsw:derivedFrom
<http://bioimages.vanderbilt.edu/uncg/39>.
?resource a ?type.
?resource dcterms:created ?date.
FILTER(?date >= "2000-01-01"^^xsd:date)
}
```
Examine the actual creation date value given for
[http://bioimages.vanderbilt.edu/specimen/ncu592804.rdf](http://bioimages.vanderbilt.edu/specimen/ncu592804.rdf)
```
<http://bioimages.vanderbilt.edu/specimen/ncu592804> dcterms:created "2010-10-19".
```
Recall that the resource denoted by the plain literal "2010-10-19" (a text string) is not the same as the datatyped literal "2010-10-19"^^xsd:date which denotes an actual date as an abstract thing.

3. Try this:

```
SELECT DISTINCT ?resource ?type
WHERE {
?resource dsw:derivedFrom
<http://bioimages.vanderbilt.edu/uncg/39>.
?resource a ?type.
?resource dcterms:created ?date.
FILTER(?date >= "2000-01-01")
}
```
It's doing a simple string comparison without any understanding of calendars, time zones, etc.

Datatyped dates are awesome if you are willing to go to the trouble to be careful with them and annoying of you don't care.


