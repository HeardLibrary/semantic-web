# SWWO Chapter 6 Do-it-yourself activities.

Link to Heard Library SPARQL endpoint:

http://rdf.library.vanderbilt.edu/sparql?view

# Files loaded into Callimachus:

The FOAF vocabulary: http://rdf.library.vanderbilt.edu/swwg/foaf.rdf

FOAF in Turtle: https://gist.github.com/baskaufs/fefa1bfbff14a9efc174

The Dublin Core metadata terms vocabulary: http://rdf.library.vanderbilt.edu/swwg/dcterms.rdf

DC terms in Turtle:
https://gist.github.com/baskaufs/6fdab74aaf2a755bd069

The Dublin Core type vocabulary: http://rdf.library.vanderbilt.edu/swwg/dctype.rdf

DC types in Turtle:
https://gist.github.com/baskaufs/a56096c2ac1408b8ff10

SW Working Group metadata: http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf

SW Working Group relationships:
http://rdf.library.vanderbilt.edu/swwg/assertions.ttl

# Find subclass/class relationships in the FOAF vocabulary:

### Relevant Turtle snippets (from the FOAF vocabulary):

```
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> .

foaf:Image a rdfs:Class;
    rdfs:isDefinedBy foaf:;
    rdfs:subClassOf foaf:Document.

foaf:Person a rdfs:Class;
    rdfs:isDefinedBy foaf:;
    rdfs:subClassOf geo:SpatialThing,
                    foaf:Agent;
    owl:disjointWith foaf:Organization,
                     foaf:Project.
```

### SELECT query
```
SELECT ?subclass ?class
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
WHERE {
?subclass rdfs:subClassOf ?class.
}
```

# Reason entailed class relationships in the SWWG metadata:

### Relevant Turtle snippets (from sw-group.rdf):

```
<http://orcid.org/0000-0003-4365-3135> a prov:Person,
                                         foaf:Person;
             rdfs:label "Steven J. Baskauf";
             foaf:familyName "Baskauf";
             foaf:givenName "Steve";
             foaf:name "Steven J. Baskauf";
             foaf:page <http://bioimages.vanderbilt.edu/>,
                      <http://vanderbilt.edu/trees>,
                      <https://my.vanderbilt.edu/baskauf/>.

<http://orcid.org/0000-0003-2445-1511> a prov:Person,
                                         foaf:Person;
             rdfs:label "Edward Warga";
             foaf:familyName "Warga";
             foaf:givenName "Edward".

<http://orcid.org/0000-0003-0328-0792> a prov:Person,
                                       foaf:Person;
            rdfs:label "Clifford B. Anderson";
            foaf:familyName "Anderson";
            foaf:givenName "Clifford";
            foaf:name "Clifford B. Anderson";
            foaf:page <http://www.library.vanderbilt.edu/scholarly/>.

<http://orcid.org/0000-0002-2174-0484> a prov:Person,
                                         foaf:Person;
             rdfs:label "Suellen Stringer-Hye";
             foaf:familyName "Stringer-Hye";
             foaf:givenName "Suellen".
```

### Test SELECT query:

```
SELECT ?person ?label
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>
WHERE {
  ?group foaf:name "Semantic Web Working Group".
  ?group foaf:member ?person.
  ?person a foaf:Person.
  ?person rdfs:label ?label.
}
```

### Simple CONSTRUCT query:

```
CONSTRUCT {
  ?person a foaf:Agent.
}
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>
WHERE {
  ?group foaf:name "Semantic Web Working Group".
  ?group foaf:member ?person.
  ?person a foaf:Person.
}
```

### Same CONSTRUCT query with reduced whitespace:

```
CONSTRUCT {?person a foaf:Agent.}FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>WHERE {?group foaf:name "Semantic Web Working Group".?group foaf:member ?person.?person a foaf:Person.}
```

### Same CONSTRUCT query URL encoded:

```
CONSTRUCT%20%7B%3Fperson%20a%20foaf%3AAgent.%7DFROM%20%3Chttp%3A%2F%2Frdf.library.vanderbilt.edu%2Fswwg%2Ffoaf.rdf%3EFROM%20%3Chttp%3A%2F%2Frdf.library.vanderbilt.edu%2Fswwg%2Fsww-group.rdf%3EFROM%20%3Chttp%3A%2F%2Frdf.library.vanderbilt.edu%2Fswwg%2Fassertions.ttl%3EWHERE%20%7B%3Fgroup%20foaf%3Aname%20%22Semantic%20Web%20Working%20Group%22.%3Fgroup%20foaf%3Amember%20%3Fperson.%3Fperson%20a%20foaf%3APerson.%7D
```

