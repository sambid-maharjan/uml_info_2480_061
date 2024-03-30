<!--- bookstore.cfc --->
component {
    
    <cfcomponent>

    <!--- Function to obtain search results based on the provided search term --->
    <cffunction name="obtainSearchResults" access="public" returnType="query">
        <cfargument name="searchme" type="string" required="true">
        <cfquery name="searchResults" datasource="SambidMaharjan">
            SELECT * FROM books
            INNER JOIN publishers ON books.publisher = publishers.id 
            WHERE title LIKE <cfqueryparam value="%#trim(arguments.searchme)#%" cfsqltype="cf_sql_varchar">
            OR isbn13 LIKE <cfqueryparam value="%#trim(arguments.searchme)#%" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn searchResults>
    </cffunction>

</cfcomponent>
}
