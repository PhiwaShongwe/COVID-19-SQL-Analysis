/* 05 | Data quality checks
   Overview: read-only checks proving silver is complete and trustworthy.
   Note: expected result is shown above each check. */

-- 1. No rows lost between bronze and silver (expect 85171 in all four)
SELECT 'bronze.coviddeaths' AS tbl, COUNT(*) AS row_count FROM bronze.coviddeaths
UNION ALL SELECT 'silver.coviddeaths',       COUNT(*) FROM silver.coviddeaths
UNION ALL SELECT 'bronze.covidvaccinations', COUNT(*) FROM bronze.covidvaccinations
UNION ALL SELECT 'silver.covidvaccinations', COUNT(*) FROM silver.covidvaccinations;

-- 2. One row per location per day (expect no rows)
SELECT location, date, COUNT(*) FROM silver.coviddeaths
GROUP BY location, date HAVING COUNT(*) > 1;

SELECT location, date, COUNT(*) FROM silver.covidvaccinations
GROUP BY location, date HAVING COUNT(*) > 1;

-- 3. All dates parsed (expect 0)
SELECT COUNT(*) AS null_dates FROM silver.coviddeaths WHERE date IS NULL;

-- 4. Date range (expect 2020-01-01 to 2021-04-30)
SELECT MIN(date) AS first_date, MAX(date) AS last_date FROM silver.coviddeaths;

-- 5. Tables join one-to-one (expect 85171)
SELECT COUNT(*) AS joined_rows
FROM silver.coviddeaths d
JOIN silver.covidvaccinations v ON d.location = v.location AND d.date = v.date;

-- 6. Aggregates vs countries (expect 9 aggregates, 210 countries)
--    Aggregates have a NULL continent and must be excluded from country totals.
SELECT DISTINCT location FROM silver.coviddeaths WHERE continent IS NULL ORDER BY location;

SELECT COUNT(DISTINCT location) AS countries
FROM silver.coviddeaths WHERE continent IS NOT NULL;

-- 7. Deaths never exceed cases (expect 0)
SELECT COUNT(*) AS deaths_exceed_cases FROM silver.coviddeaths WHERE total_deaths > total_cases;

-- 8. Negative daily values = countries revising counts down (expect 61 and 83). Kept as source data.
SELECT COUNT(*) FILTER (WHERE new_cases  < 0) AS negative_new_cases,
       COUNT(*) FILTER (WHERE new_deaths < 0) AS negative_new_deaths
FROM silver.coviddeaths;

-- 9. Missing values in country rows (expect population NULL 100, total_cases NULL 2094)
--    NULL means "not reported" and is never treated as 0.
SELECT COUNT(*)                                     AS country_rows,
       COUNT(*) FILTER (WHERE population  IS NULL)  AS null_population,
       COUNT(*) FILTER (WHERE total_cases IS NULL)  AS null_total_cases,
       COUNT(*) FILTER (WHERE total_deaths IS NULL) AS null_total_deaths
FROM silver.coviddeaths WHERE continent IS NOT NULL;
