Zomato SQL Data Analysis Project

Project Overview

This project focuses on analyzing customer behavior on a food delivery platform (Zomato) using SQL.
The goal is to extract meaningful insights related to customer spending, product popularity, and the impact of gold membership on purchasing patterns.

Dataset Description

The analysis is performed using the following tables:

users → Contains user signup information
goldusers_signup → Contains gold membership signup dates
sales → Contains transaction details (user, date, product)
product→ Contains product details and pricing

Business Problems Solved

The project answers key business questions such as:

What is the total amount spent by each customer?
How many days has each customer visited?
What is the first product purchased by each customer?
What is the most purchased item overall?
Which item is most popular for each customer?
What do customers purchase before and after becoming gold members?
How many points does each customer earn based on purchases?
Who earned the most points in the first year of gold membership?
SQL Concepts Used

This project demonstrates the use of:

JOIN operations
GROUP BY & Aggregate Functions
Window Functions (RANK())
CASE Statements
Date Functions (DATE_ADD)
Filtering and Conditional Logic
Key Insights

Certain products contribute significantly more to overall revenue
Customer spending behavior changes after joining the gold membership
Some users show higher engagement before becoming members
Loyal customers tend to make repeated purchases
Conclusion

This project highlights how SQL can be effectively used to analyze transactional data and derive actionable business insights.

Tools Used

MySQL
SQL (Structured Query Language)
GitHub
