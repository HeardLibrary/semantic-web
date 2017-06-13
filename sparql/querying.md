# Querying the SPARQL endpoint
**Vanderbilt University Semantic Web Working Group**

[back to the User Guide](README.md)

[go to the SPARQL query interface](https://sparql.vanderbilt.edu/#query)

## Querying using the paste-in box

The [graphical query interface](https://sparql.vanderbilt.edu) contains a text box into which you can paste standard SPARQL queries. If the query is successful, the results will appear in a text table below the paste-in box.  Previous queries can also be re-loaded by clicking on the Query link at the bottom of the page.  Here is an example query that you can run:
```
SELECT DISTINCT ?class WHERE {
  ?resource a ?class.
  }
```
The query displays all of the classes (kinds) of resources currently represented in the database.

The major query forms (ASK, DESCRIBE, SELECT, and CONSTRUCT) of SPARQL 1.1 are supported.  SPARQL Update commands are disabled at the GUI interface.

There are many online resources for learning SPARQL.  Our working group studied the book [Learning SPARQL](http://www.learningsparql.com/) by Bob DuCharme and found it helpful.  You can find some random notes from that semester [here](../learning-sparql/README.md).

## Querying using HTTP

If you can code in Python, XQuery, jQuery, Javascript, or many other languages, you can use HTTP to run SPARQL queries via our API and use the results in your program. For testing your API calls, you can use applications like [CURL](https://curl.haxx.se/) (command line) or [Postman](https://www.getpostman.com/) (GUI).  

To execute a query, you first need to URL-encode the query as a single string.  In an application, you will probably use a built-in function to do this, but for testing purposes, you can make the conversion manually at a site like https://meyerweb.com/eric/tools/dencoder/.  In encoded form, the query above would look like this:
```
SELECT%20DISTINCT%20%3Fclass%20WHERE%20%7B%0A%20%20%3Fresource%20a%20%3Fclass.%0A%20%20%7D
```

The encoded query is the value of a key:value pair where the key is "query":
```
query=SELECT%20DISTINCT%20%3Fclass%20WHERE%20%7B%0A%20%20%3Fresource%20a%20%3Fclass.%0A%20%20%7D
```

This key:value pair is appended as a query string after the endpoint URI (https://sparql.vanderbilt.edu/sparql):
```
https://sparql.vanderbilt.edu/sparql?query=SELECT%20DISTINCT%20%3Fclass%20WHERE%20%7B%0A%20%20%3Fresource%20a%20%3Fclass.%0A%20%20%7D
```

You can paste this URI into a browser and depending on the setup of the browser, you'll get some kind of XML result (the default serialization is XML).  The results are more satisfying in Postman where you can control the form of the results by specifying the desired content type of the results.  For JSON, use the ```Accept``` header:
```
application/sparql-results+json
```

For XML, use the ```Accept``` header:
```
application/sparql-results+xml
```

Many programming languages have functions for performing HTTP interactions (e.g. AJAX) with a remote server - see the language documentation to find out how.  For an example using jQuery and Javascript, see [this blog post](http://baskauf.blogspot.com/2016/11/sparql-based-web-app-to-find-chinese.html).

The API also supports SPARQL Update commands via POST, but requires authentication.  Unless you are associated with our working group, you won't be doing this, though.

## Named graphs

The triples stored in the graph database are organized in named graphs.  If no graph is specified in the query, the query will be run on all of the triples in the database.  In some cases this may have undesirable consequences since similar types of data may exist across the various datasets loaded in the triplestore.  It may be possible to restrict the results to the desired portion of the data in the store by careful query construction.  If this is not possible, one may use the various GRAPH related commands in SPARQL 1.1 to restrict the results to particular named graphs.  To discover all of the named graphs in the store, use this query:

```
SELECT DISTINCT ?g WHERE {
  GRAPH ?g {?s ?p ?o}
  }
```

We are trying to avoid loading triples into the store that are not associated with a named graph.  You can learn about the content and models underlying the graphs by viewing the project descriptions linked from the [landing page](README.md) of this user guide.  For technical details of how Blazegraph handles named graphs, refer to [this blog post](http://baskauf.blogspot.com/2017/02/sparql-weirdness-of-unnamed-graphs.html).

[back to the User Guide](README.md)

[go to the SPARQL query interface](https://sparql.vanderbilt.edu/#query)
