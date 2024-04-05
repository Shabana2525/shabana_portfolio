select * from customer_table;
select * from delivery_partners_table;
select	* from delivery_performance_table;
select * from menu_item_table;
select	* from order_table;
select * from ratings_reviews_table;
select * from restaurants_table;

##Swiggy Analysis - Customer Behavior and Delivery Performance

##Swiggy Analysis Project Overview:

#The Swiggy Analysis Project involves examining Swiggy's data to uncover insights that can improve its operationsand customer experience. By analyzing factors like customer behavior, restaurant performance, delivery efficiency, and customer satisfaction, the project aims to identify opportunities for optimization and innovation. Through data analysis and SQL querying,  this project aims to provide actionable insights to drive Swiggy's success in the competitive food delivery market.

#Objectives of the Analysis:

# 1 Understand Customer Behavior: Analyze how customers use the Swiggy platform, including their ordering habits and preferences.

# 2 Evaluate Restaurant Performance: Assess the performance of restaurants on the Swiggy platform to identify top-performing partners and areas for improvement.

# 3Improve Delivery Efficiency: Analyze delivery times, routes, and performance metrics to ensure timely and reliable delivery service.

# 4 Enhance Customer Satisfaction: Evaluate customer feedback, ratings, and reviews to gauge satisfaction levels and address any concerns or issues.

# 5 Identify Growth Opportunities:  Identify opportunities for Swiggy to innovate and expand its services to attract more customers and grow its business.

#Problem Statement:
    # 1 How many people ordered from Swiggy on [date], and what did they order the most?

 #   Importance: Understanding daily customer engagement and food preferences helps improve service.
 #    Purpose: Identifying popular food items helps tailor offerings to customer preferences.
 
 -- Describe the structure of the tables
describe Order_table;
describe customer_table;

select	* from order_table;
select * from customer_table;

alter table order_table
add column oder_date date;

alter table order_table
rename column oder_date to order_date;

UPDATE order_table
SET order_date = STR_TO_DATE(Order_timestamp, '%d-%m-%Y %H:%i')
WHERE order_timestamp IS NOT NULL;

SELECT *
FROM order_table
WHERE order_date IS NULL;

select count(distinct Customer_ID  )as Total_Customers
from order_table
where order_date = '2023-03-01';

select Order_Items ,count(*) as order_count
from order_table 
where order_date = '2023-03-01'
group by order_Items
order by order_count Desc 
limit 1 ;


-- Add a new column 'no_of_items' to the order_ table
alter table order_table
add column no_of_items int ;

select *from order_table;

UPDATE order_table
set no_of_items = (LENGTH(Order_Items) - LENGTH(REPLACE(Order_Items, ',', ''))) + 1;


  -- Find the average number of items ordered per order on the specified date 
 
SELECT AVG(num_items) AS avg_items_ordered
FROM (
  SELECT Order_ID, COUNT(*) AS num_items
  FROM order_table
  WHERE order_date = '2023-03-01'
  GROUP BY Order_ID
) AS subquery;

SELECT 
    COUNT(DISTINCT Customer_ID) AS total_customers_ordered,
    order_date,
    MAX(no_of_items) AS most_ordered_item
FROM 
    order_table
WHERE 
    order_date = '2023-03-01' 
GROUP BY 
    order_date;
    
# 2 . Which restaurants received the most orders on [date], and why were they popular?

-- Importance: Recognizing successful partnerships helps enhance customer satisfaction.
-- Purpose: Understanding factors driving demand helps optimize restaurant collaborations.

select	* from  restaurants_table; 
select * from order_table ;

SELECT 
    o.restaurant_id,
    r.Restaurant_Name,
    r.Cuisine_Type,
    COUNT(*) AS total_orders,
    max(r.Ratings) AS max_rating
FROM 
    order_table o
JOIN 
    restaurants_table r ON o.Restaurant_ID = r.Restaurant_ID
WHERE 
    o.order_date = '2023-03-01' 
GROUP BY 
    o.restaurant_ID, r.Restaurant_Name, r.Cuisine_Type
ORDER BY 
    total_orders DESC;
  
# 3.  What were the average delivery times on date, and were there any delays?

-- Importance: Ensuring timely delivery is crucial for customer satisfaction.
-- Purpose: Identifying delivery efficiency issues helps improve service reliability. 

