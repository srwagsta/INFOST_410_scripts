USE wagstaff_INFOST_410;

/** List the book code and book title for each book. **/
SELECT BookCode, Title
FROM Book;

/** List complete Publisher table **/
SELECT *
FROM Publisher;

/** List the name for each publisher in Boston **/
SELECT PublisherName
FROM Publisher
WHERE City LIKE '%Boston%';

/** List the name of each publisher not located in Boston **/
SELECT PublisherName
FROM Publisher
WHERE City NOT LIKE '%Boston%';

/** List the book code and book title of each title that has type SFI **/
SELECT BookCode, Title
FROM Book
WHERE Type = 'SFI';

/** List the book code and book title of each title that has type SFI and is in paperback **/
SELECT BookCode, Title
FROM Book
WHERE Type = 'SFI'
AND Paperback = 'Y';

/** List book code and book title of each book that has the type SFI or is published by the
publisher with the publisher code SC **/
SELECT BookCode, Title
FROM Book
WHERE Type = 'SFI'
OR PublisherCode = 'SC';

/** List the book code, book title, and price of each book with a price between $20 and $30 **/
SELECT DISTINCT Book.BookCode, Book.Title, Copy.Price
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Copy.Price > 20
AND Copy.Price < 30;

/** List the book code, and book title of each book that has the type MYS and a price of less than $20 **/
SELECT DISTINCT Book.BookCode, Book.Title
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Copy.Price < 20
AND Book.Type = 'MYS';

/** Customers who are part of a special program get 10% discount off regular prices. List the book code, book title,
and discounted price of each book. Use Discounted_Price as the name for the computed column, which should calculate 90%
of the current prices (100% less than 10% discount). **/
SELECT DISTINCT Book.BookCode, Book.Title, .90 * Copy.Price AS 'Discounted_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
ORDER BY Book.Title, 'Discounted_Price';

/** Find the name of each publisher containing the word “and”. Be sure that your query selects only those publishers
that contain the word “and” and not those that contain letters “and” in the middle of a word. i.e your query
should select the publisher named “Farrar Straus and Giroux”, but should not select the publisher named “Random House” **/
SELECT PublisherName
FROM Publisher
WHERE PublisherName LIKE '% and %';

/** List the book code, book type, and book title of each book that has type SFI, MYS or ART. Use the IN operator in
your command. **/
SELECT BookCode, Type, Title
FROM Book
WHERE Type IN ('SFI', 'MYS', 'ART');

/** List the book code, book type, and book title of each book that has type SFI, MYS or ART.
Use the IN operator in your command. Order books in alphabetical order by title. **/
SELECT BookCode, Type, Title
FROM Book
WHERE Type IN ('SFI', 'MYS', 'ART')
ORDER BY Title;

/** List the book code, book type, and book title of each book that has type SFI, MYS or ART. Use the IN operator in
your command, and list the books in ascending order by price and then by title within the same price. **/
SELECT Book.BookCode, Type, Title
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Type IN ('SFI', 'MYS', 'ART')
ORDER BY Copy.Price, Title;

/** Display the list of book types in the database. List each book type only once. **/
SELECT DISTINCT Type
FROM Book;

/** How many book have the type SFI? **/
SELECT COUNT(BookCode) AS SFI_Count
FROM Book
WHERE Type = 'SFI';

/** For each type of the book, list the type and the average price **/
SELECT Book.Type, AVG(Copy.Price) AS 'Average_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
GROUP BY Book.Type;

/** For each type of the book, list the type and the average price, but consider only paperbacks. **/
SELECT Book.Type, AVG(Copy.Price) AS 'Average_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Book.Paperback = 'Y'
GROUP BY Book.Type;

/** For each type of the book, list the type and the average price, but consider only paperback books for those
types for which the average price is more than $10
(Note: My understanding of this question is to show the average for only paperback book if the overall average is
greater than 10 else show the overall average) **/
SELECT T1.Type, T1.Average_Price AS 'Average_Price'
FROM
(SELECT Book.Type, AVG(Copy.Price)  AS 'Average_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
GROUP BY Book.Type HAVING Average_Price < 10) AS T1
LEFT JOIN
(SELECT Book.Type, AVG(Copy.Price)  AS 'Average_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Book.Paperback = 'Y'
GROUP BY Book.Type) AS T2
ON T1.Type = T2.Type
UNION
SELECT T1.Type, T1.Average_Price AS 'Average_Price'
FROM
(SELECT Book.Type, AVG(Copy.Price)  AS 'Average_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Book.Paperback = 'Y'
GROUP BY Book.Type ) AS T1
LEFT JOIN
(SELECT Book.Type, AVG(Copy.Price)  AS 'Average_Price'
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
GROUP BY Book.Type HAVING Average_Price < 10) AS T2
ON T1.Type = T2.Type;

