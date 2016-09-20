
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at './serialize.xqm';

(: other values to try are "ind-barberr","rb427" :)
(: serialization options are "turtle","xml", and "json":)
serialize:main("Anchansi","turtle")


