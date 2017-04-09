xquery version "3.1";

declare namespace functx = "http://www.functx.com";
declare function functx:trim
  ( $arg as xs:string? )  as xs:string {

   replace(replace($arg,'\s+$',''),'^\s+','')
 } ;
 
(:--------------------------------------------------------------------------------------------------:)
(: Read in the CSV files :)
let $metadataDoc := file:read-text('file:///c:/github/semantic-web/vase/vase-only/vase.csv')
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : ',' })
let $vaseMetadata := $xmlMetadata/csv/record

let $metadataDoc := file:read-text('file:///c:/github/semantic-web/vase/scene-cv/scene.csv')
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : ',' })
let $cvData := $xmlMetadata/csv/record

(: Construct XML about the vase sides :)
let $vases :=
              for $vase in $vaseMetadata
              return <vase>
                          <vase-id>{$vase/local_unique_identifier/text()}</vase-id>
                          <side>{
                              <side-id>{$vase/side_A_identifier/text()}</side-id>,
                              for $scene in tokenize($vase/SCENE_TYPE_A/text(),',')
                              return (<cv-string>{functx:trim($scene)}</cv-string>)
                          }</side>
                          <side>{
                              <side-id>{$vase/side_B_identifier/text()}</side-id>,
                              for $scene in tokenize($vase/SCENE_TYPE_B/text(),',')
                              return <cv-string>{functx:trim($scene)}</cv-string>
                          }</side>
                     </vase>
return 
       (: Output a single string that is the Turtle (actually, Ntriples) file. :)
       file:write-text("c:\github\semantic-web\vase\scene-cv\cv-link.ttl",string-join
                           (
                            for $side in $vases//side, $cv in $cvData
                            where $cv//pref_label/text() = $side//cv-string/text() or $cv//alt_label/text() = $side//cv-string/text() or $cv//hide_label/text() = $side//cv-string/text()
                            return concat("<http://lod.vanderbilt.edu/scene/",$side//side-id/text(),"> <http://purl.org/dc/terms/subject> <http://lod.vanderbilt.edu/apulian/scene/",$cv//local_name/text(),'>.&#xa;')
                           )
                      
                      ) 