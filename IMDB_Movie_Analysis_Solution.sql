USE imdb;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select * from director_mapping;
select * from genre;
select * from movie;
select * from names;
select * from ratings;
select * from role_mapping;



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select id 
from movie
where id IS NULL;

select year
from movie
where year IS NULL;

select date_published
from movie
where date_published IS NULL;

select duration
from movie
where duration IS NULL;

select country
from movie
where country is null;

select worldwide_gross_income
from movie
where worldwide_gross_income is null;

select languages
from movie
where languages is null;

select production_company
from movie
where production_company is null;

# 4 columns have null values. The columns production_company, languages, worldwide_gross_income, country contains null values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year, count(id) as number_of_movies
from movie
group by year;

select month(date_published) as month_num, count(id) as number_of_movies
from movie
group by month_num
order by count(id) desc;

# In the month of march, highest number pf movies have been produced


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) as movie_count
from movie
where country=("USA" or "India") and year=2019; 

# Total 1992 movies have been released in the year 2019 for USA and India

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct(genre)
from genre;
# There are total 13 different genre

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(movie_id) as total_movies
from genre
group by genre
order by total_movies desc
limit 1;

# Drama genre has the highest movie count with total number of movies 4285.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(genre)as genre_count, movie_id
from genre
group by movie_id having count(genre)=1;

#Total there are 3289 movies with only one genre.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, avg(m.duration) as avg_duration
from movie m
inner join genre g on m.id= g.movie_id
group by g.genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_rank_info as(
select g.genre, count(m.id) as movie_count, rank() over(order by count(m.id) desc) as genre_rank
from genre g
left join movie m on g.movie_id= m.id
group by g.genre)

select * from genre_rank_info where genre="Thriller";

# Thriller genre comes on 3rd, it's among the top 3 of all genres.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select min(avg_rating) as min_avg_rating, 
		max(avg_rating) as max_avg_rating, 
        min(total_votes) as min_total_votes, 
        min(median_rating) as min_median_rating,
        min(median_rating) as min_median_rating
from ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
with movie_rank as (
select title,
		avg_rating,
        row_number() over(order by avg_rating desc) as movie_rank
from ratings r
inner join movie m on r.movie_id=m.id)
select * from movie_rank where movie_rank<=10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select median_rating,
		count(movie_id) as movie_count
from ratings
group by(median_rating)
order by movie_count desc;

# Movies with a median rating of 7 is has total of 2257 movies. 

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
		count(id) as movie_count,
        rank() over(partition by count(id) order by production_company) as prod_company_rank
from movie m
left join ratings r on m.id=r.movie_id
where (avg_rating>8)
group by production_company
order by movie_count desc;

# Dream Warrior Pictures production house has produced 3 hit movies whose average rating is above 8.


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, 
		count(g.movie_id)as movie_count
from genre g
inner join movie m on m.id=g.movie_id
inner join ratings r using(movie_id)
where month(m.date_published) and
        year(m.date_published) and 
        UPPER(m.country) LIKE 'USA' and
        r.total_votes>1000
group by g.genre
order by movie_count desc;

# Drama genre has the highest number of movies.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select title,
		avg_rating,
        genre
from movie m
left join ratings r on m.id=r.movie_id
left join genre g using(movie_id)
where title like 'The%'
		and avg_rating>8
order by avg_rating desc;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
select title,
		median_rating,
        genre
from movie m
left join ratings r on m.id=r.movie_id
left join genre g using(movie_id) 
where title like 'The%'
		and median_rating>8
order by median_rating desc;



-- Q16. Number Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select count(m.id) num_of_movies_released, median_rating
from movie m
inner join ratings r on m.id=r.movie_id
where m.date_published between '2018-04-01' and '2019-04-01' 
		and median_rating=8
group by median_rating;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
  country, 
  sum(total_votes) as total_votes 
FROM 
  movie AS m 
  INNER JOIN ratings as r ON m.id = r.movie_id 
WHERE 
  country = 'Germany' 
  or country = 'Italy' 
GROUP BY country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:
-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select count(*) as name_nulls
from names
where name is null;

select count(*) as height_nulls
from names
where height is null;

select count(*) as date_of_birth_nulls
from names
where date_of_birth is null;

select count(*) as known_for_movies_nulls
from names
where known_for_movies is null;

# There are no null values in the column 'name', whereas height column has 17335 null values,
# date_of_birth column has 13431 null values, known_for_movies column has 15226 null values

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_3_genres_movie_director AS ( 
SELECT genre, Count(m.id) AS movie_count , DENSE_Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank 
FROM movie m 
INNER JOIN genre g ON g.movie_id = m.id 
INNER JOIN ratings AS r ON r.movie_id = m.id 
WHERE avg_rating > 8 
GROUP BY genre 
limit 3 ) 

SELECT n.NAME AS director_name , 
Count(d.movie_id) AS movie_count 
FROM director_mapping AS d 
INNER JOIN genre g USING (movie_id) 
INNER JOIN names AS n ON n.id = d.name_id 
INNER JOIN top_3_genres_movie_director USING (genre) 
INNER JOIN ratings USING (movie_id) 
WHERE avg_rating > 8 
GROUP BY NAME 
ORDER BY movie_count DESC 
limit 3 ;

