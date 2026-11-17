/* 01 | Schemas and bronze tables
   Overview: creates the bronze / silver / gold schemas and the raw landing tables.
   Note: bronze columns are all TEXT so the import never fails. Types are fixed in silver.
         Safe to re-run. */

CREATE SCHEMA IF NOT EXISTS bronze;   -- raw data
CREATE SCHEMA IF NOT EXISTS silver;   -- cleaned and typed
CREATE SCHEMA IF NOT EXISTS gold;     -- analysis-ready views

-- bronze.coviddeaths (CovidDeaths.csv)
CREATE TABLE IF NOT EXISTS bronze.coviddeaths (
    -- Identifiers and date
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date TEXT,
    -- Cases and deaths (counts)
    total_cases TEXT,
    new_cases TEXT,
    new_cases_smoothed TEXT,
    total_deaths TEXT,
    new_deaths TEXT,
    new_deaths_smoothed TEXT,
    -- Cases and deaths (per million people)
    total_cases_per_million TEXT,
    new_cases_per_million TEXT,
    new_cases_smoothed_per_million TEXT,
    total_deaths_per_million TEXT,
    new_deaths_per_million TEXT,
    new_deaths_smoothed_per_million TEXT,
    -- Reproduction rate and hospital / ICU load
    reproduction_rate TEXT,
    icu_patients TEXT,
    icu_patients_per_million TEXT,
    hosp_patients TEXT,
    hosp_patients_per_million TEXT,
    weekly_icu_admissions TEXT,
    weekly_icu_admissions_per_million TEXT,
    weekly_hosp_admissions TEXT,
    weekly_hosp_admissions_per_million TEXT,
    -- Testing
    new_tests TEXT,
    total_tests TEXT,
    total_tests_per_thousand TEXT,
    new_tests_per_thousand TEXT,
    new_tests_smoothed TEXT,
    new_tests_smoothed_per_thousand TEXT,
    positive_rate TEXT,
    tests_per_case TEXT,
    tests_units TEXT,
    -- Vaccinations
    total_vaccinations TEXT,
    people_vaccinated TEXT,
    people_fully_vaccinated TEXT,
    new_vaccinations TEXT,
    new_vaccinations_smoothed TEXT,
    total_vaccinations_per_hundred TEXT,
    people_vaccinated_per_hundred TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    new_vaccinations_smoothed_per_million TEXT,
    -- Government response
    stringency_index TEXT,
    -- Country demographics and health context
    population TEXT,
    population_density TEXT,
    median_age TEXT,
    aged_65_older TEXT,
    aged_70_older TEXT,
    gdp_per_capita TEXT,
    extreme_poverty TEXT,
    cardiovasc_death_rate TEXT,
    diabetes_prevalence TEXT,
    female_smokers TEXT,
    male_smokers TEXT,
    handwashing_facilities TEXT,
    hospital_beds_per_thousand TEXT,
    life_expectancy TEXT,
    human_development_index TEXT
);

-- bronze.covidvaccinations (CovidVaccinations.csv)
CREATE TABLE IF NOT EXISTS bronze.covidvaccinations (
    -- Identifiers and date
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date TEXT,
    -- Testing
    new_tests TEXT,
    total_tests TEXT,
    total_tests_per_thousand TEXT,
    new_tests_per_thousand TEXT,
    new_tests_smoothed TEXT,
    new_tests_smoothed_per_thousand TEXT,
    positive_rate TEXT,
    tests_per_case TEXT,
    tests_units TEXT,
    -- Vaccinations
    total_vaccinations TEXT,
    people_vaccinated TEXT,
    people_fully_vaccinated TEXT,
    new_vaccinations TEXT,
    new_vaccinations_smoothed TEXT,
    total_vaccinations_per_hundred TEXT,
    people_vaccinated_per_hundred TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    new_vaccinations_smoothed_per_million TEXT,
    -- Government response
    stringency_index TEXT,
    -- Country demographics and health context
    population_density TEXT,
    median_age TEXT,
    aged_65_older TEXT,
    aged_70_older TEXT,
    gdp_per_capita TEXT,
    extreme_poverty TEXT,
    cardiovasc_death_rate TEXT,
    diabetes_prevalence TEXT,
    female_smokers TEXT,
    male_smokers TEXT,
    handwashing_facilities TEXT,
    hospital_beds_per_thousand TEXT,
    life_expectancy TEXT,
    human_development_index TEXT
);
