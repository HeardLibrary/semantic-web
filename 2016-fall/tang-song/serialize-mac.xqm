xquery version "3.1";
module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize';
import module namespace propvalue = 'http://bioimages.vanderbilt.edu/xqm/propvalue' at 'https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/propvalue.xqm'; (: can substitute local directory if you need to mess with it :)
(:--------------------------------------------------------------------------------------------------:)

declare function serialize:main($id,$serialization)
{
  
let $localFilesFolderUnix := file:current-dir() || "/Repositories/semantic-web/2016-fall/tang-song/" (: Subsitute your path here:)

let $metadataDoc := file:read-text($localFilesFolderUnix || 'metadata.csv')
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : "," })
let $columnIndexDoc := file:read-text(concat($localFilesFolderUnix, 'column-index.csv'))
let $xmlColumnIndex := csv:parse($columnIndexDoc, map { 'header' : true(),'separator' : "," })
let $namespaceDoc := file:read-text(concat($localFilesFolderUnix,'namespace.csv'))
let $xmlNamespace := csv:parse($namespaceDoc, map { 'header' : true(),'separator' : "," })
let $classesDoc := file:read-text(concat($localFilesFolderUnix,'classes.csv'))
let $xmlClasses := csv:parse($classesDoc, map { 'header' : true(),'separator' : "," })

let $namespaces := $xmlNamespace/csv/record
let $columnInfo := $xmlColumnIndex/csv/record
let $classes := $xmlClasses/csv/record

