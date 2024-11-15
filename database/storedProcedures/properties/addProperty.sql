CREATE OR ALTER PROCEDURE addProperty(
    @id VARCHAR(255),
    @ownerId VARCHAR(255),
    @name VARCHAR(100),
    @propertyType VARCHAR(100),
    @detailsJson NVARCHAR(MAX),
    @locationJson NVARCHAR(MAX),
    @status VARCHAR(100)
)
AS
BEGIN
    INSERT INTO properties(id,ownerId,name,propertyType,detailsJson,locationJson,status)
    VALUES (@id,@ownerId,@name,@propertyType,@detailsJson,@locationJson,@status)
END;
GO


-- this does not return any error! look into it
-- CREATE OR ALTER PROCEDURE addProperty(
--     @id VARCHAR(255),
--     @ownerId VARCHAR(255),
--     @name VARCHAR(100),
--     @propertyType VARCHAR(100),
--     @detailsJson NVARCHAR(MAX),
--     @locationJson NVARCHAR(MAX),
--     @status VARCHAR(100)
-- )
-- AS
-- BEGIN TRY
--     INSERT INTO properties(id,ownerId,name,propertyType,detailsJson,locationJson,status)
--     VALUES (@id,@ownerId,@name,@propertyType,@detailsJson,@locationJson,@status)
-- END TRY
-- BEGIN CATCH
--     PRINT 'Error occurred:' + ERROR_MESSAGE()
-- END CATCH;
-- GO