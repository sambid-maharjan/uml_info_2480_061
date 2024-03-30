<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <!-- Include CKEditor JavaScript -->
    <script src="https://cdn.ckeditor.com/4.16.1/standard/ckeditor.js"></script>
</head>
<body>

<!-- Search Form -->
<form class="d-flex" action="details.cfm" method="post"> <!-- Ensure that action points to details.cfm -->
    <input type="hidden" name="searchme" value="#form.searchme#"> <!-- Ensure that the correct variable name is used -->
    <input class="form-control me-2" type="search" name="qterm" value="#form.searchme#" placeholder="Search" aria-label="Search"> <!-- Use the correct variable name -->
    <button class="btn btn-outline-success" type="submit">Search</button>
</form>



<cfparam name="book" default="">
<cfparam name="qterm" default="">
<cfparam name="p" default="carousel">
<cfset addEditFunctions = createObject("component", "AddEdit")>
<cfset thisBookDetails = {}>

<cftry>
    <!--- Check if the search term is submitted --->
    <cfif structKeyExists(form, "qterm")>
        <!--- Assign the submitted search term to the qterm variable --->
        <cfset qterm = form.qterm>
    </cfif>

    <cfif len(trim(book))>
        <cfset bookQuery = addEditFunctions.bookDetails(book)>
        <!-- Convert query to struct if book details are fetched -->
        <cfif bookQuery.recordCount>
            <cfset thisBookDetails = {
                isbn13 = bookQuery.isbn13[1],
                title = bookQuery.title[1],
                year = bookQuery.year[1],
                isbn = bookQuery.isbn[1],
                weight = bookQuery.weight[1],
                binding = bookQuery.binding[1],
                pages = bookQuery.pages[1],
                language = bookQuery.language[1],
                publisherID = bookQuery.publisher[1],
                image = bookQuery.image[1],
                description = bookQuery.description[1]
            }>
        </cfif>
    </cfif>

    <cfif structKeyExists(form, "title") and form.title neq "">
        <cfset addEditFunctions.processForms(form)>
    </cfif>

    <div class="row">
        <div id="main" class="col-9">
            <cfif structKeyExists(thisBookDetails, "isbn13") or book eq "new">
                <cfoutput>#mainForm(thisBookDetails, addEditFunctions.allPublishers())#</cfoutput>
            </cfif>
        </div>
        <div id="leftgutter" class="col-lg-3 order-first">
            <!--- Pass the search term to the sideNav function --->
            <cfoutput>#sideNav(addEditFunctions, qterm)#</cfoutput>
        </div>
        <div>
            <cfif structKeyExists(thisBookDetails, "description")>
                <cfoutput>#thisBookDetails.description#</cfoutput>
            </cfif>
        </div>
    </div>

<cfcatch type="any">
    <cfoutput>Error: #cfcatch.message#</cfoutput>
</cfcatch>
</cftry>


<cffunction name="sideNav">
    <cfargument name="addEditFunctions" type="any" required="true">
    <cfargument name="qterm" type="string" required="false" default="">

    <!--- Step 1: Retrieve all books using the sideNavBooks function --->
    <cfset allBooks = addEditFunctions.sideNavBooks(qterm)>

    <!--- Step 2: Display the side navigation menu --->
    <div>
        Book List
    </div>

    <cfoutput>
        <ul class="nav flex-column">
            <!--- Step 3: Loop through each book and display it in the list --->
            <cfloop query="allBooks">
                <li class="nav-item">
                    <!--- Step 4: Display book title as a link in the list item --->
                    <a href="#cgi.script_name#?tool=addedit&book=#isbn13#" class="nav-link">#trim(title)#</a>
                </li>
            </cfloop>

            <!--- Step 5: Add a link to add a new book --->
            <li class="nav-item">
                <a href="#cgi.script_name#?tool=addedit&book=new" class="nav-link">New Book</a>
            </li>

            <!--- Step 6: Add a link to open the module for adding publishers --->
            <li class="nav-item">
                <a href="#cgi.script_name#?tool=addpublisher" class="nav-link">Add Publisher</a>
            </li>
        </ul>
    </cfoutput>
</cffunction>



<cffunction name="mainForm">
    <cfargument name="thisBookDetails" type="struct" required="yes">
    <cfargument name="publishers" required>

    <cfoutput>
       <form action="#cgi.script_name#?tool=addedit" method="post" enctype="multipart/form-data">
            <div class="row">
                <!--- Search Input Field --->
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="qterm" name="qterm" value="#qterm#" placeholder="Search Book Title" class="form-control" />
                        <label for="qterm">Search Book Title:</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="isbn13" name="isbn13" value="#thisBookDetails.isbn13#" placeholder="Please Enter The ISBN13 of the book" class="form-control" />
                        <label for="isbn13">ISBN 13:</label>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="title" name="title" value="#thisBookDetails.title#" placeholder="Book Title" class="form-control" />
                        <label for="title">Book Title:</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="year" name="year" value="#thisBookDetails.year#" placeholder="Year" class="form-control" />
                        <label for="year">Year:</label>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="isbn" name="isbn" value="#thisBookDetails.isbn#" placeholder="ISBN" class="form-control" />
                        <label for="isbn">ISBN:</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="number" id="weight" name="weight" value="#thisBookDetails.weight#" step=".1" class="form-control" />
                        <label for="weight">Weight:</label>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="binding" name="binding" value="#thisBookDetails.binding#" placeholder="Binding" class="form-control" />
                        <label for="binding">Binding:</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="pages" name="pages" value="#thisBookDetails.pages#" placeholder="Pages" class="form-control" />
                        <label for="pages">Pages:</label>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <input type="text" id="language" name="language" value="#thisBookDetails.language#" placeholder="Language" class="form-control" />
                        <label for="language">Language:</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-floating mb-3">
                        <select class="form-select" id="publisherID" name="publisher" aria-label="Publisher Select Control">
                            <option></option>
                            <!-- Loop through publishers and generate options -->
                            <cfloop query="publishers">
                                <option value="#id#">#name#</option>
                            </cfloop>
                        </select>
                        <label for="publisherID">Publisher</label>
                    </div>
                </div>
            </div>
            <br>

            <!-- Add Book Cover Upload Field -->
            <div class="row">
                <div class="col-sm-6">
                    <label for="uploadImage">Upload Cover:</label>
                    <input type="file" id="uploadImage" name="uploadImage" class="form-control" />
                </div>
                <div class="col-sm-6">
                    <input type="hidden" name="image" value="#trim(thisBookDetails.image)#" />
                </div>
            </div>
            
            
            <!-- CKEditor for the Description field -->
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="form-control"><cfoutput>#trim(thisBookDetails.description)#</cfoutput></textarea>
            </div>
            <!-- Include CKEditor JavaScript and replace textarea with CKEditor -->
            <script src="https://cdn.ckeditor.com/4.16.1/standard/ckeditor.js"></script>
            <script>
                 CKEDITOR.replace('description');
            </script>

            <div class="row">
                <div class="col-sm-12">
                    <button type="submit" class="btn btn-primary" style="width: 100%">Add Book</button>
                </div>
            </div>
        </form>
    </cfoutput>
</cffunction>