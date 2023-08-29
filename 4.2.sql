CREATE TABLE IF NOT EXISTS products (
   id SERIAL PRIMARY KEY,
   title VARCHAR (100),
   price DECIMAL
)
DISTRIBUTED BY (id);

INSERT INTO products (id, title, price) 
VALUES (1, 'Huawei', 76390),
       (2, 'Asus', 84590),
       (3, 'Lenovo', 69990),
       (4, 'Dell', 71490),
       (5, 'Samsung', 89990);


CREATE TABLE IF NOT EXISTS sales (
   sales_id SERIAL,
   product_id INTEGER,
   sales_date DATE,
   cnt INTEGER,
   FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL
)
DISTRIBUTED BY (sales_id)
PARTITION BY RANGE (sales_date)
(
START (DATE '2023-07-01') INCLUSIVE 
END (DATE '2023-08-01') EXCLUSIVE
EVERY (INTERVAL '1 week')
);

INSERT INTO sales (sales_id, product_id, sales_date, cnt) 
VALUES (1, 4, '2023-07-01', 1),
       (2, 3, '2023-07-01', 1),
       (3, 1, '2023-07-02', 2),
       (4, 5, '2023-07-04', 1),
       (5, 4, '2023-07-06', 2),
       (6, 5, '2023-07-09', 2),
       (7, 1, '2023-07-11', 1),
       (8, 3, '2023-07-15', 1),
       (9, 2, '2023-07-15', 1),
       (10, 2, '2023-07-18', 1),
       (11, 5, '2023-07-19', 2),
       (12, 1, '2023-07-23', 1),
       (13, 2, '2023-07-27', 1),
       (14, 3, '2023-07-30', 2),
       (15, 4, '2023-07-30', 1);

SET optimizer = ON;

EXPLAIN
SELECT SUM (p.price * s.cnt) AS sum_sales
FROM sales AS s JOIN products AS p ON s.product_id = p.id
WHERE p.id = 1 AND s.sales_date BETWEEN '2023-07-01' AND '2023-07-31'
GROUP BY p.name;