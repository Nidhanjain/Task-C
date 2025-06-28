Use [Practice DB]
Go

-- TASK 1
CREATE TABLE Projects (
    Task_ID INT,
    Start_Date DATE,
    End_Date DATE
);
INSERT INTO Projects (Task_ID, Start_Date, End_Date)
VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');

SELECT * FROM Projects ORDER BY Start_Date;

WITH OrderedTasks AS (
    SELECT *, 
    ROW_NUMBER() OVER (ORDER BY Start_Date) AS rn
    FROM Projects
),
GroupKey AS (
    SELECT *, 
     DATEADD(DAY, -rn, Start_Date) AS group_key
    FROM OrderedTasks
),
ProjectGroups AS (
    SELECT 
        MIN(Start_Date) AS Project_Start,
        MAX(End_Date) AS Project_End,
        DATEDIFF(DAY, MIN(Start_Date), MAX(End_Date)) + 1 AS Duration
    FROM GroupKey
    GROUP BY group_key
)
SELECT Project_Start, Project_End
FROM ProjectGroups
ORDER BY Duration, Project_Start;

-- TASK 2 

CREATE TABLE Friends (
   id INT ,
   Friend_id INT,
) ;
INSERT into Friends(id , Friend_id)
VALUES
(1,2),
(2,3),
(3,4),
(4,1);


CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);
INSERT INTO Students (ID, Name) VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Scarlet');


CREATE TABLE Packages (
    ID INT PRIMARY KEY, 
    Salary FLOAT        
);
INSERT INTO Packages (ID, Salary) VALUES
(1, 15.20), (2, 10.06),(3, 11.55),(4, 12.12);
SELECT S.Name
FROM Students S
JOIN Friends F ON S.ID = F.ID
JOIN Packages P1 ON S.ID = P1.ID         
JOIN Packages P2 ON F.Friend_ID = P2.ID  
WHERE P2.Salary > P1.Salary
ORDER BY P2.Salary;

-- Task 3 

CREATE TABLE Functions (
    X INT,
    Y INT
);
INSERT INTO Functions (X, Y) VALUES
(20, 20),
(20, 20),
(20, 21),
(23, 22),
(22, 23),
(21, 20);

SELECT DISTINCT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2
  ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y 
ORDER BY f1.X;

-- Task 4 
DROP TABLE IF EXISTS Contests, Colleges, Challenges, View_Stats, Submission_Stats;
CREATE TABLE Contests (
    contest_id INT,
    hacker_id INT,
    name VARCHAR(50)
);

INSERT INTO Contests VALUES
(66406, 17973, 'Rose'),
(66556, 79153, 'Angela'),
(94828, 80275, 'Frank');
CREATE TABLE Colleges (
    college_id INT,
    contest_id INT
);
INSERT INTO Colleges VALUES
(11219, 66406),
(32473, 66556),
(56885, 94828);

CREATE TABLE Challenges (
    challenge_id INT,
    college_id INT
);

INSERT INTO Challenges VALUES
(47127, 11219),
(86922, 32473),
(72974, 56885);

CREATE TABLE View_Stats (
    challenge_id INT,
    total_views INT,
    total_unique_views INT
);

INSERT INTO View_Stats VALUES
(47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(75516, 35, 17),
(86922, 11, 10),
(72974, 41, 15),
(75516, 75, 11);

CREATE TABLE Submission_Stats (
challenge_id INT,total_submissions INT,total_accepted_submissions INT
);
INSERT INTO Submission_Stats VALUES
(75516, 34, 12),
(47127, 27, 10),
(47127, 56, 18),
(75516, 74, 12),
(75516, 83, 8),
(72974, 68, 24),
(72974, 82, 14),
(47127, 28, 11);

SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    SUM(ss.total_submissions) AS total_submissions,
    SUM(ss.total_accepted_submissions) AS total_accepted_submissions,
    SUM(vs.total_views) AS total_views,
    SUM(vs.total_unique_views) AS total_unique_views
FROM Contests c
JOIN Colleges col ON c.contest_id = col.contest_id
JOIN Challenges ch ON ch.college_id = col.college_id
LEFT JOIN Submission_Stats ss ON ss.challenge_id = ch.challenge_id
LEFT JOIN View_Stats vs ON vs.challenge_id = ch.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
ORDER BY c.contest_id;


-- Task 5
DROP TABLE IF EXISTS Hackers , Submissions ;
CREATE TABLE Hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT,
    hacker_id INT,
    score INT
);
INSERT INTO Hackers VALUES
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');

