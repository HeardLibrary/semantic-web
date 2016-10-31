# Answers to the SPARQL query challenge questions (2016-10-31)

There may be multiple ways to answer the challenge questions.

**Question 5 answer**:
```
SELECT DISTINCT ?strippedSiteLabel ?strippedChineseSiteLabel ?strippedBuildingLabel ?strippedChineseBldgLabel
WHERE {
?site a geo:SpatialThing.
?site rdfs:label "Longxingsi"@zh-latn-pinyin.
?site rdfs:label ?siteLabel.
FILTER (lang(?siteLabel)="zh-latn-pinyin")
BIND (str(?siteLabel) AS ?strippedSiteLabel)
?site rdfs:label ?chineseSiteLabel.
FILTER (lang(?chineseSiteLabel)="zh-hans")
BIND (str(?chineseSiteLabel) AS ?strippedChineseSiteLabel)

?building schema:containedInPlace ?site.
?building rdfs:label ?buildingLabel.
FILTER (lang(?buildingLabel)="zh-latn-pinyin")
BIND (str(?buildingLabel) AS ?strippedBuildingLabel)
?building rdfs:label ?chineseBldgLabel.
FILTER (lang(?chineseBldgLabel)="zh-hans")
BIND (str(?chineseBldgLabel) AS ?strippedChineseBldgLabel)
}
LIMIT 10
```
