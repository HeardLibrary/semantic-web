# SWWO Chapter 7 Do-it-yourself activities.

Link to Heard Library SPARQL endpoint:

http://rdf.library.vanderbilt.edu/sparql?view

# Files loaded into Callimachus:

The FOAF vocabulary: http://rdf.library.vanderbilt.edu/swwg/foaf.rdf or  [foaf.rdf](data/foaf.rdf)

FOAF in Turtle: https://gist.github.com/baskaufs/fefa1bfbff14a9efc174 or [foaf.ttl](data/foaf.ttl)

SW Working Group metadata: http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf or  [sww-group.rdf](data/sww-group.rdf) or [sww-group.ttl](data/sww-group.ttl)

SW Working Group relationships:
http://rdf.library.vanderbilt.edu/swwg/assertions.ttl or [assertions.ttl](data/assertions.ttl)

# Find subproperty relationships expressed in the data:

```
SELECT DISTINCT ?p ?superproperty
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>

WHERE {
?s ?p ?o.
?p rdfs:subPropertyOf ?superproperty.
}
```

### CONSTRUCT query (triples that are entailed but not materialized):
```
CONSTRUCT {
  ?s ?superproperty ?o.
}
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>
WHERE {
  ?s ?p ?o.
  ?p rdfs:subPropertyOf ?superproperty.
  MINUS {?s ?superproperty ?o.}
  }
```

### Stardog reasoning (on many RDFS relationships, not just subPropertyOf)

Change Stardog Schema to the entire FOAF vocabulary
Flip reasoning switch

```
SELECT DISTINCT ?thing ?label
WHERE {
?thing rdfs:label ?label.
}
```

### Other RDFS relationships
rdfs:domain

rdfs:range

rdfs:seeAlso (linked resource may not be dereferenceable as RDF)

# Used in RDF vocabularies (e.g. dcterms:)
rdfs:isDefinedBy

rdfs:comment
