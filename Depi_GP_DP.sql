-- HABIBA
/*Customers*/
-- 1-Add a new customer
INSERT INTO customers (first_name, last_name, email_address, city, country_region)
VALUES ('John','Smith','john@acme.com','New York','USA');
SELECT * FROM customers WHERE email_address='john@acme.com';

-- 2-Read all customers from a specific country
SELECT id, first_name, last_name, company,country_region
FROM customers
WHERE country_region = 'USA';

-- 3-Update customer city
UPDATE customers SET city='Los Angeles' WHERE id=1;
SELECT city FROM customers WHERE id=1;

-- 4-Delete a customer who has no orders
DELETE FROM customers WHERE id=30;
SELECT * FROM customers WHERE id=30;

-- 5-Delete a customer who has orders (FK check)
DELETE FROM customers WHERE id=1;

-- 6-Add customer with missing name fields
INSERT INTO customers (company, email_address)
VALUES ('Acme Corp', 'info@acme.com');

/*Inventory*/
-- 1-Record a stock received transaction
INSERT INTO inventory_transactions
  (transaction_type, transaction_created_date, product_id, quantity, purchase_order_id)
VALUES (1, NOW(), 1, 50, 90);
SELECT * FROM inventory_transactions ORDER BY id DESC LIMIT 1;


-- 2-Calculate total stock for a product
SELECT product_id, SUM(quantity) AS total_stock
FROM inventory_transactions
WHERE product_id=1
GROUP BY product_id;


/*Integration (TC-46, TC-47)*/
-- 1-Find orphaned order details (data integrity check)
SELECT od.id, od.order_id
FROM order_details od
LEFT JOIN orders o ON od.order_id=o.id
WHERE o.id IS NULL;

-- 2-Top customers by order value
SELECT c.first_name, c.last_name,
  SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_value
FROM customers c
JOIN orders o ON c.id=o.customer_id
JOIN order_details od ON o.id=od.order_id
GROUP BY c.id
ORDER BY total_value DESC
LIMIT 5;




/*PERRYHAN*/
/*Products & Suppliers*/
Insert into northwind.products (product_code, product_name, standard_cost, list_price, discontinued) values("NWTC-93", "Northwind Widget A",10.00,25.00,0);
Update northwind.products set list_price = 30.00 where id = 5;
Update northwind.products set discontinued = 1 where id = 1;
Insert into northwind.products (product_name, standard_cost, list_price) values ("BadWidget", 50.00, 10.00);
SELECT * FROM northwind.products;
insert into northwind.suppliers (company, first_name, last_name, email_address, city) values ('SupplyCo', 'BOB', 'Brown','bob@supply.com', 'Chicago');
SELECT * FROM northwind.suppliers;

/*Purchase Order*/
insert into northwind.purchase_orders (supplier_id, created_by, creation_date,status_id) values (1,1,Now(),1);
insert into northwind.purchase_orders (supplier_id, created_by,status_id) values (9999,1,1);
Update northwind.purchase_orders set approved_by = 2, approved_date = Now() where id = 149;
SELECT * FROM northwind.purchase_orders;
Insert into northwind.purchase_order_details  (purchase_order_id,product_id,quantity, unit_cost) values (90,1,100,8.50);
SELECT * FROM northwind.purchase_order_details;


/*NERMEEN*/

/*Invoices*/
-- 1-Create an invoice for an order
INSERT INTO invoices (order_id, invoice_date, due_date, tax, shipping, amount_due)
VALUES (56, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 10.00, 5.00, 115.00);
SELECT * FROM invoices WHERE order_id=56;

-- 2-Create invoice with invalid order (FK check)
INSERT INTO invoices (order_id, invoice_date, amount_due)
VALUES (9999, NOW(), 100.00);

-- 3-View overdue invoices
SELECT id, order_id, due_date, amount_due
FROM invoices
WHERE due_date > NOW()
ORDER BY due_date;

-- 4-Check negative amount_due is not allowed
INSERT INTO invoices (order_id, invoice_date, amount_due)
VALUES (56, NOW(), -50.00);


/*Order Details*/
-- 1-Add an order detail line
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount)
VALUES (60, 1, 5, 25.00, 0.10);
SELECT * FROM order_details WHERE order_id=60 AND product_id=1;

-- 2-Add order detail with invalid order_id (FK check)
INSERT INTO order_details (order_id, product_id, quantity, unit_price)
VALUES (9999, 1, 1, 10.00);

-- 3-Calculate line total (quantity × price × discount)
SELECT id, quantity, unit_price, discount,
  (quantity * unit_price * (1 - discount)) AS line_total
FROM order_details WHERE id=60;

-- 4-Update quantity on an order detail
UPDATE order_details SET quantity=15 WHERE id=27;
SELECT quantity FROM order_details WHERE id=27;

