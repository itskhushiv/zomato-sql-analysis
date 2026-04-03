     -- ZOMATO SQL PROJECT

create database zomato;
use zomato;
DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup(
    userid INT,
    gold_signup_date DATE
); 

INSERT INTO goldusers_signup(userid, gold_signup_date) 
VALUES 
(1, '2017-09-22'),
(3, '2017-04-21');


DROP TABLE IF EXISTS users;
CREATE TABLE users(
    userid INT,
    signup_date DATE
); 

INSERT INTO users(userid, signup_date) 
VALUES 
(1, '2014-09-02'),
(2, '2015-01-15'),
(3, '2014-04-11');


DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
    userid INT,
    created_date DATE,
    product_id INT
); 

INSERT INTO sales(userid, created_date, product_id) 
VALUES 
(1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


DROP TABLE IF EXISTS product;
CREATE TABLE product(
    product_id INT,
    product_name TEXT,
    price INT
); 

INSERT INTO product(product_id, product_name, price) 
VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


-- Check data
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;


-- questions
-- Q1) what is total amount each customer spent on zomato
select userid,
sum(price) as total_amount_spent
from sales s
join product p
on s.product_id= p.product_id
 group by s.userid;
 
 
 -- Q2) how many days has each customer visited zomato?
 select userid, count(distinct created_date) as dinstict_days from sales group by userid;
 
 -- Q3) what was the first product purchased by each customer
 
 with first_purchase as  
 (SELECT userid, created_date, product_id,
 rank() over(partition by userid  order by created_date) as rnk
FROM sales)

select userid, created_date, product_id
from first_purchase
where rnk=1;

-- Q4) what is the most purchased item on the menu and how many times was it purchased by all customers?
-- with using rank

WITH most_purchased_item AS (
    SELECT product_id, COUNT(product_id) AS total_count,
	RANK() OVER (ORDER BY COUNT(product_id) DESC) AS rnk
    FROM sales
    GROUP BY product_id
)
SELECT product_id, total_count AS times_it_is_purchased
FROM most_purchased_item
WHERE rnk = 1;

-- code without using rank 
 SELECT 
    product_id,COUNT(product_id) AS total_purchases
FROM sales
GROUP BY product_id
ORDER BY total_purchases DESC
LIMIT 1;

-- Q5) which item was the most popular for each of the customer
with most_popular as (select  userid ,product_id,count(product_id) as purchased_times ,
RANK() OVER ( PARTITION BY userid ORDER BY COUNT(product_id) DESC ) AS rnk
from sales
GROUP BY userid ,product_id)
 
  select  userid ,product_id, purchased_times
  from most_popular
  where rnk=1;
  
  -- Q6) WHICH ITAM WAS PURCHASED FIRST BY THE CUSTOMER AFTER THEY BECOME A MEMEBER?
  with  first_purchased as 
  (select s.userid, s.created_date, s.product_id ,b.gold_signup_date, rank() over(partition by userid order by created_date) as rnk
  from sales s
  join goldusers_signup b
  on s.userid= b.userid
  and created_date>=gold_signup_date)
  
  select *
  from first_purchased
  where rnk=1;
  
  -- Q7) WHICH ITEM WAS PURCHASED JUST BEFORE THE CUSTOMER BECOME MEMBER?
  
 with  first_purchased as 
  (select s.userid, s.created_date, s.product_id ,b.gold_signup_date, rank() over(partition by userid order by created_date DESC) as rnk
  from sales s
  join goldusers_signup b
  on s.userid= b.userid
  and created_date<=gold_signup_date)
  
  select *
  from first_purchased
  where rnk=1;
  
  -- Q8) what is the total order and amount spent for each member before they become a member?
SELECT s.userid, COUNT(s.product_id) AS total_orders, SUM(p.price) AS total_amount
FROM sales s
JOIN product p 
    ON s.product_id = p.product_id
left JOIN goldusers_signup g 
    ON s.userid = g.userid
WHERE s.created_date < g.gold_signup_date
GROUP BY s.userid;
 -- Q9) WHAT IS THE TOTAL ORDER AND AMOUNT SPENT BY EACH AFTER THEY BECOME A MEMBER?
 SELECT 
    s.userid,
    COUNT(s.product_id) AS total_orders,
    SUM(p.price) AS total_amount
FROM sales s
JOIN product p 
    ON s.product_id = p.product_id
JOIN goldusers_signup g 
    ON s.userid = g.userid
WHERE s.created_date >=g.gold_signup_date
GROUP BY s.userid;
-- Q10) if buying each product  generrates points for eg- 5rs= 2 zomato points and each product has different purchasing points for eg-
-- for p1 5rs=1 zomato points, for p2 10rs= 5 zomato points and p3 5rs= 1 zomato point
-- calculate points collecetd by each cuxtomer and for which product most points have been given till now.

select userid, 
round(sum(case when s.product_id=1 then (p.price/5)
         when s.product_id=2 then ((p.price/10 )*5) 
         when s.product_id=3 then (p.price/5) 
         end),2) as total_points
from sales s
join product p
on s.product_id = p.product_id
group by userid
order by userid;
-- for each product
select s.product_id, 
sum(case when s.product_id=1 then p.price/5
         when s.product_id=2 then (p.price/10 )*5
         when s.product_id=3 then p.price/5
         end) as total_points
from sales s
join product p
on s.product_id = p.product_id
group by product_id
ORDER BY total_points DESC
LIMIT 1;
-- order by userid;

-- Q10) in the first one year after a customer joins the gold program (including their join date) irrespective of what the customer has purchased they earn 5 
-- zomato points for every 10 rs spent  who earned more 1 or 3 and what was their points in their first yr?
select s.userid,
round(sum((p.price/10) * 5),0) as total_points
from sales s
join product p
on s.product_id= p.product_id
join goldusers_signup g
on s.userid= g.userid
where s.created_date >= g.gold_signup_date
  AND s.created_date <= DATE_ADD(g.gold_signup_date, INTERVAL 1 YEAR)
group by s.userid
ORDER BY total_points DESC
limit 1;


-- Q11) rnk all the transaction of the customers 
select *, rank() over( partition by userid order by created_date) rnk from sales;


-- Q12) rank all the transaction for each member whenever they are a zomato gold member transction for every 
-- non gold member transction  mark as na











