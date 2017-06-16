# Traditional Chinese Architecture graph model
**Vanderbilt University Semantic Web Working Group**

[back to the User Guide](README.md)

[go to the SPARQL query interface](https://sparql.vanderbilt.edu/#query)

## Status

The Traditional Chinese Architecture Digital Research Tool (http://tcadrt.org/) dataset has undergone preliminary testing and is in a usable form.  However, the selection of properties in its underlying model were not based on a single particular standard or community consensus, so those properties may be subject to change in the future as consensus develops within the traditional Chinese architecture community.  The graph model was developed by [Steve Baskauf](https://my.vanderbilt.edu/baskauf/) in consultation with the members of the [Semantic Web Working Group](https://heardlibrary.github.io/semantic-web) at Vanderbilt during the fall of 2016.  For a narrative about the development of the model and dataset, see blog posts [here](http://baskauf.blogspot.com/2016/10/guid-o-matic-goes-to-china.html) and [here](http://baskauf.blogspot.com/2016/11/sparql-based-web-app-to-find-chinese.html).

## Named graphs in the triple store (URIs do not dereference)

### Structures graph http://tcadrt.org/building

This graph describes particular structures of importance to traditional Chinese architecture.  They may be single temple buildings, particular halls within temple complexes, gates (shanmen), or other structures.  These structures are nested within sites.  Structures are typed as schema:LandmarksOrHistoricalBuildings .

Each structure is linked to some related resources. Location is modeled both simply through direct latitude and longitude properties from the geo: namespace, and through a schema:GeoCoordinates instance linked to the same geocoordinates.  The temporal extent of the construction of the structure is described by an instance of dcterms:PeriodOfTime.  That time period is described simply through direct year properties using the approach of the Getty Ontology (gvp:).  But it is also typed as a time:Interval and described using the more complex system of the W3C Time Ontology (time:).

**Graph model:**

![structures graph](media/building-graph.png)

The containing site is shown in red, linked by the schema:containedInPlace predicate.

**CURIEs (namespaces) used:**
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX gvp: <http://vocab.getty.edu/ontology#>
PREFIX tcao: <http://tcadrt.org/ontology/>
```
**Sample queries:**

Find structures that were under construction in 1300 CE and give their names in English and simplified Chinese characters:
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gvp: <http://vocab.getty.edu/ontology#>

SELECT DISTINCT ?chineseName ?englishName WHERE {
  ?building a schema:LandmarksOrHistoricalBuildings.
  ?building dcterms:temporal ?interval.
  ?interval gvp:estStart ?start.
  FILTER (?start < "1300"^^xsd:gYear)
  ?interval gvp:estEnd ?end.
  FILTER (?end > "1300"^^xsd:gYear)
  ?building rdfs:label ?chineseName.
  FILTER (lang(?chineseName)="zh-hans")
  ?building rdfs:label ?englishName.
  FILTER (lang(?englishName)="en")
  }
```

Find structures that have the feature Beveled Linggong and give their names in English and traditional Chinese characters:
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX tcao: <http://tcadrt.org/ontology/>

SELECT DISTINCT ?chineseName ?englishName WHERE {
  ?building a schema:LandmarksOrHistoricalBuildings.
  ?building tcao:beveled_linggong "1".
  ?building rdfs:label ?chineseName.
  FILTER (lang(?chineseName)="zh-hant")
  ?building rdfs:label ?englishName.
  FILTER (lang(?englishName)="en")
  }
```

### Site graph http://tcadrt.org/site

This graph describes sites that contain structures.  There may be one to many structures within a site.  Sites are typed as schema:Place and geo:SpatialThing .

As with structures, sites are linked to resources describing the place and time associated with the site. The site is not considered a point location (as is a structure within the site), but is a spatial thing that is located near standardized places or features. Thus the site may be linked to resources described by the [Getty Thesaurus of Geographic Names](http://www.getty.edu/research/tools/vocabularies/tgn/) or GeoNames (http://www.geonames.org/). The time over which the entire complex was constructed is modeled as an instance of time:ProperInterval as well as dcterms:PeriodOfTime.  This period is described according to the W3C Time Ontology, with the start and end of the period indicated by links to standardized [PeriodO](http://perio.do/) URIs.

**Graph model:**

![structures graph](media/site-graph.png)

A contained structure is shown in red, linked by the schema:containedInPlace predicate.

**CURIEs (namespaces) used:**
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX gn: <http://www.geonames.org/ontology#>
```
**Sample queries:**

Find sites located in Fujian province and give the Pinyin romanization of their Chinese names:
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX schema: <http://schema.org/>

SELECT DISTINCT ?pinyinName WHERE {
  ?site a schema:Place.
  ?site dwc:stateProvince "Fujian"@zh-latn-pinyin.
  ?site rdfs:label ?pinyinName.
  FILTER (lang(?pinyinName)="zh-latn-pinyin")
  }
```
Note that this query does not restrict the results to places that are traditional Chinese architecture sites.  Any other schema:Place in the triplestore located in Fujian would be returned.

Building on the previous query, list the dynasties over which sites in Shanxi province were constructed:
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>

SELECT DISTINCT ?pinyinName ?periodName WHERE {
  ?site a schema:Place.
  ?site dcterms:temporal ?period.
  ?period rdfs:label ?periodName.
  FILTER (lang(?periodName)="en")
  ?site dwc:stateProvince "Shanxi"@zh-latn-pinyin.
  ?site rdfs:label ?pinyinName.
  FILTER (lang(?chineseName)="zh-latn-pinyin")
  }
```

### Images graph http://tcadrt.org/temple-images

Currently, images are handled in a somewhat ad hoc manner. They are modeled in similar manner to the Bioimages images (see the [Bioimages graph description page](bioimages.md) for details).  Images are linked to particular structures using foaf:depicts.

The images are currently retrieved from Flickr.  In the future, images will be linked to particular architectural features.

**Sample query:**

Find buildings contained in the Baitai Monastery, then find the images that depict the building.  List the building names and the Flickr access URIs for the thumbnails of the images:
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX ac: <http://rs.tdwg.org/ac/terms/>

SELECT DISTINCT ?pinyinName ?thumbnail WHERE {
  ?site rdfs:label "Baitaisi"@zh-latn-pinyin.
  ?building schema:containedInPlace ?site.
  ?building rdfs:label ?pinyinName.
  FILTER (lang(?pinyinName)="en")
  ?image foaf:depicts ?building.
  ?image ac:hasServiceAccessPoint ?sap.
  ?sap ac:variant ac:Thumbnail.
  ?sap ac:accessURI ?thumbnail.
  }
ORDER BY ?building
```

### Dynasties timeline graph http://tcadrt.org/timeline

This graph includes the data from the [PeriodO Ontology](http://perio.do/) about Chinese dynasties.  These data are from the particular dataset http://n2t.net/ark:/99152/p0fp7wv about Chinese dynasties.  The data taken from the JSON-LD were munged a bit to correct some errors.  The resulting file converted to RDF/Turtle is [here](https://github.com/HeardLibrary/semantic-web/blob/master/2016-fall/tang-song/period-o.ttl).  There are still some issues with this file.  The English labels are the values of skos:prefLabel (without language tags) while the alternate (incorrectly language-tagged) labels are skos:altLabel values.  The labels are not explicitly values of rdfs:label (although that relationship is entailed).

**Model:**

![structures graph](media/dynasty-diagram.jpg)

The diagram above shows the simplified relationships between Chinese dynasties.  These relationships were modeled by asserting time:intervalMetBy relationships between a dynasty and another dynasty that directly followed it.  The following RDF in Turtle serialization expresses these relationships:

```
@prefix time: <http://www.w3.org/2006/time#>.

<http://n2t.net/ark:/99152/p0fp7wvtqp9> #Qing
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wv2s8c>. #Ming

<http://n2t.net/ark:/99152/p0fp7wv2s8c> #Ming
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wvvrz5>. #Yuan

<http://n2t.net/ark:/99152/p0fp7wvvrz5> #Yuan
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wvmghn>. #Jin

<http://n2t.net/ark:/99152/p0fp7wvvrz5> #Yuan
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wv9x7n>. #Southern Song

<http://n2t.net/ark:/99152/p0fp7wv9x7n> #Southern Song
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wvjvn8>. #Northern Song

<http://n2t.net/ark:/99152/p0fp7wvmghn> #Jin
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wvjvn8>. #Northern Song

<http://n2t.net/ark:/99152/p0fp7wvmghn> #Jin
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wvw8zq>. #Liao

<http://n2t.net/ark:/99152/p0fp7wvjvn8> #Northern Song
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wv5h26>. #Five Dynasties

<http://n2t.net/ark:/99152/p0fp7wv5h26> #Five Dynasties
     time:intervalMetBy <http://n2t.net/ark:/99152/p0fp7wvrjpj>. #Tang
```


**CURIEs (namespaces) used:**
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX ns1: <http://n2t.net/ark:/99152/p0v#>
```

**Sample queries:**

Find dynasties that occurred immediately after the Jin Dynasty:
```
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT ?label WHERE {
  ?earlier skos:prefLabel "Jin Dynasty".
  ?earlier time:intervalMetBy ?later.
  ?later skos:prefLabel ?label.
  }
```

Find any dynasty that occurred before the Jin Dynasty. This query uses [SPARQL 1.1 property paths](https://www.w3.org/TR/sparql11-query/#propertypaths) (indicated by the "+" after time:intervalMetBy):
```
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT ?label WHERE {
  ?later skos:prefLabel "Jin Dynasty".
  ?earlier time:intervalMetBy+ ?later.
  ?earlier skos:prefLabel ?label.
  }
```

The following query uses [SPARQL 1.1 property paths](https://www.w3.org/TR/sparql11-query/#propertypaths) (indicated by the "\*" after time:intervalMetBy) to constrain starting and ending dynasties of an interval to include the Yuan dynasty.  It then finds sites whose construction intervals meet this constraint.  Note that it does not take into consideration whether a particular site actually falls into a geographic region that was under the control of the constraining dynasty.  It only uses the temporal order of the dynasties shown in the diagram above.

```
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX time: <http://www.w3.org/2006/time#>

SELECT DISTINCT ?name WHERE {
  # target dynasty must be earlier than ?endDynasty
  ?endDynasty time:intervalMetBy* <http://n2t.net/ark:/99152/p0fp7wvmghn>. #test with Yuan

  #target dynasty must be later than ?startDynasty
  <http://n2t.net/ark:/99152/p0fp7wvmghn> time:intervalMetBy* ?startDynasty. #test with Yuan

  ?interval time:intervalStartedBy ?startDynasty.
  ?interval time:intervalFinishedBy ?endDynasty.
  ?site dcterms:temporal ?interval.
  ?site rdfs:label ?name.
  FILTER (lang(?name)="en")
  }
ORDER BY ?name
```

[back to the User Guide](README.md)

[go to the SPARQL query interface](https://sparql.vanderbilt.edu/#query)
