ALTER TABLE Student(
StudentID nvarchar(8) PRIMARY KEY,
StudentName nvarchar(20),
DoB date,
Gender bit
)

CREATE TABLE Lecture(
	LectureID nvarchar(8) PRIMARY KEY,
	LectureName nvarchar(20),
	DoB date,
	Gender bit
)

CREATE TABLE [Subject](
	SubjectID nvarchar(8) PRIMARY KEY,
	SubjectName nvarchar(50)
)

CREATE TABLE Semester(
	SemesterID nvarchar(10) PRIMARY KEY,
	[Start] date,
	[End] date
)

CREATE TABLE Assessment(
	AssessmentID nvarchar(10) PRIMARY KEY,
	AssessmentName nvarchar(30),
	Weight int,
	SubjectID nvarchar(8) FOREIGN KEY REFERENCES [Subject](SubjectID)
)

CREATE TABLE Student_Assessment(
	AssessmentID nvarchar(10) FOREIGN KEY REFERENCES [Assessment](AssessmentID),
	StudentID nvarchar(8) FOREIGN KEY REFERENCES [Student](StudentID),
	Date date,
	Score float,
	CONSTRAINT [PK_SA] PRIMARY KEY (AssessmentID, StudentID, Date)

)

CREATE TABLE [Group](
	GroupID nvarchar(10) PRIMARY KEY,
	SemesterID nvarchar(10) FOREIGN KEY REFERENCES [Semester](SemesterID)
)

CREATE TABLE Group_Student(
	GroupID nvarchar(10) FOREIGN KEY REFERENCES [Group](GroupID),
	StudentID nvarchar(8) FOREIGN KEY REFERENCES [Student](StudentID)
	CONSTRAINT [PK_GS] PRIMARY KEY (GroupID, StudentID)
)

CREATE TABLE Group_Lecture(
	GroupID nvarchar(10) FOREIGN KEY REFERENCES [Group](GroupID),
	LectureID nvarchar(8) FOREIGN KEY REFERENCES [Lecture](LectureID)
	CONSTRAINT [PK_GL] PRIMARY KEY (GroupID, LectureID)
)
