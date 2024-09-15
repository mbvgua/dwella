CREATE OR ALTER PROCEDURE updateProperty(
    @id VARCHAR(255),
    @name VARCHAR(100),
    @propertyType VARCHAR(100),
    @detailsJson NVARCHAR(MAX),
    @locationJson NVARCHAR(MAX),
    @status VARCHAR(100)
)
AS
BEGIN TRY
    UPDATE properties
    SET name=@name,propertyType=@propertyType,detailsJson=@detailsJson,locationJson=@locationJson,status=@status
    WHERE id=@id
    PRINT 'User added successfully!'
END TRY
BEGIN CATCH
    PRINT 'Error occurred:' + ERROR_MESSAGE()
END CATCH;
GO