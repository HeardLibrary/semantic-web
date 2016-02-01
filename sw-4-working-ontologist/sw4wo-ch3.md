#Semantic Web for the Working Ontologist chapter 3 notes

## Clifford Anderson RDF at VIAF
Here's how I found out what VIAF had to say about Cliff:

1. Go to http://viaf.org/ and search for "Clifford B Anderson".

2. Copy the permalink URI (http://viaf.org/viaf/168432349).

3. Dereference the URI requesting RDF/XML.  You can use cURL or other software, but I used the Advanced REST Client plugin for Chrome.  In the Advanced REST Client, paste Cliff's URI into the URI box.  In the Headers section (Form tab), I entered "Accept" as the name and "application/rdf+xml" as the value.  This is the MIME Media Type for an XML serialization of RDF.  I tried to get Turtle serialization by asking for text/turtle, but it apparently isn't served.

4. Here's what was returned from the server:

'''xml
<?xml version="1.0" encoding="utf-16"?>
<!DOCTYPE rdf:RDF [
	<!ENTITY rdf 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'>
	<!ENTITY rdfs 'http://www.w3.org/2000/01/rdf-schema#'>
	<!ENTITY xsd 'http://www.w3.org/2001/XMLSchema#'>
	<!ENTITY xml 'http://www.w3.org/XML/1998/namespace'>
	<!ENTITY schema 'http://schema.org/'>
	<!ENTITY genont 'http://www.w3.org/2006/gen/ont#'>
	<!ENTITY bgn 'http://bibliograph.net/'>
	<!ENTITY umbel 'http://umbel.org/umbel#'>
	<!ENTITY pto 'http://www.productontology.org/id/'>
	<!ENTITY void 'http://rdfs.org/ns/void#'>
	<!ENTITY foaf 'http://xmlns.com/foaf/0.1/'>
	<!ENTITY dcterms 'http://purl.org/dc/terms/'>
	<!ENTITY skos 'http://www.w3.org/2004/02/skos/core#'>
]>
<rdf:RDF xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:schema="http://schema.org/" xmlns:genont="http://www.w3.org/2006/gen/ont#" xmlns:bgn="http://bibliograph.net/" xmlns:umbel="http://umbel.org/umbel#" xmlns:pto="http://www.productontology.org/id/" xmlns:void="http://rdfs.org/ns/void#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <schema:Person rdf:about="http://viaf.org/viaf/168432349" dcterms:identifier="168432349" schema:alternateName="Clifford B. Anderson" schema:birthDate="1970" schema:familyName="Anderson" schema:givenName="Clifford B.">
    <schema:name xml:lang="en">Clifford B. Anderson</schema:name>
    <schema:name xml:lang="en-us">Clifford B. Anderson</schema:name>
    <schema:name xml:lang="fr-fr">Clifford B. Anderson</schema:name>
    <schema:name xml:lang="nl-nl">Clifford Anderson</schema:name>
    <schema:sameAs rdf:resource="http://id.loc.gov/authorities/names/n2011010026" />
    <schema:sameAs rdf:resource="http://isni.org/isni/0000000115389774" />
    <schema:sameAs rdf:resource="http://www.idref.fr/158171160/id" />
    <rdfs:comment xml:lang="en">Warning: skos:prefLabels are not ensured against change!</rdfs:comment>
    <skos:prefLabel xml:lang="en-us">Clifford B. Anderson</skos:prefLabel>
    <skos:prefLabel xml:lang="nl-nl">Clifford Anderson</skos:prefLabel>
  </schema:Person>
  <genont:InformationResource rdf:about="http://viaf.org/viaf/168432349/">
    <void:inDataset rdf:resource="http://viaf.org/viaf/data" />
    <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" />
    <foaf:primaryTopic rdf:resource="http://viaf.org/viaf/168432349" />
  </genont:InformationResource>
  <skos:Concept rdf:about="http://viaf.org/viaf/sourceID/ISNI%7C0000000115389774#skos:Concept" skos:altLabel="Anderson, Clifford B." skos:prefLabel="Anderson, Clifford B.">
    <skos:inScheme rdf:resource="http://viaf.org/authorityScheme/ISNI" />
    <foaf:focus rdf:resource="http://viaf.org/viaf/168432349" />
  </skos:Concept>
  <skos:Concept rdf:about="http://viaf.org/viaf/sourceID/LC%7Cn+2011010026#skos:Concept" skos:prefLabel="Anderson, Clifford B.">
    <skos:inScheme rdf:resource="http://viaf.org/authorityScheme/LC" />
    <foaf:focus rdf:resource="http://viaf.org/viaf/168432349" />
  </skos:Concept>
  <skos:Concept rdf:about="http://viaf.org/viaf/sourceID/NTA%7C337889384#skos:Concept" schema:url="http://opc4.kb.nl/PPN?PPN=337889384" skos:altLabel="Anderson, Clifford B." skos:prefLabel="Anderson, Clifford (Clifford Blake)">
    <skos:inScheme rdf:resource="http://viaf.org/authorityScheme/NTA" />
    <foaf:focus rdf:resource="http://viaf.org/viaf/168432349" />
  </skos:Concept>
  <skos:Concept rdf:about="http://viaf.org/viaf/sourceID/SUDOC%7C158171160#skos:Concept" skos:prefLabel="Anderson, Clifford B.">
    <skos:inScheme rdf:resource="http://viaf.org/authorityScheme/SUDOC" />
    <foaf:focus rdf:resource="http://viaf.org/viaf/168432349" />
  </skos:Concept>
</rdf:RDF>
'''

5. To convert it to Turtle, I used rdfEditor, which unfortunately is only available for PCs.  In rdfEditor, I opened the RDF/XML file and used Save With from the file menu to save with the Turtle writer.  Here's what I got:

```
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>.
@prefix xsd: <http://www.w3.org/2001/XMLSchema#>.
@prefix xml: <http://www.w3.org/XML/1998/namespace>.
@prefix schema: <http://schema.org/>.
@prefix genont: <http://www.w3.org/2006/gen/ont#>.
@prefix bgn: <http://bibliograph.net/>.
@prefix umbel: <http://umbel.org/umbel#>.
@prefix pto: <http://www.productontology.org/id/>.
@prefix void: <http://rdfs.org/ns/void#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/>.
@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix skos: <http://www.w3.org/2004/02/skos/core#>.

<http://viaf.org/viaf/168432349> dcterms:identifier "168432349";
                                 schema:alternateName "Clifford B. Anderson";
                                 schema:birthDate "1970";
                                 schema:familyName "Anderson";
                                 schema:givenName "Clifford B.";
                                 schema:name "Clifford B. Anderson"@en,
                                             "Clifford B. Anderson"@en-us,
                                             "Clifford B. Anderson"@fr-fr,
                                             "Clifford Anderson"@nl-nl;
                                 schema:sameAs <http://id.loc.gov/authorities/names/n2011010026>,
                                               <http://isni.org/isni/0000000115389774>,
                                               <http://www.idref.fr/158171160/id>;
                                 a schema:Person;
                                 rdfs:comment "Warning: skos:prefLabels are not ensured against change!"@en;
                                 skos:prefLabel "Clifford B. Anderson"@en-us,
                                                "Clifford Anderson"@nl-nl.
<http://viaf.org/viaf/168432349/> void:inDataset <http://viaf.org/viaf/data>;
                                  a genont:InformationResource,
                                    foaf:Document;
                                  foaf:primaryTopic <http://viaf.org/viaf/168432349>.
<http://viaf.org/viaf/sourceID/ISNI%7C0000000115389774#skos:Concept> a skos:Concept;
                                                                     skos:altLabel "Anderson, Clifford B.";
                                                                     skos:inScheme <http://viaf.org/authorityScheme/ISNI>;
                                                                     skos:prefLabel "Anderson, Clifford B.";
                                                                     foaf:focus <http://viaf.org/viaf/168432349>.
<http://viaf.org/viaf/sourceID/LC%7Cn+2011010026#skos:Concept> a skos:Concept;
                                                               skos:inScheme <http://viaf.org/authorityScheme/LC>;
                                                               skos:prefLabel "Anderson, Clifford B.";
                                                               foaf:focus <http://viaf.org/viaf/168432349>.
<http://viaf.org/viaf/sourceID/NTA%7C337889384#skos:Concept> schema:url "http://opc4.kb.nl/PPN?PPN=337889384";
                                                             a skos:Concept;
                                                             skos:altLabel "Anderson, Clifford B.";
                                                             skos:inScheme <http://viaf.org/authorityScheme/NTA>;
                                                             skos:prefLabel "Anderson, Clifford (Clifford Blake)";
                                                             foaf:focus <http://viaf.org/viaf/168432349>.
<http://viaf.org/viaf/sourceID/SUDOC%7C158171160#skos:Concept> a skos:Concept;
                                                               skos:inScheme <http://viaf.org/authorityScheme/SUDOC>;
                                                               skos:prefLabel "Anderson, Clifford B.";
                                                               foaf:focus <http://viaf.org/viaf/168432349>.
```
These are exactly the same 39 triples as in the XML serialization.

6. To visualize the RDF as a bubble and arrow graph diagram, go to the W3C RDF Validation Service at http://www.w3.org/RDF/Validator/ .  Copy and paste the RDF/XML into the "Check by Direct Input" box.  Drop down "Graph Only" or "Triples and Graph" depending on what you want to see, then click on Parse RDF.

## Clifford Anderson RDF at ORCID

I got the RDF describing Cliff at ORCID using approximately the same method as above.  ORCID will dereference the URI as either text/turtle or application/rdf+xml, so there was no need to do the conversion using rdfEditor.  Here are the 31 triples about Cliff in XML and Turtle serializations:

### RDF/XML

```
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:pav="http://purl.org/pav/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:gn="http://www.geonames.org/ontology#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#" >
  <rdf:Description rdf:about="http://orcid.org/0000-0003-0328-0792#orcid-id">
    <rdfs:label>0000-0003-0328-0792</rdfs:label>
    <foaf:accountName>0000-0003-0328-0792</foaf:accountName>
    <foaf:accountServiceHomepage rdf:resource="http://orcid.org"/>
    <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/OnlineAccount"/>
  </rdf:Description>
  <rdf:Description rdf:about="http://sws.geonames.org/6252001/">
    <gn:name>United States</gn:name>
    <gn:countryCode>US</gn:countryCode>
    <rdfs:label>United States</rdfs:label>
  </rdf:Description>
  <rdf:Description rdf:nodeID="A0">
    <gn:parentCountry rdf:resource="http://sws.geonames.org/6252001/"/>
    <gn:countryCode>US</gn:countryCode>
    <rdf:type rdf:resource="http://www.geonames.org/ontology#Feature"/>
  </rdf:Description>
  <rdf:Description rdf:about="http://orcid.org/0000-0003-0328-0792#workspace-works">
    <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document"/>
  </rdf:Description>
  <rdf:Description rdf:about="http://pub.orcid.org/orcid-pub-web/experimental_rdf_v1/0000-0003-0328-0792">
    <pav:createdOn rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-12-10T16:46:58.271Z</pav:createdOn>
    <prov:generatedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2016-01-26T16:04:49.747Z</prov:generatedAtTime>
    <pav:lastUpdateOn rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2016-01-26T16:04:49.747Z</pav:lastUpdateOn>
    <pav:createdWith rdf:resource="http://orcid.org"/>
    <prov:wasAttributedTo rdf:resource="http://orcid.org/0000-0003-0328-0792"/>
    <pav:createdBy rdf:resource="http://orcid.org/0000-0003-0328-0792"/>
    <foaf:maker rdf:resource="http://orcid.org/0000-0003-0328-0792"/>
    <foaf:primaryTopic rdf:resource="http://orcid.org/0000-0003-0328-0792"/>
    <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/PersonalProfileDocument"/>
  </rdf:Description>
  <rdf:Description rdf:about="http://orcid.org/0000-0003-0328-0792">
    <foaf:name>Clifford B. Anderson</foaf:name>
    <foaf:account rdf:resource="http://orcid.org/0000-0003-0328-0792#orcid-id"/>
    <foaf:based_near rdf:nodeID="A0"/>
    <foaf:publications rdf:resource="http://orcid.org/0000-0003-0328-0792#workspace-works"/>
    <foaf:page rdf:resource="http://www.library.vanderbilt.edu/scholarly/"/>
    <foaf:givenName>Clifford</foaf:givenName>
    <rdf:type rdf:resource="http://www.w3.org/ns/prov#Person"/>
    <foaf:familyName>Anderson</foaf:familyName>
    <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Person"/>
    <foaf:plan></foaf:plan>
    <rdfs:label>Clifford B. Anderson</rdfs:label>
  </rdf:Description>
</rdf:RDF>
```

### RDF/Turtle

```
@prefix pav:   <http://purl.org/pav/> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix gn:    <http://www.geonames.org/ontology#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix prov:  <http://www.w3.org/ns/prov#> .
@prefix foaf:  <http://xmlns.com/foaf/0.1/> .

<http://orcid.org/0000-0003-0328-0792#workspace-works>
        a       foaf:Document .

<http://orcid.org/0000-0003-0328-0792#orcid-id>
        a                            foaf:OnlineAccount ;
        rdfs:label                   "0000-0003-0328-0792" ;
        foaf:accountName             "0000-0003-0328-0792" ;
        foaf:accountServiceHomepage  <http://orcid.org> .

<http://pub.orcid.org/orcid-pub-web/experimental_rdf_v1/0000-0003-0328-0792>
        a                     foaf:PersonalProfileDocument ;
        pav:createdBy         <http://orcid.org/0000-0003-0328-0792> ;
        pav:createdOn         "2013-12-10T16:46:58.271Z"^^xsd:dateTime ;
        pav:createdWith       <http://orcid.org> ;
        pav:lastUpdateOn      "2016-01-26T16:04:49.747Z"^^xsd:dateTime ;
        prov:generatedAtTime  "2016-01-26T16:04:49.747Z"^^xsd:dateTime ;
        prov:wasAttributedTo  <http://orcid.org/0000-0003-0328-0792> ;
        foaf:maker            <http://orcid.org/0000-0003-0328-0792> ;
        foaf:primaryTopic     <http://orcid.org/0000-0003-0328-0792> .

<http://sws.geonames.org/6252001/>
        rdfs:label      "United States" ;
        gn:countryCode  "US" ;
        gn:name         "United States" .

<http://orcid.org/0000-0003-0328-0792>
        a                  prov:Person , foaf:Person ;
        rdfs:label         "Clifford B. Anderson" ;
        foaf:account       <http://orcid.org/0000-0003-0328-0792#orcid-id> ;
        foaf:based_near    [ a                 gn:Feature ;
                             gn:countryCode    "US" ;
                             gn:parentCountry  <http://sws.geonames.org/6252001/>
                           ] ;
        foaf:familyName    "Anderson" ;
        foaf:givenName     "Clifford" ;
        foaf:name          "Clifford B. Anderson" ;
        foaf:page          <http://www.library.vanderbilt.edu/scholarly/> ;
        foaf:plan          "" ;
        foaf:publications  <http://orcid.org/0000-0003-0328-0792#workspace-works> .
```

---
Notes from Heath, T. and C. Bizer. 2011. Linked Data: Evolving the Web into a Global Data Space.

From [Section 2.4.1](http://linkeddatabook.com/editions/1.0/#htoc16), section entitled "RDF Features Best Avoided in the Linked Data Context":

1. RDF reification (SPARQL problems, suggests attaching metadata to the document containing the triples; see more on Semantic Sitemaps and voiD at [Publishing Data about Data](http://linkeddatabook.com/editions/1.0/#htoc45); see also the [W3C PROV Ontology](https://www.w3.org/TR/prov-o/) and the lighter-weight [draft Open Annotation data model](http://www.openannotation.org/spec/core/))

2. RDF collections and RDF containers (falls apart when queried by SPARQL)

3. blank nodes (scope limited to the document in which they appear, so can't be linked to)
