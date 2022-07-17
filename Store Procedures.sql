--Store Procedure for a student to his/her result on a partical subject
CREATE PROC check_student_result 
@StudentID nvarchar(8),
@SubjectID nvarchar(8)
AS
SELECT a.AssessmentID as [GRADE CATEGORY], a.AssessmentName as [GRADE ITEM], a.Weight as [WEIGHT(%)], stuA.Score as GRADE
FROM Student stu INNER JOIN Student_Assessment stuA ON stu.StudentID =stuA.StudentID 
				INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID 
WHERE stu.StudentID = @StudentID AND a.SubjectID = @SubjectID
ORDER BY a.Weight
GO


EXEC check_student_result @StudentID = 'HE160520', @SubjectID = 'MAD101'

--Store Procedure for a student to his/her result on all subject
CREATE PROC check_student_Allresult 
@StudentID nvarchar(8)
AS
SELECT sub.SubjectID, sub.SubjectName, sem.SemesterID, g.GroupID, sem.Start, sem.[End],
SUM(stuA.Score*a.Weight/100) as [Average Mark], [dbo].[Status](stu.StudentID, sub.SubjectID) as [Status]
FROM Student stu INNER JOIN Group_Student gs ON stu.StudentID = gs.StudentID
							INNER JOIN [Group] g ON gs.GroupID = g.GroupID
							INNER JOIN Semester sem ON g.SemesterID =sem.SemesterID
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
							INNER JOIN Subject sub ON sub.SubjectID =a.SubjectID
GROUP BY stu.StudentID, sub.SubjectID, sub.SubjectName, sem.SemesterID, g.GroupID, sem.Start, sem.[End] 
HAVING stu.StudentID = @StudentID
GO

EXEC check_student_Allresult @StudentID = 'HE160520'
