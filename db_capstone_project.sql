#using little lemon database
use LittleLemonDM;

#creating view
CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost FROM Orders
WHERE Quantity > 2;

# retrieving infomation from different tables using join
SELECT Customers.CustomerID, CONCAT(Customers.FirstName, ' ', Customers.LastName) AS FullName, 
Orders.OrderID, Orders.TotalCost, Menu.MenuName
FROM Orders INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Menu ON Orders.MenuID = Menu.MenuID;

# using subquery
SELECT MenuName FROM Menu WHERE 2 < ANY (SELECT Quantity FROM Orders);

# creating and using stored procedure
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
SELECT MAX(Quantity) AS 'Max quatity in order' FROM Orders;
END //
DELIMITER ;
CALL GetMaxQuantity();

# creating and using prepared statement
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

# creating and calling stored procedure with in parameter
DELIMITER //
CREATE PROCEDURE CancelOrder(IN order_id int)
BEGIN
DELETE FROM OrderDeliveryStatus WHERE OrderID = order_id;
DELETE FROM Orders WHERE OrderID = order_id;
SELECT CONCAT('Order ', order_id, ' is cancelled') AS Confirmation;
END //
DELIMITER ;

CALL CancelOrder(5);

#populating Bookings table with data
INSERT INTO Bookings (BookingID, BookingDate, TableNo, CustomerID)
VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

#creating stored procedure to check whether table is already booked
DELIMITER //
CREATE PROCEDURE CheckBooking(IN booking_date DATE, IN table_number INT)
BEGIN
DECLARE booking_count INT;
SELECT COUNT(*) INTO booking_count 
FROM Bookings
WHERE BookingDate = booking_date AND TableNo = table_number;
IF booking_count = 0 THEN
SELECT CONCAT('Table ', table_number, ' could be booked') AS 'Booking Status';
ELSE
SELECT CONCAT('Table ', table_number, ' is already booked') AS 'Booking Status';
END IF;
END //
DELIMITER ;

CALL CheckBooking('2022-11-12', 3);

#creating stored procedure to add booking if it is possible
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN booking_date DATE, IN table_number INT)
BEGIN
DECLARE booking_count INT;
START TRANSACTION;
SELECT COUNT(*) INTO booking_count 
FROM Bookings
WHERE BookingDate = booking_date AND TableNo = table_number;
IF booking_count = 0 THEN
INSERT INTO Bookings (BookingDate, TableNo)
VALUES
(booking_date, table_number);
SELECT 'Booking was succesful' AS 'Booking Status';
COMMIT;
ELSE
SELECT CONCAT('Table ', table_number, ' is already booked. Booking cancelled') AS 'Booking Status';
ROLLBACK;
END IF;
END //
DELIMITER ;

CALL AddValidBooking('2022-12-17', 6);

#creating stored procedure to add booking
DELIMITER //
CREATE PROCEDURE AddBooking(IN b_id INT, IN cus_id INT, IN booking_date DATE, IN table_number INT)
BEGIN
INSERT INTO Bookings (BookingID, BookingDate, TableNo, CustomerID)
VALUES
(b_id, booking_date, table_number, cus_id);
SELECT 'New booking added' AS 'Confirmation';
END //
DELIMITER ;

CALL AddBooking(9, 3, '2022-12-30', 4);

#creating stored procedure to update booking
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN b_id INT, IN booking_date DATE)
BEGIN
UPDATE Bookings
SET BookingDate = booking_date
WHERE BookingID = b_id;
SELECT CONCAT('Booking ', b_id, 'was updated') AS 'Confirmation';
END //
DELIMITER ;

CALL UpdateBooking(9, '2022-12-17');

#creating stored procedure to cancel booking
DELIMITER //
CREATE PROCEDURE CancelBooking(IN b_id INT)
BEGIN
DELETE FROM Bookings
WHERE BookingID = b_id;
SELECT CONCAT('Booking ', b_id, ' is cancelled') AS 'Confirmation';
END //
DELIMITER ;

CALL CancelBooking(9);





