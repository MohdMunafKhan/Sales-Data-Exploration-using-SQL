/*-------------------------------Analyzing sales on differents types of paper--------------------------------------*/

select * from orders;
select * from region;
select * from sales_reps;
select * from accounts;
select * from web_events;

 

/*1. Query a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. Sort the accounts alphabetically (A-Z) according to account name.*/

select s.name as sales_rep,r.name as region,a.name as accounts from ((sales_reps s
join region r
on r.id=s.region_id) join accounts a
on s.id=a.sales_rep_id)
where r.name ="Midwest"
order by a.name;



/*2.Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
Sort the accounts alphabetically (A-Z) according to account name.*/

select s.name as sales_rep,r.name as region,a.name as accounts from ((sales_reps s
join region r
on r.id=s.region_id) join accounts a
on s.id=a.sales_rep_id)
where s.name like 'S%' and r.name ="Midwest"
order by a.name;



/*3. Query a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
Sort the accounts alphabetically (A-Z) according to account name.*/

select s.name as sales_rep,r.name as region,a.name as accounts from ((sales_reps s
join region r
on r.id=s.region_id) join accounts a
on s.id=a.sales_rep_id)
where s.name like ('% K%') and r.name ="Midwest"
order by a.name;



/*4. Query the name for each region for every order, as well as the account name and the unit price they paid
(total_amt_usd/total) for the order. However, you should only provide the results
if the standard order quantity exceeds 100.*/

select r.name as region,a.name as accounts,(o.total_amt_usd/o.total+0.01) as unit_price
from (((region r join sales_reps s on r.id=s.region_id) join accounts a on s.id=a.sales_rep_id) 
join orders o on a.id=o.account_id)
where standard_qty>100;



/*5. Provide the name for each region for every order, as well as the account name and the unit price 
they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100 and 
the poster order quantity exceeds 50. Sort for the smallest unit price first.*/

select r.name as region,a.name as accounts,(o.total_amt_usd/o.total+0.01) as unit_price
from (((region r join sales_reps s on r.id=s.region_id) join accounts a on s.id=a.sales_rep_id) 
join orders o on a.id=o.account_id)
where standard_qty>100 and poster_qty>50
order by unit_price;



/*6. Provide the name for each region for every order, as well as the account name and
the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity
exceeds 50.  Sort for the largest unit price first.*/
select r.name as region,a.name as accounts,(o.total_amt_usd/o.total+0.01) as unit_price
from (((region r join sales_reps s on r.id=s.region_id) join accounts a on s.id=a.sales_rep_id) 
join orders o on a.id=o.account_id)
where standard_qty>100 and poster_qty>50
order by unit_price desc;



/*7. For each account, determine the average amount of each type of paper (i.e. standard_qty, gloss_qty, poster_qty) 
they purchased across their orders.*/

select a.name as accounts, avg(standard_qty) as avg_std, avg(gloss_qty) as avg_gloss, avg(poster_qty) as avg_poster 
from accounts a join orders o on a.id=o.account_id
group by a.name;



/*8. For each account, determine the average amount spent per order on each paper type. */

select a.name as accounts, avg(standard_amt_usd) as avg_std_amt, avg(gloss_amt_usd) as avg_gloss_amt, 
avg(poster_amt_usd) as avg_poster_amt from accounts a join orders o on a.id=o.account_id
group by a.name;

/*In the next query we can visualize the account_name that had spend the most */
select a.name as accounts, avg(standard_amt_usd) as avg_std_amt, avg(gloss_amt_usd) as avg_gloss_amt, 
avg(poster_amt_usd) as avg_poster_amt, avg(total_amt_usd) as total
from accounts a join orders o on a.id=o.account_id
group by a.name
order by total desc;



/*9. Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Order your table with the highest number of occurrences first.*/

select s.name as sales_rep_name,w.channels as channels_name,count(channels) as channels 
from ((web_events w join accounts a on a.id=w.account_id) join sales_reps s on s.id=a.sales_rep_id)
group by s.name, w.channels
order by channels desc;



/*10. Query the table to show that which year has the minimum sale or maximum sale (total_amt_usd) from orders
table.*/

select year(occurred_at) as years, sum(total_amt_usd) as sales from orders
group  by years
order by sales asc; 



/*11. Query the table to show how much monthly sale done in 2013 and 2017 year.*/

select year(occurred_at) as years,month(occurred_at) as months, sum(total_amt_usd) as sales from orders
where year(occurred_at) in (2013,2017)
group  by years,months
order by years,months asc;



/*12. Query the table to show the day wsie sale (total_amt_usd) for the year of 2017.*/

select extract(year from occurred_at) as years, extract(month from occurred_at) as months,
extract(day from occurred_at) as days, sum(total_amt_usd) as sales from orders
where extract(year from occurred_at)=2017
group by years,months,days
order by years,months,days asc;



/*13. Query the table to show the sale of 1st January 2017.*/

select extract(year from occurred_at) as years, extract(month from occurred_at) as months,
extract(day from occurred_at) as days, sum(total_amt_usd) as sales from orders
where extract(year from occurred_at)=2017 and extract(month from occurred_at)=1 and extract(day from occurred_at)=1
group by years,months,days
order by years,months,days asc;



/*14. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/

select a.name as account_holder, year(occurred_at) as years, month(occurred_at) as months, 
sum(gloss_amt_usd) as spend from accounts a join orders o on a.id=o.account_id
where a.name="Walmart"
group by years,months
order by spend desc
limit 1;
