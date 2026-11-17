/* 04 | Silver: covidvaccinations
   Overview: rebuilds silver.covidvaccinations from bronze with correct data types.
   Note: same cleaning rules as 03. Joins 1:1 with coviddeaths on (location, date).
         Safe to re-run. */

DROP TABLE IF EXISTS silver.covidvaccinations;

CREATE TABLE silver.covidvaccinations (
    -- Identifiers and date
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date DATE,
    -- Testing
    new_tests BIGINT,
    total_tests BIGINT,
    total_tests_per_thousand NUMERIC,
    new_tests_per_thousand NUMERIC,
    new_tests_smoothed BIGINT,
    new_tests_smoothed_per_thousand NUMERIC,
    positive_rate NUMERIC,
    tests_per_case NUMERIC,
    tests_units TEXT,
    -- Vaccinations
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    new_vaccinations BIGINT,
    new_vaccinations_smoothed BIGINT,
    total_vaccinations_per_hundred NUMERIC,
    people_vaccinated_per_hundred NUMERIC,
    people_fully_vaccinated_per_hundred NUMERIC,
    new_vaccinations_smoothed_per_million BIGINT,
    -- Government response
    stringency_index NUMERIC,
    -- Country demographics and health context
    population_density NUMERIC,
    median_age NUMERIC,
    aged_65_older NUMERIC,
    aged_70_older NUMERIC,
    gdp_per_capita NUMERIC,
    extreme_poverty NUMERIC,
    cardiovasc_death_rate NUMERIC,
    diabetes_prevalence NUMERIC,
    female_smokers NUMERIC,
    male_smokers NUMERIC,
    handwashing_facilities NUMERIC,
    hospital_beds_per_thousand NUMERIC,
    life_expectancy NUMERIC,
    human_development_index NUMERIC
);

INSERT INTO silver.covidvaccinations
SELECT
    -- Identifiers and date
    NULLIF(iso_code, '') AS iso_code,
    NULLIF(continent, '') AS continent,
    NULLIF(location, '') AS location,
    to_date(NULLIF(date, ''), 'YYYY/MM/DD') AS date,
    -- Testing
    NULLIF(replace(new_tests, ',', '.'), '')::bigint AS new_tests,
    NULLIF(replace(total_tests, ',', '.'), '')::bigint AS total_tests,
    NULLIF(replace(total_tests_per_thousand, ',', '.'), '')::numeric AS total_tests_per_thousand,
    NULLIF(replace(new_tests_per_thousand, ',', '.'), '')::numeric AS new_tests_per_thousand,
    NULLIF(replace(new_tests_smoothed, ',', '.'), '')::bigint AS new_tests_smoothed,
    NULLIF(replace(new_tests_smoothed_per_thousand, ',', '.'), '')::numeric AS new_tests_smoothed_per_thousand,
    NULLIF(replace(positive_rate, ',', '.'), '')::numeric AS positive_rate,
    NULLIF(replace(tests_per_case, ',', '.'), '')::numeric AS tests_per_case,
    NULLIF(tests_units, '') AS tests_units,
    -- Vaccinations
    NULLIF(replace(total_vaccinations, ',', '.'), '')::bigint AS total_vaccinations,
    NULLIF(replace(people_vaccinated, ',', '.'), '')::bigint AS people_vaccinated,
    NULLIF(replace(people_fully_vaccinated, ',', '.'), '')::bigint AS people_fully_vaccinated,
    NULLIF(replace(new_vaccinations, ',', '.'), '')::bigint AS new_vaccinations,
    NULLIF(replace(new_vaccinations_smoothed, ',', '.'), '')::bigint AS new_vaccinations_smoothed,
    NULLIF(replace(total_vaccinations_per_hundred, ',', '.'), '')::numeric AS total_vaccinations_per_hundred,
    NULLIF(replace(people_vaccinated_per_hundred, ',', '.'), '')::numeric AS people_vaccinated_per_hundred,
    NULLIF(replace(people_fully_vaccinated_per_hundred, ',', '.'), '')::numeric AS people_fully_vaccinated_per_hundred,
    NULLIF(replace(new_vaccinations_smoothed_per_million, ',', '.'), '')::bigint AS new_vaccinations_smoothed_per_million,
    -- Government response
    NULLIF(replace(stringency_index, ',', '.'), '')::numeric AS stringency_index,
    -- Country demographics and health context
    NULLIF(replace(population_density, ',', '.'), '')::numeric AS population_density,
    NULLIF(replace(median_age, ',', '.'), '')::numeric AS median_age,
    NULLIF(replace(aged_65_older, ',', '.'), '')::numeric AS aged_65_older,
    NULLIF(replace(aged_70_older, ',', '.'), '')::numeric AS aged_70_older,
    NULLIF(replace(gdp_per_capita, ',', '.'), '')::numeric AS gdp_per_capita,
    NULLIF(replace(extreme_poverty, ',', '.'), '')::numeric AS extreme_poverty,
    NULLIF(replace(cardiovasc_death_rate, ',', '.'), '')::numeric AS cardiovasc_death_rate,
    NULLIF(replace(diabetes_prevalence, ',', '.'), '')::numeric AS diabetes_prevalence,
    NULLIF(replace(female_smokers, ',', '.'), '')::numeric AS female_smokers,
    NULLIF(replace(male_smokers, ',', '.'), '')::numeric AS male_smokers,
    NULLIF(replace(handwashing_facilities, ',', '.'), '')::numeric AS handwashing_facilities,
    NULLIF(replace(hospital_beds_per_thousand, ',', '.'), '')::numeric AS hospital_beds_per_thousand,
    NULLIF(replace(life_expectancy, ',', '.'), '')::numeric AS life_expectancy,
    NULLIF(replace(human_development_index, ',', '.'), '')::numeric AS human_development_index
FROM bronze.covidvaccinations;
