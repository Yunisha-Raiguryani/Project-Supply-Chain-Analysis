
-- shipping carriers with highest number of products sold
Select [Shipping carriers], sum ([Number of products sold]) as total_products_sold
From [Project]..supply_chain_data$
group by [Shipping carriers] order by total_products_sold Desc

--product with  highest margin
Select [Product type], Round(sum([Shipping costs]),0) as total_shipping_cost, Round(sum([Revenue generated]),0) as total_Revenue_generated, sum (round([Revenue generated] - [Shipping costs] - [Manufacturing costs],0)) as gross_margin
from [Project]..supply_chain_data$
Group by [Product type] order by gross_margin desc


--Maximum shipping cost by different transportation modes
Select [Transportation modes], Max(round([Shipping costs],2)) as max_cost, [product type]
From [Project]..supply_chain_data$
group by [Transportation modes], [Product type] order by max_cost Desc


--Maximum shipping cost by different transportation modes
Select Q1.[Transportation modes], Q1.max_cost , Q1.[Product type]
From(
Select [Transportation modes], round([Shipping costs],2)as max_cost, [product type], ROW_NUMBER() over ( Partition by [transportation modes] order by round([Shipping costs],2) desc) as rn
from [Project]..supply_chain_data$)Q1
where Q1.rn= 1



--Top 10 SKU on the basis of revenue

Select Top 10 SKU, round(Sum([Revenue generated]),0) as Revenue 
from [Project]..supply_chain_data$
group by SKU order by Revenue desc


--product with highest total shipping cost of the location
Select Q2.[Product type], Q2.[Shipping carriers], Q2.[location], Q2.total_shipping_cost
from (select Q1.[Product type], Q1.[Shipping carriers], Q1.[location], Q1.total_shipping_cost, rank () over (partition by location order by Q1.total_shipping_cost desc) as rank from
(
Select [Product type], [Shipping carriers], [location], round (sum([shipping costs]),0) as total_shipping_cost
From [Project]..supply_chain_data$
group by [Product type], [Shipping carriers], Location) Q1) Q2
Where Q2.rank = 1

--3 products with overall highest totalshipping cost 
Select top 3 round(sum([Shipping costs]),0) as total_shipping_cost, [Product type], [Shipping carriers], Location,  rank() over(order by round(sum([shipping costs]),0) desc) as rank
From [Project]..supply_chain_data$
group by [Product type], [Shipping carriers], Location


--product with highest shipping cost at every location
Select Q1.location, Q1.[Shipping carriers], Q1.[Product type], Q1.[Supplier name],  Q1.cost
from (
Select location, [Shipping carriers], [Product type], [Supplier name], round([Shipping costs],2) as cost, ROW_NUMBER() OVER (PARTITION by location order by round([Shipping costs],2) Desc) as rn
from [Project]..supply_chain_data$)Q1
Where rn = 1 

--product with highest shipping cost
Select Q1.location, Q1.[Shipping carriers], Q1.[Product type], Q1.[Supplier name], Q1.Cost
from (
Select location, [Shipping carriers], [Product type], [Supplier name], round([Shipping costs],2) as Cost, ROW_NUMBER() OVER (order by round([shipping costs],2) Desc) as rn
from [Project]..supply_chain_data$)Q1
Where rn = 1 

--product with lowest shipping cost at every location
Select Q1.[Shipping carriers], Q1.[Product type], Q1.[Supplier name], Q1.cost, Q1. Location
from (
Select location, [Shipping carriers], [Product type], [Supplier name], round([Shipping costs],2) as cost, ROW_NUMBER() OVER (PARTITION by location order by [shipping costs]) as rn
from [Project]..supply_chain_data$)Q1
Where rn = 1 


--product with highest lead time in every location by the shipping carriers
Select Q1.[Shipping carriers] ,Q1. [lead_time], Q1.location, Q1.[Product type], Q1.RNK from
(Select [Shipping carriers],sum([Lead time]) as lead_time, location, [Product type], rank() over (partition by location order by sum([Lead time]) desc) as rnk
from [Project]..supply_chain_data$ 
group by [Shipping carriers], Location, [Product type], [Lead time])Q1
Where rnk = 1


-- Product shipped maximum number of times by shipping carrier

Select Q1.Shipping_times, Q1.[Shipping carriers], Q1.[Product type], Q1.ranking
from
(Select sum([Shipping times]) as shipping_times, [Shipping carriers], [Product type], rank () over (partition by [shipping carriers] order by sum([Shipping times]) desc) as ranking
from [Project]..supply_chain_data$
group by [Shipping carriers], [Product type])Q1
Where ranking = 1

-- Lead time take by different modes of transportation
Select Routes, Location, [Transportation modes], sum([Lead time]) as Total_Lead_time
from [Project]..supply_chain_data$
Group by Routes, Location, [Transportation modes] 





  

