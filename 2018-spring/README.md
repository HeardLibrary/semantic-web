# Semantic Web Working Group - spring 2018

Links for 2018-01-15 meeting:

## Review Data From SPARQL

https://github.com/HeardLibrary/semantic-web/blob/master/2017-fall/data-from-sparql.md

## Reification

https://www.w3.org/TR/rdf-schema/#ch_reificationvocab

The Trouble with Triples (blogpost) https://blogs.library.duke.edu/dcthree/2013/07/27/the-trouble-with-triples/

## PROV-O: The PROV Ontology https://www.w3.org/TR/prov-o/ (A W3C Recommendation)

"This ontology specification provides the foundation to implement provenance applications in different domains that can represent, exchange, and integrate provenance information generated in different systems and under different contexts. Together with the PROV Access and Query [PROV-AQ] and PROV Data Model [PROV-DM], this document forms a framework for provenance information interchange in domain-specific Web-based applications.

PROV-O is a lightweight ontology that can be adopted in a wide range of applications. ... The PROV Ontology classes and properties are defined such that they can not only be used directly to represent provenance information, but also can be specialized for modeling application-specific provenance details in a variety of domains."

## PAV ontology: Provenance, authoring and versioning (PAV) https://jbiomedsem.biomedcentral.com/articles/10.1186/2041-1480-4-37 (published, but NOT a W3C Recommendation.  Lighter weight and therefore broader than PROV-O)

"Provenance is a critical ingredient for establishing trust of published scientific content. This is true whether we are considering a data set, a computational workflow, a peer-reviewed publication or a simple scientific claim with supportive evidence. Existing vocabularies such as Dublin Core Terms (DC Terms) and the W3C Provenance Ontology (PROV-O) are domain-independent and general-purpose and they allow and encourage for extensions to cover more specific needs. In particular, to track authoring and versioning information of web resources, PROV-O provides a basic methodology but not any specific classes and properties for identifying or distinguishing between the various roles assumed by agents manipulating digital artifacts, such as author, contributor and curator."

Note:
* In Results: PROV-O and PAV mapping shows how PAV refines PROV-O
* In Discussion: comparison to Dublin Core Terms and BIBFRAME.  Also, reference to complexity of FRBR.

## Web Annotation Data Model (a.k.a. Open Annotation or OA) https://www.w3.org/TR/annotation-model/ (W3C Recommendation)

"The Web Annotation Data Model specification describes a structured model and format to enable annotations to be shared and reused across different hardware and software platforms. Common use cases can be modeled in a manner that is simple and convenient, while at the same time enabling more complex requirements, including linking arbitrary content to a particular data point or to segments of timed multimedia resources."

"The Web Annotation Data Model is defined using the following basic principles:

An Annotation is a rooted, directed graph that represents a relationship between resources.
There are two primary types of resource that participate in this relationship, Bodies and Targets.
* Annotations have 0 or more Bodies.
* Annotations have 1 or more Targets.
* The content of the Body resources is related to, and typically "about", the content of the Target resources.
Annotations, Bodies and Targets may have their own properties and relationships, typically including creation and descriptive information.
* The intent behind the creation of an Annotation or the inclusion of a particular Body or Target is an important property and represented by a Motivation resource.""

Note: Described specifically as JSON-LD.

