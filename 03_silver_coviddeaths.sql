/* 03 | Silver: coviddeaths
   Overview: rebuilds silver.coviddeaths from bronze with correct data types.
   Note: '' -> NULL, decimal commas -> dots, text dates -> DATE.
         Aggregate rows (World, continents) are kept here and filtered out in gold.
         Safe to re-run. */

DROP TABLE IF EXISTS silver.coviddeaths;

CREATE TABLE silver.coviddeaths (
    -- Identifiers and date
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date DATE,
    -- Cases and deaths (counts)
    total_cases BIGINT,
    new_cases BIGINT,
    new_cases_smoothed NUMERIC,
    total_deaths BIGINT,
    new_deaths BIGINT,
    new_deaths_smoothed NUMERIC,
    -- Cases and deaths (per million people)
    total_cases_per_million NUMERIC,
    new_cases_per_million NUMERIC,
    new_cases_smoothed_per_million NUMERIC,
    total_deaths_per_million NUMERIC,
    new_deaths_per_million NUMERIC,
    new_deaths_smoothed_per_million NUMERIC,
    -- Reproduction rate and hospital / ICU load
    reproduction_rate NUMERIC,
    icu_patients BIGINT,
    icu_patients_per_million NUMERIC,
    hosp_patients BIGINT,
    hosp_patients_per_million NUMERIC,
    weekly_icu_admissions NUMERIC,
    weekly_icu_admissions_per_million NUMERIC,
    weekly_hosp_admissions NUMERIC,
    weekly_hosp_admissions_per_million NUMERIC,
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
    population BIGINT,
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

INSERT INTO silver.coviddeaths
SELECT
    -- Identifiers and date
    NULLIF(iso_code, '') AS iso_code,
    NULLIF(continent, '') AS continent,
    NULLIF(location, '') AS location,
    to_date(NULLIF(date, ''), 'YYYY/MM/DD') AS date,
    -- Cases and deaths (counts)
    NULLIF(replace(total_cases, ',', '.'), '')::bigint AS total_cases,
    NULLIF(replace(new_cases, ',', '.'), '')::bigint AS new_cases,
    NULLIF(replace(new_cases_smoothed, ',', '.'), '')::numeric AS new_cases_smoothed,
    NULLIF(replace(total_deaths, ',', '.'), '')::bigint AS total_deaths,
    NULLIF(replace(new_deaths, ',', '.'), '')::bigint AS new_deaths,
    NULLIF(replace(new_deaths_smoothed, ',', '.'), '')::numeric AS new_deaths_smoothed,
    -- Cases and deaths (per million people)
    NULLIF(replace(total_cases_per_million, ',', '.'), '')::numeric AS total_cases_per_million,
    NULLIF(replace(new_cases_per_million, ',', '.'), '')::numeric AS new_cases_per_million,
    NULLIF(replace(new_cases_smoothed_per_million, ',', '.'), '')::numeric AS new_cases_smoothed_per_million,
    NULLIF(replace(total_deaths_per_million, ',', '.'), '')::numeric AS total_deaths_per_million,
    NULLIF(replace(new_deaths_per_million, ',', '.'), '')::numeric AS new_deaths_per_million,
    NULLIF(replace(new_deaths_smoothed_per_million, ',', '.'), '')::numeric AS new_deaths_smoothed_per_million,
    -- Reproduction rate and hospital / ICU load
    NULLIF(replace(reproduction_rate, ',', '.'), '')::numeric AS reproduction_rate,
    NULLIF(replace(icu_patients, ',', '.'), '')::bigint AS icu_patients,
    NULLIF(replace(icu_patients_per_million, ',', '.'), '')::numeric AS icu_patients_per_million,
    NULLIF(replace(hosp_patients, ',', '.'), '')::bigint AS hosp_patients,
    NULLIF(replace(hosp_patients_per_million, ',', '.'), '')::numeric AS hosp_patients_per_million,
    NULLIF(replace(weekly_icu_admissions, ',', '.'), '')::numeric AS weekly_icu_admissions,
    NULLIF(replace(weekly_icu_admissions_per_million, ',', '.'), '')::numeric AS weekly_icu_admissions_per_million,
    NULLIF(replace(weekly_hosp_admissions, ',', '.'), '')::numeric AS weekly_hosp_admissions,
    NULLIF(replace(weekly_hosp_admissions_per_million, ',', '.'), '')::numeric AS weekly_hosp_admissions_per_million,
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
    NULLIF(replace(population, ',', '.'), '')::bigint AS population,
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
FROM bronze.coviddeaths;
