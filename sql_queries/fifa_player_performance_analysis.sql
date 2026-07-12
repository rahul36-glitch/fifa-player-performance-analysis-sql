CREATE DATABASE fifa_player_performance_analysis;

CREATE TABLE palyer_analysis(
   player_id INT PRIMARY KEY,
   player_name VARCHAR(50),
   age INT NOT NULL,
   nationality VARCHAR(100),
   club VARCHAR(100),
   player_position VARCHAR(10),
   overall_rating INT,
   potential_rating INT, 
   matches_played INT,
   goals INT,
   assists INT,
   minutes_played INT,
   market_value_million_eur NUMERIC(10, 2),
   contract_years_left INT,
   injury_prone CHAR(3),
   transfer_risk_level VARCHAR(10)
);

--data exploration

--sample data 
SELECT * FROM player_analysis
LIMIT 10;

--null values
SELECT * FROM player_analysis
WHERE player_name IS NULL
OR 
age IS NULL
OR 
 nationality IS NULL
OR 
 club IS NULL
OR 
 player_position IS NULL
OR 
 overall_rating IS NULL
OR 
 potential_rating IS NULL
OR 
 matches_played IS NULL
OR 
 goals IS NULL
OR 
 assists IS NULL
OR 
 minutes_played IS NULL
OR
 market_value_million_eur IS NULL
OR
 contract_years_left IS NULL
OR 
 injury_prone IS NULL
OR 
 transfer_risk_level IS NULL;

--different country 
SELECT DISTINCT nationality
FROM player_analysis
ORDER BY nationality;

--total number of players
SELECT COUNT(*) AS total_players
FROM player_analysis

--count players by position
SELECT player_position, COUNT(*) 
FROM player_analysis
GROUP BY player_position;

--average age
SELECT ROUND(AVG(age), 2) AS avg_age
FROM player_analysis;

--average overall rating
SELECT ROUND(AVG(overall_rating), 2) AS avg_overall_rating
FROM player_analysis;

--avg market value player
SELECT ROUND(AVG(market_value_million_eur), 2) AS avg_market_value
FROM player_analysis;

--injury-prone percentage
SELECT 
ROUND(AVG(CASE WHEN injury_prone = 'Yes' THEN 1
              ELSE 0
			  END ) * 100, 2) AS injury_prone_percentage
FROM player_analysis;

--top 10 highest rate player
SELECT player_name, overall_rating 
FROM player_analysis
ORDER BY overall_rating DESC
LIMIT 10;

--players older than 30
SELECT player_name, age 
FROM player_analysis
WHERE age > 30;

--highest club avg rating
SELECT club, ROUND(AVG(overall_rating), 2) AS avg_rating
FROM player_analysis
GROUP BY club
ORDER BY avg_rating DESC
LIMIT 1;

--nationality most player
SELECT nationality, COUNT(*) AS total_players
FROM player_analysis
GROUP BY nationality
ORDER BY total_players DESC;

--most valuable young player (<25) 
SELECT player_name, age, market_value_million_eur
FROM player_analysis
WHERE age < 25
ORDER BY market_value_million_eur DESC
LIMIT 10;

--potential higher than overall
SELECT player_name, overall_rating, potential_rating
FROM player_analysis
WHERE potential_rating > overall_rating;

--highest goal contribution
SELECT player_name, goals + assists AS total_goal_contribution
FROM player_analysis
ORDER BY total_goal_contribution DESC
LIMIT 10;

--efficiency per 90 min
SELECT player_name, goals, minutes_played,
ROUND((goals * 90.0 / minutes_played), 2) AS goals_per_90
FROM player_analysis
WHERE minutes_played > 0
ORDER BY goals_per_90 DESC;

--overvalued players
SELECT player_name, market_value_million_eur, overall_rating
FROM player_analysis
WHERE market_value_million_eur > 100 AND overall_rating < 75
ORDER BY overall_rating DESC;

--undervalued players
SELECT player_name, market_value_million_eur, overall_rating
FROM player_analysis
WHERE market_value_million_eur < 30 AND overall_rating > 85
ORDER BY overall_rating DESC;

--players at transfer risk
SELECT player_name, contract_years_left, market_value_million_eur
FROM player_analysis
WHERE contract_years_left <=1
ORDER BY market_value_million_eur DESC;

