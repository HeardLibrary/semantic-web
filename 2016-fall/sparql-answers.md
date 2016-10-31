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

**Question 6 answer**:
```
SELECT DISTINCT ?strippedSiteLabel ?strippedBuildingLabel ?lat ?long
WHERE {
?site a geo:SpatialThing.
?site rdfs:label ?siteLabel.
FILTER (lang(?siteLabel)="zh-latn-pinyin")
BIND (str(?siteLabel) AS ?strippedSiteLabel)

?building schema:containedInPlace ?site.
?building rdfs:label ?buildingLabel.
FILTER (lang(?buildingLabel)="zh-latn-pinyin")
BIND (str(?buildingLabel) AS ?strippedBuildingLabel)

?building geo:lat ?lat.
?building geo:long ?long.
}
ORDER BY ?site
LIMIT 10
```

**Question 7 answer**:
```
SELECT DISTINCT ?strippedSiteLabel ?startDynastyName ?endDynastyName
WHERE {
?site a geo:SpatialThing.
?site rdfs:label ?siteLabel.
FILTER (lang(?siteLabel)="zh-latn-pinyin")
BIND (str(?siteLabel) AS ?strippedSiteLabel)

?site dcterms:temporal ?periodOfTime.
?periodOfTime time:intervalStartedBy ?startingDynasty.
?periodOfTime time:intervalFinishedBy ?endingDynasty.
?startingDynasty skos:prefLabel ?startDynastyName.
?endingDynasty skos:prefLabel ?endDynastyName.
}
LIMIT 10
```

**Question 8 answer**:
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

?periodOfTime time:intervalFinishedBy ?endingDynasty.
?endingDynasty skos:prefLabel ?endDynastyName.
?endingDynasty time:intervalStartedBy ?siteEndDate.
?siteEndDate skos:prefLabel ?siteEndDateLabel.
}
```
