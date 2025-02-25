USE [AutoPush]
GO
/****** Object:  StoredProcedure [dbo].[sp_Device_Save]    Script Date: 2/4/2025 3:37:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_Device_Save]
    @id AS INT = 0,
    @deviceOfficeName AS NVARCHAR(250),  
    @deviceOfficeUrl AS NVARCHAR(250),   
    @deviceSerialNo AS NVARCHAR(1000),
    @remarks AS NVARCHAR(500)
AS
BEGIN
    DECLARE @officeId INT;

    SELECT @officeId = Id 
    FROM Office 
    WHERE HostUrl = @deviceOfficeUrl;

 
    IF @officeId IS NULL
        THROW 51000, 'Office does not exist for the provided Host URL.', 1;

    
    IF EXISTS (SELECT * FROM Device WHERE Id != @id AND DeviceSerialNo = @deviceSerialNo)
        THROW 52000, 'Duplicate Device Serial Number.', 1;

    -- Insert or Update Device
    IF (@id = 0)
    BEGIN
        INSERT INTO [dbo].[Device] (
            [OfficeId],
            [DeviceOfficeName],
            [DeviceOfficeUrl],
            [DeviceSerialNo],
            [Remark]
        )
        VALUES (
            @officeId,
            @deviceOfficeName,
            @deviceOfficeUrl,
            @deviceSerialNo,
            @remarks
        );

        SELECT @id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE [dbo].[Device] 
        SET 
            [OfficeId] = @officeId,
            [DeviceOfficeName] = @deviceOfficeName,
            [DeviceOfficeUrl] = @deviceOfficeUrl,
            [DeviceSerialNo] = @deviceSerialNo,
            [Remark] = @remarks
        WHERE 
            Id = @id;
    END

    SELECT @id AS Id;
END