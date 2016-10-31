# Answers to the SPARQL queries on the tang-song metadata (2016-10-31)

There may be multiple ways to answer the challenge questions.

**Question 5 answer**:
```
SELECT DISTINCT ?strippedSiteLabel ?startDynastyLabel ?siteStartDateLabel ?endDynastyLabel ?siteEndDateLabel
WHERE {
?site a geo:SpatialThing.
?site rdfs:label "
?site rdfs:label ?siteLabel.
FILTER (lang(?siteLabel)="zh-latn-pinyin")
BIND (str(?siteLabel) AS ?strippedSiteLabel)
}
```
