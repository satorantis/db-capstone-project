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














