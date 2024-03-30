component {
    variables.datasource = "SambidMaharjan";

    public AddEdit function init() {
        return this;
    }

    public void function processForms(required struct formData) {
        var qs = new Query(datasource=variables.datasource);
        var sql = "";

        if (structKeyExists(formData, "uploadImage") && formData.uploadImage neq "") {
            var uploadResult = uploadBookCover(uploadImage=formData.uploadImage);
            formData.image = uploadResult; 
        } else {
            formData.image = ""; 
        }

        qs.setSQL("IF NOT EXISTS (SELECT * FROM books WHERE isbn13 = :isbn13)
                    BEGIN
                        INSERT INTO books (isbn13, title, year, isbn, weight, binding, pages, language, publisher, image, description)
                        VALUES (:isbn13, :title, :year, :isbn, :weight, :binding, :pages, :language, :publisherID, :image, :description);
                    END
                    ELSE
                    BEGIN
                        UPDATE books SET title = :title, year = :year, isbn = :isbn, weight = :weight,
                        binding = :binding, pages = :pages, language = :language, publisher = :publisherID, image = :image, description = :description
                        WHERE isbn13 = :isbn13;
                    END");

        qs.addParam(name="isbn13", value=formData.isbn13, cfsqltype="CF_SQL_VARCHAR");
        qs.addParam(name="title", cfsqltype="CF_SQL_NVARCHAR", value=formData.title);
        qs.addParam(name="year", cfsqltype="CF_SQL_NUMERIC", value=formData.year);
        qs.addParam(name="isbn", cfsqltype="CF_SQL_VARCHAR", value=formData.isbn);
        qs.addParam(name="weight", cfsqltype="CF_SQL_NUMERIC", value=formData.weight);
        qs.addParam(name="binding", cfsqltype="CF_SQL_NVARCHAR", value=formData.binding);
        qs.addParam(name="pages", cfsqltype="CF_SQL_NUMERIC", value=formData.pages);
        qs.addParam(name="language", cfsqltype="CF_SQL_NVARCHAR", value=formData.language);
        qs.addParam(name="publisherID", cfsqltype="CF_SQL_NVARCHAR", value=formData.publisher);
        qs.addParam(name="image", cfsqltype="CF_SQL_VARCHAR", value=formData.image);
        qs.addParam(name="description", value=trim(formData.description), cfsqltype="CF_SQL_NVARCHAR", null=trim(formData.description).len() == 0);

        qs.execute();
    }

    public string function uploadBookCover(required string uploadImage) {
        var destinationDir = expandPath("/Users/sambidmaharjan/Documents/Sites/UML/SambidMaharjan/myFinalProject/images/");
        var result = fileUpload(destinationDir, uploadImage, "image/*", "makeunique");
        return result.serverFile;
    }

    // Function to retrieve all publishers
    public query function allPublishers() {
        var qs = new Query(datasource=variables.datasource);
        qs.setSQL("SELECT publisherID AS id, name FROM publishers ORDER BY name ASC");
        return qs.execute().getResult();
    }

    // Function to retrieve all books for side navigation
public query function sideNavBooks(required string qterm) {
    var qs = new Query(datasource=variables.datasource);
    var sql = "SELECT * FROM books";
    
    if (len(qterm)) {
        sql &= " WHERE title LIKE :qterm";
        qs.addParam(name="qterm", value="%#qterm#%", cfsqltype="CF_SQL_VARCHAR");
    }
    
    sql &= " ORDER BY title ASC";
    qs.setSQL(sql);
    
    return qs.execute().getResult();
}



    // Function to retrieve book details based on ISBN13
    public query function bookDetails(required string isbn13) {
        var qs = new Query(datasource=variables.datasource);
        qs.setSQL("SELECT * FROM books WHERE isbn13 = :isbn13");
        qs.addParam(name="isbn13", value=isbn13, cfsqltype="CF_SQL_VARCHAR");
        return qs.execute().getResult();
    }
}
