declare namespace search="http://www.orcid.org/ns/search";
declare namespace common="http://www.orcid.org/ns/common";

declare function local:query-endpoint($endpoint,$query)
{
(: Assumes default response is XML, if not then figure out how to send an Accept request header :)
let $encoded := $endpoint||"?"||$query
let $request := <http:request href='{$encoded}' method='get'/>
return
  http:send-request($request)
};

declare function local:get-hundred($start)
{
let $query := 'q=affiliation-org-name:"Vanderbilt+University"&amp;start='||$start||'&amp;rows=100'
let $endpoint := 'https://pub.orcid.org/v2.0/search/'
let $response := local:query-endpoint($endpoint,$query)
for $result in $response[2]/search:search/search:result
return $result/common:orcid-identifier/common:path/text()
};

(: The initial query is just to determine the number of results :)
let $query := 'q=affiliation-org-name:"Vanderbilt+University"&amp;start=101&amp;rows=100'
let $endpoint := 'https://pub.orcid.org/v2.0/search/'
let $response := local:query-endpoint($endpoint,$query)

let $numberOfResults := number(data($response[2]/search:search/@num-found))
let $pages := ($numberOfResults idiv 100) (: pages are sets of 100 results :)

(: retrieve ORCID IDs one hundred at a time :)
for $page in (0 to $pages)
  let $start := string(($page * 100) + 1)
  return local:get-hundred($start)
