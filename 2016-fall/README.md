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

---
Sep 26 meeting: Work session

Implementation notes:

1. **Display of Chinese characters in BaseX output.**  I was confused because on my home computer, Chinese characters displayed correctly in the BaseX output screen, while on my work computer they did not display correctly.  After some investigation, I discovered that they must have inherited different default fonts from some system setting or something, since I'd never messed with the font.  I fixed the problem by going to the BaseX Options menu, then selecting Font... .  I then chose SanSerif, Monospaced, Standard, 13 (the defaults on my home computer).  Despite the choice of SanSerif, the output font was serifed (looks like Courier?).  In any case, the Chinese characters then displayed correctly.

2. **Preventing OpenOffice Calc from messing with strings** If you have downloaded OpenOffice to use for editing the CSV files (recommended over using Excel), the default settings include some AutoCorrect options that mess with the characters in the file, for example replacing regular double quotes with "smart quotes".  I recommend turning all AutoCorrect options off.  Go to the Tools menu and select AutoCorrect Options... .  Under the Options and Localized Options tab, uncheck every box, then click OK.  

3. **Setting the local directory in the script** In order to be able to see the effects of modifications to the metadata on the output data, the Xquery script needs to know where to find the CSV files are that you downloaded from GitHub.  There are two ways to take care of this.  One is to figure out what the path is to your fork of the Semantic Web GitHub repo.  Another option is to copy the tang-song folder containing the files from the GitHub repo to some place for which you know the path (e.g. your home directory on a Mac, or some subdirectory of the C: drive on a PC).  In either case, after figuring out the path of the 2016-fall/tang-song/ directory, using BaseX open the serialize.xqm file in the 2016-fall/tang-song/ directory, find line 10, and change the value in quotes of $localFilesFolderUnix to the path of the tang-song directory.  If you are having problems with this, fixing it will be one of the first things that we will do at the meeting on Monday.

---
Some tools:

[RDF Translator](http://rdf-translator.appspot.com/) Note: this only seems to work correctly with JSON-LD that is in "expanded" form, not "compacted" form. Convert to expanded form at JSON-LD Playground before converting to other serializations.

[JSON-LD Playground](http://json-ld.org/playground/) Validates JSON-LD and converts from one form to another.  Also includes some examples.

[LODLive for graph visualization](http://en.lodlive.it/)

[W3C RDF validator; generates a graphical display, but only accepts RDF/XML as an input (convert using RDF Translator, then paste in)](https://www.w3.org/RDF/Validator/)

---
Things to investigate:

[International Image Interoperability Framework] (http://iiif.io/)

[Mirador] (http://projectmirador.org)