--injury-prone high value players
SELECT player_name, market_value_million_eur, injury_prone
FROM player_analysis
WHERE injury_prone = 'Yes'
ORDER BY market_value_million_eur DESC;

--rank player within each club by rating
SELECT player_name, club, overall_rating,
  RANK() OVER(PARTITION BY club ORDER BY overall_rating DESC)
FROM player_analysis;

--highest valued player in each club
SELECT * 
FROM(
         SELECT *,
		          ROW_NUMBER() OVER(PARTITION BY club ORDER BY market_value_million_eur DESC) AS hvp
FROM player_analysis)
WHERE hvp = 1;

-- running otal of goals by club
SELECT player_name, club, goals,
        SUM(goals) OVER(PARTITION BY club ORDER BY goals DESC) AS running_goals
FROM player_analysis;

--player whose market value is above club average
SELECT p.player_name, p.club, p.market_value_million_eur AS player_market_value,
(
      SELECT 
	        ROUND(AVG(market_value_million_eur), 2) 
	            FROM player_analysis
	               WHERE club = p.club AS club_avg_market_value
               FROM player_analysis p
                   WHERE p.market_value_million_eur > 
(
    SELECT 
 	     AVG(market_value_million_eur)
		  FROM player_analysis 
		  WHERE club = p.club
);

--top 3 players in each position by goals
WITH ranked_players AS(
      SELECT player_name, player_position, goals, 
            ROW_NUMBER() OVER(PARTITION BY player_position ORDER BY goals DESC) AS top_three_players
FROM player_analysis
)
SELECT player_name, player_position, goals, top_three_players
FROM ranked_players
WHERE top_three_players <= 3;

--players with highest improvement gap
SELECT player_name, potential_rating, overall_rating,
   (potential_rating - overall_rating) AS improvement_gap
FROM  player_analysis
ORDER BY improvement_gap DESC;

--clubs spending too much on injury prone players
SELECT club, injury_prone,
    SUM(market_value_million_eur) AS total_spent,
	ROUND(AVG(overall_rating), 2) AS avg_rating,
	COUNT(*) AS total_players
FROM player_analysis
WHERE injury_prone = 'Yes'
GROUP BY club, injury_prone
HAVING AVG(overall_rating) < 80
ORDER BY total_spent DESC;

--best young player age<23 in each nationality
WITH young_player AS (
    SELECT  nationality, player_name, age, overall_rating,
	    ROW_NUMBER() OVER(PARTITION BY nationality ORDER BY overall_rating DESC) AS rnk
FROM player_analysis
WHERE age < 23
)
SELECT player_name, nationality, age, overall_rating
FROM young_player
WHERE rnk = 1;

--player with highest goal contribution per club
WITH player_contribution AS(
SELECT player_name, club, goals, assists, (goals + assists) AS goal_contribution,
        ROW_NUMBER() OVER(PARTITION BY club ORDER BY (goals + assists) DESC) AS rn
FROM player_analysis
)
SELECT player_name, club, goals, assists, goal_contribution
FROM player_contribution
WHERE rn = 1;

--classify players
SELECT player_name, overall_rating, 
        CASE 
		     WHEN overall_rating >= 90 THEN 'Elite'
			 WHEN overall_rating BETWEEN 80 AND 90 THEN 'Good'
			 WHEN overall_rating BETWEEN 70 AND 79 THEN 'Average'
			 ELSE 'Weak'
			 END AS player_category
FROM player_analysis
LIMIT 10;

--Aggregation:
--total goals scored by club
SELECT club, SUM(goals) AS total_goals
FROM player_analysis
GROUP BY club
ORDER BY total_goals DESC;

--avg overall rating by position
SELECT player_position, ROUND(AVG(overall_rating), 2) AS avg_rating
FROM player_analysis 
GROUP BY player_position;

--count injury prone players in each club
SELECT club, COUNT(*) AS injury_count
FROM player_analysis
WHERE injury_prone = 'Yes' 
GROUP BY club, injury_prone;

--nationality highest avg market value
SELECT nationality,  ROUND(AVG(market_value_million_eur), 2) AS avg_market_value
FROM player_analysis
GROUP BY nationality
ORDER BY avg_market_value DESC
LIMIT 1;

--clubs total market value is greater than 5000
SELECT club, SUM(market_value_million_eur) AS total_market_value
FROM player_analysis
GROUP BY club
HAVING SUM(market_value_million_eur) > 5000
ORDER BY total_market_value DESC;

--avg goals & assists by position
SELECT player_position, ROUND(AVG(goals), 2) AS avg_goals,
                        ROUND(AVG(assists), 2) AS avg_assists
FROM player_analysis
GROUP BY player_position;

--club with most injury-prone
SELECT club, COUNT(*) AS total_injuries
FROM player_analysis
WHERE injury_prone = 'Yes'
GROUP BY club
ORDER BY total_injuries DESC
LIMIT 1;

--Case Statement:
--categorize players overall rating
SELECT player_name, overall_rating,
             CASE 
			    WHEN overall_rating >= 90 THEN 'Elite'
				WHEN overall_rating BETWEEN 80 AND 89 THEN 'Good'
				WHEN overall_rating BETWEEN 70 AND 79 THEN 'Average'
				ELSE 'poor'
				END AS player_category
FROM player_analysis;

--categorize plyers age
SELECT player_name, age,
          CASE
		     WHEN age < 23 THEN 'Young'
			 WHEN age BETWEEN 23 AND 29 THEN 'Prime'
			 ELSE 'Veteran'
			 END AS age_group
FROM player_analysis;

--categorize transfer risk
SELECT player_name, contract_years_left,
          CASE 
		     WHEN contract_years_left < 1 THEN 'Expiring Soon'
			 WHEN contract_years_left BETWEEN 2 AND 3 THEN 'Medium Level'
			 ELSE 'Long Term'
			 END AS contract_status
FROM player_analysis;

--performance classification
SELECT player_name, goals, 
        CASE 
		  WHEN goals >= 25 THEN 'Excellent'
		  WHEN goals BETWEEN 15 AND 24 THEN 'Good'
		  WHEN goals BETWEEN 5 AND 14 THEN 'Average'
		  ELSE 'Poor'
		  END AS performance
FROM player_analysis;

--market value category
SELECT player_name, market_value_million_eur,
         CASE
		    WHEN market_value_million_eur >= 150 THEN 'Superstar'
		    WHEN market_value_million_eur BETWEEN 100 AND 149.99 THEN 'World Class'
			WHEN market_value_million_eur BETWEEN 50 AND 99.99 THEN 'Valuable'
			ELSE 'Budget Player'
			END AS value_category
FROM player_analysis;

--player development
SELECT player_name, overall_rating, potential_rating,
           CASE
		      WHEN potential_rating - overall_rating >= 10 THEN 'High Potential'
              WHEN potential_rating - overall_rating BETWEEN 5 AND 9 THEN 'Moderate Potential'
		      ELSE 'Near Peak'
		      END AS development_status
FROM player_analysis;

--playing time analysis
SELECT player_name, minutes_played,
          CASE 
		     WHEN minutes_played >= 2500 THEN 'Regular Starter'
			 WHEN minutes_played BETWEEN 1000 AND 2499 THEN 'Rotation Player'
			 ELSE 'Bench Player'
			 END AS playing_status
FROM player_analysis;

--create report showing
SELECT player_name, overall_rating, market_value_million_eur, age,
            CASE
			    WHEN overall_rating >= 90 THEN 'Elite'
				WHEN overall_rating BETWEEN 80 AND 89 THEN 'Good'
				WHEN overall_rating BETWEEN 70 AND 79 THEN 'Average'
				ELSE 'Poor'
				END AS player_category,
			CASE
			    WHEN market_value_million_eur >= 150 THEN 'Superstar'
		        WHEN market_value_million_eur BETWEEN 100 AND 149.99 THEN 'World Class'
			    WHEN market_value_million_eur BETWEEN 50 AND 99.99 THEN 'Valuable'
			    ELSE 'Budget Player'
			    END AS value_category,
		    CASE
		        WHEN age < 23 THEN 'Young'
			    WHEN age BETWEEN 23 AND 29 THEN 'Prime'
			    ELSE 'Veteran'
			    END AS age_group
FROM player_analysis;

--Subqueries:
--players whose overall rating is above avg rating
SELECT player_name, overall_rating
FROM player_analysis
WHERE overall_rating > (
               SELECT AVG(overall_rating)
			   FROM player_analysis
);

--players whose market value above avg market value
SELECT player_name, market_value_million_eur
FROM player_analysis
WHERE market_value_million_eur > (
                       SELECT AVG(market_value_million_eur)
					   FROM player_analysis
);

--players with highest overall rating
SELECT player_name, overall_rating
FROM player_analysis
WHERE overall_rating = (
               SELECT MAX(overall_rating)
			   FROM player_analysis
);

--players with lowest market value
SELECT player_name, market_value_million_eur
FROM player_analysis
WHERE market_value_million_eur = (
                   SELECT MIN(market_value_million_eur)
				   FROM player_analysis
);

--players market value greater than club avg market value
SELECT player_name, club, market_value_million_eur
FROM player_analysis p1
WHERE market_value_million_eur > (
                   SELECT AVG(market_value_million_eur)
				   FROM player_analysis p2
				   WHERE p1.club = p2.club
);

--players whose goals are above avg goals of position
SELECT player_name, player_position, goals
FROM player_analysis p1
WHERE goals > (
           SELECT AVG(goals)
		   FROM player_analysis p2
		   WHERE p1.player_position = p2.
);

--clubs have more players than avg players per club
SELECT club, COUNT(*) AS total_players
FROM player_analysis
GROUP BY club
HAVING COUNT(*) > (
            SELECT AVG(player_count)
			FROM (
                SELECT COUNT(*) AS player_count
				FROM player_analysis
				GROUP BY club
			) AS club_counts
);

--players whose potential rating higher than avg potential rating of nationality
SELECT player_name, nationality, potential_rating
FROM player_analysis p1
WHERE potential_rating > (
                SELECT AVG(potential_rating)
				FROM player_analysis p2
				WHERE p1.nationality = p2.nationality
);

--highest rated player in each club
SELECT club, player_name, overall_rating
FROM player_analysis p1
WHERE overall_rating = (
                SELECT MAX(overall_rating)
				FROM player_analysis p2
				WHERE p1.club = p2.club
);

--highest market value player in each position
SELECT player_position, player_name, market_value_million_eur
FROM player_analysis p1
WHERE market_value_million_eur = (
               SELECT MAX(market_value_million_eur)
			   FROM player_analysis p2
			   WHERE p1.player_position = p2.player_position
);

--players who scored more goals than every other player in their club
SELECT club, player_name, goals
FROM player_analysis p1
WHERE goals = (
            SELECT MAX(goals)
			FROM player_analysis p2
			WHERE p1.club = p2.club
);

--players played more mins then avg mins played in their club
SELECT player_name, club, minutes_played
FROM player_analysis p1
WHERE minutes_played > (
                SELECT AVG(minutes_played)
				FROM player_analysis p2
				WHERE p1.club = p2.club
);

--Common Table Expressions(CTEs):
--players above avg rating
 WITH avg_rating AS(
               SELECT AVG(overall_rating) AS overall_avg_rating
			    FROM player_analysis
)
SELECT player_name, overall_rating
FROM player_analysis, avg_rating
WHERE overall_rating > overall_avg_rating;

--club wise total goals
WITH club_goals AS (
          SELECT club, SUM(goals) AS total_goals
		  FROM player_analysis
		  GROUP BY club
)
SELECT club, total_goals
FROM club_goals;

--avg market value by position
WITH position_market_value AS (
             SELECT player_position, ROUND(AVG(market_value_million_eur), 2) AS avg_market_value
			 FROM player_analysis
			 GROUP BY player_position
)
SELECT player_position, avg_market_value
FROM  position_market_value;

--player above club avg rating
WITH club_avg_rating AS (
           SELECT club, AVG(overall_rating) AS avg_rating
		   FROM player_analysis
		   GROUP BY club
)
SELECT p.player_name, p.club, p.overall_rating
FROM player_analysis p
JOIN club_avg_rating c
ON p.club = c.club
WHERE p.overall_rating > c.avg_rating;

--highest goal scorer in each club
WITH club_top_scorer AS(
          SELECT club, MAX(goals) AS highest_goals
		  FROM player_analysis
		  GROUP BY club
)
SELECT p.player_name, p.club, p.goals
FROM player_analysis p
JOIN club_top_scorer c
ON p.club = c.club
AND p.goals = c.highest_goals;

--club with high avg market value
WITH club_market_value AS (
          SELECT club, ROUND(AVG(market_value_million_eur), 2) AS avg_market_value
		  FROM player_analysis
		  GROUP BY club
)
SELECT club, avg_market_value
FROM club_market_value
WHERE avg_market_value > 90;

--best young player in every nationality
WITH young_players AS (
              SELECT nationality, MAX(overall_rating) AS highest_rated
			  FROM player_analysis
			  WHERE age < 23
			  GROUP BY nationality
)
SELECT p.nationality, p.player_name, p.age, p.overall_rating 
FROM player_analysis p
JOIN young_players y
ON p.nationality = y.nationality
AND p.overall_rating = y.highest_rated
WHERE p.age < 23;

--most valuable player in each position
WITH valuable_player AS (
            SELECT player_position, MAX(market_value_million_eur) AS highest_market_value
			FROM player_analysis
			GROUP BY player_position
)
SELECT p.player_name, p.player_position, p.market_value_million_eur
FROM player_analysis p
JOIN valuable_player v
ON p.player_position = v.player_position
AND p.market_value_million_eur = v.highest_market_value;

--clubs spending too much on injury prone player
WITH injury_spending AS (
             SELECT club, SUM(market_value_million_eur) AS total_market_value
			 FROM player_analysis
			 WHERE injury_prone = 'Yes'
			 GROUP BY club
)
SELECT club, total_market_value
FROM injury_spending
where total_market_value > 200;

--players with highest improvement potential 
WITH player_gap AS (
               SELECT player_name, potential_rating, overall_rating, 
			          (potential_rating - overall_rating) AS improvement_gap
				FROM player_analysis
)
SELECT player_name, improvement_gap
FROM player_gap
WHERE improvement_gap = (
          SELECT MAX(improvement_gap) AS highest_gap
		  FROM player_gap
);

--Windows Function 
--second highest rated player in each club
WITH rated_player AS(
SELECT player_name, overall_rating, club,
        DENSE_RANK() OVER(PARTITION BY club ORDER BY overall_rating DESC) AS highest_rated
FROM player_analysis
) 
SELECT player_name, overall_rating, club, highest_rated
FROM rated_player
WHERE highest_rated = 2;

--top 5 players in each nationality based on market value
WITH ranked_player AS(
SELECT player_name, nationality, market_value_million_eur,
              ROW_NUMBER() OVER(PARTITION BY nationality ORDER BY market_value_million_eur DESC) AS market_value
FROM player_analysis
)
SELECT player_name, nationality, market_value_million_eur, market_value
FROM ranked_player
WHERE market_value <= 5

--players whose market value is higher than the pervious player in their club
WITH player_value AS(
SELECT player_name, club, market_value_million_eur,
       LAG(market_value_million_eur) OVER(PARTITION BY club ORDER BY market_value_million_eur DESC) AS previous_value
FROM player_analysis
)
SELECT player_name, club, market_value_million_eur
FROM player_value
WHERE market_value_million_eur > previous_value;

--club where top player's rating is more than 10 points above the club avg
WITH club_stats AS(
SELECT player_name, club, overall_rating,
       MAX(overall_rating ) OVER(PARTITION BY club) AS highest_rating,
	   AVG(overall_rating) OVER(PARTITION BY club) AS avg_rating
FROM player_analysis
)
SELECT player_name, club, overall_rating, highest_rating,
       ROUND(avg_rating, 2) AS avg_rating, 
	   ROUND(highest_rating - avg_rating, 2) AS rating_gap
FROM club_stats 
WHERE highest_rating - avg_rating > 10  AND overall_rating = highest_rating;

--player contributing more goals than the avg goals of position
WITH position_avg AS(
SELECT player_name, player_position, goals,
       ROUND(AVG(goals) OVER(PARTITION BY player_position), 2) AS avg_goals
FROM player_analysis
)
SELECT player_name, player_position, goals, avg_goals
FROM position_avg
WHERE goals > avg_goals;

--player with largest improvement gap in each nationality
WITH player_gap AS (
SELECT player_name, nationality, potential_rating, overall_rating,
       (potential_rating - overall_rating) AS improvement_gap,
	         RANK() OVER(PARTITION BY nationality ORDER BY (potential_rating - overall_rating) DESC) AS rnk
FROM player_analysis
)
SELECT player_name, nationality, improvement_gap 
FROM player_gap
WHERE rnk = 1;

--top scorer and second top scorer in each club
WITH scorer_rank AS (
SELECT player_name, club, goals,
       ROW_NUMBER() OVER(PARTITION BY club ORDER BY goals DESC) AS goals_rank
FROM player_analysis
)
SELECT player_name, club, goals, goals_rank
FROM scorer_rank
WHERE goals_rank IN (1, 2)
ORDER BY club, goals_rank;
	   






