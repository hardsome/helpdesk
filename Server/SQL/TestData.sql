
 Use helpdesk                              
 GO                                         
     
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Project --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Project]
       ([ProjectName]  , [POP3Address]  , [isActive] )
    Values 
       (  'test Project ' + CONVERT(nvarchar,@i)   ,   'test Project ' + CONVERT(nvarchar,@i)   ,   1 )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- User --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [User]
       ([UserName]  , [FirstName]  , [LastName] )
    Values 
       (  'test User ' + CONVERT(nvarchar,@i)   ,   'test User ' + CONVERT(nvarchar,@i)   ,   'test User ' + CONVERT(nvarchar,@i)  )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Status --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Status]
       ([StatusName]  , [SortOrder]  , [CSSClass]  , [isDefault] )
    Values 
       (  'test Status ' + CONVERT(nvarchar,@i)   ,   1   ,   'test Status ' + CONVERT(nvarchar,@i)   ,   1 )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Priority --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Priority]
       ([PriorityName]  , [CSSClass]  , [SortOrder] )
    Values 
       (  'test Priority ' + CONVERT(nvarchar,@i)   ,   'test Priority ' + CONVERT(nvarchar,@i)   ,   1  )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Category --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Category]
       ([CategoryName]  , [SortOrder] )
    Values 
       (  'test Category ' + CONVERT(nvarchar,@i)   ,   1  )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Incident --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Incident]
       ([IncidentName]  , [ProjectID]  , [StatusID]  , [PriorityID]  , [CategoryID]  , [Description]  , [ReportedDate]  , [UpdatedDate]  , [UserID] )
    Values 
       (  'test Incident ' + CONVERT(nvarchar,@i)   ,   1   ,   1   ,   1   ,   1   ,   'test Incident' + CONVERT(nvarchar,@i)   ,   GETDATE()    ,   GETDATE()    ,   1  )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Post --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Post]
       ([PostName]  , [IncidentID]  , [FromUser]  , [ToUser]  , [PostedDate]  , [Desctiption] )
    Values 
       (  'test Post ' + CONVERT(nvarchar,@i)   ,   1   ,   1   ,   1   ,   GETDATE()    ,   'test Post' + CONVERT(nvarchar,@i)  )
END              
GO



      
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Attachment --------------

DECLARE @i int = 1
WHILE @i < 10 BEGIN
    SET @i = @i + 1
    /* do some work */

    Insert into [Attachment]
       ([AttachmentName]  , [Incident]  , [Creator]  , [Content]  , [MimeType] )
    Values 
       (  'test Attachment ' + CONVERT(nvarchar,@i)   ,   1   ,   1   ,   'test Attachment' + CONVERT(nvarchar,@i)   ,   'test Attachment ' + CONVERT(nvarchar,@i)  )
END              
GO



 