-- 5-Check discount cannot exceed 100%
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount)
VALUES (36, 1, 1, 10.00, 1.5);


/*AYA*/

/*Shippers*/
-- 1-Add a new shipper
INSERT INTO shippers (company, first_name, last_name, email_address, business_phone)
VALUES ('FastShip', 'Tom', 'Davis', 'tom@fastship.com', '555-1234');
SELECT * FROM shippers WHERE email_address='tom@fastship.com';

-- 2-Delete shipper used by orders (FK check)
DELETE FROM shippers WHERE id=1;

-- 3-Update shipper phone number
UPDATE shippers SET business_phone='555-9999' WHERE id=2;
SELECT business_phone FROM shippers WHERE id=2;

/*Orders*/
-- 1-Create a new order
INSERT INTO orders (employee_id, customer_id, order_date, shipper_id, status_id)
VALUES (1, 1, NOW(), 1, 1);
SELECT * FROM orders ORDER BY id DESC LIMIT 1;

-- 2-Create order with non-existent customer (FK check)
INSERT INTO orders (employee_id, customer_id, order_date)
VALUES (1, 9999, NOW());

-- 3-Update order status to Shipped
UPDATE orders SET status_id=2 WHERE id=3;
SELECT o.id, os.status_name
FROM orders o
JOIN orders_status os ON o.status_id=os.id
WHERE o.id=3;

-- 4-Set shipped date on an order
UPDATE orders SET shipped_date=NOW() WHERE id=30;
SELECT shipped_date FROM orders WHERE id=30;

-- 5-Delete an order that has order details (FK check)
DELETE FROM orders WHERE id=5;

-- 6-Filter orders by date range
SELECT id, order_date, customer_id
FROM orders
WHERE order_date BETWEEN '2006-01-15' AND '2006-04-14'
ORDER BY order_date;

/*OMAR*/

-- /*Employees & Privileges*/

-- 1-Add a new employee
INSERT INTO employees (first_name, last_name, email_address, job_title)
VALUES ('Alice','Johnson','alice@nw.com','Sales Rep');
SELECT * FROM employees WHERE email_address='alice@nw.com';

-- 2-Assign a privilege to an employee
INSERT INTO employee_privileges (employee_id, privilege_id) VALUES (3, 2);
SELECT * FROM employee_privileges WHERE employee_id=3;

-- 3-Assign a privilege that does not exist (FK check)
INSERT INTO employee_privileges (employee_id, privilege_id) VALUES (1, 999);

-- 4-View employees with their privilege names 
SELECT e.first_name, e.last_name, p.privilege_name
FROM employees e
JOIN employee_privileges ep ON e.id = ep.employee_id
JOIN privileges p ON ep.privilege_id = p.id;

-- /*Lookup Tables*/
-- 1-Add a new order status
INSERT INTO orders_status (id,status_name) VALUES (5,'Awaiting Pickup');
SELECT * FROM orders_status WHERE status_name='Awaiting Pickup';
-- 2-Check all orders have a valid status
SELECT o.id, o.status_id
FROM orders o
LEFT JOIN orders_status os ON o.status_id=os.id
WHERE os.status_name IS NULL;

-- 3-Delete a status that is in use (FK check)
DELETE FROM orders_status WHERE id=5;

-- /*integration*/
-- 1-Full order flow: order → detail → invoice
INSERT INTO orders (employee_id,customer_id,order_date,shipper_id,status_id)
VALUES (2,1,NOW(),2,1);
SET @oid=LAST_INSERT_ID();
INSERT INTO order_details (order_id,product_id,quantity,unit_price)
VALUES (@oid,1,5,20.00);
INSERT INTO invoices (order_id,invoice_date,due_date,amount_due)
VALUES (@oid,NOW(),DATE_ADD(NOW(),INTERVAL 30 DAY),100.00);
SELECT o.id, od.product_id, i.amount_due
FROM orders o
JOIN order_details od ON o.id=od.order_id
JOIN invoices i ON o.id=i.order_id
WHERE o.id=@oid;

-- 2-Full purchase flow: PO → detail → inventory
INSERT INTO purchase_orders (supplier_id,created_by,creation_date,status_id)
VALUES (1,1,NOW(),1);
SET @po=LAST_INSERT_ID();
INSERT INTO purchase_order_details (purchase_order_id,product_id,quantity,unit_cost)
VALUES (@po,1,100,8.50);
INSERT INTO inventory_transactions (transaction_type,product_id,quantity,purchase_order_id)
VALUES (1,1,100,@po);
SELECT pod.quantity, it.quantity AS inv_qty
FROM purchase_order_details pod
JOIN inventory_transactions it ON pod.purchase_order_id=it.purchase_order_id
WHERE pod.purchase_order_id=@po;

