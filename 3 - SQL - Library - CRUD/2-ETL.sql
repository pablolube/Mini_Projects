-- Library System Management SQL Project
-- Project TASK
-- ### 2. CRUD Operations


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
USE library;
INSERT INTO  books (isbn,book_title,category,rental_price,status,author,publisher) 
VALUES ( '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
UPDATE members 
SET member_address='9 July Main Avenue'
where member_id='C101';
select * from members;

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

delete from issued_status
where issued_id='IS104';
select * from issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT  b.* from books as b
INNER JOIN issued_status as i
on b.isbn=i.issued_book_isbn
where i.issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT concat(m.member_id,' - ',m.member_name) as Member ,COUNT(i.issued_book_isbn) as 'books not issued' from members m
INNER JOIN issued_status i
ON i.issued_member_id=m.member_id
GROUP BY (m.member_id)
HAVING COUNT(i.issued_book_isbn)>1
ORDER BY COUNT(i.issued_book_isbn) DESC;

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt

CREATE TABLE book_cnts
AS 
SELECT b.isbn,b.book_title ,count(i.issued_id) FROM books as b
INNER JOIN issued_status i
ON i.issued_book_isbn=b.isbn
GROUP BY  isbn
order by count(i.issued_id) desc;

SELECT * FROM
book_cnts;


-- ### 4. Data Analysis & Findings
-- Task 7. **Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category:
SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;


-- Task 9. **List Members Who Registered in the Last 180 Days**: 
--  For practical purposes, the last day in the reg_date field corresponds to the current day.
SELECT member_name 
FROM members 
WHERE datediff ( (SELECT max(reg_date) FROM members ), reg_date) <=180;
  
-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:
SELECT e.*, e2.emp_name as Manager_name from employees e 
INNER JOIN branch b
ON b.branch_id=e.branch_id
INNER JOIN employees e2
ON b.manager_id=e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE  books_toprental
as
SELECT * FROM BOOKS
WHERE rental_price>7;

SELECT * FROM 
books_toprental;



-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;


    

 -- ### Advanced SQL Operations

-- Task 13: Identify Members with Overdue Books-- Write a query to identify members who have overdue books (assume a 30-day return period).
-- Display the member's name, book title, issue date, and days overdue.

USE library;
-- Corrección: Asignación de la variable sin paréntesis innecesarios
SET @currentdate ='2024-05-1';

SELECT 
	i.issued_member_id,
    m.member_name,
    i.issued_book_name,
    i.issued_date,
    DATEDIFF(@currentdate,i.issued_date) AS Over_dues_days
FROM members m
INNER JOIN issued_status i
    ON i.issued_member_id = m.member_id
LEFT JOIN return_status rs
    ON i.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
AND DATEDIFF(@currentdate,i.issued_date) > 30; 





-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

UPDATE books b
set status='yes' 
WHERE  b.isbn in 
(select issued_book_isbn FROM issued_status i
inner JOIN return_status rs
ON i.issued_id = rs.issued_id
WHERE rs.return_id IS NOT NULL);
select*from books;


-- Store Procedure -- State change
DELIMITER $$

CREATE PROCEDURE add_return_records 
(p_return_id varchar(10), 
p_issued_id varchar(10)
)

BEGIN
DECLARE v_book_name VARCHAR(80); 
DECLARE v_book_isbn VARCHAR(50);

-- INSERTO EN TABLA DE DEVOLUCIONES 

INSERT INTO return_status(return_id,issued_id,return_date) 
VALUES (p_return_id,p_issued_id,current_date());

SELECT b.isbn,b.book_title  
INTO v_book_isbn,v_book_name
FROM BOOKS b
WHERE  b.isbn IN
(SELECT i.issued_book_isbn
FROM issued_status i
WHERE  i.issued_id=p_issued_id);

UPDATE BOOKS b
set status='yes' 
WHERE  b.isbn = v_book_isbn;

SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;

END $$

DELIMITER ;

CALL add_return_records('RS150', 'IS140');

SELECT * FROM issued_status;
SELECT * FROM books;


-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
CREATE TABLE branch_reports
AS

SELECT 
    b.branch_id AS "Branch Number",
    COUNT(ist.issued_book_isbn) AS "Total Issued",
    COUNT(rs.return_id) AS "Total Return",
    SUM(bk.rental_price) AS revenue
FROM branch b
JOIN employees e 
    ON e.branch_id = b.branch_id
JOIN issued_status ist 
    ON e.emp_id = ist.issued_emp_id
LEFT JOIN return_status rs 
    ON rs.issued_id = ist.issued_id
JOIN books bk 
    ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id;

SELECT * FROM branch_reports;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.
SET @currentdate ='2024-09-1';
CREATE TABLE Active_members 
AS
SELECT 
	m.*
FROM members m
INNER JOIN issued_status i
WHERE DATEDIFF(@currentdate,i.issued_date) <=180; 

SELECT * FROM Active_members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.


SELECT e.emp_name as 'Employee Name',  b.*, count(i.issued_book_isbn) as 'Books prcessed' FROM employees as e
inner join issued_status i
on i.issued_emp_id=e.emp_id
inner join branch b
on b.branch_id=e.branch_id
group by 1,2
order by count(i.issued_book_isbn) desc
limit 3;

-- Task 18: Stored Procedure
--    Objective: Create a stored procedure to manage the status of books in a library system.
--    Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
--    If a book is issued, the status should change to 'no'.
--    If a book is returned, the status should change to 'yes'.

DELIMITER $$

CREATE PROCEDURE issue_book
(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))

BEGIN
DECLARE v_book_status VARCHAR(3); 

-- INSERTO EN TABLA DE DEVOLUCIONES 

SELECT status into v_book_status from books
where isbn=p_issued_book_isbn;

IF v_book_status='Yes' then
   INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, current_date(), p_issued_book_isbn, p_issued_emp_id);
        
	UPDATE books
    set status='No'
    where isbn= p_issued_book_isbn;

SELECT 'Book records added successfully for book isbn : %', p_issued_book_isbn;
else

SELECT 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;

END IF;

END $$
DELIMITER ;


CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');
CALL add_return_records('RS150', 'IS140');



-- Task 19: Create Table As Select (CTAS)
-- Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines. */
/*
Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
*/

SET @currentdate ='2024-09-1';
-- Crear tabla de libros vencidos con multas
DROP TABLE IF EXISTS overdue_books;
CREATE TABLE overdue_books AS
SELECT 
    i.issued_member_id AS member_id,
    COUNT(i.issued_book_isbn) AS overdue_books,
    SUM(DATEDIFF(@currentdate, i.issued_date) - 30) * 0.50 AS total_fines
FROM issued_status i
LEFT JOIN return_status r 
    ON i.issued_book_isbn = r.return_book_isbn
WHERE DATEDIFF(@currentdate, i.issued_date) > 30 
    AND r.return_book_isbn IS NULL -- Asegura que el libro aún no se devolvió
GROUP BY i.issued_member_id;

SELECT * FROM overdue_books;
