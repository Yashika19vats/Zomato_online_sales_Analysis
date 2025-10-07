use zm;
select * from zom;

-- top 10 most voted resturant
select distinct name, votes, approx_cost_for_two_people as cost, rate
from zom
order by votes desc
offset 0 rows fetch next 10 rows only;

--resturant offering both online and offline booking
select name, listed_in_type, rate, votes
from zom
where online_order= 1 AND book_table=1
order by rate desc;

--average cost per meal type
 select listed_in_type as meal_type, 
 round(avg(approx_cost_for_two_people),2)as avg_cost
 from zom
 group by listed_in_type
 order by avg_cost desc;

 --correlation check higher cost and higher rating
 select approx_cost_for_two_people, rate
 from zom
order by approx_cost_for_two_people;

--online orders
select online_order,count(*) as total_resturants
from zom
group by online_order;

--comparing online and off;ine ratings
select online_order,
round(avg(rate),2) as avg_rating,
round(avg(approx_cost_for_two_people),2) as avg_cost
from zom
group by online_order;

--top rated resturant by category
select name, rate, listed_in_type
from (select listed_in_type, name, rate, 
rank() over(partition by listed_in_type order by rate desc) as rank_type
from zom
) as ranked
where rank_type <= 3;

-- identify costeliest and cheapest resturant
select name,approx_cost_for_two_people, rate
 from zom
 where approx_cost_for_two_people = (select max(approx_cost_for_two_people) from zom)
 OR approx_cost_for_two_people= (select min(approx_cost_for_two_people) from zom)
 order by approx_cost_for_two_people desc;