/** What is the most expensive book in the database? **/
SELECT DISTINCT Book.BookCode, Book.Title, Copy.Price
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Copy.Price = (SELECT MAX(Copy.Price)
                    FROM Copy);

/** What are the title(s) and price(s) of the least expensive books in the database? **/
SELECT DISTINCT Book.BookCode, Book.Title, Copy.Price
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Copy.Price = (SELECT MIN(Copy.Price)
                    FROM Copy);

/** List the name of each publisher that’s located in New York **/
SELECT PublisherName
FROM Publisher
WHERE City LIKE '%New York%';

/** List the name of each publisher that’s not located in New York **/
SELECT PublisherName
FROM Publisher
WHERE City NOT LIKE '%New York%';

/** List the title of each book published by Penguin USA **/
SELECT Book.Title
FROM Book
JOIN Publisher
ON Book.PublisherCode = Publisher.PublisherCode
WHERE Publisher.PublisherName = 'Penguin USA';

/** List the title of each book that has the type MYS **/
SELECT Book.Title
FROM Book
WHERE Type = 'MYS';

/** List the title of each book that has the type SFI and is in paperback **/
SELECT Book.Title
FROM Book
WHERE Type = 'SFI'
AND Paperback = 'Y';

/** List the title of each book that has the type PSY or whose publisher code is JP **/
SELECT Book.Title
FROM Book
WHERE Type = 'PSY'
AND PublisherCode = 'JP';

/** List the title of each book that has the type, CMP, HIS, or SCI **/
SELECT Book.Title
FROM Book
WHERE Book.Type IN ('CMP', 'HIS', 'SCI');

/** How many books have a publisher code of ST or VB? **/
SELECT COUNT(BookCode) AS 'Book_Count'
FROM Book
WHERE PublisherCode IN ('ST', 'VB');

/** List the title of each book written by Dick Francis **/
SELECT Book.Title
FROM Book
JOIN Wrote
ON Book.BookCode = Wrote.BookCode
Join Author
ON Wrote.AuthorNum = Author.AuthorNum
WHERE Author.AuthorFirst LIKE 'Dick'
AND Author.AuthorLast LIKE 'Francis';

/** List the title of each book that has the type FIC and that was written by John Steinbeck **/
SELECT Book.Title
FROM Book
JOIN Wrote
ON Book.BookCode = Wrote.BookCode
Join Author
ON Wrote.AuthorNum = Author.AuthorNum
WHERE Book.Type = 'FIC'
AND Author.AuthorFirst LIKE 'John'
AND Author.AuthorLast LIKE 'Steinbeck';

/** For each book list the title, publisher code, type, and author names. Order by title. **/
SELECT Book.Title, Book.PublisherCode, Book.Type, CONCAT(Author.AuthorFirst, ' ', Author.AuthorLast) AS 'Author'
FROM Book
JOIN Wrote
ON Book.BookCode = Wrote.BookCode
Join Author
ON Wrote.AuthorNum = Author.AuthorNum
ORDER BY Book.Title;

/** How many book copies have a price that is greater than $20 but less than $25? **/
SELECT COUNT(BookCode) AS 'Copy_Count'
FROM Copy
WHERE Price > 20
AND Price < 25;

/** List the branch number, copy number, quality, and price for each copy of ‘The Stranger’ **/
SELECT Copy.BranchNum, Copy.CopyNum, Copy.Quality, Copy.Price
FROM Copy
JOIN Book
ON Copy.BookCode = Book.BookCode
WHERE Book.Title LIKE 'The Stranger';

/** List branch number, copy number, quality, and price for each copy of ‘Electric Light’ **/
SELECT Copy.BranchNum, Copy.CopyNum, Copy.Quality, Copy.Price
FROM Copy
JOIN Book
ON Copy.BookCode = Book.BookCode
WHERE Book.Title LIKE 'Electric Light';

/** For each book copy with a price greater than $25, list Title, quality and price **/
SELECT Book.Title, Copy.Quality, Copy.Price
FROM Copy
JOIN Book
ON Copy.BookCode = Book.BookCode
WHERE Copy.Price > 25;

/** For each book copy available at the Feisty on the Hill branch where quality is excellent. Order by Title.
Include Title, Author First and Last Name, BranchName, and quality **/
SELECT Book.Title, Author.AuthorFirst, Author.AuthorLast, Branch.BranchName, Copy.Quality
FROM Copy
JOIN Book
ON Copy.BookCode = Book.BookCode
JOIN Wrote
ON Book.BookCode = Wrote.BookCode
Join Author
ON Wrote.AuthorNum = Author.AuthorNum
Join Branch
ON Copy.BranchNum = Branch.BranchNum
WHERE Branch.BranchName LIKE 'Feisty on the Hill'
AND Copy.Quality LIKE 'Excellent'
ORDER BY Book.Title;


