select * from df_orders;

#find top 10 highest reveue generating products 
select  product_id,sum(sale_price)  as sales
from df_orders
group by product_id
order by sales desc
limit 10;

#find top 5 highest selling products in each region
with cte as (select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id),
cte1 as (select region, product_id,sales,
row_number() over(partition by region order by sales desc) as rnk
from cte)
select region,product_id,sales,rnk 
from cte1
where rnk <= 5;

#find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

with cte as (select year(order_date) as order_year,month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)
)
select order_month,
sum(case when order_year = 2022 then sales else 0 end )as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month;

#for each category which month had highest sales 
with cte as (select category,DATE_FORMAT(order_date,'%Y%m') as order_year_month,sum(sale_price) as sales
from df_orders
group by category,order_year_month
order by category,order_year_month),
cte1 as (select *,
row_number() over(partition by category order by sales desc) as rnk
from cte)
select category, order_year_month,sales
from cte1
where rnk = 1;

#which sub category had highest growth by profit in 2023 compare to 2022

with cte as (select sub_category,year(order_date) as order_year, sum(sale_price) as sales
from df_orders
group by sub_category, year(order_date)
order by sub_category, year(order_date)
),
cte1 as (select sub_category,
sum(case when order_year = 2022 then sales else 0 end )as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by sub_category)
select *,
(sales_2023-sales_2022)*100/sales_2022 as growth_per
from cte1
order by growth_per desc
limit 1