CREATE OR ALTER FUNCTION [Status](
	@StudentID nvarchar(8),
	@SubjectID nvarchar(8)
)
RETURNS nvarchar(20)
AS 
BEGIN
	DECLARE 
	@Status nvarchar(20),
	@AverageMark float,
	@FinalMark float,
	@ProgestMark float,
	@Attend int
	SET @Status ='Passed'
	SELECT @AverageMark = table1.[Average Mark] FROM (
SELECT stu.StudentID, sub.SubjectID,
SUM(stuA.Score*a.Weight/100) as [Average Mark]

FROM Student stu INNER JOIN Group_Student gs ON stu.StudentID = gs.StudentID
							INNER JOIN [Group] g ON gs.GroupID = g.GroupID
							INNER JOIN Semester sem ON g.SemesterID =sem.SemesterID
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
							INNER JOIN Subject sub ON sub.SubjectID =a.SubjectID
GROUP BY stu.StudentID, sub.SubjectID
) table1 WHERE table1.StudentID =@StudentID AND table1.SubjectID =@SubjectID

IF @AverageMark < 5
BEGIN
SET @Status = 'Not Passed'
END

	SELECT @FinalMark = sa.Score FROM
	Student_Assessment sa INNER JOIN Student s ON sa.StudentID = s.StudentID
						INNER JOIN Assessment a ON sa.AssessmentID = a.AssessmentID
	WHERE a.AssessmentID LIKE 'FE%' AND sa.StudentID = @StudentID AND @SubjectID = a.SubjectID
	IF @FinalMark < 4
	BEGIN
		SET @Status = 'Not Passed';
	END
	SELECT @Attend = att.AttendPercent FROM Attendance att WHERE att.StudentID =@StudentID AND @SubjectID = att.SessionID
	IF @Attend < 80
	BEGIN
		SET @Status = 'Attendance Fail'
	END

	SELECT @ProgestMark = MIN(sa.Score) FROM Student_Assessment sa INNER JOIN Student s ON sa.StudentID = s.StudentID
						INNER JOIN Assessment a ON sa.AssessmentID = a.AssessmentID
	WHERE sa.StudentID =@StudentID AND @SubjectID = a.SubjectID
	IF @ProgestMark = 0
	BEGIN
		SET @Status = 'Not Passed';
	END
	RETURN @Status;
END
