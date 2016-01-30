#Semantic Web for the Working Ontologist chapter 3 notes

Notes from Heath, T. and C. Bizer. 2011. Linked Data: Evolving the Web into a Global Data Space. 

From [Section 2.4.1](http://linkeddatabook.com/editions/1.0/#htoc16), section entitled "RDF Features Best Avoided in the Linked Data Context":
1. RDF reification (SPARQL problems, suggests attaching metadata to the document containing the triples; see more on Semantic Sitemaps and voiD at [Publishing Data about Data](http://linkeddatabook.com/editions/1.0/#htoc45); see also the [W3C PROV Ontology](https://www.w3.org/TR/prov-o/) and the lighter-weight [draft Open Annotation data model](http://www.openannotation.org/spec/core/)) 
2. RDF collections and RDF containers (falls apart when queried by SPARQL)
3. blank nodes (scope limited to the document in which they appear, so can't be linked to)
