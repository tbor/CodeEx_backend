
-- =================================================================================================================================
-- Stored Procedures
-- =================================================================================================================================

/****** Object:  StoredProcedure [dbo].[Event_Delete]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('Event_Delete') IS NOT NULL DROP PROC [Event_Delete]
GO
CREATE PROC [dbo].[Event_Delete]
	(
	@EventId int
)
AS
BEGIN
	SET NOCOUNT ON

	DELETE
	FROM dbo.[Event]
	WHERE EventId = @EventId
END
GO
/****** Object:  StoredProcedure [dbo].[Event_Get]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('Event_Get') IS NOT NULL DROP PROC [Event_Get]
GO
CREATE PROC [dbo].[Event_Get]
(
	@EventId int = -1,
	@Search varchar(255) = ''
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT 
		e.[EventId]
		, e.[EventTitle]
		, e.[EventDescription]
		, e.[CoordinatorId]
		, [CoordinatorName] = uc.[UserName]
		, e.[EventDate]
		, e.[EventStatusId]
		, s.[EventStatus]
		, DATEDIFF(DAY, GETDATE(), e.[EventDate])
		, [Event in past] = CASE WHEN s.[EventStatus] = 'Completed' OR DATEDIFF(DAY, GETDATE(), e.[EventDate]) < 0 THEN 1 ELSE 0 END
	FROM dbo.[Event] e 
		LEFT JOIN dbo.[User] uc ON e.[CoordinatorId] = uc.UserId 
		LEFT JOIN dbo.[EventStatus] s ON e.[EventStatusId] = s.[EventStatusId]
	WHERE 
		(e.EventId = @EventId OR @EventId = -1) 
		AND 
		(@Search = ''
			OR e.[EventTitle] LIKE '%' + @Search + '%'
			OR e.[EventDescription] LIKE '%' + @Search + '%'
			OR uc.[UserName] LIKE '%' + @Search + '%'
			OR e.[CoordinatorId] LIKE '%' + @Search + '%')

END
GO
/****** Object:  StoredProcedure [dbo].[User_Post]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('User_Post') IS NOT NULL DROP PROC [User_Post]
GO
CREATE PROC [dbo].[User_Post]
(
	@UserId [nvarchar](128)
	, @UserEmail nvarchar(100) = ''
	, @UserName nvarchar(100) = ''
	, @isCoordinator bit = 0
)
AS
BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS ( SELECT 1 FROM [CodeEx].[dbo].[User] WHERE [UserId] = @UserId )
	BEGIN
		INSERT INTO dbo.[User] ([UserId],[UserEmail],[UserName],[isCoordinator])
		VALUES (@UserId, @UserEmail, @UserName, @isCoordinator)
	END
	ELSE BEGIN
		UPDATE dbo.[User]
		SET
		[UserEmail] = @UserEmail
		, [UserName] = @UserName
		, [isCoordinator] = @isCoordinator
		WHERE [UserId] = @UserId
	END

	--IF @UserId = -1 SET @UserId = SCOPE_IDENTITY()

	SELECT [UserId],[UserName],[UserEmail],[isCoordinator],[Created]
	FROM [CodeEx].[dbo].[User]
	WHERE [UserId] = @UserId

END
GO

/****** Object:  StoredProcedure [dbo].[Event_Post]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('Event_Post') IS NOT NULL DROP PROC [Event_Post]
GO
CREATE PROC [dbo].[Event_Post]
(
	@EventId int = -1
	, @EventTitle nvarchar(100)
	, @EventDescription nvarchar(100) = ''
	, @CoordinatorId nvarchar(128)
	, @CoordinatorEmail nvarchar(128) = ''
	, @CoordinatorName nvarchar(128) = ''
	, @EventDate datetime2 = null
	, @EventStatusId int = 1
)
AS
BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS ( SELECT 1 FROM [CodeEx].[dbo].[User] WHERE [UserId] = @CoordinatorId )
		EXEC [dbo].[User_Post] @UserId = @CoordinatorId, @UserEmail = @CoordinatorEmail, @UserName = @CoordinatorName, @isCoordinator = 1

	IF @EventId = -1 BEGIN
		INSERT INTO dbo.[Event] ([EventTitle],[EventDescription],[CoordinatorId],[EventDate],[EventStatusId])
		VALUES (@EventTitle,@EventDescription,@CoordinatorId,@EventDate,@EventStatusId)
	END
	ELSE BEGIN

		UPDATE dbo.[Event]
		SET
			[EventTitle] = @EventTitle
			,[EventDescription] = @EventDescription
			,[CoordinatorId] = @CoordinatorId
			,[EventDate] = @EventDate
			,[EventStatusId] = @EventStatusId
		WHERE
			EventId = @EventId

	END

	IF @EventId = -1 SET @EventId = SCOPE_IDENTITY()

	SELECT e.[EventId],e.[EventTitle],e.[EventDescription],e.[CoordinatorId], uc.[UserName] as [CoordinatorName],e.[EventDate],e.[EventStatusId],s.[EventStatus]
	FROM dbo.[Event] e 
		LEFT JOIN dbo.EventRegistration reg ON e.[EventId] = reg.[EventId]
		LEFT JOIN dbo.[User] uc ON e.[CoordinatorId] = uc.UserId 
		LEFT JOIN dbo.[EventStatus] s ON e.[EventStatusId] = s.[EventStatusId]
	WHERE e.EventId = @EventId

END
GO
/****** Object:  StoredProcedure [dbo].[EventRegistration_Get]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('EventRegistration_Get') IS NOT NULL DROP PROC [EventRegistration_Get]
GO
CREATE PROC [dbo].[EventRegistration_Get]
(
	@EventId int = -1,
	@UserId [nvarchar](128) = '',
	@userAuthorized bit = null,
	@userRejected bit = null,
	@userAttended bit = null,
	@userHold bit = null,
	@Search varchar(255) = ''
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT 
		[EventId]
		,[AttendeeId] = er.[UserId]
		,[AttendeeName] = ua.[UserName]
		,[AttendeeEmail] = ua.[UserEmail]
		,er.[RequestComment]
		,er.[RequestReply]
		,er.[AttendeeStatusId]
		,attStat.[AttendeeStatus]
		,er.[Created]
		,attStat.[Authorized]
		,attStat.[Rejected]
		,attStat.[Attended]
		,attStat.[Hold]
	FROM 
		[CodeEx].[dbo].[EventRegistration] er 
		LEFT JOIN dbo.[User] ua ON er.UserId = ua.UserId 
		LEFT JOIN [dbo].[vAttendeeStatus] attStat ON er.[AttendeeStatusId] = attStat.[AttendeeStatusId]
	WHERE (EventId = @EventId OR @EventId = -1) AND (er.UserId = @UserId OR @UserId = '') 
		AND ([Authorized] = @userAuthorized OR @userAuthorized is null)
		AND ([Rejected] = @userRejected OR @userRejected is null)
		AND ([Attended] = @userAttended OR @userAttended is null)
		AND ([Hold] = @userHold OR @userHold is null)
		AND (@Search = ''
			OR er.[RequestComment] LIKE '%' + @Search + '%'
			OR er.[RequestReply] LIKE '%' + @Search + '%'
			OR ua.[UserName] LIKE '%' + @Search + '%'
			OR er.[UserId] LIKE '%' + @Search + '%') 
	ORDER BY [EventId], [AttendeeId]

 END
GO
/****** Object:  StoredProcedure [dbo].[EventRegistration_Put]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('EventRegistration_Put') IS NOT NULL DROP PROC [EventRegistration_Put]
GO
CREATE PROC [dbo].[EventRegistration_Put]
(
	@EventId int
	, @UserId [nvarchar](128)
	, @UserEmail [nvarchar](128)
	, @UserName [nvarchar](128)
	, @AttendeeStatusId int
	, @RequestComment nvarchar(100) = ''
	, @RequestReply nvarchar(100) = ''
)
AS
BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS ( SELECT 1 FROM [CodeEx].[dbo].[User] WHERE [UserId] = @UserId )
		EXEC [dbo].[User_Post] @UserId = @UserId, @UserEmail = @UserEmail, @UserName = @UserName, @isCoordinator = 0

	IF NOT EXISTS ( SELECT 1 FROM dbo.EventRegistration WHERE EventId = @EventId AND UserId = @UserId ) 
	BEGIN
		INSERT INTO dbo.EventRegistration ([EventId], [UserId], [RequestComment], [RequestReply], [AttendeeStatusId])
		VALUES (@EventId, @UserId, @RequestComment, @RequestReply, @AttendeeStatusId)
	END
	ELSE
	BEGIN
		UPDATE dbo.EventRegistration
		SET
			[EventId] = @EventId
			,[UserId] = @UserId
			,[RequestComment] = @RequestComment
			,[RequestReply] = @RequestReply
			,[AttendeeStatusId] = @AttendeeStatusId
		WHERE 
			EventId = @EventId AND UserId = @UserId
	END


	SELECT reg.EventId,u.UserName,reg.UserId,reg.RequestComment,reg.RequestReply,reg.AttendeeStatusId,reg.Created
	FROM dbo.EventRegistration reg INNER JOIN dbo.[User] u ON reg.UserId = u.UserId 
	WHERE EventId = @EventId AND reg.[UserId] = @UserId

END
GO
/****** Object:  StoredProcedure [dbo].[EventStatus_Get]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('EventStatus_Get') IS NOT NULL DROP PROC [EventStatus_Get]
GO
CREATE PROC [dbo].[EventStatus_Get]
AS
BEGIN
	SET NOCOUNT ON
	SELECT [EventStatusId],[EventStatus] FROM [CodeEx].[dbo].[EventStatus]
END
GO

--:DCH:FUP:RESTART
/****** Object:  StoredProcedure [dbo].[User_Authorized]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('User_Authorized') IS NOT NULL DROP PROC [User_Authorized]
GO
CREATE PROC [dbo].[User_Authorized]
(
	@EventId int,
	@UserId int
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @UserAuthorized bit
	SELECT @UserAuthorized = [Authorized]
	FROM 
		[CodeEx].[dbo].[EventRegistration] er 
		LEFT JOIN [dbo].[vAttendeeStatus] attStat ON er.[AttendeeStatusId] = attStat.[AttendeeStatusId]
	WHERE EventId = @EventId AND er.UserId = @UserId
	ORDER BY [EventId], [UserId]
	
	IF @UserAuthorized is null SET @UserAuthorized = 0
	SELECT @UserAuthorized
 END
GO
/****** Object:  StoredProcedure [dbo].[User_Get]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('User_Get') IS NOT NULL DROP PROC [User_Get]
GO
CREATE PROC [dbo].[User_Get]
(
	@UserId [nvarchar](128) = ''
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT [UserId],[UserEmail],[UserName],[isCoordinator],[Created]
	FROM [CodeEx].[dbo].[User]
	WHERE UserId = @UserId OR @UserId = ''
END
GO
