---
title: "Lab 10 - SQL"
output: tufte::tufte_html
link-citations: yes
date: November 5, 2021
---

# Setup






```r
# install.packages(c("RSQLite", "DBI"))

library(RSQLite)
library(DBI)

# Initialize a temporary in memory database
con <- dbConnect(SQLite(), ":memory:")

# Download tables
actor <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/actor.csv")
rental <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/rental.csv")
customer <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/customer.csv")
payment <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/payment_p2007_01.csv")

# Copy data.frames to database
dbWriteTable(con, "actor", actor)
dbWriteTable(con, "rental", rental)
dbWriteTable(con, "customer", customer)
dbWriteTable(con, "payment", payment)
```


```r
dbListTables(con)
```

TIP: You can use the following QUERY to see the structure of a table


```sql
PRAGMA table_info(actor)
```

SQL references:

https://www.w3schools.com/sql/

# Exercise 1

Edit the code below to retrieve the actor ID, first name and last name for all actors using the `actor` table. Sort by last name and then by first name (note that the code chunk below is set up to run SQL code rather than R code).


```sql
SELECT
FROM
ORDER by
```

# Exercise 2

Retrieve the actor ID, first name, and last name for actors whose last name equals 'WILLIAMS' or 'DAVIS'.


```sql
SELECT 
FROM 
WHERE ___ IN ('WILLIAMS', 'DAVIS')
```

# Exercise 3

Write a query against the `rental` table that returns the IDs of the customers who rented a film on July 5, 2005 (use the rental.rental_date column, and you can use the `date()` function to ignore the time component). Include a single row for each distinct customer ID. 


```sql
SELECT DISTINCT 
FROM 
WHERE date(___) = '2005-07-05'
```
# Exercise 4

## Exercise 4.1

Construct a query that retrieves all rows from the `payment` table where the amount is either 1.99, 7.99, 9.99.


```sql
SELECT *
FROM ___
WHERE ___ IN (1.99, 7.99, 9.99)
```

## Exercise 4.2

Construct a query that retrieves all rows from the `payment` table where the amount is greater then 5.


```sql
SELECT *
FROM 
WHERE 
```

## Exercise 4.2

Construct a query that retrieves all rows from the `payment` table where the amount is greater then 5 and less then 8.


```sql
SELECT *
FROM ___
WHERE ___ AND ___
```
# Exercise 5

Retrieve all the payment IDs and their amounts from the customers whose last name is 'DAVIS'.


```sql
SELECT 
FROM 
  INNER JOIN 
WHERE 
AND 
```

# Exercise 6

## Exercise 6.1

Use `COUNT(*)` to count the number of rows in `rental`.


```sql

```

## Exercise 6.2

Use `COUNT(*)` and `GROUP BY` to count the number of rentals for each `customer_id`.


```sql

```
## Exercise 6.3

Repeat the previous query and sort by the count in descending order.


```sql

```

## Exercise 6.4

Repeat the previous query but use `HAVING` to only keep the groups with 40 or more.


```sql

```

# Exercise 7

Write a query that calculates a number of summary statistics for the payment table using `MAX`, `MIN`, `AVG` and `SUM`


```sql

```

## Exercise 7.1

Modify the above query to do those calculations for each `customer_id`.


```sql

```
## Exercise 7.2

Modify the above query to only keep the `customer_id`s that have more then 5 payments.


```sql

```
# Cleanup

Run the following chunk to disconnect from the connection.


```r
# clean up
dbDisconnect(con)
```
