# Downloading Protégé and loading the vegetarian example from SWWO Chapter 11#

 #1. Download link for the Protégé ontology editor:

http://protege.stanford.edu/products.php

I downloaded the Protégé Desktop for Windows 5.0 beta, which seemed to work pretty much the same as ver. 4.  I unzipped the downloaded files into a folder where I could find them.

 #2. Copy the triples from page 239 and pasted them in a plain text document (actually I used rdfEditor, but you could paste them in a plain text doc).

```
:Person a owl:Class.
:Food a owl:Class.
:eats rdfs:domain :Person.
:eats rdfs:range :Food.

:Maverick :eats :Steak.

:Vegetarian a owl:Class;
rdfs:subClassOf :Person.
:VegetarianFood a owl:Class;
rdfs:subClassOf :Food.

:Vegetarian rdfs:subClassOf
[a owl:Restriction;
owl:onProperty :eats;
owl:allValuesFrom :VegetarianFood].

:Jen a :Vegetarian;
     :eats :Marzipan.
```

 #3. I added these namespace abbreviations to the top of the doc:

```
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>.
@prefix : <http://example.org/>.
@prefix owl: <http://www.w3.org/2002/07/owl#>.
```

 #4. I saved the file as vegie.ttl, which you can see/download here:

https://github.com/HeardLibrary/semantic-web/blob/master/sw-4-working-ontologist/data/vegie.ttl

 #5. Launch Protégé by double-clicking on the run.bat file in the Protege-5.0.0-beta-24 folder.  Patience is a virtue - it takes a while to launch.  When asked if I wanted to install plug-ins, I picked a bunch of them, but notably Pellet and Hermit, which were the reasonsers I wanted to play with.

 #6. Use Open from the File menu to open the vegie.ttl file.  Click on the Entities tab to see the class and object property hierarchies (which can be expanded by clicking on the triangles to the left of the top entities).  To see the Individuals (like :Jen), click on the Individuals by type tab in the lower left window. Expand the Vegetarian class and you will see :Jen.

 #7. To save the ontology in prettied-up form, use Save as... from the file menu.  I chose to save it as Turtle syntax and gave it a .owl file extension.  You can see the result here:

https://github.com/HeardLibrary/semantic-web/blob/master/sw-4-working-ontologist/data/veggie.owl

The triples are exactly the same as they were in the veggie.ttl file except that there's a type declaration for the blank-node representing the ontology itself.

 #8. To try reasoning the entailed triple shown in the example:

```
:Marzipan a:VegetarianFood.
```

I went to the Reasoner menu and selected Pellet.  I then selected Start reasoner from the same menu.  Now if you click on the :Marizpan individual, you will see that its type listed in the description window is :VegetarianFood.  If you click on the question mark at the right of the type listing, it will explain the justification for the inference.  Similarly, you can check on the reasons for class inferences for :Maverick, :Steak, and :Marzipan. Turn the reasoner off and the entailed types disappear!
