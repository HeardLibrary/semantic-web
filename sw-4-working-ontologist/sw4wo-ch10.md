# SWWO Chapter 10 Do-it-yourself activities.

Link to Getty Vocabularies SPARQL endpoint:

http://vocab.getty.edu/sparql

Link to FactForge SPARQL endpoint (for GeoNames triples):

http://factforge.net/sparql

### Find countries in Africa

```
SELECT ?concept ?label WHERE {
  ?concept skos:broader <http://vocab.getty.edu/tgn/7001242>.
  ?concept skos:prefLabel ?label.
  FILTER (lang(?label)="en")
  }
```

### Find preferred labels for China
```
SELECT ?prefLabel WHERE
    {
    ?country gvp:placeType <http://vocab.getty.edu/aat/300128207>.
    ?country rdfs:label "China"@en.
    ?country skos:prefLabel ?prefLabel.
    }
```

# Find the "preferred" prefLabel along with the prefLabel for different languages:

```
SELECT DISTINCT ?country ?value ?engLabel WHERE
   {
   ?country gvp:placeType <http://vocab.getty.edu/aat/300128207>.
   ?country skosxl:prefLabel ?xlLabel.
   OPTIONAL {
            ?country skos:prefLabel ?engLabel.
            FILTER (lang(?engLabel)="en")
            }
   ?xlLabel gvp:displayOrder "1"^^xsd:positiveInteger.
   ?xlLabel skosxl:literalForm ?prefLabel.
   BIND (str(?prefLabel) AS ?value)
   }
ORDER BY ?engLabel
```
