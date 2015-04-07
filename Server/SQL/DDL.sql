
if  (db_id('helpdesk') is null)                   
    Create database helpdesk                  
GO                                         
Use helpdesk                              
GO                                         
-- create the user and login               
IF NOT EXISTS (SELECT name   FROM master.sys.server_principals  WHERE name = 'Xx_helpdesk123') 
BEGIN    CREATE LOGIN Xx_helpdesk123 WITH PASSWORD = N'xxPxaxssxwx123' END  
USE helpdesk;                              
IF NOT EXISTS(SELECT name FROM sys.database_principals WHERE name = 'Xx_helpdesk123') 
BEGIN    CREATE USER [Xx_helpdesk123] FOR LOGIN [Xx_helpdesk123] END 
-- add user to the role                    
EXEC sp_addrolemember  'db_owner','Xx_helpdesk123';    
      
      
       
-- Project --------------
      IF OBJECT_ID('dbo.[Project]','U') IS NOT NULL
      DROP TABLE dbo.[Project]
      CREATE TABLE [Project]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [ProjectName]    nvarchar(200)   NULL  , 
  [POP3Address]    nvarchar(200)   NULL  , 
  [isActive]    bit  NULL 
, CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- User --------------
      IF OBJECT_ID('dbo.[User]','U') IS NOT NULL
      DROP TABLE dbo.[User]
      CREATE TABLE [User]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [UserName]    nvarchar(200)   NULL  , 
  [FirstName]    nvarchar(200)   NULL  , 
  [LastName]    nvarchar(200)   NULL 
, CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- Status --------------
      IF OBJECT_ID('dbo.[Status]','U') IS NOT NULL
      DROP TABLE dbo.[Status]
      CREATE TABLE [Status]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [StatusName]    nvarchar(200)   NULL  , 
  [SortOrder]    int   NULL  , 
  [CSSClass]    nvarchar(200)   NULL  , 
  [isDefault]    bit  NULL 
, CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- Priority --------------
      IF OBJECT_ID('dbo.[Priority]','U') IS NOT NULL
      DROP TABLE dbo.[Priority]
      CREATE TABLE [Priority]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [PriorityName]    nvarchar(200)   NULL  , 
  [CSSClass]    nvarchar(200)   NULL  , 
  [SortOrder]    int   NULL 
, CONSTRAINT [PK_Priority] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- Category --------------
      IF OBJECT_ID('dbo.[Category]','U') IS NOT NULL
      DROP TABLE dbo.[Category]
      CREATE TABLE [Category]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [CategoryName]    nvarchar(200)   NULL  , 
  [SortOrder]    int   NULL 
, CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- Incident --------------
      IF OBJECT_ID('dbo.[Incident]','U') IS NOT NULL
      DROP TABLE dbo.[Incident]
      CREATE TABLE [Incident]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [IncidentName]    nvarchar(200)   NULL  , 
  [ProjectID]    int   NULL  , 
  [StatusID]    int   NULL  , 
  [PriorityID]    int   NULL  , 
  [CategoryID]    int   NULL  , 
  [Description]    nvarchar(MAX)   NULL  , 
  [ReportedDate]    datetime   NULL  , 
  [UpdatedDate]    datetime   NULL  , 
  [UserID]    int   NULL 
, CONSTRAINT [PK_Incident] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- Post --------------
      IF OBJECT_ID('dbo.[Post]','U') IS NOT NULL
      DROP TABLE dbo.[Post]
      CREATE TABLE [Post]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [PostName]    nvarchar(200)   NULL  , 
  [IncidentID]    int   NULL  , 
  [FromUser]    int   NULL  , 
  [ToUser]    int   NULL  , 
  [PostedDate]    datetime   NULL  , 
  [Desctiption]    nvarchar(MAX)   NULL 
, CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 
-- Attachment --------------
      IF OBJECT_ID('dbo.[Attachment]','U') IS NOT NULL
      DROP TABLE dbo.[Attachment]
      CREATE TABLE [Attachment]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [AttachmentName]    nvarchar(200)   NULL  , 
  [Incident]    int   NULL  , 
  [Creator]    int   NULL  , 
  [Content]    nvarchar(MAX)   NULL  , 
  [MimeType]    nvarchar(200)   NULL 
, CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
 