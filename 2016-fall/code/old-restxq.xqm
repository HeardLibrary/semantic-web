(: this module needs to be put in the webapp folder of your BaseX installation.  On my computer it's at c:\Program Files (x86)\BaseX\webapp\ :)

(: to test, send an HTTP GET to localhost:8984/ind-durandp/dd343 using cURL, Postman, etc. :)

module namespace page = 'http://basex.org/modules/web-page';
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at 'https://raw.githubusercontent.com/HeardLibrary/semantic-web/master/2016-fall/code/serialize.xqm';
(:
declare
  %rest:path("/{$namespace1}/{$local-id1}")
  %rest:produces("text/turtle")
  function page:turtle-redirect($namespace1,$local-id1)
  {
  let $value := concat("/",$namespace1,"/",$local-id1,".ttl")
  return
  <rest:response>
    <http:response status="303" message="303 See Other">
      <http:header name="location" value="{$value}"/>
    </http:response>
  </rest:response>
  };
:)
declare
  %rest:error("err:bad")
  function page:error()
  {
  let $namespace := "lingyansi"
  let $local-id := "main_hall"
  return serialize:html($namespace,$local-id,"html")
  };

declare
  %rest:path("/{$namespace}/{$local-id}")
  %rest:produces("text/turtle")
  function page:turtle($namespace,$local-id)
  {
  <rest:response>
    <output:serialization-parameters>
      <output:media-type value='text/turtle'/>
    </output:serialization-parameters>
  </rest:response>,
  serialize:main($namespace,$local-id,"turtle")
  };

declare
  %rest:path("/{$namespace}/{$local-id}")
  %rest:produces("application/rdf+xml")
  function page:xml($namespace,$local-id)
  {
  <rest:response>
    <output:serialization-parameters>
      <output:media-type value='application/rdf+xml'/>
    </output:serialization-parameters>
  </rest:response>,
  serialize:main($namespace,$local-id,"xml")
  };

declare
  %rest:path("/{$namespace}/{$local-id}")
  %rest:produces("application/json")
  function page:json-ld($namespace,$local-id)
  {
    <rest:response>
    <output:serialization-parameters>
      <output:media-type value='application/json'/>
    </output:serialization-parameters>
  </rest:response>,
  serialize:main($namespace,$local-id,"json")
  };

declare
  %rest:path("/{$namespace}/{$local-id}")
  %rest:produces("text/html","application/xhtml+xml")
  function page:html($namespace,$local-id)
  {
    <rest:response>
    <output:serialization-parameters>
      <output:media-type value='text/html'/>
    </output:serialization-parameters>
  </rest:response>,
  serialize:html($namespace,$local-id,"html")
  };