(: The main function returns a single string formed by concatenating all of the assembled pieces of the document :)
return (
  concat( 
    (: the namespace abbreviations only needs to be generated once for the entire document :)
    serialize:list-namespaces($namespaces,$serialization),
    string-join( 
      (: each record in the database must be checked for a match to the requested URI :)
      for $record in $xmlMetadata/csv/record
      where $record/iri/text()=concat("http://art.vanderbilt.edu/",$id)
      let $baseIRI := $record/iri/text()
      let $modified := $record/modified/text()
      return 
        ( 
          (: Generate unabbreviated URIs and blank node identifiers. This must be done for every record separately since the UUIDs generated for the blank node identifiers must be the same within a record, but differ among records. :)
          let $IRIs := serialize:construct-iri($baseIRI,$classes)
          (: generate a description for each class of resource included in the record :)
          for $modifiedClass in $IRIs
          return serialize:describe-resource($IRIs,$columnInfo,$record,$modifiedClass,$serialization,$namespaces) 
          ,
          (: The document description is done once for each record. :)
          serialize:describe-document($baseIRI,$modified,$serialization,$namespaces)
        )
      ),
    serialize:close-container($serialization)
    ) 
  )
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:describe-document($baseIRI,$modified,$serialization,$namespaces)
{
  let $type := "http://xmlns.com/foaf/0.1/Document"
  let $suffix := propvalue:extension($serialization)
  let $iri := concat($baseIRI,$suffix)
  return concat(
    propvalue:subject($iri,$serialization),
    propvalue:plain-literal("dc:format",propvalue:media-type($serialization),$serialization),
    propvalue:plain-literal("dc:creator","Vanderbilt History of Art Department",$serialization),
    propvalue:iri("dcterms:references",$baseIRI,$serialization,$namespaces),
    if ($modified)
    then propvalue:datatyped-literal("dcterms:modified",$modified,"http://www.w3.org/2001/XMLSchema#dateTime",$serialization,$namespaces)
    else "",
    propvalue:type($type,$serialization,$namespaces)
  )  
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:remove-last-comma($temp)
{
  concat(fn:substring($temp,1,fn:string-length($temp)-2),"&#10;")
};

(:--------------------------------------------------------------------------------------------------:)

(: This generates the list of namespace abbreviations used :)
declare function serialize:list-namespaces($namespaces,$serialization)
{  
(: Because this is the beginning of the file, it also opens the root container for the serialization (if any) :)
switch ($serialization)
    case "turtle" return string-join(serialize:curie-value-pairs($namespaces,$serialization))

    case "xml" return concat(
                          "<rdf:RDF&#10;",
                          string-join(serialize:curie-value-pairs($namespaces,$serialization)),
                          ">&#10;"
                        )
    case "json" return concat(
                          "{&#10;",
                          '"@context": {&#10;',
                          serialize:remove-last-comma(string-join(serialize:curie-value-pairs($namespaces,$serialization))),
                          '},&#10;',
                          '"@graph": [&#10;'
                        )
    default return ""
};

(:--------------------------------------------------------------------------------------------------:)

(: generate sequence of CURIE,value pairs :)
declare function serialize:curie-value-pairs($namespaces,$serialization)
{
  for $namespace in $namespaces
  return switch ($serialization)
        case "turtle" return concat("@prefix ",$namespace/curie/text(),": <",$namespace/value/text(),">.&#10;")
        case "xml" return concat('xmlns:',$namespace/curie/text(),'="',$namespace/value/text(),'"&#10;')
        case "json" return concat('"',$namespace/curie/text(),'": "',$namespace/value/text(),'",&#10;')
        default return ""
};

(:--------------------------------------------------------------------------------------------------:)

(: This function describes a single instance of the type of resource being described by the table :)
declare function serialize:describe-resource($IRIs,$columnInfo,$record,$class,$serialization,$namespaces)
{  
(: Note: the propvalue:subject function sets up any string necessary to open the container, and the propvalue:type function closes the container :)
  let $type := $class/class/text()
  let $suffix := $class/id/text()
  let $iri := $class/fullId/text()
  return concat(
    propvalue:subject($iri,$serialization),
    string-join(serialize:property-value-pairs($IRIs,$columnInfo,$record,$type,$serialization,$namespaces)),
    propvalue:type($type,$serialization,$namespaces)
  )
  ,
  (: each described resource must be separated by a comma in JSON. The last described resource is the document, which isn't followed by a trailing comma :)
  if ($serialization="json")
  then ",&#10;"
  else ""
};

(:--------------------------------------------------------------------------------------------------:)

(: generate sequence of non-type property/value pair strings :)
declare function serialize:property-value-pairs($IRIs,$columnInfo,$record,$type,$serialization,$namespaces)
{
  (: generates property/value pairs that have fixed values :)
  for $columnType in $columnInfo
  where "$constant" = $columnType/header/text() and $columnType/class/text() = $type
  return switch ($columnType/type/text())
     case "plain" return propvalue:plain-literal($columnType/predicate/text(),$columnType/value/text(),$serialization)
     case "datatype" return propvalue:datatyped-literal($columnType/predicate/text(),$columnType/value/text(),$columnType/attribute/text(),$serialization,$namespaces)
     case "language" return propvalue:language-tagged-literal($columnType/predicate/text(),$columnType/value/text(),$columnType/attribute/text(),$serialization)
     case "iri" return propvalue:iri($columnType/predicate/text(),$columnType/value/text(),$serialization,$namespaces)
     default return ""
,

  (: generates property/value pairs whose values are given in the metadata table :)
  for $column in $record/child::*, $columnType in $columnInfo
  (: The loop only includes columns containing properties associated with the class of the described resource; that column in the record must not be empty :)
  where fn:local-name($column) = $columnType/header/text() and $columnType/class/text() = $type and $column//text() != ""
  return switch ($columnType/type/text())
     case "plain" return propvalue:plain-literal($columnType/predicate/text(),$column//text(),$serialization)
     case "datatype" return propvalue:datatyped-literal($columnType/predicate/text(),$column//text(),$columnType/attribute/text(),$serialization,$namespaces)
     case "language" return propvalue:language-tagged-literal($columnType/predicate/text(),$column//text(),$columnType/attribute/text(),$serialization)
     case "iri" return propvalue:iri($columnType/predicate/text(),$column//text(),$serialization,$namespaces)
     default return ""
,

  (: generates links to associated resources described in the same document :)
  for $columnType in $columnInfo
  where "$link" = $columnType/header/text() and $columnType/class/text() = $type
  let $suffix := $columnType/value/text()
  return 
      for $iri in $IRIs
      where $iri/id/text()=$suffix
      let $object := $iri/fullId/text()
      return propvalue:iri($columnType/predicate/text(),$object,$serialization,$namespaces)
};

(:--------------------------------------------------------------------------------------------------:)

(: this function closes the root container for the serialization (if any) :)
declare function serialize:close-container($serialization)
{  
switch ($serialization)
    case "turtle" return ""
    case "xml" return "</rdf:RDF>&#10;"
    case "json" return ']&#10;}'
    default return ""
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:construct-iri($baseIRI,$classes)
{
  (: This function basically creates a parallel set of class records that contain the full URIs in addition to the abbreviated ones that are found in classes.csv . In addition, UUID blank node identifiers are generated for nodes that are anonymous.  UUIDs are used instead of sequential numbers since the main function may be hacked to serializa ALL records rather than just one and in that case using UUIDs would ensure that there is no duplication of blank node identifiers among records. :)
  for $class in $classes
  let $suffix := $class/id/text()
  return
     <record>{
     if (fn:substring($suffix,1,2)="_:")
     then (<fullId>{concat("_:",random:uuid() ) }</fullId>, $class/id, $class/class )
     else (<fullId>{concat($baseIRI,$suffix) }</fullId>, $class/id, $class/class )
   }</record>
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:html($id,$serialization)
{
 let $value := concat("Placeholder page for local ID=",$id,".")
return 
<html>
  <body>
  {$value}
  </body>
</html>
};
