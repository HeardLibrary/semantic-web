(: this module needs to be put in the webapp folder of your BaseX installation.  On my computer it's at c:\Program Files (x86)\BaseX\webapp\ :)

(: to test, send an HTTP GET to localhost:8984/Longxingsi using cURL, Postman, etc. :)

module namespace page = 'http://basex.org/modules/web-page';
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at 'c:/github/guid-o-matic/serialize.xqm';

declare
  %rest:path("/header")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:web($acceptHeader)
  {
  <p>{$acceptHeader}</p>
  };

declare
  %rest:path("/dump")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:dump-database($acceptHeader)
  {
  if (contains(string-join($acceptHeader),"application/rdf+xml"))
  then
      (
      <rest:response>
        <output:serialization-parameters>
          <output:media-type value='application/rdf+xml'/>
        </output:serialization-parameters>
      </rest:response>,
      serialize:main("","xml","guid-o-matic/","c:/github/","dump","false")
      )
  else
      if (contains(string-join($acceptHeader),"text/turtle"))
      then
          (
          <rest:response>
            <output:serialization-parameters>
              <output:media-type value='text/turtle'/>
            </output:serialization-parameters>
          </rest:response>,
          serialize:main("","turtle","guid-o-matic/","c:/github/","dump","false")
          )
      else 
          if (contains(string-join($acceptHeader),"application/ld+json") or contains(string-join($acceptHeader),"application/json"))
          then
              (
              <rest:response>
                <output:serialization-parameters>
                  <output:media-type value='application/ld+json'/>
                </output:serialization-parameters>
              </rest:response>,
              serialize:main("","json","guid-o-matic/","c:/github/","dump","false")
              )
          else 
              (
              <rest:response>
                <output:serialization-parameters>
                  <output:media-type value='text/html'/>
                </output:serialization-parameters>
              </rest:response>,
              <html>
                  <body>
                      <p>The accept header was: {$acceptHeader}</p>
                  </body>
              </html>
            )
  };

declare
  %rest:path("/{$local-id}")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:content-negotiation($acceptHeader,$local-id)
  {
  if (contains(string-join($acceptHeader),"application/rdf+xml"))
  then
      (
      <rest:response>
        <output:serialization-parameters>
          <output:media-type value='application/rdf+xml'/>
        </output:serialization-parameters>
      </rest:response>,
      serialize:main($local-id,"xml","guid-o-matic/","c:/github/","single","false")
      )
  else
      if (contains(string-join($acceptHeader),"text/turtle"))
      then
          (
          <rest:response>
            <output:serialization-parameters>
              <output:media-type value='text/turtle'/>
            </output:serialization-parameters>
          </rest:response>,
          serialize:main($local-id,"turtle","guid-o-matic/","c:/github/","single","false")
          )
      else 
          if (contains(string-join($acceptHeader),"application/ld+json") or contains(string-join($acceptHeader),"application/json"))
          then
              (
              <rest:response>
                <output:serialization-parameters>
                  <output:media-type value='application/ld+json'/>
                </output:serialization-parameters>
              </rest:response>,
              serialize:main($local-id,"json","guid-o-matic/","c:/github/","single","false")
              )
          else 
              (
              <rest:response>
                <output:serialization-parameters>
                  <output:media-type value='text/html'/>
                </output:serialization-parameters>
              </rest:response>,
              <html>
                  <body>
                      <p>The accept header was: {$acceptHeader}</p>
                  </body>
              </html>
            )
  };