INSERT INTO Submissions VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30178, 36396, 70),
('2016-03-02', 34928, 20703, 25),
('2016-03-02', 38740, 15758, 0),
('2016-03-02', 42789, 79722, 25),
('2016-03-02', 43464, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 60),
('2016-03-05', 76487, 62529, 80),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);
WITH DailySubmissionStats AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) AS submission_count
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
RankedDailyTopHackers AS (
    SELECT 
        submission_date,
        hacker_id,
        submission_count,
        RANK() OVER (PARTITION BY submission_date ORDER BY submission_count DESC, hacker_id ASC) AS rnk
    FROM DailySubmissionStats
)
SELECT 
    r.submission_date,
    (SELECT COUNT(DISTINCT s.hacker_id) 
     FROM Submissions s 
     WHERE s.submission_date = r.submission_date) AS total_hackers,
    r.hacker_id
FROM RankedDailyTopHackers r
WHERE r.rnk = 1
ORDER BY r.submission_date;

-- Task 6
CREATE TABLE STATION (
    ID INT,
    CITY VARCHAR(21),
    STATE VARCHAR(2),
    LAT_N FLOAT,
    LONG_W FLOAT
);
INSERT INTO STATION VALUES
(1, 'Chicago', 'IL', 41.8781, 87.6298),
(2, 'Miami', 'FL', 25.7617, 80.1918),
(3, 'Seattle', 'WA', 47.6062, 122.3321),
(4, 'Denver', 'CO', 39.7392, 104.9903);
SELECT 
    ROUND(
        ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W)),
        4
    ) AS ManhattanDistance
FROM STATION;

-- Task 7 
CREATE TABLE Numbers (n INT);

DECLARE @i INT = 2;
WHILE @i <= 1000
BEGIN
    INSERT INTO Numbers VALUES (@i);
    SET @i = @i + 1;
END
DROP FUNCTION IF EXISTS dbo.IsPrime;
GO
CREATE FUNCTION dbo.IsPrime(@num INT)
RETURNS BIT
AS
BEGIN
    IF @num < 2 RETURN 0;
    DECLARE @i INT = 2;
    WHILE @i * @i <= @num
    BEGIN
        IF @num % @i = 0 RETURN 0;
        SET @i += 1;
    END
    RETURN 1;
