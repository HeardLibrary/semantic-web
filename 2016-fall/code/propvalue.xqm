xquery version "3.1";

module namespace propvalue = 'http://bioimages.vanderbilt.edu/xqm/propvalue';

declare function propvalue:subject($iri,$serialization)
{
  (: Note: the subject iri begins the description, so the returned string includes characters necessary to open the container.  In turtle and xml, blank nodes have different formats than full URIs :)
switch ($serialization)
  case "turtle" return 
       if (fn:substring($iri,1,2)="_:") 
       then concat($iri,"&#10;") 
       else concat("<",$iri,">&#10;")
  case "xml" return 
        if (fn:substring($iri,1,2)="_:") 
       then concat('<rdf:Description rdf:nodeID="',concat("U",fn:substring($iri,3,fn:string-length($iri)-2)),'">&#10;') 
       else concat('<rdf:Description rdf:about="',$iri,'">&#10;')
  case "json" return concat("{&#10;",'"@id": "',$iri,'",&#10;')
  default return ""
};

declare function propvalue:plain-literal($predicate,$string,$serialization)
{
switch ($serialization)
  case "turtle" return concat("     ",$predicate,' "',$string,'";&#10;')
  case "xml" return concat("     <",$predicate,'>',$string,'</',$predicate,'>&#10;')
  case "json" return concat('"',$predicate,'": "',$string,'",&#10;')
  default return ""
};

declare function propvalue:datatyped-literal($predicate,$string,$datatype,$serialization)
{
switch ($serialization)
  case "turtle" return concat("     ",$predicate,' "',$string,'"^^<',$datatype,">;&#10;")
  case "xml" return concat("     <",$predicate,' rdf:datatype="',$datatype,'">',$string,'</',$predicate,'>&#10;')
  case "json" return concat('"',$predicate,'": {"@type": "',$datatype,'","@value": "',$string,'"},&#10;')
  default return ""
};

declare function propvalue:language-tagged-literal($predicate,$string,$lang,$serialization)
{
switch ($serialization)
  case "turtle" return concat("     ",$predicate,' "',$string,'"@',$lang,";&#10;")
  case "xml" return concat("     <",$predicate,' xml:lang="',$lang,'">',$string,'</',$predicate,'>&#10;')
  case "json" return concat('"',$predicate,'": {"@language": "',$lang,'","@value": "',$string,'"},&#10;')
  default return ""
};

declare function propvalue:iri($predicate,$string,$serialization)
{
  (: blank nodes need special handling for turtle and xml :)
switch ($serialization)
  case "turtle" return 
       if (fn:substring($string,1,2)="_:") 
       then concat("     ",$predicate,' ',$string,";&#10;") 
       else concat("     ",$predicate,' <',$string,'>',";&#10;")
  case "xml" return 
       if (fn:substring($string,1,2)="_:") 
       then concat("     <",$predicate,' rdf:nodeID="',concat("U",fn:substring($string,3,fn:string-length($string)-2)),'"/>&#10;') 
       else concat("     <",$predicate,' rdf:resource="',$string,'"/>&#10;')
  case "json" return concat('"',$predicate,'": {"@id": "',$string,'"},&#10;')
  default return ""
};

declare function propvalue:type($type,$serialization)
{
  (: Note: type is the last property listed, so the returned string includes characters necessary to close the container :)
  (: There also is no trailing separator (if the serialization has one) :)
switch ($serialization)
  case "turtle" return concat("     a <",$type,">.&#10;&#10;")
  case "xml" return concat('     <rdf:type rdf:resource="',$type,'"/>&#10;','</rdf:Description>&#10;&#10;')
  case "json" return concat('"@type": "',$type,'"&#10;',"}&#10;")
  default return ""
};

declare function propvalue:media-type($serialization)
{
switch ($serialization)
  case "turtle" return "text/turtle"
  case "xml" return "application/rdf+xml"
  case "json" return "application/json"
  default return ""
};

declare function propvalue:extension($serialization)
{
switch ($serialization)
  case "turtle" return ".ttl"
  case "xml" return ".rdf"
  case "json" return ".json"
  default return ""
};

