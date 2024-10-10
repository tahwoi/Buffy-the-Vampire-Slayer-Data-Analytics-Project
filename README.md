# Buffy the Vampire Slayer: SQL Data Analytics Project

Personal project, completed by Tutuwa Ahwoi in October 2024.

## Project Overview

This project uses SQL to analyze data from the cult classic television show "Buffy the Vampire Slayer". It aims to uncover interesting patterns and insights about the show, its episodes, writers, and ratings through data analysis.

## Technologies Used

1. Microsoft Excel
    - Used for data cleaning and transformation
    - Used for creating preliminary charts and graphs
2. SQL (PostgreSQL)
    - Chosen as the relational database management system for storing and querying the dataset
    - Used for initial data exploration, basic statistical analysis, and complex queries
    - Leveraged for performing advanced analytical functions and window operations

## Data Sources

The data for this project was collected from the following sources:

1. IMDb (Internet Movie Database)
    - Episode (user) ratings and vote counts
    - Ratings are on a scale of 0 to 10, which is standard for IMDB ratings. 10 is the best, and 0 is the worst.
2. Buffy the Vampire Slayer Wikipedia Page
    - Episode titles
    - Writer and director information
    - Season and episode numbers
    - U.S. viewer numbers for each episode

## Dataset

The dataset includes information on:

- Episodes (title, air date, season, episode number, director)
- IMDb ratings (ratings and votes, viewership)
- Writers
- Writers-Episodes relationship

## Methodology

1. Data Collection: Gathered U.S. viewer ratings from Wikipedia and IMDB scores for all episodes.
2. Data Cleaning: Used Excel to clean and preprocess the data.
3. Exploratory Data Analysis: Utilized SQL for initial data exploration and basic statistical analysis.
4. Visualization: Created charts and graphs using Excel.

## **Exploratory Data Analysis**

### Identify the average IMDb rating for all episodes

The analysis starts by calculating and displaying the average IMDb rating across all episodes in the dataset. This simple yet informative analysis provides a quick overview of the general quality of episodes as perceived by IMDb users. The result offers a baseline metric that can be used for comparison with individual episode ratings or ratings of specific seasons or shows.

### **Top 10 Most Popular Episodes**

This SQL query identifies and lists the ten episodes with the highest IMDb ratings in the dataset. It provides a quick overview of the most well-received episodes according to IMDb users. This helps to identify peak moments of quality or popularity across the episodes in the show.

### **Top 10 Least Popular Episodes**

This SQL query identifies and displays the ten episodes with the lowest IMDb ratings in the dataset. It offers a glimpse into the least popular or critically acclaimed episodes according to IMDb users. This provides insight into some of the show’s potential weak points.

### Analyze the distribution of ratings

This SQL query analyzes the distribution of IMDb ratings for episodes in the "Buffy the Vampire Slayer" dataset. It groups episodes by their rounded IMDb rating (to the nearest integer) and counts how many episodes fall into each rating bracket. The results offer a clear picture of the overall quality perception of the show's episodes, highlighting which rating ranges are most common.

## Additional Key Queries

- Episode analysis by season and overall series trends
- Director impact on episode ratings
- Writer contribution and patterns
- Correlation between viewership numbers and IMDb ratings
- Relationship between “Big Bad” (main villains) and IMDb ratings

## Key Insights

My analysis revealed several interesting patterns and insights:

1. **Episode Quality**: The IMDb ratings range from a minimum of 6.3 to a maximum of 9.7 (out of 10), with an average IMDb rating of 8.01 for all episodes. A majority of episodes fall within the 7-8 range, indicating most episodes were well-received by the audience. 
2. **Writer Impact**: Joss Whedon-written episodes had an average rating of 8.58/10, significantly higher than the series average of 8.01/10. 
3. **Viewership:** Viewership peaked in the early seasons (2-3) and showed a general declining trend afterwards. 
    - Highest Average viewership: Season 3 (6.10m)
    - Lowest Average viewership: Season 1 (3.63m).
4. **Viewership vs. Ratings**: In general, there is no strong correlation between user ratings and viewership numbers. 
5. **Director Influence**: Episodes directed by Joss Whedon had the highest average rating (8.84/10) among directors with more than five episodes. Michael Gershman, who directed 10 episodes, had the second highest average rating of 8.26/10.
6. **Seasonal Patterns Pt 1**: The show maintained consistently high ratings throughout its run, with all seasons averaging above 7.5. Season 3 had the highest average rating of 8.32/10, closely followed by Season 5 at 8.06/10. 
7. **Seasonal Patterns Pt 2**: The data revealed a trend of season finales consistently outperforming season premiere ratings. The premiere ratings fluctuate between 7.6 and 8.1, while finale ratings have a wider range from 8.6 to 9.5. The series finale (the very final episode of the show) also had the third highest finale rating of 9.3, indicating that fans were generally satisfied with the conclusion of the show.

## Conclusion
Buffy the Vampire Slayer maintained a consistent level of quality throughout its run, thanks to strong writing, directing, and the contributions of a talented team of creators. The show's ability to engage viewers and maintain a loyal fanbase is a testament to its enduring appeal.

The show maintained consistently high IMDb ratings throughout its run, with an average rating of 8.01. While viewership declined in later seasons, the show's quality remained strong, indicating a loyal core audience.

## Acknowledgments

- Data sourced from IMDb and Wikipedia
- Inspired by the work of Joss Whedon and the Buffy the Vampire Slayer creative team
