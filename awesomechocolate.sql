select * from sales;

select SaleDate, Amount, Customers from sales;

select Amount, Customers, GeoID from sales;

select GeoId, Customers, Amount, Boxes, Amount/Boxes from sales;

#adding name to the column

select GeoId, Customers, Amount, Boxes, Amount/Boxes as 'Amount per box' from sales;
select GeoId, Customers, Amount, Boxes, Amount/Boxes 'Amount per Box' from sales;

select * from sales
where Amount >10000;

select * from sales
where Amount >10000
order by amount;

select * from sales
where Amount >10000
order by amount desc;

select * from sales
where GeoID='G1'
order by PID, Amount desc;

select * from sales
where Amount > 10000 and SaleDate >= '2022-01-01';

select SaleDate, Amount from sales
where Amount > 10000 and year(SaleDate) = '2022'
order by Amount desc;

select * from sales
where Boxes between 0 and 50;

select SaleDate, Amount, Boxes, weekday(SaleDate) 'Day of Week'
from sales
where weekday(SaleDate) = '4';

select * from people;

select * from people
where team = 'Delish' or team='Jucies';

select * from people
where team in ('Delish', 'Jucies');

select * from people 
where Salesperson like '%B%';

select * from sales;

select SaleDate, Amount,
	case 	when amount < 1000 then 'Under 1k'
			when amount < 5000 then 'Under 5k'
            when amount < 10000 then 'Under 10K'
		
        else '10K or more'
	end as 'Amount Category'

from sales; 

## Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales
where Amount >2000 and Boxes<100;

select * from sales;

## How many shipments (sales) each of the sales persons had in the month of January 2022?

select * from sales
where year(SaleDate) = '2022';


# Sales data with person's name

select * from sales;
select *from people;

#### joining 2 queries

select s.SaleDate, s.Amount, p.Salesperson, s.SPID, p.SPID
from sales s
join people p on p.SPID = s.SPID;

## Product name that we are selling this department(left join)

select s.SaleDate, s.Amount, pr.Product
from sales s
left join products pr on pr.PID = s.PID;

## product name and person name in one view

select s.SaleDate, s.Amount, p.Salesperson, pr.PID, pr.Product, p.team
from sales s
join people p on p.SPID = s.SPID
left join products pr on pr.PID = s.PID;

#### join query using condition as where
select s.SaleDate, s.Amount, p.Salesperson, pr.PID, pr.Product, p.team
from sales s
join people p on p.SPID = s.SPID
left join products pr on pr.PID = s.PID
where s.Amount < 500;

select s.SaleDate, s.Amount, p.Salesperson, pr.PID, pr.Product, p.team
from sales s
join people p on p.SPID = s.SPID
join products pr on pr.PID = s.PID
where s.Amount < 500
and p.Team = "Delish";

#### people from india or new zealand 

select s.SaleDate, s.Amount, p.Salesperson, pr.PID, pr.Product, p.team, g.Region
from sales s
join people p on p.SPID = s.SPID
join products pr on pr.PID = s.PID
join geo g on g.GeoID=s.GeoID
where s.Amount < 500
and g.Geo in ('India', 'New Zealand')
order by SaleDate;

## Group By

select g.GeoID, sum(Amount), avg(amount), sum(Boxes), g.Geo
from sales s
join geo g on g.GeoID = s.GeoID
group by GeoID;

### get the data from people and product table

select pr.Category, p.Team, sum(Boxes), sum(Amount)
from sales s
join people p on p.SPID = s.SPID
join products pr on pr.PID = s.PID
group by pr.Category, p.Team
order by pr.Category, p.Team;

### Total amounts by top 10 products

select pr.Product, sum(s.Amount) as "Total Amount"
from sales s
join products pr on pr.PID=s.PID
group by pr.Product
order by "Total Amount" desc
limit 10;

																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										
## Which product sells more boxes? Milk Bars or Eclairs?

select pr.Product, sum(Boxes) as "Total Boxes"
from sales s
join products pr on pr.PID = s.PID
where pr.Product in ("Milk Bars", "Eclairs")
group by pr.Product;


## Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

select pr.Product, sum(Boxes) as "Total Boxes"
from sales s
join products pr on pr.PID = s.PID
where pr.Product in ("Milk Bars", "Eclairs")
and s.SaleDate between '2022-02-01' and '2022-02-07'
group by pr.Product;

## Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?

select * from sales 
where Customers < 100 and Boxes < 100;

select *,
case when weekday(SaleDate)=2 then "Wednesday Shipment"

else " "
end as 'W Shipment'

from sales
where customers < 100 and Boxes < 100;


## What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?

select distinct p.Salesperson
from sales s
join people p on p.SPID = s.SPID
where s.SaleDate between '2022-01-01' and '2022-01-07';

## Which salespersons did not make any shipments in the first 7 days of January 2022?

select p.Salesperson
from people p
where p.SPID not in
(select distinct s.SPID
from sales s
where s.SaleDate between '2022-01-01' and '2022-01-01');

## How many times we shipped more than 1,000 boxes in each month?

select year(SaleDate) 'Year', month(SaleDate) 'Month', count(*) 'Boxes shipped more than 1K'
from sales
where Boxes > 1000
group by year(SaleDate), month(SaleDate)
order by year(SaleDate), month(SaleDate);

## India or Australia? Who buys more chocolate boxes on a monthly basis?

select year(SaleDate) 'Year', month(SaleDate) 'Month',
sum(Case when g.geo = 'India' then boxes else 0 end) 'India Boxes',
sum(Case when g.geo = 'Australia' then boxes else 0 end) 'Australia boxes'
from sales s
join geo g on g.GeoId = s.GeoId
group by year(SaleDate), month(SaleDate)
order by year(SaleDate), month(SaleDate);










