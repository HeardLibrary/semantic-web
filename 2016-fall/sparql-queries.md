# SPARQL queries on the tang-song metadata (2016-10-31)

![](https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/images/spatial-thing.png)

Above is the part of the graph about a site (yellow bubble).  [Click here to see the whole graph diagram at once](https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/images/whole graph.png). The full Turtle is below:

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
Go to the [Heard Library SPARQL endpoint](http://rdf.library.vanderbilt.edu/sparql?view), where the tang-song RDF has been loaded.  

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

**Challenge Question 5.** Develop a query whose graph pattern links the site to the building, then shows the names of both the building and the site in transliterated Chinese and in simplified Chinese characters (zh-hans).  In the second triple pattern of my answer, I limited the buildings to only those at Longxinsi, but you could show more by leaving that triple pattern out.  [Check here for an answer](sparql-answers.md).

**Challenge Question 6.** Display the latitude and longitude as well.  You can decide which of the site and building labels you want to display with it.  Put
```
ORDER BY ?site
```
after the graph pattern and before "LIMIT 10" to put the sites in alphabetical order.  [Check here for an answer](sparql-answers.md) Don't peek below where there are clues !!!

.

.

.

.

.

.

Below I created a hack of the previous query that creates a hyperlink to Google Maps to display the location of the buildings at the Longxingsi site.  It's kind of complicated, so you can just paste it in and see what it does if you don't want to take the time to figure it out.
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

After weeks of working on this, we are actually going to be doing LINKED DATA !!!!!  We are going to leverage somebody else's work by linking to it!

I downloaded the [Chinese Dynasty RDF](https://test.perio.do/#/p/Canonical/periodCollections/p0fp7wv/?show_period=p0fp7wvtqp9) from Period-O (http://perio.do/) as Turtle.  It had some serialization errors that I corrected and I also fixed the incorrect language tags.  You can [click here](p0fp7wv.ttl) to look at the whole document.  Here is a part of the RDF for the Qing Dynasty (represented by the black bubble):

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
You may have noticed in the diagram that there are a number of blank nodes and that's why there are so many square brackets in the Turtle.  This graph is confusingly complicated, because Period-O uses the draft W3C Time Ontology, and it's designed to be able to handle very complicated situations.  In this case, it's not that complicated - each dynasty just has a beginning and an ending date.

The corrected Chinese Dynasty RDF has also been loaded into the Heard Library triple store, so we can query it along with the tang-song RDF.

![](https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/images/site-dynasty-link.png)

The diagram above shows how a site is linked to its starting and ending dynasty.

**Challenge Question 7.** Show the name of a site in the language of your preference (hack from previous queries), then display the preferred label (skos:prefLabel) for the starting and ending dynasty linked to it via the dcterms:PeriodOfTime blank node.  For whatever reason, Period-O didn't use language tags for the preferred labels, so you don't need to worry about filtering or scrubbing the language tag.  [Check here for an answer](sparql-answers.md)

**Challenge Question 8.** Display the site name (hack from before), and the starting and ending dates for the site period.  That requires finding the starting date of the starting dynasty's period and the ending date of the ending dynasty's period.  Since you'll start from the previous query, it would be easy to also include the names of the starting and ending dynasties. Skip the LIMIT 10 thing so that you can see all of them (there aren't that many). [Check here for an answer](sparql-answers.md)  Don't peak below!

.

.

.

.

.

.


**Question 9.** It would be good to order the sites by the starting date of the site period.  However if you try adding
```
ORDER BY ?siteStartDateLabel
```
you will see that it orders them by the string (1 comes before 9), not by the actual number of the year.  You can modify the query to find the starting date datatyped as xsd:gYear.  The SPARQL processor then "knows" that it's a year rather than a string:

```
SELECT DISTINCT ?strippedSiteLabel ?startDynastyName ?siteStartDateLabel ?endDynastyName ?siteEndDateLabel
WHERE {
?site a geo:SpatialThing.
?site rdfs:label ?siteLabel.
FILTER (lang(?siteLabel)="zh-latn-pinyin")
BIND (str(?siteLabel) AS ?strippedSiteLabel)

?site dcterms:temporal ?periodOfTime.

?periodOfTime time:intervalStartedBy ?startingDynasty.
?startingDynasty skos:prefLabel ?startDynastyName.
?startingDynasty time:intervalStartedBy ?siteStartDate.
?siteStartDate skos:prefLabel ?siteStartDateLabel.
?siteStartDate time:hasDateTimeDescription ?siteStartDesc.
?siteStartDesc time:year ?siteStartYear.

?periodOfTime time:intervalFinishedBy ?endingDynasty.
?endingDynasty skos:prefLabel ?endDynastyName.
?endingDynasty time:intervalStartedBy ?siteEndDate.
?siteEndDate skos:prefLabel ?siteEndDateLabel.
}
ORDER BY ?siteStartYear
```

**More fun stuff that we could do, but that I didn't work out in advance**

- list the start and end time for each building at a site along with the start and end time for the site.
- trickier would be to check whether the building interval falls outside of the start and end time for the site and only show the cases where they do (a data cleaning operation).
- determine all of the sites whose time period include a certain dynasty (i.e. the user submits a dynasty name and the query finds all sites whose active time includes that dynasty).  This is probably something we will want to do when we write our web application.  There are several approaches to take with this one.
- generate all of the latitudes and longitudes for the buildings on the sites that we screened out in the previous one.  This could be used to build a clickable map for sites relevant to a certain dynasty.
- even trickier would be to do this on a building level.  That would require testing for overlap of the building period with the time that the dynasty was going on.  As with the last one, a map would be a great output.
- specify a language tag and then generate all of the output (site name, building name, and dynasty information) so that it was only displayed in the chosen language.  This would be the first step in building a muliti-lingual application (again something we really should do, at least a dual Chinese-English site).
- etc. etc. etc.
