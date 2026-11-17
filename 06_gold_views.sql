/* 06 | Gold views for Tableau
   Overview: a country dimension, a daily fact table and two summary views, built from silver.
   Note: countries only (continent IS NOT NULL), so World / continent rows are excluded.
         Run in this order, the later views read from the earlier ones. */

-- One row per country: static attributes (population, age, GDP...)
CREATE OR REPLACE VIEW gold.dim_country AS
SELECT location,
       MAX(iso_code)                   AS iso_code,
       MAX(continent)                  AS continent,
       MAX(population)                 AS population,
       MAX(population_density)         AS population_density,
       MAX(median_age)                 AS median_age,
       MAX(aged_65_older)              AS aged_65_older,
       MAX(gdp_per_capita)             AS gdp_per_capita,
       MAX(hospital_beds_per_thousand) AS hospital_beds_per_thousand,
       MAX(life_expectancy)            AS life_expectancy,
       MAX(human_development_index)    AS human_development_index
FROM silver.coviddeaths
WHERE continent IS NOT NULL
GROUP BY location;


-- One row per country per day: deaths table joined to vaccinations table
CREATE OR REPLACE VIEW gold.fact_country_daily AS
SELECT d.location,
       d.date,
       d.new_cases,
       d.total_cases,
       d.new_deaths,
       d.total_deaths,
       d.new_cases_smoothed,
       d.new_deaths_smoothed,
       d.total_deaths_per_million,
       v.total_tests,
       v.total_vaccinations,
       v.people_vaccinated,
       v.people_fully_vaccinated,
       v.new_vaccinations,
       v.people_vaccinated_per_hundred,
       v.stringency_index,
       ROUND(d.total_deaths::numeric / NULLIF(d.total_cases, 0) * 100, 2) AS death_pct
FROM silver.coviddeaths d
JOIN silver.covidvaccinations v
  ON d.location = v.location
 AND d.date     = v.date
WHERE d.continent IS NOT NULL;


-- One row per country: final totals, rates and latest vaccination coverage
CREATE OR REPLACE VIEW gold.country_summary AS
WITH totals AS (
    SELECT location,
           MAX(total_cases)  AS total_cases,
           MAX(total_deaths) AS total_deaths,
           MAX(total_tests)  AS total_tests
    FROM gold.fact_country_daily
    GROUP BY location
),
latest_vax AS (
    -- latest NON-NULL value; the last row by date is often empty
    SELECT DISTINCT ON (location)
           location,
           people_vaccinated_per_hundred AS pct_vaccinated
    FROM gold.fact_country_daily
    WHERE people_vaccinated_per_hundred IS NOT NULL
    ORDER BY location, date DESC
)
SELECT c.location,
       c.iso_code,
       c.continent,
       c.population,
       c.median_age,
       c.gdp_per_capita,
       t.total_cases,
       t.total_deaths,
       ROUND(t.total_cases::numeric  / c.population * 100, 3)                AS infection_pct,
       ROUND(t.total_deaths::numeric / NULLIF(t.total_cases, 0) * 100, 2)    AS death_pct,
       ROUND(t.total_deaths::numeric / c.population * 1000000, 1)            AS deaths_per_million,
       ROUND(t.total_tests::numeric  / c.population * 1000, 1)               AS tests_per_1000,
       v.pct_vaccinated
FROM gold.dim_country c
JOIN totals t ON t.location = c.location
LEFT JOIN latest_vax v ON v.location = c.location;


-- One row per month per continent: for trend charts
CREATE OR REPLACE VIEW gold.monthly_by_continent AS
SELECT date_trunc('month', f.date)::date AS month,
       c.continent,
       SUM(f.new_cases)  AS new_cases,
       SUM(f.new_deaths) AS new_deaths
FROM gold.fact_country_daily f
JOIN gold.dim_country c ON c.location = f.location
GROUP BY date_trunc('month', f.date), c.continent;
