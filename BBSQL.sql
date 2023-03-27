/*total rides by customer and subscriber */
select Count(bike_id) 
From bluebikes_2019 
where user_type ilike 'subscriber' 

/*most popular start locations */
select Count(bb.bike_id), bb.start_station_id, bs.name, bs.district
from bluebikes_2019 bb
Full join bluebikes_stations bs
on start_station_id = id
where user_type ilike 'subscriber'
group by start_station_id, bs.name, bs.district
order by 1 desc;

/*most popular routes*/
select distinct(start_station_name, end_station_name), total_rides, district
from (
 select count(bb.bike_id) as total_rides, 
 bb.start_station_id, 
 bb.end_station_id, 
 bs.name as start_station_name, 
 bs.district as district, 
 bss.name as end_station_name
from bluebikes_2019 bb
join bluebikes_stations bs
on bb.start_station_id = bs.id
join bluebikes_stations bss
on bb.end_station_id = bss.id
group by  2, 3, 4, 5, 6
  ) sub
group by 1, 2, 3
order by 2 desc

/*10 most popular routes */
select distinct(start_station_name, end_station_name), total_rides, district
from (
 select count(bb.bike_id) as total_rides, 
 bb.start_station_id, 
 bb.end_station_id, 
 bs.name as start_station_name, 
 bs.district as district, 
 bss.name as end_station_name
from bluebikes_2019 bb
join bluebikes_stations bs
on bb.start_station_id = bs.id
join bluebikes_stations bss
on bb.end_station_id = bss.id
group by  2, 3, 4, 5, 6
  ) sub
group by 1, 2, 3
order by 2 desc
limit 10



/*duration of ride */
select avg(t1.trip_time), t1.user_type
from(
 select (end_time - start_time) as trip_time, user_type, Bike_id
from bluebikes_2019
where (end_time - start_time) < interval '5 hours') t1
group by 2



/*riders that were college aged*/
"select count(bike_id)
from bluebikes_2019
where user_birth_year::int >= 1997
and user_birth_year::int <= 2001
group by user_type"

/*number of rides based on age group*/
select count(bike_id),
case when user_birth_year::int >= 1939 and user_birth_year::int <= 1959 then 'Elderly'
 when  user_birth_year::int > 1959 and user_birth_year::int <= 1979 then 'Middle_Adult'
 when  user_birth_year::int > 1979 and user_birth_year::int <= 1999 then 'Adult'
 when  user_birth_year::int > 1999 and user_birth_year::int <= 2019 then 'Young_adult'
 else 'n/a'
 end as user_age_group
from bluebikes_2019
where user_type ilike 'customer'
group by 2
order by 1

/*Count of customers and subscribers by district*/
select count(bb.bike_id), bs.district
from bluebikes_2019 bb
join bluebikes_stations bs
on bb.start_station_id = bs.id
where bb.user_type ilike 'subscriber'
group by 2
order by 1 desc

/*count of rides by season*/
select count(bike_id), user_type,
case when date_part('Month', start_time) <4 or date_part('Month', start_time)= 12 then 'Winter'
 when date_part('Month', start_time) >=4 and date_part('Month', start_time) <6 then 'Spring'
 when date_part('Month', start_time) >=6 and date_part('Month', start_time) <9 then 'Summer'
 when date_part('Month', start_time) >=9 and date_part('Month', start_time) <12 then 'Fall'
 end as Season
from bluebikes_2019
group by season, 2

/*Rides by time of day*/
select count(bike_id), user_type,
case when date_part('hour', start_time) >=7 and date_part('hour', start_time) <=9 then 'Commuter_hours'
 when  date_part('hour', start_time) >9 and date_part('hour', start_time) <=16 then 'Mid_Day'
  when date_part('hour', start_time) >16 and date_part('hour', start_time) <=18 then 'Evening_Commuter_hours'
  else 'other'
  end as Time_of_Day
from bluebikes_2019
group by 2, 3

/*Manhattan distance*/
select
 avg(round(abs(t1.start_lat - t1.end_lat), 4) + round(abs(t1.start_long - t1.end_long), 4))
from(select bb.start_station_id, bb.end_station_id, bs.latitude as start_lat, bs.longtitude as start_long, bss.latitude as end_lat, bss.longtitude as end_long
 from  bluebikes_2019 bb
join bluebikes_stations bs
on bb.start_station_id = bs.id
join bluebikes_stations bss
on bb.end_station_id = bss.id
where user_type ilike 'subscriber')t1















