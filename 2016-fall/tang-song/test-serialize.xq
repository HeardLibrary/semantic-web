
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at './serialize.xqm';

(: other values to try for first argument are "Longmensi_West_Side_Hall" or "Longxingsi_Revolving_Sutra_Repository" :)
(: serialization options are "turtle","xml", and "json":)
serialize:main("Longmensi_Tianwandian","turtle")