## tables
select * from delivery_partners_table;
select * from delivery_performance_table;
select *  from order_table;

SELECT 
    TIMESTAMPDIFF(MINUTE, Pickup_Time, Delivery_Time) AS delivery_time_difference
from
    delivery_performance_table;
    
    SELECT 
    AVG(TIMESTAMPDIFF(MINUTE, Pickup_Time, Delivery_Time)) AS avg_delivery_time
from 
    delivery_performance_table;
    
   
    select Partner_ID ,Delivery_Zone ,Performance_Rating 
    from 
       delivery_partners_table
	where performance_Rating <3;
    
    SELECT
    dp.Pickup_Time,
    dp.Delivery_Time,
    dp.Delivery_Partner_ID,
    dpz.Delivery_Zone,
    dpz.Performance_Rating
FROM
    delivery_performance_table dp
JOIN
    delivery_partners_table dpz ON dp.Delivery_Partner_ID = dpz.Partner_ID
where  dpz.Performance_Rating <3 ;


# 4 How did customers rate their Swiggy experience on [date], and what were the common issues?

 -- Importance: Customer feedback informs service improvements.
-- Purpose: Addressing common concerns promptly enhances customer satisfaction.

# tables

 select * from ratings_reviews_table;
 select * from restaurants_table;
 select * from order_table;
 
 SELECT 
    rr.Comments ,
    rr.Ratings ,
    rr.Restaurant_ID,
    o.Customer_ID,
    o.order_date
FROM 
    ratings_reviews_table rr
JOIN 
    order_table o ON rr.Restaurant_ID = o.Restaurant_ID 
WHERE 
    o.order_date = '2023-03-01';
    
ALTER TABLE ratings_reviews_table
ADD COLUMN Rating_Group VARCHAR(20);

UPDATE ratings_reviews_table
SET Rating_Group = CASE 
when Ratings = 5 THEN 'Excellent'
when Ratings = 4 THEN 'Good'
when Ratings = 3 THEN 'Average'
when Ratings = 2 THEN 'Not Good'
when Ratings = 1 THEN 'Bad'
ELSE 'Unknown'
END;

 select * from ratings_reviews_table;
 
 SELECT Rating_Group, COUNT(*) AS Frequency
FROM ratings_reviews_table
GROUP BY Rating_Group
ORDER BY Frequency DESC;

select Order_Items ,Order_Status
from order_table
where Order_date = '2023-03-01' and order_Status = 'Cancelled';

select * from ratings_reviews_table 
where Rating_Group = 'Not Good';

SELECT
    rr.Ratings,
    rr.Rating_Group as Reviews,
    rr.Comments as Common_Issues
FROM
    ratings_reviews_table rr
JOIN
    order_table o ON rr.Order_ID = o.Order_ID
WHERE
     rr.Rating_Group = 'Not Good' and o.order_date = '2023-03-01'; 
     
# 5 Based on date orders, are there opportunities for Swiggy to expand its services?

 -- Importance: Identifying growth opportunities drives business expansion.
-- Purpose: Exploring trends helps target new market segments and innovate offerings.

 # tables 
 select * from order_table;
 select * from delivery_partners_table;
 
select *  
from Order_table
where Order_date = '2023-03-01';

SELECT dp.Delivery_Zone,  COUNT(*)AS Order_Count
FROM Order_table o
join delivery_partners_table dp on o.Delivery_Partner_ID = dp.Partner_ID
WHERE  o.Order_Date = '2023-03-01'
GROUP BY Delivery_Zone
ORDER BY Order_Count DESC;

select * from menu_item_table;
select * from restaurants_table;
select * from order_table;

SELECT r.Cuisine_Type, COUNT(*) AS Order_Count
FROM order_table o
join restaurants_table r on o.Restaurant_ID = r.Restaurant_ID
WHERE order_date = '2023-03-01'
GROUP BY Cuisine_Type
ORDER BY Order_Count DESC;

## Conclusion:

-- Analyzing Swiggy's data for highlights areas for improvement in delivery efficiency, addressing customer feedback, and identifying growth opportunities. Implementing these recommendations will enhance service quality and customer satisfaction, cementing Swiggy's position as a premier food delivery platform.




 
 




 

 
 
       
 
 
 



    
       
       
    
    






    




