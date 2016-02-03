# Stardog Notes


## General Note
The examples are for Windows.  For Mac or Linux, generally drop the ".bat" off of the end of the command.  For example:

```stardog.bat data add myDB schema.ttl```

on Windows would be

```stardog data add myDB schema.ttl```

for Mac.

# Installation (Windows)
Go to http://stardog.com and click Download.  Enter the info and select Stardog Community.  Click download, then check your email.

Use the links in the email to download the .zip archive containing the software.  Unzip it somewhere. In this example I unzipped it to the root of c:, resulting in ```c:\stardog-4.0.3``` as the installation directory.

Add ```c:\stardog-4.0.3\bin``` to the PATH environmental variable.

Set up ```c:\stardog-home``` to be my home directory.  

Download the license key (stardog-license-key.bin) and move it to the home directory.

With reference to the directions at
http://docs.stardog.com/
I set the environmental variable STARDOG_HOME in a batch file that I also used to launch the server (as in next section).


# Starting the Stardog server (Windows)
- In the Command Prompt window, Enter the command

```c:\stardog-4.0.2\bin\stardog-admin.bat server start```

if the PATH variable is set correctly, the first part of the path can be omitted.

- The first time you do this, you'll have to allow Java Platform to communicate on the network - at VU I used Domain networks.

- Leave the Command Prompt window open.

# Creating a new database (Windows)
From the directory where the data.ttl file resides, enter the command

```stardog-admin.bat db create -n myDB data.ttl```

where myDB is the name of the database and data.ttl is the file containing the RDF/Turtle.  The database will be placed in the home folder. Note: if the file isn't found, it will just create the database and you can load the data from the web interface.

# Adding data to a database
From the directory where the Turtle file resides, enter

```stardog.bat data add myDB schema.ttl```

To load the data into a named graph having the URI http://foo, use

```stardog.bat data add -g http://foo myDB schema.ttl```


# Using the Web Console

In the browser, open

```http://localhost:5820/myDB ```

Default username and pwd are both ```admin```

Click the Query tab to get to the SPARQL editor.
