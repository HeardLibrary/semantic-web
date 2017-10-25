# TDWG standards machine-readable metadata
**Vanderbilt University Semantic Web Working Group SPARQL endpoint**

[back to the User Guide](README.md)

[go to the SPARQL query interface](https://sparql.vanderbilt.edu/#query)

Some of the IRIs in this graph dereference as human-readable text and some may return machine-readable RDF/XML.  Eventually, every URI will dereference in both human- and machine-readable form, but as of 2017-10-24, this has not yet been achieved.

## Status

The [Standards Documentation Specification](https://github.com/tdwg/vocab/blob/master/sds/documentation-specification.md) (SDS) of [Biodiversity Information Standards](http://www.tdwg.org/) (TDWG) describes how metadata related to TDWG standards should be described in machine-readable form.  The data in this graph include all current available metadata about TDWG standards.  The properties of resources in this graph should be considered relatively stable, given that they are generally specified by the SDS.  This is particularly true for metadata about vocabularies, term lists, and terms.  Properties of documents is still under development as of 2017-10-24 and most documents are not yet described fully.

## Named graphs in the triple store

### TDWG standards metadata graph http://rs.tdwg.org/

There are currently about 31 000 triples in the graph.  

The raw metadata used to generate the graph is located at https://github.com/tdwg/rs.tdwg.org.  A general description of the metadata model and patterns used for IRIs that identify resources are described in [that repo's README](https://github.com/tdwg/rs.tdwg.org/blob/master/README.md).



# Beyond this point is under construction and contains irrelevant information that is being used as a template.


**Graph model:**

![concept scheme graph](media/cv-graph.png)

Some  



**CURIEs (namespaces) used:**
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX vann: <http://purl.org/vocab/vann/>
PREFIX tdwgutility: <http://rs.tdwg.org/dwc/terms/attributes/>
```
**Sample queries:**

List the terms in the controlled vocabulary and give their label and definition in Spanish.  To retrieve labels and definitions in other languages, replace 'es' with 'pt', 'en', 'zh-hans', 'zh-hant', or 'de'.  (A web application that uses a variant of this query to make a multilingual pick list is [here](http://bioimages.vanderbilt.edu/pick-list.html?de) and is described [here](http://baskauf.blogspot.com/2017/05/using-tdwg-standards-documentation.html).)
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX cvstatus: <http://rs.tdwg.org/cv/status/>
SELECT DISTINCT ?term ?label ?def WHERE {
?term rdfs:isDefinedBy cvstatus:.
?term skos:prefLabel ?label.
?term skos:definition ?def.
FILTER (lang(?label)='es')
FILTER (lang(?def)='es')
}
ORDER BY ASC(?label)
```

Determine which controlled vocabulary term has been associated with the string "Común" as a label.  The query checks the normative string values of terms (value of rdf:value), all language tagged preferred labels of terms (values of skos:prefLabel), and all string variants known to have been used with terms (values of skos:hiddenLabel).  (A web application that uses a variant of this query to perform data cleaning is [here](http://bioimages.vanderbilt.edu/clean.html) and is described [here](http://baskauf.blogspot.com/2017/05/using-tdwg-standards-documentation.html).)
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX cvstatus: <http://rs.tdwg.org/cv/status/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
SELECT DISTINCT ?term where {
?term rdfs:isDefinedBy cvstatus:.
 {?term skos:prefLabel ?langLabel.FILTER (str(?langLabel) = 'Común')}
UNION
 {?term skos:hiddenLabel 'Común'. }
UNION
 {?term rdf:value 'Común'. }
}
```

## Using the SPARQL endpoint as an API

### Format of the GET URI

Using an HTTP GET request, a limitless variety of data can be retrieved by sending the appropriate SPARQL query to the endpoint.  If the request header ```Accept: application/sparql-results+json``` is sent with the request, the results will be returned as JSON.  (For our endpoint, without an Accept header, the default format is XML.)  The endpoint URI is https://sparql.vanderbilt.edu/sparql .  The query is sent as a query string with the key "query" and value as the URL-encoded query string; for example:

```
query=PREFIX%20rdf%3A%20%3Chttp%3A%2F ...
```
The overall GET URL looks like this:
```
https://sparql.vanderbilt.edu/sparql?query=PREFIX%20rdf%3A%20%3Chttp%3A%2F ...
```

### Example query to retrieve all known "dirty" string values for all terms.

If you have built an application to do data cleaning on "dirty" string values for dwc:occurrenceStatus, you might want to periodically update your application with the most recent and comprehensive list of known string values and the controlled value terms with which they are associated.  The following query will retrieve pairs of term URIs and known values:

```
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
SELECT DISTINCT ?term ?value where {
?term <http://www.w3.org/2000/01/rdf-schema#isDefinedBy> <http://rs.tdwg.org/cv/status/>.
{?term skos:prefLabel ?langLabel.FILTER (str(?langLabel) = ?value)}
UNION
{?term skos:hiddenLabel ?value. }
UNION
{?term <http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?value. }
}
```

You can test this query by pasting it into the box at https://sparql.vanderbilt.edu .

### API call to retrieve all known "dirty" string values for all terms

Using a [URL Encoder](https://meyerweb.com/eric/tools/dencoder/) to encode the query, here is the GET URI necessary to retrieve the data:
```
https://sparql.vanderbilt.edu/sparql?query=PREFIX%20skos%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0ASELECT%20DISTINCT%20%3Fterm%20%3Fvalue%20where%20%7B%0A%3Fterm%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23isDefinedBy%3E%20%3Chttp%3A%2F%2Frs.tdwg.org%2Fcv%2Fstatus%2F%3E.%0A%7B%3Fterm%20skos%3AprefLabel%20%3FlangLabel.FILTER%20(str(%3FlangLabel)%20%3D%20%3Fvalue)%7D%0AUNION%0A%7B%3Fterm%20skos%3AhiddenLabel%20%3Fvalue.%20%7D%0AUNION%0A%7B%3Fterm%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23value%3E%20%3Fvalue.%20%7D%0A%7D
```

With a header of ```Accept: application/sparql-results+json```, here is what the (truncated) JSON results look like:
```
{
    "head": {
        "vars": [
            "term",
            "value"
        ]
    },
    "results": {
        "bindings": [
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/extant"
                },
                "value": {
                    "type": "literal",
                    "value": "Raro"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/extant"
                },
                "value": {
                    "type": "literal",
                    "value": "Reported"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/inappropriate"
                },
                "value": {
                    "type": "literal",
                    "value": "Processed"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/inappropriate"
                },
                "value": {
                    "type": "literal",
                    "value": "radan vieressä"
                }
            },
...
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/uncertain"
                },
                "value": {
                    "type": "literal",
                    "value": "uncertain"
                }
            }
        ]
    }
}
```
If the JSON response body is loaded into a Javascript object called "returnedJson", the term URIs and string values can be referenced as array values by
```
returnedJson.results.bindings[i].term.value
```
and
```
returnedJson.results.bindings[i].value.value
```
respectively.

### API call for the first sample query to retrieve term labels and definitions in Spanish

**GET URI:**
```
https://sparql.vanderbilt.edu/sparql?query=PREFIX%20skos%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0ASELECT%20DISTINCT%20%3Fterm%20%3Flabel%20%3Fdef%20WHERE%20%7B%0A%3Fterm%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23isDefinedBy%3E%20%3Chttp%3A%2F%2Frs.tdwg.org%2Fcv%2Fstatus%2F%3E.%0A%3Fterm%20skos%3AprefLabel%20%3Flabel.%0A%3Fterm%20skos%3Adefinition%20%3Fdef.%0AFILTER%20(lang(%3Flabel)%3D%27es%27)%0AFILTER%20(lang(%3Fdef)%3D%27es%27)%0A%7D%0AORDER%20BY%20ASC(%3Flabel)
```
(for a different language, substitute a different language code for the two occurrences of "es" in the query string)


**JSON response:**
```
{
    "head": {
        "vars": [
            "term",
            "label",
            "def"
        ]
    },
    "results": {
        "bindings": [
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/absent"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "ausente"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "No está presente en la localidad"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/extant"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "existente"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "Se conoce o espera con alta probabilidad que la especie se encuentre en el area, incluyendo localidades con registros recientes (los ultimos  20-30 años) de la presencia de un habitat adecuado a una altitud apropiada"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/extinct"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "extinta"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "Se sabe de la existencia de la especie en el area en el pasado, o se cree que la especie pudo haber existido en el area, pero se ha confirmado que la especie no se encuentra debido a que luego de búsquedas exhaustivas, no se han producido registros recientes, y la intensidad duracion de amenazas posiblemente hayan extirpado el taxón"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/recentlyextinct"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "extinta post 1500"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "Se sabe de la existencia de la especie en el area en el pasado, o se cree que la especie pudo haber existido en el area (despues del año 1,500), pero se ha confirmado que la especie no se encuentra debido a que luego de búsquedas exhaustivas, no se han producido registros recientes, y la intensidad duracion de amenazas posiblemente hayan extirpado el taxón"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/inappropriate"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "inadecuado"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "El registro incluye un valor no adecuado para la propiedad estadoOcurrencia"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/pextant"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "posiblemente existente"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "No hay registro de la especie en el area, pero es posible que la especie se encuentre allí"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/pextinct"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "possiblemente extinta"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "Se sabe de la existencia de la especie en el area en el pasado, o se cree que la especie pudo haber existido en el area, pero es muy probable que la especie no se encuentre debido a que luego de búsquedas exhaustivas, no se han producido registros recientes y la intensidad duracion de amenazas posiblemente hayan extirpado el taxón"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/uncertain"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "presencia incierta"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "La presencia de la especie se ha registrado en el area, pero dicho registro necesita ser verificado o es cuestionable debido a la incertidumbre o autenticidad del registro o la exactitud de la localidad"
                }
            },
            {
                "term": {
                    "type": "uri",
                    "value": "http://rs.tdwg.org/cv/status/null"
                },
                "label": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "sin valor"
                },
                "def": {
                    "xml:lang": "es",
                    "type": "literal",
                    "value": "El registro no incluye valor adecuado"
                }
            }
        ]
    }
}
```

**Javascript array references:**

```returnedJson.results.bindings[i].term.value``` for the term URI

```returnedJson.results.bindings[i].label.value``` for the term label

```returnedJson.results.bindings[i].def.value``` for the term definition

## Some additional notes about metadata management

Although the metadata about the controlled vocabulary are accessed by searching RDF triples in the Blazegraph graph database, they will actually be managed as CSV files on Github.  Ultimately, they will probably be maintained on the [TDWG Github site](https://github.com/tdwg), but currently they are at https://github.com/baskaufs/cv.  The data used to generate the "standards" metadata are in [this CSV file](https://github.com/baskaufs/cv/blob/master/occurrenceStatus/occurrenceStatus.csv), the translations metadata are in [this CSV file](https://github.com/baskaufs/cv/blob/master/occurrenceStatusTranslations/occurrenceStatusTranslations.csv), and the mapping of "dirty" string values to controlled vocabulary terms are in [this CSV file](https://github.com/baskaufs/cv/blob/master/occurrenceStatusHiddenLabel/occurrenceStatusHiddenLabel.csv) that was derived from actual data from GBIF.  

The CSV columns are mapped to RDF predicates using the mappings [here](https://github.com/baskaufs/cv/blob/master/occurrenceStatus/occurrenceStatus-column-mappings.csv), [here](https://github.com/baskaufs/cv/blob/master/occurrenceStatusTranslations/occurrenceStatusTranslations-column-mappings.csv), and [here](https://github.com/baskaufs/cv/blob/master/occurrenceStatusHiddenLabel/occurrenceStatusHiddenLabel-column-mappings.csv) by [Guid-O-Matic](https://github.com/baskaufs/guid-o-matic/blob/master/README.md), which is described [here](http://baskauf.blogspot.com/2016/10/guid-o-matic-goes-to-china.html).  The web server version of Guid-O-Matic described [here](http://baskauf.blogspot.com/2017/03/a-web-service-with-content-negotiation.html) has a graph dump URI that was used to load the graphs directly into Blazegraph.  The details aren't important - the point is that changes to the three data sources (the "standard", the translations, and the "dirty" values) are made by updating the corresponding CSVs on Github, not by editing the RDF directly or manipulating the triples directly in the graph database.  This avoids manual editing of anything other than the source CSVs on Github.  A client consuming the machine-readable data from the endpoint will get exactly the labels and definitions entered in the CSV files because the transformations are all automated.



[back to the User Guide](README.md)

[go to the SPARQL query interface](https://sparql.vanderbilt.edu/#query)
