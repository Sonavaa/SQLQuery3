Create database LibraryDb
Use LibraryDb

Create table Authors 
(
Id int Identity Primary Key,
Name nvarchar(100) ,
Surname nvarchar(100) 
)

Create table Books 
(
Id int Identity Foreign Key References Authors(Id), 
Name nvarchar(100) Check (LEN(Name) Between 2 AND 100),
PageCount int Check (LEN(PageCount) >= 10),
AuthorFullName nvarchar(100) Check ()
)

Select (Authors.Name+' '+Authors.Surname) as AuthorFullName From Authors 
Left  Join Books on Books.Id=Authors.Id

GO
Create View usv_ReturnColumns
AS
Select B.Id, B.Name, B.PageCount, B.AuthorFullName 
From Books B

Select * From usv_ReturnColumns

GO
Create Procedure usp_ReturnColumns
@Name nvarchar(100),
@AuthorFullName nvarchar(100)
As
Begin
Select B.Id, B.Name, B.PageCount, B.AuthorFullName
From Books B 
Join Authors A
On B.Id=A.Id
End


Select dbo.usp_ReturnColumns ('The Missing','Jane Casey')

Create table ChangedSituation
(
Id int Identity ,
Name nvarchar(100) ,
Surname nvarchar(100) 
)

GO
Create Trigger AuthorsChanged
On Authors 
after insert,delete 
as Begin
Declare @Id int
Declare @Name nvarchar(100)
Declare @SurName nvarchar(100)

Select @Id=a.id From inserted a
Select @Name=a.Name From inserted a
Select @SurName=a.SurName From inserted a

Select @Id=a.id From deleted a
Select @Name=a.Name From deleted a
Select @SurName=a.SurName From deleted a

Insert Into ChangedSituation(Id, Name, SurName)
Values (@Id, @Name, @SurName)
END

GO
Create Trigger AuthorsUpdatedChanged
On Authors 
after update
as Begin
Declare @Id int
Declare @Name nvarchar(100)
Declare @SurName nvarchar(100)

Select @Id=a.id From updated a
Select @Name=a.Name From updated a
Select @SurName=a.SurName From updated a

Insert Into ChangedSituation(Id, Name, SurName)
Values (@Id, @Name, @SurName)
END

