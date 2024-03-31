<!--- bookstore.cfc --->
<cfcomponent>

    <!--- Function to obtain search results based on the provided search term --->
    <cffunction name="obtainSearchResults" access="public" returnType="query">
        <cfargument name="searchme" type="string" required="true">
        <cfquery name="searchResults" datasource="SambidMaharjan">
            SELECT books.title, publishers.name AS publisherName
            FROM books
            INNER JOIN publishers ON books.publisher = publishers.publisherID 
            WHERE title LIKE <cfqueryparam value="%#trim(arguments.searchme)#%" cfsqltype="cf_sql_varchar">
            OR isbn13 LIKE <cfqueryparam value="%#trim(arguments.searchme)#%" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn searchResults>
    </cffunction>

    <!--- Function to display no results message --->
    <cffunction name="noResults" access="public" returnType="string">
        <cfreturn "No results found.">
    </cffunction>
    
    <!--- Function to handle/display many results --->
    <cffunction name="manyResults" access="public" returnType="string">
        <cfargument name="searchResults" type="query" required="true">
        <cfset var resultString = "Multiple results found.">
        <!-- Additional processing could be added here -->
        <cfreturn resultString>
    </cffunction>

</cfcomponent>
