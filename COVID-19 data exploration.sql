-- selecting a database
use coronaviurs_data;

/* The following data is outdated, please refer
to the latest COVID-19 stats. */ 

SELECT 
    *
FROM
    covid_cases;
    
-- selecting countries and their largest total cases recorded. 
SELECT 
    location AS country, MAX(total_cases) AS total_cases
FROM
    covid_cases
GROUP BY country
ORDER BY total_cases DESC;

-- creating a view of  continents and their largest total cases
CREATE VIEW total_cases_by_continet AS
    SELECT 
        continent, MAX(total_cases) AS total_cases
    FROM
        covid_cases
    GROUP BY continent
    ORDER BY total_cases DESC;
    
-- selecting countries that have higher than average new cases using a nested query.
SELECT 
    location AS country, new_cases
FROM
    covid_cases
WHERE
    new_cases > (SELECT 
            ROUND(AVG(new_cases)) AS average_new_cases
        FROM
            covid_cases)
GROUP BY country;

-- selecting countries and their  highest number of  ICU patients due to COVID-19 complications
SELECT 
    location AS country,
    MAX(CAST(icu_patients AS UNSIGNED)) AS highest_count_of_ICU_patients
FROM
    covid_cases
GROUP BY country
ORDER BY highest_count_of_ICU_patients DESC;

SELECT 
    *
FROM
    covid_deaths;
    
-- creating a stored procedure for countries with their corresponding  highest COVID-19 deaths
    delimiter $$
    create procedure largest_coronavirus_death_count_registered ()
    begin 
    select location as country,max(cast(total_deaths as unsigned)) as highest_coronavirus_death
    from covid_deaths 
    group by country
    order by highest_coronavirus_death desc;
    end $$
    delimiter ;

-- a view of continents and their highest death rates
CREATE VIEW Higest_death_counts_per_continent AS
    SELECT 
        continent,
        MAX(CAST(total_deaths AS UNSIGNED)) AS highest_coronavirus_death
    FROM
        covid_deaths
    GROUP BY continent
    ORDER BY highest_coronavirus_death DESC;
    
SELECT 
    *
FROM
    covid_vaccinations;
    
    /* comparing countries and their respective citizens 
    who  have  recieved double doses or more of a vaccine */
    
SELECT 
    location AS country,
    population,
    MAX(CAST(people_fully_vaccinated AS UNSIGNED)) AS fully_vaxed
FROM
    covid_vaccinations
GROUP BY country;
   
   -- a view of fully vaccinated citizens by country
CREATE VIEW citizens_fully_vaxed AS
    SELECT 
        location AS country,
        population,
        MAX(CAST(people_fully_vaccinated AS UNSIGNED)) AS fully_vaxed
    FROM
        covid_vaccinations
    GROUP BY country;

/* finding the percentage of fully vaccinated citizens for each country 
and assigning conditions of whether a country will  reach herd immunity or not using case statements. */
SELECT 
    location AS country,
    population,
    MAX(CAST(people_fully_vaccinated AS UNSIGNED)) AS fully_vaxed,
    ROUND((MAX(CAST(people_fully_vaccinated AS UNSIGNED)) / population),
            2) * 100 AS percentage_of_fully_vaxed_citizens,
    CASE
        WHEN
            ROUND((MAX(CAST(people_fully_vaccinated AS UNSIGNED)) / population),
                    2) * 100 >= 49.5
        THEN
            'likely_to_reach_herd_immunity'
        ELSE 'unlikely_to_reach_herd_immunity'
    END AS Herd_immunity_status
FROM
    covid_vaccinations
GROUP BY country;

-- creating a view for herd immunity 
CREATE VIEW Herd_immunity AS
    SELECT 
        location AS country,
        population,
        MAX(CAST(people_fully_vaccinated AS UNSIGNED)) AS fully_vaxed,
        ROUND((MAX(CAST(people_fully_vaccinated AS UNSIGNED)) / population),
                2) * 100 AS percentage_of_fully_vaxed_citizens,
        CASE
            WHEN
                ROUND((MAX(CAST(people_fully_vaccinated AS UNSIGNED)) / population),
                        2) * 100 >= 49.5
            THEN
                'likely_to_reach_herd_immunity'
            ELSE 'unlikely_to_reach_herd_immunity'
        END AS Herd_immunity_status
    FROM
        covid_vaccinations
    GROUP BY country
    ORDER BY percentage_of_fully_vaxed_citizens DESC;
    
   --  A stored procedure for finding a country and its related COVID-19 data using the 'IN'  parameter. 
    delimiter &&
    create procedure country_analysis(in p_country text)
    begin
    SELECT 
    location AS country,
    population,
    MAX(CAST(people_fully_vaccinated AS UNSIGNED)) AS fully_vaxed,
    ROUND((MAX(CAST(people_fully_vaccinated AS UNSIGNED)) / population),
            2) * 100 AS percentage_of_fully_vaxed_citizens,
    CASE
        WHEN
            ROUND((MAX(CAST(people_fully_vaccinated AS UNSIGNED)) / population),
                    2) * 100 >= 49.5
        THEN
            'likely_to_reach_herd_immunity'
        ELSE 'unlikely_to_reach_herd_immunity'
    END AS Herd_immunity_status
FROM
    covid_vaccinations
    where location = p_country;
    end &&
   delimiter ;
  
  -- calling-out the procedure. 
   call country_analysis('South Africa') ; 
   
    
    
    
    
    



    
    

