xquery version "3.1";
module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize';
import module namespace propvalue = 'http://bioimages.vanderbilt.edu/xqm/propvalue' at 'https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/code/propvalue.xqm'; (: can substitute local directory if you need to mess with it :)
(:--------------------------------------------------------------------------------------------------:)

declare function serialize:remove-last-comma($temp)
{
  concat(fn:substring($temp,1,fn:string-length($temp)-2),"&#10;")
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:lookup-base-iri($record)
{
  for $column in $record/child::*
  where fn:local-name($column) = "iri"
  return $column//text()
};
(:--------------------------------------------------------------------------------------------------:)
declare function serialize:lookup-modified-datetime($record)
{
  for $column in $record/child::*
  where fn:local-name($column) = "modified"
  return $column//text()
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
declare function serialize:describe-resource($baseIRI,$columnInfo,$record,$class,$serialization)
{  
(: Note: the propvalue:subject function sets up any string to open the container and the propvalue:type function closes the container :)
  let $type := $class/class/text()
  let $suffix := $class/id/text()
  let $iri := concat($baseIRI,$suffix)
  return concat(
    propvalue:subject($iri,$serialization),
    string-join(serialize:property-value-pairs($baseIRI,$columnInfo,$record,$type,$serialization)),
    propvalue:type($type,$serialization)
  )
  ,
  (: each described resource must be separated by a comma in JSON. The last described resource is the document, which isn't followed by a trailing comma :)
  if ($serialization="json")
  then ",&#10;"
  else ""
};

(:--------------------------------------------------------------------------------------------------:)

(: generate sequence of non-type property/value pair strings :)
declare function serialize:property-value-pairs($baseIRI,$columnInfo,$record,$type,$serialization)
{
  (: generates property/value pairs that have fixed values :)
  for $columnType in $columnInfo
  where "$constant" = $columnType/header/text() and $columnType/class/text() = $type
  return switch ($columnType/type/text())
     case "plain" return propvalue:plain-literal($columnType/predicate/text(),$columnType/value/text(),$serialization)
     case "datatype" return propvalue:datatyped-literal($columnType/predicate/text(),$columnType/value/text(),$columnType/attribute/text(),$serialization)
     case "language" return propvalue:language-tagged-literal($columnType/predicate/text(),$columnType/value/text(),$columnType/attribute/text(),$serialization)
     case "iri" return propvalue:iri($columnType/predicate/text(),$columnType/value/text(),$serialization)
     case "blank" return "blank"
     default return ""
,

  (: generates property/value pairs whose values are given in the metadata table :)
  for $column in $record/child::*, $columnType in $columnInfo
  (: The loop only includes columns containing properties associated with the class of the described resource :)
  where fn:local-name($column) = $columnType/header/text() and $columnType/class/text() = $type
  return switch ($columnType/type/text())
     case "plain" return propvalue:plain-literal($columnType/predicate/text(),$column//text(),$serialization)
     case "datatype" return propvalue:datatyped-literal($columnType/predicate/text(),$column//text(),$columnType/attribute/text(),$serialization)
     case "language" return propvalue:language-tagged-literal($columnType/predicate/text(),$column//text(),$columnType/attribute/text(),$serialization)
     case "iri" return propvalue:iri($columnType/predicate/text(),$column//text(),$serialization)
     case "blank" return "blank"
     default return ""
,

  (: generates links to associated resources described in the same document :)
  for $columnType in $columnInfo
  where "$link" = $columnType/header/text() and $columnType/class/text() = $type
  return 
      let $suffix := $columnType/value/text()
      let $iri := concat($baseIRI,$suffix)
      return propvalue:iri($columnType/predicate/text(),$iri,$serialization)
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:describe-document($baseIRI,$modified,$serialization)
{
  let $type := "http://xmlns.com/foaf/0.1/Document"
  let $suffix := propvalue:extension($serialization)
  let $iri := concat($baseIRI,$suffix)
  return concat(
    propvalue:subject($iri,$serialization),
    propvalue:plain-literal("dc:format",propvalue:media-type($serialization),$serialization),
    propvalue:plain-literal("dc:creator","Vanderbilt History of Art Department",$serialization),
    propvalue:iri("dcterms:references",$baseIRI,$serialization),
    if ($modified)
    then propvalue:datatyped-literal("dcterms:modified",$modified,"http://www.w3.org/2001/XMLSchema#dateTime",$serialization)
    else "",
    propvalue:type($type,$serialization)
  )  
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

declare function serialize:main($id,$serialization)
{
  
(: to run on local files, change the following paths to the location where you put the csv files, comment out the send-request lines, and uncomment the read-file lines :)  
let $localFilesFolderUnix := "c:/github/semantic-web/2016-fall/tang-song"
let $localFilesFolderPC := "c:\github\semantic-web\2016-fall\tang-song"

let $metadataDoc := file:read-text(concat('file:///',$localFilesFolderUnix,'/metadata.csv'))
(: let $metadataDoc := http:send-request(<http:request method='get' href='https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/code/metadata.csv'/>)[2] :)
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : "," })

let $columnIndexDoc := file:read-text(concat('file:///',$localFilesFolderUnix,'/column-index.csv'))
(: let $columnIndexDoc := http:send-request(<http:request method='get' href='https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/code/column-index.csv'/>)[2] :)
let $xmlColumnIndex := csv:parse($columnIndexDoc, map { 'header' : true(),'separator' : "," })

let $namespaceDoc := file:read-text(concat('file:///',$localFilesFolderUnix,'/namespace.csv'))
(: let $namespaceDoc := http:send-request(<http:request method='get' href='https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/code/namespace.csv'/>)[2] :)
let $xmlNamespace := csv:parse($namespaceDoc, map { 'header' : true(),'separator' : "," })

let $classesDoc := file:read-text(concat('file:///',$localFilesFolderUnix,'/classes.csv'))
(: let $classesDoc := http:send-request(<http:request method='get' href='https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/code/classes.csv'/>)[2] :)
let $xmlClasses := csv:parse($classesDoc, map { 'header' : true(),'separator' : "," })

let $namespaces := $xmlNamespace/csv/record
let $columnInfo := $xmlColumnIndex/csv/record
let $classes := $xmlClasses/csv/record

(: The main function returns a single string formed by concatenating all of the assembled pieces :)
return 

  concat(
    serialize:list-namespaces($namespaces,$serialization),
    string-join(
      for $record in $xmlMetadata/csv/record
      where $record/iri/text()=concat("http://art.vanderbilt.edu/",$id)
      let $baseIRI := serialize:lookup-base-iri($record)
      let $modified := serialize:lookup-modified-datetime($record)
      return (
          for $class in $classes
          return serialize:describe-resource($baseIRI,$columnInfo,$record,$class,$serialization)
          ,
          serialize:describe-document($baseIRI,$modified,$serialization)
        )
    ),
    serialize:close-container($serialization)
  )

};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:html($ns,$id,$serialization)
{
 let $value := concat("Placeholder page for namespace=",$ns," and local ID=",$id,".")
return 
<html>
  <body>
  {$value}
  </body>
</html>
};