/** Create a new table named FictionCopies using the data in the BookCode, Title, BranchNum, CopyNum, Quality, and Price
 for those books that have type FIC **/
CREATE TABLE FictionCopies
AS
SELECT Book.BookCode, Book.Title, Copy.BranchNum, Copy.CopyNum, Copy.Quality, Copy.Price
FROM Book
JOIN Copy
ON Book.BookCode = Copy.BookCode
WHERE Book.Type = 'FIC';

/** FiestyBooks considering increasing the priced of all copies of fiction books whose quality is excellent by 10% .
To determine the new prices, list the book code, title, and increased price of every book in FictionCopies table.
Your computed column should determine 110% of the current price, which is 100% plus a 10% increase. (Hint: Price*1.1) **/
SELECT FictionCopies.BookCode, FictionCopies.Title, (FictionCopies.Price * 1.1) AS 'Increased_Price'
FROM FictionCopies
WHERE FictionCopies.Quality LIKE 'Excellent';

/** Use an update query to change price of each book in the FictionCopies table with the current
price of $14.00 to $14.25. Use Select * query to show the result of the query. **/
UPDATE FictionCopies
SET FictionCopies.Price = 14.25
WHERE FictionCopies.Price = 14;

/** Show Output. **/
SELECT *
FROM FictionCopies;

/** Use a delete query to delete all books in the FictionCopies table whose quality is poor. **/
DELETE
FROM FictionCopies
WHERE Quality LIKE 'Poor';

/** Show Output. **/
SELECT *
FROM FictionCopies;

/** Write and execute the CREATE VIEW command to create PenguinBooks view. It consists of the book code, book title,
bok type, and book price for every book published by Penguin USA. Display the data in the view
(Run select * from PenguinBooks). **/
CREATE VIEW PenguinBooks AS
SELECT Book.BookCode, Book.Title, Book.Type, Copy.Price
FROM Copy
JOIN Book
ON Copy.BookCode = Book.BookCode
JOIN Publisher
ON Book.PublisherCode = Publisher.PublisherCode
WHERE Publisher.PublisherName LIKE 'Penguin USA';

/** Show Output. **/
SELECT * FROM PenguinBooks;

/** Create a view named Paperback. It consists of the book code, book title, publisher name, branch number,
copy number, and price for every book copy that is available in paperback. Display the data in the view **/
CREATE VIEW PaperBack AS
SELECT Book.BookCode, Book.Title, Publisher.PublisherName, Copy.BranchNum, Copy.CopyNum, Copy.Price
FROM Copy
JOIN Book
ON Copy.BookCode = Book.BookCode
JOIN Publisher
ON Book.PublisherCode = Publisher.PublisherCode
WHERE Book.Paperback = 'Y';

/** Show Output. **/
SELECT * FROM PaperBack;

/** Create a view named BookAuthor. It consists of the book code, book title, book type, author number,
first name, last name, and sequence number for each book. Display the data in the view. **/
CREATE VIEW BookAuthor AS
SELECT Book.BookCode, Book.Title, Book.Type, Author.AuthorNum, Author.AuthorFirst, Author.AuthorLast,
(ROW_NUMBER() OVER (ORDER BY Book.BookCode ASC)) AS Sequence_Num
FROM Book
JOIN Wrote
ON Book.BookCode = Wrote.BookCode
JOIN Author
ON Wrote.AuthorNum = Author.AuthorNum;

/** Show Output. **/
SELECT * FROM BookAuthor;

/** Create an index named BookIndex1 on the PublisherName field in the Publisher table **/
CREATE INDEX BookIndex1
ON Publisher (PublisherName);

/** Show Output. **/
SHOW INDEX FROM Publisher;

/** Create an index named BookIndex2 on the Type field in the Book table **/
CREATE INDEX BookIndex2
ON Book (Type);

/** Show Output. **/
SHOW INDEX FROM Book;

/** Create an Index named BookIndex3 on the BookCode and Type fields in the Book table and list the book
code in descending order **/
CREATE INDEX BookIndex3
ON Book (BookCode, Type);

/** Show Output. **/
SELECT BookCode FROM Book ORDER BY BookCode DESC;

/** Add to the Book table a new character field named Classic that is one character in length. **/
ALTER TABLE Book
ADD COLUMN Classic CHAR(1);

/** Show Output. **/
SHOW COLUMNS FROM Book;

/** Change the Classic field in the Book table to Y for the Book title ‘The Grapes of Wrath’ **/
UPDATE Book
SET Classic = 'Y'
WHERE Title = 'The Grapes of Wrath';

/** Show Output. **/
SELECT * FROM Book WHERE Title = 'The Grapes of Wrath';

/** Change the length of the Title field in the Book table to 60. Show working SQL statement. **/
ALTER TABLE Book
MODIFY COLUMN Title CHAR(60);

/** Show Output. **/
SHOW COLUMNS FROM Book;
