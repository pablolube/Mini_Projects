# Netflix Movies and TV Shows Data Analysis using SQL

## Overview
This project presents an in-depth analysis of Netflix's movies and TV shows dataset using SQL. The objective is to derive actionable insights and answer key business questions based on the data. This README outlines the project’s goals, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs. TV shows).
- Identify the most common ratings for movies and TV shows.
- Investigate content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The dataset used for this project is sourced from Kaggle:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

# Findings and Conclusion
- Content Distribution: The dataset includes a wide variety of movies and TV shows, with diverse ratings and genres.
- Common Ratings: Analyzing the most frequent ratings helps understand the target audience of the content.
- Geographical Insights: The analysis reveals the top countries for Netflix content and provides insights into regional content trends, particularly in India.
- Content Categorization: Organizing content by specific keywords enhances understanding of the types of content available on Netflix.
- This analysis offers a comprehensive understanding of Netflix’s content and can guide decisions related to content strategy and planning.



