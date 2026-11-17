# COVID-19 SQL Analysis

I took two raw COVID-19 CSV files, cleaned them in PostgreSQL using a bronze / silver / gold structure, answered six questions with SQL, and built a Tableau dashboard from the results.

[**View the interactive dashboard on Tableau Public**](https://public.tableau.com/shared/47FHYG57T?:display_count=n&:origin=viz_share_link)

<img src="screenshots/dashboard.png" alt="COVID-19 dashboard" width="800">

**Data:** [Our World in Data COVID-19 dataset](https://github.com/owid/covid-19-data), 85,171 rows per file, 1 January 2020 to 30 April 2021, 210 countries.
**Tools:** PostgreSQL, pgAdmin 4, Tableau Public.
**SQL used:** joins, CTEs, window functions (`LAG`, `RANK`, running totals), `DISTINCT ON`, `HAVING`, date functions, type casting and data cleaning.

## How dataset it's built

| Layer | Schema | What it holds |
|---|---|---|
| Bronze | `bronze` | Raw CSV data, all TEXT |
| Silver | `silver` | Cleaned and correctly typed |
| Gold | `gold` | Views for the dashboard |

To reproduce it, run the scripts in `sql/` in this order:

1. `01_create_schemas_and_bronze_tables.sql`
2. `02_import_bronze.md` (import the CSVs)
3. `03_silver_coviddeaths.sql`
4. `04_silver_covidvaccinations.sql`
5. `05_data_quality_checks.sql`
6. `06_gold_views.sql`
7. `07_analysis_queries.sql`

The questions I set out to answer are in [docs/business_questions.md](docs/business_questions.md). The raw CSV files aren't in the repo, so download them from the source above.

## Key findings

- **Infection:** 8 of 190 countries had over 10% of their population confirmed infected (Andorra 17.1%, Czechia 15.2%), while 81 had under 1%. Nigeria was 0.08% and the US 9.8%.
- **Deaths by continent:** Europe (32%), North America (27%) and South America (21%) account for about 80% of the 3.18 million confirmed deaths. Africa is 3.8%.
- **Death percentage:** ranges from 19.4% (Yemen) to 0.05% (Singapore). The differences largely reflect testing, not how deadly the virus was.
- **Trend:** monthly deaths peaked in January 2021 (411,021), and monthly cases peaked in April 2021 (22.5 million).
- **Vaccination:** by 30 April 2021, Israel had given 121 doses per 100 people, the US 69, the UK 68, India 10 and South Africa 0.5. Coverage alone didn't explain death rates across countries.

## Limitations

- Confirmed cases depend on how much each country tested, so comparing countries needs care.
- The two CSV files share 35 identical columns, so the join between them adds no new data.
- Daily vaccination figures (`new_vaccinations`) are reported on only about 9% of rows, so running totals undercount.
- The data ends on 30 April 2021, which is too early to judge how well vaccines worked.

## Next steps

This version stops at April 2021. I plan to rerun the pipeline on newer data to cover the Omicron wave and booster doses, and to test whether countries that tested more recorded higher infection rates, which I left out of this version.

## AI assistance

I used AI (Claude) for guidance, code review and debugging while building this project. I ran every script, checked the results against the data, and I can explain each step.
