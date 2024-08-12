-- create database sql_advanced_queries;
-- use sql_advanced_queries;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_name, email, city, join_date) VALUES
('John Doe', 'john@example.com', 'New York', '2020-01-15'),
('Jane Smith', 'jane@example.com', 'Los Angeles', '2021-03-22'),
('Alice Johnson', 'alice@example.com', 'Chicago', '2019-07-08'),
('Bob Brown', 'bob@example.com', 'Houston', '2020-11-30'),
('Eve Davis', 'eve@example.com', 'San Francisco', '2022-02-20'),
('Joao Victor', 'joao@example.com', 'San Francisco', '2020-02-20');

INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 1200.00, 50),
('Smartphone', 'Electronics', 800.00, 100),
('Tablet', 'Electronics', 600.00, 80),
('Headphones', 'Accessories', 150.00, 200),
('Keyboard', 'Accessories', 100.00, 150);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2022-03-01', 1300.00),
(2, '2022-03-15', 950.00),
(3, '2022-04-10', 750.00),
(4, '2022-04-20', 1500.00),
(5, '2022-05-05', 1700.00);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),
(1, 4, 2, 150.00),
(2, 2, 1, 800.00),
(2, 5, 1, 100.00),
(3, 3, 1, 600.00),
(3, 4, 1, 150.00),
(4, 1, 1, 1200.00),
(4, 5, 3, 100.00),
(5, 1, 1, 1200.00),
(5, 2, 1, 800.00);

INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Excellent laptop!', '2022-03-05'),
(2, 2, 4, 'Very good smartphone.', '2022-03-18'),
(3, 3, 3, 'Average tablet.', '2022-04-12'),
(4, 4, 2, 'Not worth the price.', '2022-04-25'),
(5, 5, 4, 'Great keyboard!', '2022-05-07'),
(2, 5, 4, 'Great smartphone', '2022-05-07'),
(2, 3, 2, 'Not worth', '2022-05-07'),
(2, 1, 3, 'Average smartphone', '2022-05-07');

-- Primeira Questao: Encontrar a media de avaliacao de cada produto
select p.product_name, round(avg(r.rating), 2) as average_rating from reviews r
join products p on p.product_id = r.product_id
group by p.product_name;

-- Segunda Questao: Listar os clientes que fizeram pedidos em março de 2022 e o valor total gasto
select * from orders;

select c.customer_name, month(o.order_date), year(o.order_date) from orders o
left join customers c on c.customer_id = o.customer_id
where o.order_date in (select order_date from orders 
					   where month(order_date) = 3 and year(order_date) = 2022);

-- Terceira Questao: Encontrar os produtos mais vendidos (quantidade total) em abril de 2022
select oi.product_id, p.product_name, sum(oi.quantity) as total_quantity, o.order_date from order_items oi
left join products p on oi.product_id = p.product_id
left join orders o on oi.order_id = o.order_id
where month(o.order_date) = 4 and year(o.order_date) = 2022
group by oi.product_id, p.product_name, o.order_date
order by total_quantity desc;

-- Quarta Questao: Identificar clientes que não fizeram nenhum pedido em 2022
select c.customer_id, c.customer_name, sum(o.total_amount) as total_amount from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name having sum(o.total_amount) is null or sum(o.total_amount) = 0;

select * from orders;
select * from customers;

-- Quinta Questao: Calcular a receita total por categoria de produto
select * from products;
select * from order_items;

select p.category, sum(oi.quantity * oi.price) as total_revenue from order_items oi
join products p on oi.product_id = p.product_id
group by p.category;

-- Sexta Questao: Encontrar os clientes que fizeram mais de um pedido e a quantidade de pedidos que fizeram
select o.customer_id, c.customer_name, count(o.customer_id) as number_orders from orders o
join customers c on c.customer_id = o.customer_id
group by o.customer_id, c.customer_name
order by number_orders desc;

-- Setima Questao: Listar os produtos que receberam mais de 3 avaliações
-- refazer
select r.product_id, p.product_name, count(r.product_id) as number_reviews from reviews r
left join products p on r.product_id = p.product_id
group by r.product_id having number_reviews > 3;

-- Oitava Questao: Encontrar o produto com a maior receita total
select oi.product_id, p.product_name, sum(oi.quantity * oi.price) as total_revenue from order_items oi
join products p on p.product_id = oi.product_id
group by oi.product_id 
order by total_revenue desc limit 1; 

-- Nona Questao: Identificar o cliente com o maior gasto total e o valor gasto
select o.customer_id, c.customer_name, sum(o.total_amount) as total_expenditure from orders o
left join customers c on c.customer_id = o.customer_id
group by o.customer_id, c.customer_name
order by total_expenditure desc limit 1; 

-- Decima Questao: Listar os produtos que estão fora de estoque (stock = 0)
select p.product_name, p.stock from products p
where p.stock = 0 or p.stock is null;

select * from products;

