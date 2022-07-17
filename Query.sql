-- 1 Students can check their results at the end of semester as following example:
EXEC check_student_Allresult @StudentID = 'HE160529'

-- 2 A query that uses INNER JOINS Check result of all students
SELECT stu.StudentID, sub.SubjectID, sub.SubjectName, sem.SemesterID, g.GroupID, sem.Start, sem.[End],
SUM(stuA.Score*a.Weight/100) as [Average Mark], [dbo].[Status](stu.StudentID, sub.SubjectID) as [Status]
FROM Student stu INNER JOIN Group_Student gs ON stu.StudentID = gs.StudentID
							INNER JOIN [Group] g ON gs.GroupID = g.GroupID
							INNER JOIN Semester sem ON g.SemesterID =sem.SemesterID
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
							INNER JOIN Subject sub ON sub.SubjectID =a.SubjectID
GROUP BY stu.StudentID, sub.SubjectID, sub.SubjectName, sem.SemesterID, g.GroupID, sem.Start, sem.[End] 

-- 3 Students can check the results of a specific subject
EXEC check_student_result @StudentID = 'HE160520', @SubjectID = 'MAD101'

-- 4 A query that uses aggregate functions to Check GPA of all Students
SELECT table1.StudentID, AVG(table1.[Average Mark]*4/10) as GPA FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID

--5 A query that uses a sub-query as a relation to CHECK GPA AND CLASSIFICATION
SELECT table1.StudentID, AVG(table1.[Average Mark]*4/10) as GPA, (
CASE
	WHEN AVG(table1.[Average Mark]*4/10) >= 3.6 THEN 'Excellent'
	WHEN AVG(table1.[Average Mark]*4/10) >= 3.2 AND AVG(table1.[Average Mark]*4/10) < 3.6 THEN 'Very Good'
	WHEN AVG(table1.[Average Mark]*4/10) >= 2.5 AND AVG(table1.[Average Mark]*4/10) < 3.2 THEN 'Good'
	WHEN AVG(table1.[Average Mark]*4/10) > = 2 AND AVG(table1.[Average Mark]*4/10) <2.5 THEN 'Average'
	WHEN AVG(table1.[Average Mark]*4/10) <2 THEN 'WEAK'
END) as [Classification]
FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID

--6 A Query that uses the GROUP BY and HAVING clauses to find students whose GPA is greater than 3.6
SELECT table1.StudentID, AVG(table1.[Average Mark]*4/10) as GPA, (
CASE
	WHEN AVG(table1.[Average Mark]*4/10) >= 3.6 THEN 'Excellent'
	WHEN AVG(table1.[Average Mark]*4/10) >= 3.2 AND AVG(table1.[Average Mark]*4/10) < 3.6 THEN 'Very Good'
	WHEN AVG(table1.[Average Mark]*4/10) >= 2.5 AND AVG(table1.[Average Mark]*4/10) < 3.2 THEN 'Good'
	WHEN AVG(table1.[Average Mark]*4/10) > = 2 AND AVG(table1.[Average Mark]*4/10) <2.5 THEN 'Average'
	WHEN AVG(table1.[Average Mark]*4/10) <2 THEN 'WEAK'
END) as [Classification]
FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID HAVING AVG(table1.[Average Mark]*4/10) > 3.6

--7 A query that uses ORDER BY to sort students according to their date of birth
SELECT * FROM Student ORDER BY DoB

--8 A query that uses a sub-query in the WHERE clause to find students whose GPA is greater than the average of all students
SELECT * FROM (
SELECT table1.StudentID, AVG(table1.[Average Mark]*4/10) as GPA FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID) table3 
WHERE table3.GPA > (SELECT AVG (table2.GPA) FROM
(SELECT AVG(table1.[Average Mark]*4/10) as GPA FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID ) table2)

--9 A query that uses partial matching in the WHERE clause to find students whose name start with 'Le'
SELECT * FROM Student WHERE StudentName LIKE 'Le%'

--10 A query that uses a self-JOIN for a stundet to find students who has lower GPA than him/her
SELECT * FROM (
SELECT table1.StudentID, AVG(table1.[Average Mark]*4/10) as GPA FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID ) table2,
(SELECT table1.StudentID, AVG(table1.[Average Mark]*4/10) as GPA FROM (
SELECT stu.StudentID, a.SubjectID, 
SUM(stuA.Score*a.Weight/100) as [Average Mark]
FROM Student stu 
							INNER JOIN Student_Assessment stuA ON stuA.StudentID = stu.StudentID
							INNER JOIN Assessment a ON a.AssessmentID = stuA.AssessmentID
GROUP BY stu.StudentID, a.SubjectID) table1
GROUP BY table1.StudentID) table3
WHERE table2.GPA > table3.GPA
ORDER BY table2.StudentID

