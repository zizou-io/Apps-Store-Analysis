-- 1. What is the average rating for all apps in Google Play Store?
SELECT 
	ROUND(AVG(Rating), 2) AS average_rating
FROM googleplaystore;

-- 2. What is the distribution of app ratings?
SELECT 
    rating_range, 
    COUNT(*) AS count_rating
FROM (
    SELECT
        CASE
            WHEN Rating BETWEEN 1 AND 1.9 THEN 1
            WHEN Rating BETWEEN 2 AND 2.9 THEN 2
            WHEN Rating BETWEEN 3 AND 3.9 THEN 3
            WHEN Rating BETWEEN 4 AND 4.9 THEN 4
            WHEN Rating = 5 THEN 5
            ELSE "no_rating"
        END AS rating_range
    FROM googleplaystore
)
GROUP BY rating_range
ORDER BY rating_range;

-- 3.  What are the most popular app categories by number of installs?
SELECT 
	Category,
	SUM(CAST(REPLACE(Installs, '+', '') * 1000 AS INTEGER)) AS total_installs
FROM googleplaystore
GROUP BY Category
ORDER BY total_installs DESC;

-- 4. What are the most popular genres by average rating?
SELECT 
	Genres, 
	ROUND(AVG(Rating), 2) AS average_rating
FROM googleplaystore
GROUP BY Genres
ORDER BY average_rating DESC;

-- 5. How many free and paid apps in each category?
SELECT 
	Category, 
	Type, 
	COUNT(*) AS count_type
FROM googleplaystore
GROUP BY Category, Type;

-- 6. What is the overall sentiment distribution for user reviews across all apps?
SELECT 
	Sentiment, 
	COUNT(*) AS sentiment_count
FROM googleplaystore_user_reviews
GROUP BY Sentiment
ORDER BY Sentiment;

-- 7. What is the distribution of sentiment for user reviews of each app?
SELECT 
	App, 
	Sentiment,
	count(*) AS sentiment_count
FROM googleplaystore_user_reviews
GROUP BY App, Sentiment;

-- 8. Which app has the most positive sentiment?
SELECT 
	App, 
	Sentiment,
	count(*) AS sentiment_count
FROM googleplaystore_user_reviews
WHERE Sentiment = 'Positive'
GROUP BY App
ORDER BY sentiment_count DESC;

-- 9. What are the top 10 most positively reviewed apps in the Game category?
SELECT 
	googleplaystore_user_reviews.App AS google_app,
	AVG(Sentiment_Polarity) AS avg_sentiment
FROM googleplaystore_user_reviews
	JOIN googleplaystore 
	ON googleplaystore_user_reviews.App = googleplaystore.App
WHERE googleplaystore.Category = 'GAME'
GROUP BY google_app
ORDER BY avg_sentiment DESC
LIMIT 10;
