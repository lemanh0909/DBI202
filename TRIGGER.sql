-- TRIGGER so that the user does not enter a student's score greater than 10 or lower than 0
CREATE TRIGGER trigger_score ON Student_Assessment
AFTER INSERT, UPDATE
AS
DECLARE @new_score float;
SELECT @new_score = Score FROM inserted
IF @new_score < 0
BEGIN
	PRINT 'Score cannot lower than 0'
	ROLLBACK TRAN
END
ELSE IF @new_score > 10
BEGIN
	PRINT 'Score cannot higher than 10'
	ROLLBACK TRAN
END

UPDATE Student_Assessment SET Score = -6 WHERE AssessmentID = 'ASS1CSD201' AND StudentID = 'HE140527'