END
GO
SELECT STUFF((
    SELECT '&' + CAST(n AS VARCHAR)
    FROM Numbers
    WHERE dbo.IsPrime(n) = 1
    ORDER BY n
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS PrimeList;

-- Task 8

DROP TABLE IF EXISTS OCCUPATIONS;
CREATE TABLE OCCUPATIONS (
    Name VARCHAR(50),
    Occupation VARCHAR(20)
);
INSERT INTO OCCUPATIONS VALUES 
('Samantha', 'Doctor'),
('Julia', 'Actor'),
('Maria', 'Actor'),
('Meera', 'Singer'),
('Ashley', 'Professor'),
('Ketty', 'Professor'),
('Christeen', 'Professor'),
('Jane', 'Actor'),
('Jenny', 'Doctor'),
('Priya', 'Singer');
SELECT
    [Doctor],
    [Professor],
    [Singer],
    [Actor]
FROM (
    SELECT Name, Occupation,
           ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
) AS Source
PIVOT (
    MAX(Name) FOR Occupation IN ([Doctor], [Professor], [Singer], [Actor])
) AS Pivoted
ORDER BY rn;

-- Task 9 

CREATE TABLE BST (
    N INT,
    P INT
);
INSERT INTO BST (N, P) VALUES
(1, 2),
(3, 2),
(6, 8),
(9, 8),
(2, 5),
(8, 5),
(5, NULL);

SELECT  b.N,
CASE
WHEN b.P IS NULL THEN 'Root'
WHEN b.N NOT IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
ELSE 'Inner'
END AS NodeType
FROM BST b
ORDER BY b.N;


-- Task 10 


CREATE TABLE Company (
    company_code VARCHAR(10),
    founder VARCHAR(50)
);
INSERT INTO Company VALUES
('C1', 'Monika'),
('C2', 'Samantha');
CREATE TABLE Lead_Manager (
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);
INSERT INTO Lead_Manager VALUES
('LM1', 'C1'),
('LM2', 'C2');
CREATE TABLE Senior_Manager (
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

INSERT INTO Senior_Manager VALUES
('SM1', 'LM1', 'C1'),
('SM2', 'LM1', 'C1'),
('SM3', 'LM2', 'C2');
CREATE TABLE Manager (
    manager_code VARCHAR(10),
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

INSERT INTO Manager VALUES
('M1', 'SM1', 'LM1', 'C1'),
('M2', 'SM3', 'LM2', 'C2'),
('M3', 'SM3', 'LM2', 'C2');
CREATE TABLE Emploee (
    emploee_code VARCHAR(10),
    manager_code VARCHAR(10),
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);
INSERT INTO Emploee VALUES
('E1', 'M1', 'SM1', 'LM1', 'C1'),
('E2', 'M1', 'SM1', 'LM1', 'C1'),
('E3', 'M2', 'SM3', 'LM2', 'C2'),
('E4', 'M3', 'SM3', 'LM2', 'C2');
SELECT 
    c.company_code,
    c.founder,
    (SELECT COUNT(*) FROM Lead_Manager WHERE company_code = c.company_code) AS lead_count,
    (SELECT COUNT(*) FROM Senior_Manager WHERE company_code = c.company_code) AS senior_count,
    (SELECT COUNT(*) FROM Manager WHERE company_code = c.company_code) AS manager_count,
    (SELECT COUNT(*) FROM Emploee WHERE company_code = c.company_code) AS employee_count
FROM Company c
ORDER BY c.company_code;


-- Task 11 is same as task 2 


-- Task 12
CREATE TABLE JobCost (
    JobFamily VARCHAR(50),
    Country VARCHAR(50),
    Cost INT
);
INSERT INTO JobCost VALUES
('Engineering', 'India', 4000),
('Engineering', 'International', 8000),
('HR', 'India', 2000),
('HR', 'International', 6000);
SELECT 
    JobFamily,
    SUM(CASE WHEN Country = 'India' THEN Cost ELSE 0 END) * 100.0 / SUM(Cost) AS India_Percentage,
    SUM(CASE WHEN Country = 'International' THEN Cost ELSE 0 END) * 100.0 / SUM(Cost) AS Intl_Percentage
FROM JobCost
GROUP BY JobFamily;

-- task 13

CREATE TABLE BU_CostRevenue (
    BU VARCHAR(50),
    Month VARCHAR(10),
    Cost INT,
    Revenue INT
);
INSERT INTO BU_CostRevenue VALUES
('IT', 'Jan', 1000, 2000),
('IT', 'Feb', 1500, 3000),
('HR', 'Jan', 500, 800),
('HR', 'Feb', 600, 900);
SELECT BU, Month,
       CAST(Cost AS FLOAT) / Revenue AS CostRevenueRatio
FROM BU_CostRevenue;

-- Task 14

CREATE TABLE EmployeeBand (
    EmpID INT,
    Band VARCHAR(10)
);
INSERT INTO EmployeeBand VALUES
(1, 'A'), (2, 'A'), (3, 'B'), (4, 'B'), (5, 'B'), (6, 'C');
SELECT 
 Band,
COUNT(*) AS Headcount,
COUNT(*) * 100.0 / Total.TotalCount AS Percentage
FROM EmployeeBand
CROSS JOIN (SELECT COUNT(*) AS TotalCount FROM EmployeeBand) AS Total
GROUP BY Band, Total.TotalCount;

-- Task 15

CREATE TABLE EmplSalary (
    EmpID INT,
    Salary INT
);
INSERT INTO EmplSalary VALUES (1, 5000), (2, 7000), (3, 9000), (4, 6500), (5, 7500), (6, 7100);
SELECT EmpID, Salary
FROM (
    SELECT EmpID, Salary, RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM EmplSalary
) t
WHERE rnk <= 5;

-- Task 16

CREATE TABLE SwapTable (A INT, B INT);
INSERT INTO SwapTable VALUES (10, 20);
UPDATE SwapTable
SET A = A + B,
    B = A - B,
    A = A - B;
SELECT * FROM SwapTable;

-- Task 17

CREATE LOGIN testUser WITH PASSWORD = 'Test@123';
CREATE USER testUser FOR LOGIN testUser;
ALTER ROLE db_owner ADD MEMBER testUser;

-- Task 18
CREATE TABLE BU_Employees (
    BU VARCHAR(50),
    Month VARCHAR(10),
    Headcount INT,
    Salary INT
);
INSERT INTO BU_Employees VALUES
('IT', 'Jan', 10, 5000),
('IT', 'Feb', 20, 6000),
('HR', 'Jan', 5, 4000);
SELECT BU, Month,
SUM(Salary * Headcount) * 1.0 / SUM(Headcount) AS WeightedAvg
FROM BU_Employees
GROUP BY BU, Month;

-- Task 19
CREATE TABLE Employes (
    EmpID INT,
    Salary INT
);

INSERT INTO Employes VALUES
(1, 5000),
(2, 6000),
(3, 0),     
(4, 7000);
SELECT 
  ROUND(
 AVG(CAST(Salary AS FLOAT)) 
        - 
 (SELECT AVG(CAST(Salary AS FLOAT)) FROM Employes WHERE Salary > 0), 
        0
    ) AS MiscalculationDifference;

-- Task 20 

CREATE TABLE TargetData (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);
CREATE TABLE SourceData (
    ID INT,
    Name VARCHAR(50)
);
INSERT INTO TargetData VALUES (1, 'Alice'), (2, 'Bob');
INSERT INTO SourceData VALUES (2, 'Bob'), (3, 'Charlie'), (4, 'David');
INSERT INTO TargetData (ID, Name)
SELECT s.ID, s.Name
FROM SourceData s
LEFT JOIN TargetData t ON s.ID = t.ID
WHERE t.ID IS NULL;



