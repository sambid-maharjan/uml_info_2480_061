<!-- details.cfm -->
<cfparam name="searchme" default="" />
<!--- Dumping form variables for debugging purposes --->
<cfdump var="#form#">

<!--- Importing the bookstore.cfc component --->
<cfset bookstoreFunctions = createObject("component", "bookstore")>

<!--- Calling the obtainSearchResults function from the bookstore.cfc component --->
<cfset bookInfo = bookstoreFunctions.obtainSearchResults(searchme)>

<!--- Checking the number of search results and displaying appropriate messages --->
<cfif bookInfo.recordcount eq 0>
    <!--- No results message --->
    <cfoutput>#noResults()#</cfoutput>
<cfelseif bookInfo.recordcount eq 1>
    <!--- One result message --->
    <cfoutput>#oneResult()#</cfoutput>
<cfelse>
    <!--- Multiple results message --->
    <cfoutput>#manyResults()#</cfoutput>
</cfif>