![](https://camo.githubusercontent.com/bcef77e006434af9c90313c95811d8dbceb2ba14/687474703a2f2f7777772e6f70656e616e6e6f746174696f6e2e6f72672f737065632f636f72652f696d616765732f6d6f7469766174696f6e732e706e67)

Example:
```
{
  "@context": "http://www.w3.org/ns/anno.jsonld",
  "id": "http://example.org/anno13",
  "type": "Annotation",
  "audience": {
    "id": "http://example.edu/roles/teacher",
    "type": "schema:EducationalAudience",
    "schema:educationalRole": "teacher"
  },
  "body": "http://example.net/classnotes1",
  "target": "http://example.com/textbook1"
}
```

## Application: (Union List of Artist Names) ULAN at Getty http://www.getty.edu/research/tools/vocabularies/

Go to ULAN.  Enter "Warhol". Click on "Warhol, Andy". Click on N3/Turtle.  Examine in text editor.

# Notes from 2018-04-02 meeting

# from William about the PROV Ontology

* PROV-O: The PROV Ontology: <https://www.w3.org/TR/prov-o/>  
* The PROV Namespace: <https://www.w3.org/ns/prov>  
* `prov:Activity`: <https://www.w3.org/TR/prov-o/#Activity>
* `prov:Agent`: <https://www.w3.org/TR/prov-o/#Agent>
* `prov:startedAtTime`: <https://www.w3.org/TR/prov-o/#startedAtTime>


## Getty Example of Prov
<http://vocab.getty.edu/aat/rev/5000057716>  

## Gregg's Sparql Query

> Note: Gregg's method uses dcterms:modified

Getty Sparql Endpoint: <http://vocab.getty.edu/sparql>


```
select ?dv {
aat:300198841 dcterms:modified ?dv
filter not exists {aat:300198841 dcterms:modified ?dv2
filter (?dv2 > ?dv)}}
```

## Getty Recently Modified Subject  
<http://vocab.getty.edu/queries#Recently_Modified_Subjects>

### 3.11   Recently Modified Subjects
Recently modified subjects have dct:modified after their dct:created (there's no such guarantee for subjects created a long time ago). There's a dct:modified timestamp for every revision action (see Revision History Representation), and there are a lot of them (3.8M as of Mar 2016). So let's limit to AAT, and look for the last 100 revision actions. We use max() to select only the latest modification time for each subject.  

```
select ?x ?lab (max(?mod) as ?mod1) {

  {select * {?x skos:inScheme aat:; dct:modified ?mod} order by desc(?mod) limit 100}

  ?x gvp:prefLabelGVP/xl:literalForm ?lab

} group by ?x ?lab
```

If you need to find all subjects changed since a certain date, use the following query. (Note: you need to copy it manually to the edit box put a more recent date, since we don't want it to get progressively slower with time.)

```
select ?x ?lab (max(?mod) as ?mod1) {

  ?x skos:inScheme aat:; dct:modified ?mod

  filter (?mod >= "2016-03-01T00:00:00"^^xsd:dateTime)

  ?x gvp:prefLabelGVP/xl:literalForm ?lab

} group by ?x ?lab
```

## Getty Vocabulary Web Services

>NOTE: The excerpt below comes from this document: <http://www.getty.edu/research/tools/vocabularies/vocab_web_services.pdf>

### GetRevisionHistory

Returns information on edits made to vocabulary data based on a date range and input parameter that indicates which piece of revision history information is desired.

Input Notes: Parameters for revision history option include,


1. – Overall subject record edits  
2. – Added, deleted, modified terms  
3. – Scope note edits  
4. – Moved records  
5. – New records  
6. – All edits and record types  
7. – Deleted records

English_only parameter (AAT only) allows users to request only English note edits.
GET examples:

<http://vocabsservices.getty.edu/AATService.asmx/AATGetRevisionHistory?startDate=1-AUG-2017&endDate=31-DEC-2017&param=2&english_only=N>

<http://vocabsservices.getty.edu/ULANService.asmx/ULANGetRevisionHistory?startDate=1-AUG-2017&endDate=31-DEC-2017&param=2>

<http://vocabsservices.getty.edu/TGNService.asmx/TGNGetRevisionHistory?startDate=1-AUG-2017&endDate=31-DEC-2017&param=2>

Output schemas:

<http://vocabsservices.getty.edu/Schemas/AAT/AATGetRevisionHistory.xsd>
<http://vocabsservices.getty.edu/Schemas/ULAN/ULANGetRevisionHistory.xsd>
<http://vocabsservices.getty.edu/Schemas/TGN/TGNGetRevisionHistory.xsd>

# from Steve about Web Annotation Data model

Web Annotation Data Model (W3C Recommendation): https://www.w3.org/TR/annotation-model/

Web Annotation Data Model uses JSON-LD.  Example: https://www.w3.org/TR/annotation-model/#annotations

Reasons for annotating: https://www.w3.org/TR/annotation-model/#motivation-and-purpose

Motivation and purpose example 15, use converter: http://www.easyrdf.org/converter

Notice how rdf:value is used for the text of the body

A SpecificResource (https://www.w3.org/TR/annotation-model/#specific-resources) captures additional information about the Target (or body) as it applies in the annotation. For example, the state - including time.  See https://www.w3.org/TR/annotation-model/#states . A state can have a link to a cached copy of the sources representation appropriate for the annotation.

dokieli uses the Web Annotation Model: https://dokie.li/ and https://github.com/linkeddata/dokieli

dokieli documentation: https://dokie.li/docs

annotated article: http://csarven.ca/dokieli-rww#abstract

dokieli annotation example (An example I haven't figured out how to use.): https://linkedresearch.org/annotation/csarven.ca/dokieli-rww/b6738766-3ce5-4054-96a9-ced7f05b439f
Use View Source in RDF translator. Note that the value of the body is in the HTML, but not a TextualBody included in the Turtle.  Need to create, then sign in with a WebID (see https://www.w3.org/wiki/WebID), can this work with Keybase?
