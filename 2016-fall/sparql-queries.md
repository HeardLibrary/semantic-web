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
Above is the part of the graph where the building is linked to the site.  Below is the Turtle about the building:
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
