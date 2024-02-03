create database IPL_Case;
select * from deliveries;
select * from matches;
create table deliveries 
(id	int, inning int, overs int, ball int, batsman text,
	non_striker	text, bowler text, batsman_runs int,
	extra_runs int,	total_runs int,	is_wicket int,
    dismissal_kind text, player_dismissed text,	fielder	text,
    extras_type text, batting_team text, bowling_team text, venue text,	match_date text);

/*1. Create a table named 'matches' with appropriate data types for columns
/*2. Create a table named 'deliveries' with appropriate data types for columns
/*3. Import data from csv file 'IPL_matches.csv'attached in resources to 'matches'
/*4. Import data from csv file 'IPL_Ball.csv' attached in resources to 'deliveries*/
 
 /*5. Select the top 20 rows of the deliveries table.*/
 
 select * from deliveries order by id asc limit 20;
 
/*6. Select the top 20 rows of the matches table.*/

select * from matches 
order by id asc
limit 20;
 
/*7. Fetch data of all the matches played on 2nd May 2013.*/

desc matches;
select * from deliveries;
select * from matches;
alter table matches add New_date date;
set sql_safe_updates=0;
update matches set New_date= str_to_date(Date,"%d-%m-%Y");
select * from matches where New_date= "2013-05-02";
select * from matches where date= "02-05-2013";

/*8. Fetch data of all the matches where the margin of victory is more than 100 runs.*/ 

select * from matches where result_margin > 100;

/*9. Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.*/

select * from deliveries;
desc deliveries;
alter table deliveries drop venue;
alter table deliveries drop match_date;
select * from matches;
desc matches;

with temp as
(select distinct m.id, city, new_date, inning, sum(total_runs) over(partition by id order by inning) as Final_Score
from matches m inner join deliveries d using(id)),

temp1 as
(select row_number() over(partition by id order by final_score desc) as Rnk, final_score, id, city, new_date,inning from temp
order by new_date)
 
/*select * from temp1
where temp1.rnk <=2;*/
select rnk,id from temp1 
group by id
having count(rnk)= 1
order by final_score desc; 

select distinct id, inning, sum(total_runs) over (partition by id order by inning) from deliveries
where id in (501265,829763);

select * from deliveries where id in(501265,829763);
 
/*10. Get the count of cities that have hosted an IPL match. */

select (count(distinct(city))) as count from matches;

/*11. Create table deliveries_v02 with all the columns of deliveries and
 an additional column ball_result containing value boundary,
 dot or other depending on the total_run (boundary for >= 4, dot for 0 and other for any other number) */
 
create table deliveries_v02
(id	int, inning int, overs int, ball int, batsman text,
	non_striker	text, bowler text, batsman_runs int,
	extra_runs int,	total_runs int,	 is_wicket int,
    dismissal_kind text, player_dismissed text,	fielder	text,
    extras_type text, batting_team text, bowling_team text,ball_result text);
select * from deliveries_v02;
drop table deliveries_v02;
insert into deliveries_v02 (id, inning , overs , ball , batsman ,
	non_striker	, bowler , batsman_runs ,
	extra_runs ,	total_runs ,	 is_wicket ,
    dismissal_kind , player_dismissed ,	fielder	,
    extras_type , batting_team , bowling_team ,ball_result)
select id,inning,overs,ball,batsman,non_striker,bowler,batsman_runs,extra_runs,total_runs,is_wicket,dismissal_kind,player_dismissed,fielder,
extras_type,batting_team,bowling_team, ball_result  from
 (select *,
     case when total_runs>=4 then "Boundary"
     when total_runs=0 then "Dot"
     else "Other"
     end as ball_result
     from deliveries) as temp;
     
     
alter table deliveries_v02 add ball_result text;
with  temp as 
(select *,
     case when total_runs>=4 then "Boundary"
     when total_runs=0 then "Dot"
     else "Other"
     end as result
     from deliveries_v02)
select id, inning, batsman, total_runs, result from temp;
 
/*12. Write a query to fetch the total number of boundaries and dot balls*/

with  temp as 
(select *,
     case when total_runs>=4 then "Boundary"
     when total_runs=0 then "Dot"
     else "Other"
     end as result
     from deliveries_v02)
select count(result) from temp where result= "Boundary";
with  temp as 
(select *,
     case when total_runs>=4 then "Boundary"
     when total_runs=0 then "Dot"
     else "Other"
     end as result
     from deliveries_v02)
select count(*) from temp where result = "Dot";

/*13. Write a query to fetch the total number of boundaries scored by each team*/

 with  temp as 
(select *,
     case when total_runs>=4 then "Boundary"
     when total_runs=0 then "Dot"
     else "Other"
     end as result
     from deliveries_v02)
select batting_team,count(result) from temp where result = "Boundary"
group by batting_team;

/*14. Write a query to fetch the total number of dot balls bowled by each team */

with  temp as 
(select *,
     case when total_runs>=4 then "Boundary"
     when total_runs=0 then "Dot"
     else "Other"
     end as result
     from deliveries_v02)
select bowling_team, count(result) from temp where result = "Dot"
group by bowling_team;
select * from deliveries;

/*15. Write a query to fetch the total number of dismissals by dismissal kinds */

select count(*) from deliveries where dismissal_kind <> "NA";

