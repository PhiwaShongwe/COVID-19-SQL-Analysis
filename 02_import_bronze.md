# 02 | Import CSVs into bronze

pgAdmin 4: right-click the table > **Import/Export Data** > Import, then set:
**Format** csv | **Encoding** UTF8 | **Header** on | **Delimiter** `;`

| Table | File |
|---|---|
| `bronze.coviddeaths` | `CovidDeaths.csv` |
| `bronze.covidvaccinations` | `CovidVaccinations.csv` |

Check: both tables should have **85,171** rows.
Note: importing appends rows. Run `TRUNCATE bronze.coviddeaths, bronze.covidvaccinations;` before re-importing.
