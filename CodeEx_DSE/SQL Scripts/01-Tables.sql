

-- =================================================================================================================================
-- Tables
-- =================================================================================================================================
USE [CodeEx]
GO

IF OBJECT_ID('EventRegistration') is not null BEGIN DROP TABLE dbo.EventRegistration END
GO
IF OBJECT_ID('AttendeeStatus') is not null BEGIN DROP TABLE dbo.AttendeeStatus END
GO 
IF OBJECT_ID('Event') is not null BEGIN DROP TABLE dbo.[Event] END
GO
IF OBJECT_ID('User') is not null BEGIN DROP TABLE dbo.[User] END
GO
IF OBJECT_ID('EventStatus') is not null BEGIN DROP TABLE dbo.EventStatus END
GO 

/****** Object:  Table [dbo].[AttendeeStatus]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttendeeStatus](
	[AttendeeStatusId] [int] IDENTITY(1,1) NOT NULL,
	[AttendeeStatus] [nvarchar](20) NOT NULL,
	[CompletedEventStatus] [bit] NULL,
	--[Authorized] [bit] NULL,
	--[Rejected] [bit] NULL,
	--[Attended] [bit] NULL,
	--[Hold] [bit] NULL,
 CONSTRAINT [PK_AttendeeStatus] PRIMARY KEY CLUSTERED 
(
	[AttendeeStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[EventTitle] [nvarchar](100) NOT NULL,
	[EventDescription] [nvarchar](max) NULL,
	[CoordinatorId] [nvarchar](128) NULL,
	[EventDate] [datetime2](7) NULL,
	[EventStatusId] [int] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventRegistration]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventRegistration](
	[EventId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[RequestComment] [nvarchar](256) NULL,
	[RequestReply] [nvarchar](512) NULL,
	[AttendeeStatusId] [int] NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_EventRegistration_1] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventStatus]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventStatus](
	[EventStatusId] [int] IDENTITY(1,1) NOT NULL,
	[EventStatus] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_EventStatus] PRIMARY KEY CLUSTERED 
(
	[EventStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 8/9/2022 10:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [nvarchar](128) NOT NULL,
	[UserEmail] [nvarchar](128) NULL,
	[UserName] [nvarchar](128) NULL,
	[isCoordinator] [bit] NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AttendeeStatus] ON 

--INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [Authorized], [Rejected], [Attended], [Hold]) VALUES (1, N'Registered', 0, 0, 0, 1)
--INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [Authorized], [Rejected], [Attended], [Hold]) VALUES (2, N'Rejected', 0, 1, 0, 0)
--INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [Authorized], [Rejected], [Attended], [Hold]) VALUES (3, N'Authorized', 1, 0, 0, 0)
--INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [Authorized], [Rejected], [Attended], [Hold]) VALUES (4, N'Attended', 1, 0, 1, 0)
--INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [Authorized], [Rejected], [Attended], [Hold]) VALUES (5, N'Absent', 1, 0, 0, 0)

INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [CompletedEventStatus]) VALUES (1, N'Registered', 0)
INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [CompletedEventStatus]) VALUES (2, N'Rejected', 0)
INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [CompletedEventStatus]) VALUES (3, N'Authorized', 0)
INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [CompletedEventStatus]) VALUES (4, N'Attended', 1)
INSERT [dbo].[AttendeeStatus] ([AttendeeStatusId], [AttendeeStatus], [CompletedEventStatus]) VALUES (5, N'Absent', 1)


SET IDENTITY_INSERT [dbo].[AttendeeStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[Event] ON 

INSERT [dbo].[Event] ([EventId], [EventTitle], [EventDescription], [CoordinatorId], [EventDate], [EventStatusId], [Created]) VALUES (1, N'Jam at Joe''s Garage', '', N'auth0|62ecb86b224cf98f8543c20f', CAST(N'2022-07-31T00:00:00.0000000' AS DateTime2), 2, CAST(N'2022-07-24T13:07:24.9400000' AS DateTime2))
INSERT [dbo].[Event] ([EventId], [EventTitle], [EventDescription], [CoordinatorId], [EventDate], [EventStatusId], [Created]) VALUES (2, N'Them or Us', '', N'auth0|62f451377a9349bf5c7b5e4e', CAST(N'2022-08-31T00:00:00.0000000' AS DateTime2), 2, CAST(N'2022-07-24T13:07:54.4200000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Event] OFF
GO
INSERT [dbo].[EventRegistration] ([EventId], [UserId], [RequestComment], [RequestReply], [AttendeeStatusId], [Created]) VALUES (1, N'auth0|62f4506c7a9349bf5c7b5e3a', N'Rooster comment', N'Reply to Rooster', 3, CAST(N'2022-07-24T13:12:25.0900000' AS DateTime2))
INSERT [dbo].[EventRegistration] ([EventId], [UserId], [RequestComment], [RequestReply], [AttendeeStatusId], [Created]) VALUES (1, N'auth0|62eebc493ab935c46f203819', N'Music comment', N'reply with music', 1, CAST(N'2022-07-24T13:13:21.3400000' AS DateTime2))
INSERT [dbo].[EventRegistration] ([EventId], [UserId], [RequestComment], [RequestReply], [AttendeeStatusId], [Created]) VALUES (2, N'auth0|62f4506c7a9349bf5c7b5e3a', N'tutanota comment', N'secure reply', 3, CAST(N'2022-07-24T13:12:56.7200000' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[EventStatus] ON 

INSERT [dbo].[EventStatus] ([EventStatusId], [EventStatus]) VALUES (1, N'Planned')
INSERT [dbo].[EventStatus] ([EventStatusId], [EventStatus]) VALUES (2, N'Scheduled')
INSERT [dbo].[EventStatus] ([EventStatusId], [EventStatus]) VALUES (3, N'Hold')
INSERT [dbo].[EventStatus] ([EventStatusId], [EventStatus]) VALUES (4, N'Completed')
INSERT [dbo].[EventStatus] ([EventStatusId], [EventStatus]) VALUES (5, N'Canceled')
SET IDENTITY_INSERT [dbo].[EventStatus] OFF
GO
INSERT [dbo].[User] ([UserId], [UserEmail], [UserName], [isCoordinator], [Created]) VALUES (N'auth0|62f4506c7a9349bf5c7b5e3a', N'cantkilltherooster@gmail.com', N'Steve Vai', 0, CAST(N'2022-07-24T13:05:04.9633333' AS DateTime2))
INSERT [dbo].[User] ([UserId], [UserEmail], [UserName], [isCoordinator], [Created]) VALUES (N'auth0|62eebc493ab935c46f203819', N'cantstopthemusic@hotmail.com', N'Terry Bozzio', 0, CAST(N'2022-07-24T13:02:27.6666667' AS DateTime2))
INSERT [dbo].[User] ([UserId], [UserEmail], [UserName], [isCoordinator], [Created]) VALUES (N'auth0|62ecb86b224cf98f8543c20f', N'haskelld@seattleu.edu', N'Frank Zappa', 1, CAST(N'2022-07-24T13:02:17.6366667' AS DateTime2))
INSERT [dbo].[User] ([UserId], [UserEmail], [UserName], [isCoordinator], [Created]) VALUES (N'auth0|62f451377a9349bf5c7b5e4e', N'haskelld@tutanota.com', N'Ike Willis', 0, CAST(N'2022-07-24T13:03:26.9933333' AS DateTime2))
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [df_Event]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[EventRegistration] ADD  CONSTRAINT [df_EventRegistration]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_isCoordinator]  DEFAULT ((0)) FOR [isCoordinator]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [df_User]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_Status] FOREIGN KEY([EventStatusId])
REFERENCES [dbo].[EventStatus] ([EventStatusId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Status]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_User] FOREIGN KEY([CoordinatorId])
REFERENCES [dbo].[User] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_User]
GO
ALTER TABLE [dbo].[EventRegistration]  WITH CHECK ADD  CONSTRAINT [FK_Attendee_Status] FOREIGN KEY([AttendeeStatusId])
REFERENCES [dbo].[AttendeeStatus] ([AttendeeStatusId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventRegistration] CHECK CONSTRAINT [FK_Attendee_Status]
GO
ALTER TABLE [dbo].[EventRegistration]  WITH CHECK ADD  CONSTRAINT [FK_Registration_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventRegistration] CHECK CONSTRAINT [FK_Registration_Event]
GO
ALTER TABLE [dbo].[EventRegistration]  WITH CHECK ADD  CONSTRAINT [FK_Registration_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[EventRegistration] CHECK CONSTRAINT [FK_Registration_User]
GO


-- =================================================================================================================================
-- Views
-- =================================================================================================================================

IF OBJECT_ID('vAttendeeStatus') IS NOT NULL DROP VIEW [vAttendeeStatus]
GO
CREATE VIEW [dbo].[vAttendeeStatus]
AS
	SELECT 
		AttendeeStatusId
		, AttendeeStatus
		, Attended = CASE WHEN AttendeeStatus = 'Attended' THEN 1 ELSE 0 END
		, Authorized = CASE WHEN AttendeeStatus = 'Authorized' THEN 1 ELSE 0 END
		, Rejected = CASE WHEN AttendeeStatus = 'Rejected' THEN 1 ELSE 0 END
		, Hold = CASE WHEN AttendeeStatus = 'Hold' THEN 1 ELSE 0 END
	FROM dbo.AttendeeStatus
GO
