# SPARQL queries on the tang-song metadata (2016-10-31)

![](https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/images/spatial-thing.png)

Above is the part of the graph about a site (yellow bubble).  The full Turtle is below:

```
<http://lod.vanderbilt.edu/historyart/site/Lingyansi>
     rdf:type schema:Place;
     gn:featureCode gn:S.ANS;
     rdfs:label "灵岩寺"@zh-hans;
     rdfs:label "Lingyansi"@zh-latn-pinyin;
     rdfs:label "Lingyan Temple"@en;
     foaf:based_near <http://sws.geonames.org/1803429/>;
     foaf:based_near <http://vocab.getty.edu/tgn/8625249-place>;
     dwc:locality "山东省长清县"@zh-hans;
     dwc:locality "Changqing District"@en;
     schema:containedInPlace <http://sws.geonames.org/1815582/>;
     dcterms:temporal _:7946485f-3b19-4fb7-b5e5-70714bfff104;
     a geo:SpatialThing.
```
Go to the Heard Library SPARQL endpoint, where the tang-song RDF has been loaded.  

Here are all of the namespace abbreviations that you will need for the exercises.  Paste them in the query box and put the query below them.
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
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX gn: <http://www.geonames.org/ontology#>
PREFIX gvp: <http://vocab.getty.edu/ontology#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX bibo: <http://purl.org/ontology/bibo/>
PREFIX periodo: <http://n2t.net/ark:/99152/p0v#>
```
Paste in the queries below to see what they do and to hack as necessary.  After you click "Evaluate Query" and see what happens, click the back button on your browser to get back to the query box.

**Question 1.** Here is a query to find all of the sites:
```
SELECT DISTINCT ?site
WHERE {
      ?site a geo:SpatialThing.
      }
LIMIT 10
```
You don't really have to use "LIMIT 10" for this query since there aren't that many results.  But it's a good idea to use it for new queries so that you don't get a million results.  You can comment it out with a "#" if you don't want it.

Notice that the results are IRIs for the sites.  It would be better to have the labels.

**Question 2.** Add labels
```
SELECT DISTINCT ?site ?siteLabel
WHERE {
      ?site a geo:SpatialThing.
      ?site rdfs:label ?siteLabel.
      }
LIMIT 10
```

**Question 3.** Filter so that you only get transliterated labels
```
SELECT DISTINCT ?site ?siteLabel
WHERE {
      ?site a geo:SpatialThing.
      ?site rdfs:label ?siteLabel.
      FILTER (lang(?siteLabel)="zh-latn-pinyin")
      }
LIMIT 10
```

**Question 4.** Get rid of the annoying language tags
```
SELECT DISTINCT ?site ?strippedSiteLabel
WHERE {
      ?site a geo:SpatialThing.
      ?site rdfs:label ?siteLabel.
      FILTER (lang(?siteLabel)="zh-latn-pinyin")
      BIND (str(?siteLabel) AS ?strippedSiteLabel)
}
LIMIT 10
```

![](https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/images/building-site-link.png)

Above is the part of the graph where the building (red bubble) is linked to the site (yellow bubble).  Below is the Turtle about the building:
```
<http://lod.vanderbilt.edu/historyart/site/Lingyansi#Pizhita>
     rdfs:label "Pizhita"@zh-latn-pinyin;
     rdfs:label "辟支塔"@zh-hans;
     geo:lat "36.3632666";
     geo:long "116.977683";
     rdfs:comment "Song dynasty; corner bracket sets on front facade";
     rdfs:comment "for date see: zgmscd 585";
     schema:geo _:08cdc5fc-43b9-4ff0-8aeb-02f3b17cf46f;
     dcterms:temporal _:6808d38f-1da6-4b30-978c-fa57887dc1de;
     schema:containedInPlace <http://lod.vanderbilt.edu/historyart/site/Lingyansi>;
     a schema:LandmarksOrHistoricalBuildings.
```

**Challenge Question 5.** Develop a query whose graph pattern links the site to the building, then shows the names of both the building and the site in transliterated Chinese and in simplified Chinese characters (zh-hans).  [Check here for an answer](sparql-answers.md)

** Challenge Question 6.** Display the latitude and longitude as well.  You can decide which of the site and building labels you want to display with it.  [Check here for an answer](sparql-answers.md) Don't peek below where there are clues !!!

.
.
.
.
.
.
Creating a hyperlink to Google Maps to display the location of the buildings at the Longxingsi site.
```
SELECT DISTINCT ?strippedBuildingLabel (URI(GROUP_CONCAT(CONCAT("http://maps.google.com/maps?output=classic&q=loc:",?lat,",",?long,"&t=h&z=16");SEPARATOR="")) as ?googleMapURI)

WHERE {
?site a geo:SpatialThing.
?site rdfs:label "Longxingsi"@zh-latn-pinyin.
?building schema:containedInPlace ?site.
?building rdfs:label ?buildingLabel.
FILTER (lang(?buildingLabel)="zh-latn-pinyin")
BIND (str(?buildingLabel) AS ?strippedBuildingLabel)

?building geo:lat ?lat.
?building geo:long ?long.
}
GROUP BY ?strippedBuildingLabel
```
You can click on the link and it will go to the map.

## Linking to the Period-O RDF

I downloaded the [Chinese Dynasty RDF](https://test.perio.do/#/p/Canonical/periodCollections/p0fp7wv/?show_period=p0fp7wvtqp9) from Period-O (http://perio.do/) as Turtle.  It had some serialization errors that I corrected and I also fixed the incorrect language tags.  You can [click here](p0fp7wv.ttl) to look at the whole document.  Here is a part of the RDF for the Qing Dynasty:

![](https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/images/period-o-graph.png)

Here is what the Turtle looks like for that part of the graph:
```
<http://n2t.net/ark:/99152/p0fp7wvtqp9>
    a skos:Concept;
    periodo:spatialCoverageDescription "China";
    dcterms:language "en";
    dcterms:spatial <http://dbpedia.org/resource/China>;
    skos:altLabel "清"@zh-hans, "清"@zh-hant, "Qing Dynasty"@en;
    skos:inScheme <http://n2t.net/ark:/99152/p0fp7wv>;
    skos:note "First capital: 京师顺天府 (北京), latitude: 39.92, longitude: 116.38";
    skos:prefLabel "Qing Dynasty";
    time:intervalFinishedBy [
      skos:prefLabel "1911";
      time:hasDateTimeDescription [
        time:year "1911"^^xsd:gYear
      ]
    ];
    time:intervalStartedBy [
      skos:prefLabel "1644";
      time:hasDateTimeDescription [
        time:year "1644"^^xsd:gYear
      ]
    ].
```
The corrected Chinese Dynasty RDF has also been loaded into the Heard Library triple store, so we can query it along with the tang-song RDF.

**Question 7.**
