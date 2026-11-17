/* 07 | Analysis queries
   Overview: answers six business questions on infections, deaths and vaccination.
   Note: confirmed counts depend on testing; each query has its finding below it. */

-- PERCENTAGE OF POPULATION INFECTED PER COUNTRY 
SELECT location, population,
       MAX(total_cases) AS total_cases,
       ROUND(MAX(total_cases)::numeric / population * 100, 2) AS pct_infected
FROM silver.coviddeaths
WHERE continent IS NOT NULL
  AND total_cases IS NOT NULL
GROUP BY location, population
ORDER BY pct_infected DESC NULLS LAST; -- 8/190 countries with data had more than 10% of their population infected, while 81 had less than 1%. 
--The top four were all European countries (Andorra 17.1%, Montenegro 15.5%, Czechia 15.2%, San Marino 14.9%). Three of them are very small countries, where a few thousand cases move the percentage a lot; Czechia is the exception. 

--CONTINENTS WITH MOST DEATHS 
WITH country_deaths AS (
    SELECT continent, location, MAX(total_deaths) AS country_deaths
    FROM silver.coviddeaths
    WHERE continent IS NOT NULL
    GROUP BY continent, location
)
SELECT continent,
       SUM(country_deaths) AS total_deaths,
       ROUND(SUM(country_deaths) * 100.0 / SUM(SUM(country_deaths)) OVER (), 1) AS pct_of_world
FROM country_deaths
GROUP BY continent
ORDER BY total_deaths DESC;--Europe recorded 1,016,750 confirmed deaths (32.0% of the world total), followed by North America (26.7%) and South America (21.1%). 
--Together those three account for about 80% of the roughly 3.18 million deaths, and Africa was at 3.8% (121,784) at time of recording. 
--NB; Africa has far fewer confirmed deaths than its share of the world’s population, which may point to limited testing and reporting rather than the true number.

--DEATH PERCENTAGE PER COUNTRY (countries with 1,000+ cases)
SELECT location,
       MAX(total_cases)  AS total_cases,
       MAX(total_deaths) AS total_deaths,
       ROUND(MAX(total_deaths)::numeric / NULLIF(MAX(total_cases), 0) * 100, 2) AS death_pct
FROM silver.coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_cases) >= 1000
ORDER BY death_pct DESC NULLS LAST;--Across 177 countries, the death percentage ranged from 19.41% in Yemen to 0.05% in Singapore. South Africa was 3.44% and the US 1.78%.
--These differences largely reflect testing, since countries that only test their sickest patients show higher death percentages.

---GLOBAL NEW CASES AND DEATHS BY MONTH (incl. % change vs previous month)
WITH monthly AS (
    SELECT date_trunc('month', date)::date AS month,
           SUM(new_cases)  AS new_cases,
           SUM(new_deaths) AS new_deaths
    FROM silver.coviddeaths
    WHERE continent IS NOT NULL
    GROUP BY date_trunc('month', date)
)
SELECT month,
       new_cases,
       ROUND((new_cases - LAG(new_cases) OVER (ORDER BY month))::numeric
             / NULLIF(LAG(new_cases) OVER (ORDER BY month), 0) * 100, 1) AS cases_pct_change,
       new_deaths,
       ROUND((new_deaths - LAG(new_deaths) OVER (ORDER BY month))::numeric
             / NULLIF(LAG(new_deaths) OVER (ORDER BY month), 0) * 100, 1) AS deaths_pct_change
FROM monthly
ORDER BY month;--Monthly deaths peaked in January 2021 at 411,021, but cases peaked later, in April 2021, at 22.5 million. 
--Cases decreased by 42.7% in February 2021 and then rose again for two months. 
--The huge percentage changes in early 2020 (+947.7% in March) come from small starting numbers, making the numbers seem more dramatic than they were.

---ROLLING VACCINATIONS PER 100 PEOPLE, (5 selected countries)
WITH rolling AS (
    SELECT d.location,
           d.date,
           d.population,
           v.new_vaccinations,
           SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_doses
    FROM silver.coviddeaths d
    JOIN silver.covidvaccinations v
      ON d.location = v.location
     AND d.date = v.date
    WHERE d.location IN ('South Africa', 'United States', 'United Kingdom', 'India', 'Israel')
)
SELECT location,
       date,
       new_vaccinations,
       rolling_doses,
       ROUND(rolling_doses::numeric / population * 100, 2) AS doses_per_100
FROM rolling
WHERE rolling_doses IS NOT NULL
ORDER BY location, date;
--By the end of the data (30 April 2021), Israel had given 121.3 doses per 100 people, the US 68.8, the UK 67.9, India 10.3 and South Africa 0.5. 
--Israel is above 100 because the column counts doses, not people. 
--Daily vaccination figures are only reported on about 9% of rows (41 of South Africa’s 449 days), so the running total undercounts. 
--South Africa’s sum is 283,606 against a reported total of 317,656.

---VACCINATION COVERAGE VS OUTCOMES?
WITH latest_vax AS (
    -- latest non-null coverage per country
    SELECT DISTINCT ON (location)
           location,
           people_vaccinated_per_hundred AS pct_vaccinated
    FROM silver.covidvaccinations
    WHERE continent IS NOT NULL
      AND people_vaccinated_per_hundred IS NOT NULL
    ORDER BY location, date DESC
),
outcomes AS (
    SELECT location,
           MAX(population)   AS population,
           MAX(total_cases)  AS total_cases,
           MAX(total_deaths) AS total_deaths
    FROM silver.coviddeaths
    WHERE continent IS NOT NULL
    GROUP BY location
)
SELECT RANK() OVER (ORDER BY lv.pct_vaccinated DESC) AS vax_rank,
       o.location,
       lv.pct_vaccinated,
       ROUND(o.total_deaths::numeric / NULLIF(o.total_cases, 0) * 100, 2) AS death_pct,
       ROUND(o.total_deaths::numeric / o.population * 1000000, 0)         AS deaths_per_million
FROM outcomes o
JOIN latest_vax lv ON lv.location = o.location
WHERE o.population > 1000000
ORDER BY vax_rank;--Across 138 countries with over a million people, Israel had the highest coverage (62.4%), followed by the UAE (51.4%), the UK (50.4%) and the US (43.3%).
--The outcomes varied widely: 160 deaths per million in the UAE, 735 in Israel, but 1,882 in the UK and 2,851 in Hungary (41.6% coverage).
--Coverage alone doesn’t explain deaths here, because the data stops in April 2021 and most countries had only just started vaccinating. 
--NB; So this dataset can’t show whether vaccines work.