### Base URL for HTTP GET of a query:

```
http://rdf.library.vanderbilt.edu/sparql?query=
```
Use application/rdf+xml in Accept: header (Callimacus doesn't support text/turtle).

### URL for the CONSTRUCT query:

```
http://rdf.library.vanderbilt.edu/sparql?query=CONSTRUCT%20%7B%3Fperson%20a%20foaf%3AAgent.%7DFROM%20%3Chttp%3A%2F%2Frdf.library.vanderbilt.edu%2Fswwg%2Ffoaf.rdf%3EFROM%20%3Chttp%3A%2F%2Frdf.library.vanderbilt.edu%2Fswwg%2Fsww-group.rdf%3EFROM%20%3Chttp%3A%2F%2Frdf.library.vanderbilt.edu%2Fswwg%2Fassertions.ttl%3EWHERE%20%7B%3Fgroup%20foaf%3Aname%20%22Semantic%20Web%20Working%20Group%22.%3Fgroup%20foaf%3Amember%20%3Fperson.%3Fperson%20a%20foaf%3APerson.%7D
```

### Response in RDF/XML:

```
<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

<rdf:Description rdf:about="http://orcid.org/0000-0003-4365-3135">
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent"/>
</rdf:Description>

<rdf:Description rdf:about="http://orcid.org/0000-0002-2174-0484">
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent"/>
</rdf:Description>

<rdf:Description rdf:about="http://orcid.org/0000-0003-0328-0792">
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent"/>
</rdf:Description>

<rdf:Description rdf:about="http://orcid.org/0000-0003-2445-1511">
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent"/>
</rdf:Description>

</rdf:RDF>
```

### Response in RDF/Turtle:

```
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/>.

<http://orcid.org/0000-0003-4365-3135> a foaf:Agent.
<http://orcid.org/0000-0002-2174-0484> a foaf:Agent.
<http://orcid.org/0000-0003-0328-0792> a foaf:Agent.
<http://orcid.org/0000-0003-2445-1511> a foaf:Agent.
```
### Recall: "cached inferencing": inferences are stored with the data.

### SELECT query for Agents:

```
SELECT ?person ?label
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>
WHERE {
  ?group foaf:name "Semantic Web Working Group".
  ?group foaf:member ?person.
  ?person a foaf:Agent.
  ?person rdfs:label ?label.
}
```

Don't forget to add:

```
FROM <http://rdf.library.vanderbilt.edu/swwg/agents.ttl>
```

### Remove restriction that people are members of SWW Group:

```
CONSTRUCT {
  ?person a foaf:Agent.
}
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>
WHERE {
  ?person a foaf:Person.
}
```

### Find/Construct all superclasses:

```
SELECT ?thing ?subclass ?class
# CONSTRUCT {?thing a ?class.}
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
# FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>

WHERE {
?thing a ?subclass.
?subclass rdfs:subClassOf ?class.
}
```

### Same query, but transitive and excluding entailed triples already asserted:

```
SELECT ?thing ?subclass ?class
# CONSTRUCT {?thing a ?class.}
FROM <http://rdf.library.vanderbilt.edu/swwg/foaf.rdf>
FROM <http://rdf.library.vanderbilt.edu/swwg/sww-group.rdf>
# FROM <http://rdf.library.vanderbilt.edu/swwg/assertions.ttl>

WHERE {
?thing a ?subclass.
?subclass rdfs:subClassOf+ ?class.
MINUS {?thing a ?class.}
}
```

Note: SPARQL 1.1 property paths are highly relevant to constructing reasoning queries and 1.1 was not complete when the book was written.  See https://www.w3.org/TR/sparql11-query/#propertypaths

# Recall "just in time inferencing": implementation never stores inferred triples; inferences computed at the last moment.  Stardog does this.

### Tbox: set of rules upon which reasoning should be based (a.k.a. schema)

```
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
foaf:Person rdfs:subClassOf foaf:Agent.
```


### Query:

```
SELECT ?thing ?class
WHERE {
  ?thing a foaf:Person.
  ?thing a ?class.
  }
```

### Do:

1. Upload the data.
2. Query Stardog with inferencing off.
3. In Admin Console, set Tbox graph.
4. Upload the schema.
5. Query Stardog with inferencing on.

### p. 122: "Model as specification"

The model tells us what should happen.  It doesn't tell us how we should make it happen.