/*16. Write a query to get the top 5 bowlers who conceded maximum extra runs */

select distinct(bowler), sum(extra_runs) as maximum_extra_run from deliveries 
group by bowler order by sum(extra_runs) desc limit 5;

select bowler, extra_runs from deliveries order by extra_runs desc;

/*17. Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table 
and two additional column (named venue and match_date) of venue and date from table matches*/

 create table deliveries_v03
(id	int, inning int, overs int, ball int, batsman text,
	non_striker	text, bowler text, batsman_runs int,
	extra_runs int,	total_runs int,	 is_wicket int,
    dismissal_kind text, player_dismissed text,	fielder	text,
    extras_type text, batting_team text, bowling_team text, ball_result text, venue text, match_date text);

drop table deliveries_v03;    
insert into deliveries_v03 (id, inning , overs , ball , batsman,
	non_striker, bowler , batsman_runs ,
	extra_runs ,	total_runs ,	 is_wicket ,
    dismissal_kind, player_dismissed ,	fielder	,
    extras_type , batting_team , bowling_team , ball_result, venue , match_date )
select m.id, inning, overs, ball, batsman, non_striker, bowler, batsman_runs,
	extra_runs,	total_runs,	 is_wicket,
    dismissal_kind, player_dismissed,	fielder,
    extras_type, batting_team, bowling_team, ball_result, venue, new_date  from deliveries_v02 d inner join matches m on m.id=d.id;


select * from deliveries_v03;
select * from deliveries;
desc deliveries_v03;
select * from matches;



/*18. Write a query to fetch the total runs scored for each venue and order it in the descending order of total runs scored. */

select venue, sum(total_runs) as `Total runs` from deliveries_v03
Group by venue
order by sum(total_runs) desc;

/*19. Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending order of total runs scored. */

select venue, year(match_date) as yearwise, sum(total_runs) as `Total Runs` from deliveries_v03
where venue = "Eden Gardens"
Group by venue, 2;

/*20. Get unique team1 names from the matches table, 
you will notice that there are two entries for Rising Pune Supergiant one with Rising Pune Supergiant and another one with Rising Pune Supergiants.
 Your task is to create a matches_corrected table with two additional columns team1_corr and team2_corr
 containing team names with replacing Rising Pune Supergiants with Rising Pune Supergiant. Now analyse these newly created columns. */
 
 select id, city, date, player_of_match,venue,neutral_venue,team1, replace(team1, "Rising Pune Supergiants", "Rising Pune Supergiant") as team1_corr,
 team2, replace(team2, "Rising Pune Supergiants", "Rising Pune Supergiant") as team2_corr, toss_winner,toss_decision,winner,result,result_margin,
 eliminator,method,umpire1,umpire2,New_date from matches;
 
 
/*21. Create a new table deliveries_v04 with the first column as ball_id containing information of match_id,
 inning, over and ball separated by'(For ex. 335982-1-0-1 match_idinning-over-ball) and rest of the columns same as deliveries_v03)*/
 
 select * from deliveries_v03;
 create table deliveries_v04
 (ball_id text, batsman text,
	non_striker	text, bowler text, batsman_runs int,
	extra_runs int,	total_runs int,	 is_wicket int,
    dismissal_kind text, player_dismissed text,	fielder	text,
    extras_type text, batting_team text, bowling_team text, ball_result text,venue text, match_date text);
    
drop table deliveries_v04;
select * from deliveries_v04;
    
insert into deliveries_v04 
select concat(id,"-",inning,"-",overs,"-",ball), batsman,non_striker,bowler,batsman_runs,extra_runs,total_runs,is_wicket,dismissal_kind,player_dismissed,
 fielder,extras_type,batting_team,bowling_team, ball_result,venue,match_date  from deliveries_v03;
 
 
/*22. Compare the total count of rows and total count of distinct ball_id in deliveries_v04; */

select count(*) as `Total Cout of Row`, count(distinct(ball_id)) as `Distinct Ball_id` from deliveries_v04;


/*23. Create table deliveries_v05 with all columns of deliveries_v04 and
 an additional column for row number partition over ball_id. (HINT : row_number() over (partition by ball_id) as r_num) */
 
 create table deliveries_v05
 (r_num int, ball_id text, batsman text,
	non_striker	text, bowler text, batsman_runs int,
	extra_runs int,	total_runs int,	 is_wicket int,
    dismissal_kind text, player_dismissed text,	fielder	text,
    extras_type text, batting_team text, bowling_team text, ball_result text,venue text, match_date text);

drop table deliveries_v05;    
select * from deliveries_v05;
insert into deliveries_v05 
select row_number() over(partition by ball_id) as r_num, ball_id,batsman,non_striker,bowler,batsman_runs,extra_runs,
total_runs,is_wicket,dismissal_kind,player_dismissed,fielder,extras_type,batting_team,bowling_team,ball_result,venue,match_date
from deliveries_v04;


 /*24. Use the r_num created in deliveries_v05 to identify instances 
 where ball_id is repeating. (HINT : select * from deliveries_v05 WHERE r_num=2;) */
 
 select * from deliveries_v05 where r_num=2;
 

/*25. Use subqueries to fetch data of all the ball_id which are repeating. */

SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2); 

