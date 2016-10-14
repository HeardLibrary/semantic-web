# Linked Data: Structured data on the Web
Notes for fall 2016 sessions of the Semantic Web Working Group

---
Sep. 12 meeting: Chapter 1 through Section 1.6
[PowerPoint presentation](linked-data-ch1.pptx)   [PowerPoint in PDF format](linked-data-ch1.pdf)

The Postman HTTP client (Chrome plugin) that was demonstrated during the meeting is available [here](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en)

---
Sep. 19 meeting: Section 1.7 through 2.6
[PowerPoint presentation](Chapters_1_7-2_6.pdf)

[Linked Open Vocabularies (LOV)](http://lov.okfn.org/dataset/lov/) repository of information on vocabularies used in Linked Data

[A list of Linked Data datasets and vocabularies compiled by the W3C](http://www.w3.org/2005/Incubator/lld/XGR-lld-vocabdataset/) This is super-good and important.  All of the most authoritative sources relevant to libraries (and pretty much everybody!) are listed here.

---
<a name="wsession"></a>Sep 26 meeting: Work session

Implementation notes:

1. **Display of Chinese characters in BaseX output.**  I was confused because on my home computer, Chinese characters displayed correctly in the BaseX output screen, while on my work computer they did not display correctly.  After some investigation, I discovered that they must have inherited different default fonts from some system setting or something, since I'd never messed with the font.  I fixed the problem by going to the BaseX Options menu, then selecting Font... .  I then chose SanSerif, Monospaced, Standard, 13 (the defaults on my home computer).  Despite the choice of SanSerif, the output font was serifed (looks like Courier?).  In any case, the Chinese characters then displayed correctly.

2. **Preventing OpenOffice Calc from messing with strings** If you have downloaded OpenOffice to use for editing the CSV files (recommended over using Excel), the default settings include some AutoCorrect options that mess with the characters in the file, for example replacing regular double quotes with "smart quotes".  I recommend turning all AutoCorrect options off.  Go to the Tools menu and select AutoCorrect Options... .  Under the Options and Localized Options tab, uncheck every box, then click OK.  

3. **Setting the local directory in the script** In order to be able to see the effects of modifications to the metadata on the output data, the Xquery script needs to know where to find the CSV files are that you downloaded from GitHub.  There are two ways to take care of this.  One is to figure out what the path is to your fork of the Semantic Web GitHub repo.  Another option is to copy the tang-song folder containing the files from the GitHub repo to some place for which you know the path (e.g. your home directory on a Mac, or some subdirectory of the C: drive on a PC).  In either case, after figuring out the path of the 2016-fall/tang-song/ directory, using BaseX open the serialize.xqm file in the 2016-fall/tang-song/ directory, find line 10, and change the value in quotes of $localFilesFolderUnix to the path of the tang-song directory.  If you are having problems with this, fixing it will be one of the first things that we will do at the meeting on Monday.

---
Oct. 4 meeting: Continuing with subsections of section 2.3, with specific reference to Tracy's Chinese buildings data.  Be sure to check out [the list of Linked Data datasets and vocabularies compiled by the W3C](http://www.w3.org/2005/Incubator/lld/XGR-lld-vocabdataset/), which lists many of the most authoritative vocabularies.  We will talk about ontologies and SKOS.  [PowerPoint presentation](linked-data-ch2-3.pdf)

Implementation notes:

1. There are numerous changes to both the data files and the Xquery scripts.  So you should update your local fork of the repo.

2. It is no longer necessary to hard-code anything in the serialze.xqm file or use a different version of the file for Macs and PCs.  Load test-serialize.xq into BaseX, then set the five arguments of the serialize:main() function to appropriate values.  Mac users should be able to start with the defaults.  PC users will have to put the path to the top-level folder of their GitHub fork in the fourth argument.  Changing the last argument from "single" to "dump" will cause the script to generate RDF for the entire database.  Other implementation-specific settings can be made by changing values in the constants.csv file (e.g. the base IRI to be used).

3. There are now two separate CSV metadata tables: one for the temple sites and the other for buildings at those sites.  More about this at the meeting.  

4. There are directions on how to set up all of the files necessary to generate RDF from any CSV files [here](tang-song/readme.md).  It may be easiest to hack the existing tang-song CSV files so that you get the column headers right.

5. I uploaded RDF/XML, RDF/Turtle, and JSON-LD sample files in a [sample](tang/song/samples) directory.  You can try calling the raw versions of the files from RawGit using Postman to see how it gives the correct Content-Type header, e.g. try https://rawgit.com/HeardLibrary/semantic-web/master/2016-fall/tang-song/samples/Longxingsi.ttl .  

---
Oct. 10 meeting: Finishing Chapter 2 and discussing anything that people wanted to review from before.  

I found a good paper that describes why SKOS was designed the way it was.  It is Baker et al. 2013. http://dx.doi.org/10.1016/j.websem.2013.05.001 .  I was able to access it through ScienceDirect via the Vanderbilt Library.  There are many technical details in the paper, but I would recommend skimming section 3 (Rationale for SKOS) and reading 4.1 (SKOS concepts and how they differ from OWL classes).  Section 4.1 is important for understanding the implications of modeling something as a class, and instance, or a concept.  All of the Getty Vocabularies model entities as SKOS concepts and this section can help us understand why.

I also highly recommend reading [this blog post](http://efoundations.typepad.com/efoundations/2011/09/things-their-conceptualisations-skos-foaffocus-modelling-choices.html) which provides a excellent narrative account of the development of FOAF and SKOS, with examples from VIAF and elsewhere that might provide us with some examples to follow in our modeling.  Here's [one more short post](http://ontologydesignpatterns.org/wiki/Community:Using_SKOS_Concept) on "Using SKOS Concept" that deals with the question "When should something be an instance of SKOS Concept?"

I've been studying the details of the Getty Vocabularies.  Their approach is extremely well thought-out.  We should take a careful look at their [LOD Semantic Representation](http://vocab.getty.edu/doc/) document.  They explain a lot about how they have attempted to follow community best-practices, and document what those practices are.  The section [Concept vs Thing Duality](http://vocab.getty.edu/doc/#Concept_vs_Thing_Duality) explains how they reconcile the use of SKOS with real-world things like people and geographic locations.  

---
Oct 17 meeting: beginning of Chapter 3 plus talking about SKOS

Here is the [PowerPoint presentation](concept-thing.pdf) to which I will be referring at the meeting.

Here is the [link to current actual graph model for tang-song metadata](tang-song/graph-model.md).

See references above about SKOS.  Here are some more things I've been looking at.  I want to reference them here so that I don't have to leave dozens of browser tabs open forever!

I've added placeholder references to Chinese Dynasties from the [PeriodO Ontology](http://perio.do/technical-overview/) to Tracy's site data. I've had email contact with the authors, and PeriodO does not seem to care about the Concept/Thing duality (see references above).  PeriodO uses the [W3C Time Ontology](https://www.w3.org/TR/owl-time/) to define their historical periods.  Here is the [link to the Chinese Periods Chronology](https://test.perio.do/#/p/Canonical/periodCollections/p0fp7wv/).  The metadata are downloadable as Turtle, although some of it is invalid.  So it's fine to look at but would need cleaning up before using.  I think the JSON-LD is OK.

I've experimented with using the W3C Time Ontology to define the construction periods (in years) for Tracy's buildings and it's really complex and clunky.  There are more straightforward properties: gvp:estStart and gvp:estEnd defined by the Getty Vocabularies (see [this](http://vocab.getty.edu/doc/#Estimated_Dates) for more on the subject and why they minted their own terms for dates) that say basically exactly what we want, so I used them, too.  

Both the [Getty LOD Semantic Representation documentation](http://vocab.getty.edu/doc/) and the PeriodO people mentioned the [CIDOC Conceptual Reference Model (CRM)](http://www.cidoc-crm.org/) (CIDOC=International Council of Museums International Committee for Documentation).  It is a hard-core ontology of pretty much everything that could possibly be related to museums.  You can see a recent RDF/XML version of it [here](http://www.cidoc-crm.org/rdfs/cidoc_crm_v6.2.1-draft-b-2015October.rdfs).  It is probably way too complicated for our simple Linked Data applications, although it does attempt enable modeling complicated stuff like three dimensional archaeological sites over time.  

Another thing that came up was the [Pleiades Gazetteer of ancient places](https://pleiades.stoa.org/).  It seems similar to Dave Michaelson's syriaca.org, except worldwide.  The RDF Vocabulary that they use is [described here](https://pleiades.stoa.org/docs/partners/pleiades-rdf-vocabulary).  Here is a [sample record for Nineveh](https://pleiades.stoa.org/places/874621/turtle) in Turtle.  They accept the Concept/Thing duality, but deal with it in a weird way that results in the root IRI denoting a skos:Concept, pleiades:Place, and foaf:Document.  They do an interesting thing of representing the site geometry using [GeoJSON](https://en.wikipedia.org/wiki/GeoJSON).  

I have also been experimenting with downloading the entire Getty TGN and [GeoNames RDF dumps](http://www.geonames.org/ontology/documentation.html).  They are huge: (25 GB for TGN as uncompressed Ntriples, 18 Gb for GeoNames uncompressed as 162.5 million Ntriples).  Stardog has already choked on most of the pieces of the TGN.  For whatever reason, GeoNames does not provide their RDF dump in a form that is actually loadable in a triplestore.  Duh.  I was able to use [this Python script](https://github.com/rhasan/sw/blob/master/genames/convert2ntriples.py) (with minor modifications to make it work with Python 3) to generate usable Ntriples from the download file.  The script took several hours to run (I don't know exactly how long - I went to bed and left it running) and uses pieces of the great rdflib Python package that is described [here](https://rdflib3.readthedocs.io/en/latest/index.html).  We must play with this (I already have a little, see [this blog post](http://baskauf.blogspot.com/2015/07/shiny-new-toys-3-playing-with-linked.html)) !

With respect to characterizing building and site types, see the [GeoNames Feature Codes](http://www.geonames.org/export/codes.html), with [feature statistics](http://www.geonames.org/statistics/total.html) showing which ones are commonly used.  There are alternatives in the Getty AAT, but I haven't scrutinized them.  See for example [temples(buildings)](http://www.getty.edu/vow/AATFullDisplay?find=&logic=AND&note=&subjectid=300007595).  

Schema.org defines many types of things as classes.  See the [full hierarchy](http://schema.org/docs/full.html) and information about their [data model](http://schema.org/docs/datamodel.html).  The [normative RDF of their vocabulary](http://schema.org/docs/schema_org_rdfa.html) is in the form of RDFa. To turn it into Turtle, view the page source, then paste it into the [RDF Translator](http://rdf-translator.appspot.com/).  I used some of its terms to mark up geography in Tracy's metadata, as well as terms from the [WGS84 Geo Positioning vocabulary](https://www.w3.org/2003/01/geo/wgs84_pos), a very simple and very well-known vocabulary for that purpose.  

Here are some links that William sent out in an email:

[VRA Core ontology](http://core.vraweb.org/index.html)

[DMLI home page](https://my.vanderbilt.edu/dimli/)

[CSV to VRA Core XML conversion tool](https://github.com/exc-asia-and-europe/csv2xml)

[VRA XML to RDF conversion tool](https://github.com/mixterj/VRA-RDF-Project)

[OWL ontology for VRA Core](https://s3.amazonaws.com/VRA/ontology.html)

Here is a link to [the Pelagios Commons](http://commons.pelagios.org/), a community of people building Linked Data gazetteers for historical places.

---
Some tools:

[RDF Translator](http://rdf-translator.appspot.com/) Note: this only seems to work correctly with JSON-LD that is in "expanded" form, not "compacted" form. Convert to expanded form at JSON-LD Playground before converting to other serializations.

[JSON-LD Playground](http://json-ld.org/playground/) Validates JSON-LD and converts from one form to another.  Also includes some examples.

[LODLive for graph visualization](http://en.lodlive.it/)

[W3C RDF validator; generates a graphical display, but only accepts RDF/XML as an input (convert using RDF Translator, then paste in)](https://www.w3.org/RDF/Validator/)

[RawGit to serve GitHub RAW files with correct Content-Type headers](http://rawgit.com/)

---
Things to investigate:

[Review of the DCMI Abatract Model](http://wiki.dublincore.org/index.php/Review_of_DCMI_Abstract_Model) (probably too nerdy for general consumption, but I wanted to put this where I could find it again.  It discusses application profiles and description sets.)

[International Image Interoperability Framework] (http://iiif.io/)

[Mirador] (http://projectmirador.org)