#James Mangold can be hired as the director for RSVP's next project.

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select name as actor_name,
		count(movie_id) as movie_count
from names n 
inner join role_mapping r on r.name_id= n.id
inner join ratings ra using(movie_id)
where r.category="actor" and median_rating>=8
group by actor_name
order by movie_count desc
limit 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
		sum(total_votes) as vote_count,
        row_number() over(order by sum(total_votes) desc) as prod_comp_rank
from movie m
inner join ratings r on r.movie_id= m.id
group by production_company
order by vote_count desc
limit 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, 
-- then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


with rank_actors as(
select name as actor_name,
		sum(total_votes) as total_votes,
        count(movie_id) as movie_count,
        ROUND( SUM(r.avg_rating*r.total_votes) / SUM(r.total_votes) ,2) AS actor_avg_rating
from role_mapping ro
inner join names n on ro.name_id=n.id
inner join ratings r using(movie_id)
inner join movie m on r.movie_id= m.id
where category="actor" and country like "%India%" 
group by name
having count(distinct ro.movie_id) >=5
)
SELECT *, DENSE_Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank FROM rank_actors;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with top_actress as (
select name as actress_name,
		sum(total_votes) as total_votes,
        count(movie_id) as movie_count,
        ROUND( SUM(avg_rating*total_votes) / SUM(total_votes) ,2) as actress_rank
from role_mapping ro
inner join names n on ro.name_id=n.id
inner join ratings r using(movie_id)
inner join movie m on r.movie_id= m.id
where category="actress" and country like "%India%" and languages like "%Hindi%"
group by name
having count(m.id) >=3
limit 5
)
select *, dense_rank() over(order by actress_rank desc) as actress_rank
from top_actress;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title As movie_name, avg_rating, 
		CASE WHEN avg_rating > 8 THEN "Superhit movies" 
			WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies" 
            WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies" 
            ELSE "Flop Movies" 
            END AS avg_rating_category 
FROM movie AS m 
INNER JOIN genre AS g ON m.id = g.movie_id 
INNER JOIN ratings r ON r.movie_id = m.id 
WHERE genre="thriller";

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre,
		round(avg(duration),2) as avg_duration,
		round(sum(avg(duration)) over(order by genre),2) as running_total_duration ,
        round(avg(avg(duration)) over(order by genre),2) as moving_avg_duration
from genre g
inner join movie m on g.movie_id=m.id
group by genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_3_genre as(
select genre,
		count(movie_id) as movie_count
from genre g
inner join movie m on g.movie_id= m.id
group by genre
order by count(movie_id) desc
limit 3
),
find_rank as(
select genre,
		year,
        title as movie_name,
        worldwide_gross_income,
        dense_rank() over(partition by year order by worldwide_gross_income desc) as movie_rank
from movie m
inner join genre g on m.id=g.movie_id
where genre in (select genre from top_3_genre)
)
select * from find_rank where movie_rank<=5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) 
         #among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
		count(id) as movie_id,
        row_number() over(order by count(id) desc) as prod_comp_rank
from movie m
inner join ratings r on m.id=r.movie_id
where median_rating>=8
		and production_company is not null
        and position(',' in languages)>0
group by production_company
limit 2;

# star cinema production company has 7 hits and Twentieth Century Fox has 4 hits.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actress_name,
		sum(total_votes) as total_votes,
        count(rm.movie_id) as movie_count,
        round(sum(avg_rating*total_votes) / sum(total_votes) ,2) as actress_avg_rating,
        dense_rank() over(order by count(movie_id) desc) as actress_rank
from names n
inner join role_mapping rm on n.id=rm.name_id
inner join ratings r on r.movie_id=rm.movie_id
inner join genre g on g.movie_id=r.movie_id
where category= "actress"
		and avg_rating>8
        and g.genre="Drama"
group by name
limit 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH t_date_summary AS ( 
SELECT d.name_id, 
		NAME, 
        d.movie_id, 
        duration, 
        r.avg_rating, 
        total_votes, 
        m.date_published, 
        Lead(date_published,1) 
			OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published 
FROM director_mapping AS d 
INNER JOIN names AS n ON n.id = d.name_id 
INNER JOIN movie AS m ON m.id = d.movie_id 
INNER JOIN ratings AS r ON r.movie_id = m.id ), 
top_director_summary AS ( 
SELECT *, 
Datediff(next_date_published, date_published) AS date_difference FROM t_date_summary ) 
SELECT name_id AS director_id, 
		NAME AS director_name, 
        COUNT(movie_id) AS number_of_movies, 
        ROUND(AVG(date_difference),2) AS avg_inter_movie_days, 
        ROUND(AVG(avg_rating),2) AS avg_rating, 
        SUM(total_votes) AS total_votes, 
        MIN(avg_rating) AS min_rating, 
        MAX(avg_rating) AS max_rating, 
        SUM(duration) AS total_duration 
FROM top_director_summary 
GROUP BY director_id 
ORDER BY COUNT(movie_id) DESC 
limit 9;









