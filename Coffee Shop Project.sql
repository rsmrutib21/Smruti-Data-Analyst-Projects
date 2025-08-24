CREATE DATABASE coffee_shop_sales_db ;
use coffee_shop_sales_db ;

select * from coffee_shop_sales;
describe coffee_shop_sales;

update	coffee_shop_sales 
set transaction_time = str_to_date(transaction_time, '%H:%i:%s');

alter table coffee_shop_sales
change column ï»¿transaction_id transaction_id int;

alter table coffee_shop_sales
modify column transaction_time time; -- converted to DATE datatype

describe coffee_shop_sales ;

-- find the total sale for specific month and round it to 1 decimal point
select sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where 
month (transaction_date) = 5; -- may month 

select round(sum(unit_price * transaction_qty),1) as total_sales
from coffee_shop_sales
where 
month (transaction_date) = 3 ;-- march 

-- month-on-month increase and decrese in sales
-- cal the difference in sales between the selectrd month and prv month
select 
month(transaction_date) as Month ,
round(sum( unit_price * transaction_qty)) as total_sales , -- total sales column
(sum( unit_price * transaction_qty ) - lag (sum( unit_price * transaction_qty),1) -- diff in sales between months
over(order by month (transaction_date))) / lag (sum(unit_price * transaction_qty),1) -- division by prv month sales
over(order by month (transaction_date)) * 100 as mom_increase_percentage -- percentage 
from coffee_shop_sales
where
month (transaction_date) in (4,5) -- for month of april and may 
group by 
month(transaction_date)
order by
month(transaction_date);

-- cal the total number of order fors for rerspective months.alter
select count( transaction_id) as Totalorders -- transaction_id is primary key 
from coffee_shop_sales 
where 
month(transaction_date) = 4; -- march 

-- calulate the total sales , total quanty sold and total order , round it to one decimal place and 
-- the result should show in thousand.
select concat(round(sum( unit_price * transaction_qty)/1000,1),'k') as Total_sales,
		concat(round(sum(transaction_qty)/1000,1),'k') as Total_qty_sold,
        concat(round(count(transaction_id)/1000,1),'k')as Total_order
        from coffee_shop_sales
        where transaction_date = '2023-03-27';
        
-- Sales analysis by weekdays and weekends
-- segment sales data into weekdays  and weekends to analysize performance variation
-- provide insights into wheather sales patterns differ significantly  between weekdays and weekends.
select 
		case when dayofweek(transaction_date ) in (1,7) then 'weekend'
		else 'weekdays' 
		end as day_type,
		sum(unit_price * transaction_qty) as Total_Sales
from coffee_shop_sales
where month (transaction_date) = 5 -- may month
group by 
		case when dayofweek(transaction_date ) in (1,7) then 'weekend'
		else 'weekdays' 
		end ;
			
-- Sales analyze BY STORE LOCATION
-- find  sales data by diff store location in desc order
select store_location,
	sum(unit_price * transaction_qty) as Total_sales
from coffee_shop_sales
where month (transaction_date) = 4 -- april month
group by store_location
order by sum(unit_price * transaction_qty) desc;

-- Sales profermance across differnt product category
-- insights into which product categories contributes the most overall sells 
select product_category,
sum(unit_price * transaction_qty) as Total_Sales
from coffee_shop_sales
where month(transaction_date) = 6 -- june month 
group by product_category
order by Total_sales desc;

-- Top ten products by sale
select product_type ,
sum(unit_price * transaction_qty) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 3 -- march month
group by product_type
order by Total_sales desc
limit 10;

-- Top ten products by category and sale
select product_type ,
sum(unit_price * transaction_qty) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 3 and product_category = 'Coffee' -- march month
group by product_type
order by Total_sales desc
limit 10; 

-- Sales Anlysis by Days and Hours (for heatmap besically in dashboard)
select 
sum(unit_price * transaction_qty) as Total_sales,
sum(transaction_qty) as Total_qty_sold,
count(*) as Total_orders
from coffee_shop_sales
where month(transaction_date) = 3 -- for march
and dayofweek(transaction_date) = 2 -- for monday
and hour(transaction_time) = 8 -- for hour no 8;
