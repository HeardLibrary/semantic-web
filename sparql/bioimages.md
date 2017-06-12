# Bioiamges graph model
**Vanderbilt University Semantic Web Working Group**

## Status

The Bioimages dataset is relatively mature and has been in production for a number of years.  The graph model is based on a published model ([http://dx.doi.org/10.3233/SW-150203](http://www.semantic-web-journal.net/content/darwin-sw-darwin-core-based-terms-expressing-biodiversity-data-rdf-1)) as well as [TDWG](http://www.tdwg.org/) international biodiversity informatics standards, so it can be considered relatively stable.  See [this page](http://bioimages.vanderbilt.edu/pages/standards.htm) for details.

The dataset currently loaded is the 2017-06-11 release (https://doi.org/10.5281/zenodo.806034).

## Named graphs in the endpoint (URIs do not dereference)

### http://bioimages.vanderbilt.edu/organisms

CURIEs (namespaces) used:
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX dsw: <http://purl.org/dsw/>
PREFIX tc: <http://rs.tdwg.org/ontology/voc/TaxonConcept#>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX xmp: <http://ns.adobe.com/xap/1.0/>
PREFIX txn: <http://lod.taxonconcept.org/ontology/txn.owl#>
PREFIX blocal: <http://bioimages.vanderbilt.edu/rdf/local#>
```


### http://bioimages.vanderbilt.edu/images

CURIEs (namespaces) used:
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xhv: <http://www.w3.org/1999/xhtml/vocab#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX ac: <http://rs.tdwg.org/ac/terms/>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX dsw: <http://purl.org/dsw/>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX cc: <http://creativecommons.org/ns#>
PREFIX Iptc4xmpExt: <http://iptc.org/std/Iptc4xmpExt/2008-02-29/>
PREFIX exif: <http://ns.adobe.com/exif/1.0/>
PREFIX xmp: <http://ns.adobe.com/xap/1.0/>
PREFIX xmpRights: <http://ns.adobe.com/xap/1.0/rights/>
PREFIX photoshop: <http://ns.adobe.com/photoshop/1.0/>
PREFIX mbank: <http://www.morphbank.net/schema/morphbank#>
PREFIX blocal: <http://bioimages.vanderbilt.edu/rdf/local#>
```

### http://bioimages.vanderbilt.edu/people

CURIEs (namespaces) used:
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX xmp: <http://ns.adobe.com/xap/1.0/>
```


### http://bioimages.vanderbilt.edu/specimens

CURIEs (namespaces) used:
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX dsw: <http://purl.org/dsw/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
```

### http://bioimages.vanderbilt.edu/places

CURIEs (namespaces) used:
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX cc: <http://creativecommons.org/ns#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX gn: <http://www.geonames.org/ontology#>
PREFIX wgs84_pos: <http://www.w3.org/2003/01/geo/wgs84_pos#>
```

### http://bioimages.vanderbilt.edu/vocabs

This graph contains several vocabularies referenced in the RDF:

**Darwin-SW** (http://purl.org/dsw/) Described at: https://github.com/darwin-sw/dsw

**Standardized organism views** (http://bioimages.vanderbilt.edu/rdf/stdview) Described at: http://bioimages.vanderbilt.edu/pages/std-views.htm and http://www.cals.ncsu.edu/plantbiology/ncsc/vulpia/pdf/Baskauf_&_Kirchoff_Digital_Plant_Images.pdf (published paper) and http://baskauf.blogspot.com/2016/03/controlled-values-for-subject-category.html (blog post)

**Bioimages local properties**: (http://bioimages.vanderbilt.edu/rdf/local)
