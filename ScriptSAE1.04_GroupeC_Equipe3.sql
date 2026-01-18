/* Creation des table region, subregion, country area*/

CREATE TABLE continent (
 location_code INTEGER PRIMARY KEY,
 name TEXT NOT NULL
);

INSERT INTO continent(location_code, name)
VALUES 
	(1, 'Afro_Eurasien'),
	(2, 'Américain'),
	(3, 'Océanien');

CREATE TABLE region (
 location_code INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 parent_code INTEGER,
 FOREIGN KEY (parent_code) REFERENCES continent(location_code)
);

INSERT INTO region (location_code, name, parent_code)
SELECT DISTINCT
    "Location code",
    "Region, subregion, country or area",
    CASE
        WHEN "Region, subregion, country or area" IN ('Africa', 'Europe', 'Asia')
            THEN 1
        WHEN "Region, subregion, country or area" IN ('Northern America', 'Latin America and the Caribbean')
            THEN 2
        WHEN "Region, subregion, country or area" = 'Oceania'
            THEN 3
        ELSE NULL
    END
FROM pop
WHERE "Type" = 'Region';

CREATE TABLE subregion (
 location_code INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 parent_code INTEGER,
 FOREIGN KEY (parent_code) REFERENCES region(location_code)
);

INSERT INTO subregion
SELECT DISTINCT
 "Location code",
 "Region, subregion, country or area",
 "Parent code"
FROM pop
WHERE "Type" = 'Subregion';

INSERT INTO subregion (location_code, name, parent_code)
VALUES (905, 'Northern America (sub-region)', 905);

SELECT * FROM country 
WHERE name = 'Canada';

CREATE TABLE country (
 location_code INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 parent_code INTEGER,
 FOREIGN KEY (parent_code) REFERENCES subregion(location_code)
);

INSERT INTO country
SELECT DISTINCT
 "Location code",
 "Region, subregion, country or area",
 "Parent code"
FROM pop
WHERE "Type" = 'Country/Area';

/* Verification */

SELECT
	co.name,
    r.name, 
    s.name, 
    c.name
FROM continent co
JOIN region r ON co.location_code = r.parent_code
JOIN subregion s ON r.location_code = s.parent_code
JOIN country c    ON s.location_code = c.parent_code
WHERE c.name = 'Canada';



-- =====================================================================
-- 1. CRÉATION DE LA TABLE fact_pop_country
-- =====================================================================

CREATE TABLE fact_pop_country (
    fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    location_code INTEGER NOT NULL,
    years INTEGER NOT NULL,
    -- Population totale et démographie de base
    Total_Population_as_of_1_January_thousands REAL,
    Total_Population_as_of_1_July_thousands REAL,
    Male_Population_as_of_1_July_thousands REAL,
    Female_Population_as_of_1_July_thousands REAL,
    Population_Density_as_of_1_July_persons_per_square_km REAL,
    Population_Sex_Ratio_as_of_1_July_males_per_100_females REAL,
    Median_Age_as_of_1_July_years REAL,
    -- Croissance et changements de population
    Natural_Change_Births_minus_Deaths_thousands REAL,
    Rate_of_Natural_Change_per_1000_population REAL,
    Population_Change_thousands REAL,
    Population_Growth_Rate_percentage REAL,
    Population_Annual_Doubling_Time_years REAL,
    -- Naissances et fertilité
    Births_thousands REAL,
    Births_by_women_aged_15_to_19_thousands REAL,
    Crude_Birth_Rate_births_per_1000_population REAL,
    Total_Fertility_Rate_live_births_per_woman REAL,
    Net_Reproduction_Rate_surviving_daughters_per_woman REAL,
    Mean_Age_Childbearing_years REAL,
    Sex_Ratio_at_Birth_males_per_100_female_births REAL,
    -- Décès
    Total_Deaths_thousands REAL,
    Male_Deaths_thousands REAL,
    Female_Deaths_thousands REAL,
    Crude_Death_Rate_deaths_per_1000_population REAL,
    -- Espérance de vie
    Life_Expectancy_at_Birth_both_sexes_years REAL,
    Male_Life_Expectancy_at_Birth_years REAL,
    Female_Life_Expectancy_at_Birth_years REAL,
    Life_Expectancy_at_Age_15_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_15_years REAL,
    Female_Life_Expectancy_at_Age_15_years REAL,
    Life_Expectancy_at_Age_65_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_65_years REAL,
    Female_Life_Expectancy_at_Age_65_years REAL,
    Life_Expectancy_at_Age_80_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_80_years REAL,
    Female_Life_Expectancy_at_Age_80_years REAL,
    -- Mortalité infantile et juvénile
    Infant_Deaths_under_age_1_thousands REAL,
    Infant_Mortality_Rate_infant_deaths_per_1000_live_births REAL,
    Live_Births_Surviving_to_Age_1_thousands REAL,
    Under_Five_Deaths_under_age_5_thousands REAL,
    Under_Five_Mortality_deaths_under_age_5_per_1000_live_births REAL,
    -- Mortalité par âge
    Mortality_before_Age_40_both_sexes_deaths_under_age_40_per_1000_live_births REAL,
    Male_Mortality_before_Age_40_deaths_under_age_40_per_1000_male_live_births REAL,
    Female_Mortality_before_Age_40_deaths_under_age_40_per_1000_female_live_births REAL,
    Mortality_before_Age_60_both_sexes_deaths_under_age_60_per_1000_live_births REAL,
    Male_Mortality_before_Age_60_deaths_under_age_60_per_1000_male_live_births REAL,
    Female_Mortality_before_Age_60_deaths_under_age_60_per_1000_female_live_births REAL,
    Mortality_between_Age_15_and_50_both_sexes_deaths_under_age_50_per_1000_alive_at_age_15 REAL,
    Male_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_males_alive_at_age_15 REAL,
    Female_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_females_alive_at_age_15 REAL,
    Mortality_between_Age_15_and_60_both_sexes_deaths_under_age_60_per_1000_alive_at_age_15 REAL,
    Male_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_males_alive_at_age_15 REAL,
    Female_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_females_alive_at_age_15 REAL,
    -- Migration
    Net_Number_of_Migrants_thousands REAL,
    Net_Migration_Rate_per_1000_population REAL,
    -- Clé étrangère vers country
    FOREIGN KEY (location_code) REFERENCES country(location_code)
);

-- =====================================================================
-- 2. CRÉATION DE LA TABLE fact_pop_region
-- =====================================================================

CREATE TABLE fact_pop_region (
    fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    location_code INTEGER NOT NULL,
    years INTEGER NOT NULL,
    -- Population totale et démographie de base
    Total_Population_as_of_1_January_thousands REAL,
    Total_Population_as_of_1_July_thousands REAL,
    Male_Population_as_of_1_July_thousands REAL,
    Female_Population_as_of_1_July_thousands REAL,
    Population_Density_as_of_1_July_persons_per_square_km REAL,
    Population_Sex_Ratio_as_of_1_July_males_per_100_females REAL,
    Median_Age_as_of_1_July_years REAL,
    -- Croissance et changements de population
    Natural_Change_Births_minus_Deaths_thousands REAL,
    Rate_of_Natural_Change_per_1000_population REAL,
    Population_Change_thousands REAL,
    Population_Growth_Rate_percentage REAL,
    Population_Annual_Doubling_Time_years REAL,
    -- Naissances et fertilité
    Births_thousands REAL,
    Births_by_women_aged_15_to_19_thousands REAL,
    Crude_Birth_Rate_births_per_1000_population REAL,
    Total_Fertility_Rate_live_births_per_woman REAL,
    Net_Reproduction_Rate_surviving_daughters_per_woman REAL,
    Mean_Age_Childbearing_years REAL,
    Sex_Ratio_at_Birth_males_per_100_female_births REAL,
    -- Décès
    Total_Deaths_thousands REAL,
    Male_Deaths_thousands REAL,
    Female_Deaths_thousands REAL,
    Crude_Death_Rate_deaths_per_1000_population REAL,
    -- Espérance de vie
    Life_Expectancy_at_Birth_both_sexes_years REAL,
    Male_Life_Expectancy_at_Birth_years REAL,
    Female_Life_Expectancy_at_Birth_years REAL,
    Life_Expectancy_at_Age_15_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_15_years REAL,
    Female_Life_Expectancy_at_Age_15_years REAL,
    Life_Expectancy_at_Age_65_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_65_years REAL,
    Female_Life_Expectancy_at_Age_65_years REAL,
    Life_Expectancy_at_Age_80_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_80_years REAL,
    Female_Life_Expectancy_at_Age_80_years REAL,
    -- Mortalité infantile et juvénile
    Infant_Deaths_under_age_1_thousands REAL,
    Infant_Mortality_Rate_infant_deaths_per_1000_live_births REAL,
    Live_Births_Surviving_to_Age_1_thousands REAL,
    Under_Five_Deaths_under_age_5_thousands REAL,
    Under_Five_Mortality_deaths_under_age_5_per_1000_live_births REAL,
    -- Mortalité par âge
    Mortality_before_Age_40_both_sexes_deaths_under_age_40_per_1000_live_births REAL,
    Male_Mortality_before_Age_40_deaths_under_age_40_per_1000_male_live_births REAL,
    Female_Mortality_before_Age_40_deaths_under_age_40_per_1000_female_live_births REAL,
    Mortality_before_Age_60_both_sexes_deaths_under_age_60_per_1000_live_births REAL,
    Male_Mortality_before_Age_60_deaths_under_age_60_per_1000_male_live_births REAL,
    Female_Mortality_before_Age_60_deaths_under_age_60_per_1000_female_live_births REAL,
    Mortality_between_Age_15_and_50_both_sexes_deaths_under_age_50_per_1000_alive_at_age_15 REAL,
    Male_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_males_alive_at_age_15 REAL,
    Female_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_females_alive_at_age_15 REAL,
    Mortality_between_Age_15_and_60_both_sexes_deaths_under_age_60_per_1000_alive_at_age_15 REAL,
    Male_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_males_alive_at_age_15 REAL,
    Female_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_females_alive_at_age_15 REAL,
    -- Migration
    Net_Number_of_Migrants_thousands REAL,
    Net_Migration_Rate_per_1000_population REAL,
    -- Clé étrangère vers region
    FOREIGN KEY (location_code) REFERENCES region(location_code)
);

-- =====================================================================
-- 3. CRÉATION DE LA TABLE fact_pop_subregion
-- =====================================================================

CREATE TABLE fact_pop_subregion (
    fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    location_code INTEGER NOT NULL,
    years INTEGER NOT NULL,
    -- Population totale et démographie de base
    Total_Population_as_of_1_January_thousands REAL,
    Total_Population_as_of_1_July_thousands REAL,
    Male_Population_as_of_1_July_thousands REAL,
    Female_Population_as_of_1_July_thousands REAL,
    Population_Density_as_of_1_July_persons_per_square_km REAL,
    Population_Sex_Ratio_as_of_1_July_males_per_100_females REAL,
    Median_Age_as_of_1_July_years REAL,
    -- Croissance et changements de population
    Natural_Change_Births_minus_Deaths_thousands REAL,
    Rate_of_Natural_Change_per_1000_population REAL,
    Population_Change_thousands REAL,
    Population_Growth_Rate_percentage REAL,
    Population_Annual_Doubling_Time_years REAL,
    -- Naissances et fertilité
    Births_thousands REAL,
    Births_by_women_aged_15_to_19_thousands REAL,
    Crude_Birth_Rate_births_per_1000_population REAL,
    Total_Fertility_Rate_live_births_per_woman REAL,
    Net_Reproduction_Rate_surviving_daughters_per_woman REAL,
    Mean_Age_Childbearing_years REAL,
    Sex_Ratio_at_Birth_males_per_100_female_births REAL,
    -- Décès
    Total_Deaths_thousands REAL,
    Male_Deaths_thousands REAL,
    Female_Deaths_thousands REAL,
    Crude_Death_Rate_deaths_per_1000_population REAL,
    -- Espérance de vie
    Life_Expectancy_at_Birth_both_sexes_years REAL,
    Male_Life_Expectancy_at_Birth_years REAL,
    Female_Life_Expectancy_at_Birth_years REAL,
    Life_Expectancy_at_Age_15_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_15_years REAL,
    Female_Life_Expectancy_at_Age_15_years REAL,
    Life_Expectancy_at_Age_65_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_65_years REAL,
    Female_Life_Expectancy_at_Age_65_years REAL,
    Life_Expectancy_at_Age_80_both_sexes_years REAL,
    Male_Life_Expectancy_at_Age_80_years REAL,
    Female_Life_Expectancy_at_Age_80_years REAL,
    -- Mortalité infantile et juvénile
    Infant_Deaths_under_age_1_thousands REAL,
    Infant_Mortality_Rate_infant_deaths_per_1000_live_births REAL,
    Live_Births_Surviving_to_Age_1_thousands REAL,
    Under_Five_Deaths_under_age_5_thousands REAL,
    Under_Five_Mortality_deaths_under_age_5_per_1000_live_births REAL,
    -- Mortalité par âge
    Mortality_before_Age_40_both_sexes_deaths_under_age_40_per_1000_live_births REAL,
    Male_Mortality_before_Age_40_deaths_under_age_40_per_1000_male_live_births REAL,
    Female_Mortality_before_Age_40_deaths_under_age_40_per_1000_female_live_births REAL,
    Mortality_before_Age_60_both_sexes_deaths_under_age_60_per_1000_live_births REAL,
    Male_Mortality_before_Age_60_deaths_under_age_60_per_1000_male_live_births REAL,
    Female_Mortality_before_Age_60_deaths_under_age_60_per_1000_female_live_births REAL,
    Mortality_between_Age_15_and_50_both_sexes_deaths_under_age_50_per_1000_alive_at_age_15 REAL,
    Male_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_males_alive_at_age_15 REAL,
    Female_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_females_alive_at_age_15 REAL,
    Mortality_between_Age_15_and_60_both_sexes_deaths_under_age_60_per_1000_alive_at_age_15 REAL,
    Male_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_males_alive_at_age_15 REAL,
    Female_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_females_alive_at_age_15 REAL,
    -- Migration
    Net_Number_of_Migrants_thousands REAL,
    Net_Migration_Rate_per_1000_population REAL,
    -- Clé étrangère vers subregion
    FOREIGN KEY (location_code) REFERENCES subregion(location_code)
);

-- =====================================================================
-- 4. PEUPLEMENT DE fact_pop_country
-- =====================================================================

INSERT INTO fact_pop_country (
    location_code,
    years,
    Total_Population_as_of_1_January_thousands,
    Total_Population_as_of_1_July_thousands,
    Male_Population_as_of_1_July_thousands,
    Female_Population_as_of_1_July_thousands,
    Population_Density_as_of_1_July_persons_per_square_km,
    Population_Sex_Ratio_as_of_1_July_males_per_100_females,
    Median_Age_as_of_1_July_years,
    Natural_Change_Births_minus_Deaths_thousands,
    Rate_of_Natural_Change_per_1000_population,
    Population_Change_thousands,
    Population_Growth_Rate_percentage,
    Population_Annual_Doubling_Time_years,
    Births_thousands,
    Births_by_women_aged_15_to_19_thousands,
    Crude_Birth_Rate_births_per_1000_population,
    Total_Fertility_Rate_live_births_per_woman,
    Net_Reproduction_Rate_surviving_daughters_per_woman,
    Mean_Age_Childbearing_years,
    Sex_Ratio_at_Birth_males_per_100_female_births,
    Total_Deaths_thousands,
    Male_Deaths_thousands,
    Female_Deaths_thousands,
    Crude_Death_Rate_deaths_per_1000_population,
    Life_Expectancy_at_Birth_both_sexes_years,
    Male_Life_Expectancy_at_Birth_years,
    Female_Life_Expectancy_at_Birth_years,
    Life_Expectancy_at_Age_15_both_sexes_years,
    Male_Life_Expectancy_at_Age_15_years,
    Female_Life_Expectancy_at_Age_15_years,
    Life_Expectancy_at_Age_65_both_sexes_years,
    Male_Life_Expectancy_at_Age_65_years,
    Female_Life_Expectancy_at_Age_65_years,
    Life_Expectancy_at_Age_80_both_sexes_years,
    Male_Life_Expectancy_at_Age_80_years,
    Female_Life_Expectancy_at_Age_80_years,
    Infant_Deaths_under_age_1_thousands,
    Infant_Mortality_Rate_infant_deaths_per_1000_live_births,
    Live_Births_Surviving_to_Age_1_thousands,
    Under_Five_Deaths_under_age_5_thousands,
    Under_Five_Mortality_deaths_under_age_5_per_1000_live_births,
    Mortality_before_Age_40_both_sexes_deaths_under_age_40_per_1000_live_births,
    Male_Mortality_before_Age_40_deaths_under_age_40_per_1000_male_live_births,
    Female_Mortality_before_Age_40_deaths_under_age_40_per_1000_female_live_births,
    Mortality_before_Age_60_both_sexes_deaths_under_age_60_per_1000_live_births,
    Male_Mortality_before_Age_60_deaths_under_age_60_per_1000_male_live_births,
    Female_Mortality_before_Age_60_deaths_under_age_60_per_1000_female_live_births,
    Mortality_between_Age_15_and_50_both_sexes_deaths_under_age_50_per_1000_alive_at_age_15,
    Male_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_males_alive_at_age_15,
    Female_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_females_alive_at_age_15,
    Mortality_between_Age_15_and_60_both_sexes_deaths_under_age_60_per_1000_alive_at_age_15,
    Male_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_males_alive_at_age_15,
    Female_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_females_alive_at_age_15,
    Net_Number_of_Migrants_thousands,
    Net_Migration_Rate_per_1000_population
)
SELECT 
    "Location code",
    "Year",
    REPLACE("Total Population, as of 1 January (thousands)", ',', '.'),
    REPLACE("Total Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Male Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Female Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Population Density, as of 1 July (persons per square km)", ',', '.'),
    REPLACE("Population Sex Ratio, as of 1 July (males per 100 females)", ',', '.'),
    REPLACE("Median Age, as of 1 July (years)", ',', '.'),
    REPLACE("Natural Change, Births minus Deaths (thousands)", ',', '.'),
    REPLACE("Rate of Natural Change (per 1,000 population)", ',', '.'),
    REPLACE("Population Change (thousands)", ',', '.'),
    REPLACE("Population Growth Rate (percentage)", ',', '.'),
    REPLACE("Population Annual Doubling Time (years)", ',', '.'),
    REPLACE("Births (thousands)", ',', '.'),
    REPLACE("Births by women aged 15 to 19 (thousands)", ',', '.'),
    REPLACE("Crude Birth Rate (births per 1,000 population)", ',', '.'),
    REPLACE("Total Fertility Rate (live births per woman)", ',', '.'),
    REPLACE("Net Reproduction Rate (surviving daughters per woman)", ',', '.'),
    REPLACE("Mean Age Childbearing (years)", ',', '.'),
    REPLACE("Sex Ratio at Birth (males per 100 female births)", ',', '.'),
    REPLACE("Total Deaths (thousands)", ',', '.'),
    REPLACE("Male Deaths (thousands)", ',', '.'),
    REPLACE("Female Deaths (thousands)", ',', '.'),
    REPLACE("Crude Death Rate (deaths per 1,000 population)", ',', '.'),
    REPLACE("Life Expectancy at Birth, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Birth (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Birth (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 15, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 15 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 15 (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 65, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 65 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 65 (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 80, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 80 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 80 (years)", ',', '.'),
    REPLACE("Infant Deaths, under age 1 (thousands)", ',', '.'),
    REPLACE("Infant Mortality Rate (infant deaths per 1,000 live births)", ',', '.'),
    REPLACE("Live Births Surviving to Age 1 (thousands)", ',', '.'),
    REPLACE("Under-Five Deaths, under age 5 (thousands)", ',', '.'),
    REPLACE("Under-Five Mortality (deaths under age 5 per 1,000 live births)", ',', '.'),
    REPLACE("Mortality before Age 40, both sexes (deaths under age 40 per 1,000 live births)", ',', '.'),
    REPLACE("Male Mortality before Age 40 (deaths under age 40 per 1,000 male live births)", ',', '.'),
    REPLACE("Female Mortality before Age 40 (deaths under age 40 per 1,000 female live births)", ',', '.'),
    REPLACE("Mortality before Age 60, both sexes (deaths under age 60 per 1,000 live births)", ',', '.'),
    REPLACE("Male Mortality before Age 60 (deaths under age 60 per 1,000 male live births)", ',', '.'),
    REPLACE("Female Mortality before Age 60 (deaths under age 60 per 1,000 female live births)", ',', '.'),
    REPLACE("Mortality between Age 15 and 50, both sexes (deaths under age 50 per 1,000 alive at age 15)", ',', '.'),
    REPLACE("Male Mortality between Age 15 and 50 (deaths under age 50 per 1,000 males alive at age 15)", ',', '.'),
    REPLACE("Female Mortality between Age 15 and 50 (deaths under age 50 per 1,000 females alive at age 15)", ',', '.'),
    REPLACE("Mortality between Age 15 and 60, both sexes (deaths under age 60 per 1,000 alive at age 15)", ',', '.'),
    REPLACE("Male Mortality between Age 15 and 60 (deaths under age 60 per 1,000 males alive at age 15)", ',', '.'),
    REPLACE("Female Mortality between Age 15 and 60 (deaths under age 60 per 1,000 females alive at age 15)", ',', '.'),
    REPLACE("Net Number of Migrants (thousands)", ',', '.'),
    REPLACE("Net Migration Rate (per 1,000 population)", ',', '.')
FROM pop
WHERE "Year" IS NOT NULL
  AND "Location code" IS NOT NULL
  AND "Location code" IN (SELECT location_code FROM country);

-- =====================================================================
-- 5. PEUPLEMENT DE fact_pop_region
-- =====================================================================

INSERT INTO fact_pop_region (
    location_code,
    years,
    Total_Population_as_of_1_January_thousands,
    Total_Population_as_of_1_July_thousands,
    Male_Population_as_of_1_July_thousands,
    Female_Population_as_of_1_July_thousands,
    Population_Density_as_of_1_July_persons_per_square_km,
    Population_Sex_Ratio_as_of_1_July_males_per_100_females,
    Median_Age_as_of_1_July_years,
    Natural_Change_Births_minus_Deaths_thousands,
    Rate_of_Natural_Change_per_1000_population,
    Population_Change_thousands,
    Population_Growth_Rate_percentage,
    Population_Annual_Doubling_Time_years,
    Births_thousands,
    Births_by_women_aged_15_to_19_thousands,
    Crude_Birth_Rate_births_per_1000_population,
    Total_Fertility_Rate_live_births_per_woman,
    Net_Reproduction_Rate_surviving_daughters_per_woman,
    Mean_Age_Childbearing_years,
    Sex_Ratio_at_Birth_males_per_100_female_births,
    Total_Deaths_thousands,
    Male_Deaths_thousands,
    Female_Deaths_thousands,
    Crude_Death_Rate_deaths_per_1000_population,
    Life_Expectancy_at_Birth_both_sexes_years,
    Male_Life_Expectancy_at_Birth_years,
    Female_Life_Expectancy_at_Birth_years,
    Life_Expectancy_at_Age_15_both_sexes_years,
    Male_Life_Expectancy_at_Age_15_years,
    Female_Life_Expectancy_at_Age_15_years,
    Life_Expectancy_at_Age_65_both_sexes_years,
    Male_Life_Expectancy_at_Age_65_years,
    Female_Life_Expectancy_at_Age_65_years,
    Life_Expectancy_at_Age_80_both_sexes_years,
    Male_Life_Expectancy_at_Age_80_years,
    Female_Life_Expectancy_at_Age_80_years,
    Infant_Deaths_under_age_1_thousands,
    Infant_Mortality_Rate_infant_deaths_per_1000_live_births,
    Live_Births_Surviving_to_Age_1_thousands,
    Under_Five_Deaths_under_age_5_thousands,
    Under_Five_Mortality_deaths_under_age_5_per_1000_live_births,
    Mortality_before_Age_40_both_sexes_deaths_under_age_40_per_1000_live_births,
    Male_Mortality_before_Age_40_deaths_under_age_40_per_1000_male_live_births,
    Female_Mortality_before_Age_40_deaths_under_age_40_per_1000_female_live_births,
    Mortality_before_Age_60_both_sexes_deaths_under_age_60_per_1000_live_births,
    Male_Mortality_before_Age_60_deaths_under_age_60_per_1000_male_live_births,
    Female_Mortality_before_Age_60_deaths_under_age_60_per_1000_female_live_births,
    Mortality_between_Age_15_and_50_both_sexes_deaths_under_age_50_per_1000_alive_at_age_15,
    Male_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_males_alive_at_age_15,
    Female_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_females_alive_at_age_15,
    Mortality_between_Age_15_and_60_both_sexes_deaths_under_age_60_per_1000_alive_at_age_15,
    Male_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_males_alive_at_age_15,
    Female_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_females_alive_at_age_15,
    Net_Number_of_Migrants_thousands,
    Net_Migration_Rate_per_1000_population
)
SELECT 
    "Location code",
    "Year",
    REPLACE("Total Population, as of 1 January (thousands)", ',', '.'),
    REPLACE("Total Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Male Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Female Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Population Density, as of 1 July (persons per square km)", ',', '.'),
    REPLACE("Population Sex Ratio, as of 1 July (males per 100 females)", ',', '.'),
    REPLACE("Median Age, as of 1 July (years)", ',', '.'),
    REPLACE("Natural Change, Births minus Deaths (thousands)", ',', '.'),
    REPLACE("Rate of Natural Change (per 1,000 population)", ',', '.'),
    REPLACE("Population Change (thousands)", ',', '.'),
    REPLACE("Population Growth Rate (percentage)", ',', '.'),
    REPLACE("Population Annual Doubling Time (years)", ',', '.'),
    REPLACE("Births (thousands)", ',', '.'),
    REPLACE("Births by women aged 15 to 19 (thousands)", ',', '.'),
    REPLACE("Crude Birth Rate (births per 1,000 population)", ',', '.'),
    REPLACE("Total Fertility Rate (live births per woman)", ',', '.'),
    REPLACE("Net Reproduction Rate (surviving daughters per woman)", ',', '.'),
    REPLACE("Mean Age Childbearing (years)", ',', '.'),
    REPLACE("Sex Ratio at Birth (males per 100 female births)", ',', '.'),
    REPLACE("Total Deaths (thousands)", ',', '.'),
    REPLACE("Male Deaths (thousands)", ',', '.'),
    REPLACE("Female Deaths (thousands)", ',', '.'),
    REPLACE("Crude Death Rate (deaths per 1,000 population)", ',', '.'),
    REPLACE("Life Expectancy at Birth, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Birth (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Birth (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 15, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 15 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 15 (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 65, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 65 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 65 (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 80, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 80 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 80 (years)", ',', '.'),
    REPLACE("Infant Deaths, under age 1 (thousands)", ',', '.'),
    REPLACE("Infant Mortality Rate (infant deaths per 1,000 live births)", ',', '.'),
    REPLACE("Live Births Surviving to Age 1 (thousands)", ',', '.'),
    REPLACE("Under-Five Deaths, under age 5 (thousands)", ',', '.'),
    REPLACE("Under-Five Mortality (deaths under age 5 per 1,000 live births)", ',', '.'),
    REPLACE("Mortality before Age 40, both sexes (deaths under age 40 per 1,000 live births)", ',', '.'),
    REPLACE("Male Mortality before Age 40 (deaths under age 40 per 1,000 male live births)", ',', '.'),
    REPLACE("Female Mortality before Age 40 (deaths under age 40 per 1,000 female live births)", ',', '.'),
    REPLACE("Mortality before Age 60, both sexes (deaths under age 60 per 1,000 live births)", ',', '.'),
    REPLACE("Male Mortality before Age 60 (deaths under age 60 per 1,000 male live births)", ',', '.'),
    REPLACE("Female Mortality before Age 60 (deaths under age 60 per 1,000 female live births)", ',', '.'),
    REPLACE("Mortality between Age 15 and 50, both sexes (deaths under age 50 per 1,000 alive at age 15)", ',', '.'),
    REPLACE("Male Mortality between Age 15 and 50 (deaths under age 50 per 1,000 males alive at age 15)", ',', '.'),
    REPLACE("Female Mortality between Age 15 and 50 (deaths under age 50 per 1,000 females alive at age 15)", ',', '.'),
    REPLACE("Mortality between Age 15 and 60, both sexes (deaths under age 60 per 1,000 alive at age 15)", ',', '.'),
    REPLACE("Male Mortality between Age 15 and 60 (deaths under age 60 per 1,000 males alive at age 15)", ',', '.'),
    REPLACE("Female Mortality between Age 15 and 60 (deaths under age 60 per 1,000 females alive at age 15)", ',', '.'),
    REPLACE("Net Number of Migrants (thousands)", ',', '.'),
    REPLACE("Net Migration Rate (per 1,000 population)", ',', '.')
FROM pop
WHERE "Year" IS NOT NULL
  AND "Location code" IS NOT NULL
  AND "Location code" IN (SELECT location_code FROM region);

-- =====================================================================
-- 6. PEUPLEMENT DE fact_pop_subregion
-- =====================================================================

INSERT INTO fact_pop_subregion (
    location_code,
    years,
    Total_Population_as_of_1_January_thousands,
    Total_Population_as_of_1_July_thousands,
    Male_Population_as_of_1_July_thousands,
    Female_Population_as_of_1_July_thousands,
    Population_Density_as_of_1_July_persons_per_square_km,
    Population_Sex_Ratio_as_of_1_July_males_per_100_females,
    Median_Age_as_of_1_July_years,
    Natural_Change_Births_minus_Deaths_thousands,
    Rate_of_Natural_Change_per_1000_population,
    Population_Change_thousands,
    Population_Growth_Rate_percentage,
    Population_Annual_Doubling_Time_years,
    Births_thousands,
    Births_by_women_aged_15_to_19_thousands,
    Crude_Birth_Rate_births_per_1000_population,
    Total_Fertility_Rate_live_births_per_woman,
    Net_Reproduction_Rate_surviving_daughters_per_woman,
    Mean_Age_Childbearing_years,
    Sex_Ratio_at_Birth_males_per_100_female_births,
    Total_Deaths_thousands,
    Male_Deaths_thousands,
    Female_Deaths_thousands,
    Crude_Death_Rate_deaths_per_1000_population,
    Life_Expectancy_at_Birth_both_sexes_years,
    Male_Life_Expectancy_at_Birth_years,
    Female_Life_Expectancy_at_Birth_years,
    Life_Expectancy_at_Age_15_both_sexes_years,
    Male_Life_Expectancy_at_Age_15_years,
    Female_Life_Expectancy_at_Age_15_years,
    Life_Expectancy_at_Age_65_both_sexes_years,
    Male_Life_Expectancy_at_Age_65_years,
    Female_Life_Expectancy_at_Age_65_years,
    Life_Expectancy_at_Age_80_both_sexes_years,
    Male_Life_Expectancy_at_Age_80_years,
    Female_Life_Expectancy_at_Age_80_years,
    Infant_Deaths_under_age_1_thousands,
    Infant_Mortality_Rate_infant_deaths_per_1000_live_births,
    Live_Births_Surviving_to_Age_1_thousands,
    Under_Five_Deaths_under_age_5_thousands,
    Under_Five_Mortality_deaths_under_age_5_per_1000_live_births,
    Mortality_before_Age_40_both_sexes_deaths_under_age_40_per_1000_live_births,
    Male_Mortality_before_Age_40_deaths_under_age_40_per_1000_male_live_births,
    Female_Mortality_before_Age_40_deaths_under_age_40_per_1000_female_live_births,
    Mortality_before_Age_60_both_sexes_deaths_under_age_60_per_1000_live_births,
    Male_Mortality_before_Age_60_deaths_under_age_60_per_1000_male_live_births,
    Female_Mortality_before_Age_60_deaths_under_age_60_per_1000_female_live_births,
    Mortality_between_Age_15_and_50_both_sexes_deaths_under_age_50_per_1000_alive_at_age_15,
    Male_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_males_alive_at_age_15,
    Female_Mortality_between_Age_15_and_50_deaths_under_age_50_per_1000_females_alive_at_age_15,
    Mortality_between_Age_15_and_60_both_sexes_deaths_under_age_60_per_1000_alive_at_age_15,
    Male_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_males_alive_at_age_15,
    Female_Mortality_between_Age_15_and_60_deaths_under_age_60_per_1000_females_alive_at_age_15,
    Net_Number_of_Migrants_thousands,
    Net_Migration_Rate_per_1000_population
)
SELECT 
    "Location code",
    "Year",
    REPLACE("Total Population, as of 1 January (thousands)", ',', '.'),
    REPLACE("Total Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Male Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Female Population, as of 1 July (thousands)", ',', '.'),
    REPLACE("Population Density, as of 1 July (persons per square km)", ',', '.'),
    REPLACE("Population Sex Ratio, as of 1 July (males per 100 females)", ',', '.'),
    REPLACE("Median Age, as of 1 July (years)", ',', '.'),
    REPLACE("Natural Change, Births minus Deaths (thousands)", ',', '.'),
    REPLACE("Rate of Natural Change (per 1,000 population)", ',', '.'),
    REPLACE("Population Change (thousands)", ',', '.'),
    REPLACE("Population Growth Rate (percentage)", ',', '.'),
    REPLACE("Population Annual Doubling Time (years)", ',', '.'),
    REPLACE("Births (thousands)", ',', '.'),
    REPLACE("Births by women aged 15 to 19 (thousands)", ',', '.'),
    REPLACE("Crude Birth Rate (births per 1,000 population)", ',', '.'),
    REPLACE("Total Fertility Rate (live births per woman)", ',', '.'),
    REPLACE("Net Reproduction Rate (surviving daughters per woman)", ',', '.'),
    REPLACE("Mean Age Childbearing (years)", ',', '.'),
    REPLACE("Sex Ratio at Birth (males per 100 female births)", ',', '.'),
    REPLACE("Total Deaths (thousands)", ',', '.'),
    REPLACE("Male Deaths (thousands)", ',', '.'),
    REPLACE("Female Deaths (thousands)", ',', '.'),
    REPLACE("Crude Death Rate (deaths per 1,000 population)", ',', '.'),
    REPLACE("Life Expectancy at Birth, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Birth (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Birth (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 15, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 15 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 15 (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 65, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 65 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 65 (years)", ',', '.'),
    REPLACE("Life Expectancy at Age 80, both sexes (years)", ',', '.'),
    REPLACE("Male Life Expectancy at Age 80 (years)", ',', '.'),
    REPLACE("Female Life Expectancy at Age 80 (years)", ',', '.'),
    REPLACE("Infant Deaths, under age 1 (thousands)", ',', '.'),
    REPLACE("Infant Mortality Rate (infant deaths per 1,000 live births)", ',', '.'),
    REPLACE("Live Births Surviving to Age 1 (thousands)", ',', '.'),
    REPLACE("Under-Five Deaths, under age 5 (thousands)", ',', '.'),
    REPLACE("Under-Five Mortality (deaths under age 5 per 1,000 live births)", ',', '.'),
    REPLACE("Mortality before Age 40, both sexes (deaths under age 40 per 1,000 live births)", ',', '.'),
    REPLACE("Male Mortality before Age 40 (deaths under age 40 per 1,000 male live births)", ',', '.'),
    REPLACE("Female Mortality before Age 40 (deaths under age 40 per 1,000 female live births)", ',', '.'),
    REPLACE("Mortality before Age 60, both sexes (deaths under age 60 per 1,000 live births)", ',', '.'),
    REPLACE("Male Mortality before Age 60 (deaths under age 60 per 1,000 male live births)", ',', '.'),
    REPLACE("Female Mortality before Age 60 (deaths under age 60 per 1,000 female live births)", ',', '.'),
    REPLACE("Mortality between Age 15 and 50, both sexes (deaths under age 50 per 1,000 alive at age 15)", ',', '.'),
    REPLACE("Male Mortality between Age 15 and 50 (deaths under age 50 per 1,000 males alive at age 15)", ',', '.'),
    REPLACE("Female Mortality between Age 15 and 50 (deaths under age 50 per 1,000 females alive at age 15)", ',', '.'),
    REPLACE("Mortality between Age 15 and 60, both sexes (deaths under age 60 per 1,000 alive at age 15)", ',', '.'),
    REPLACE("Male Mortality between Age 15 and 60 (deaths under age 60 per 1,000 males alive at age 15)", ',', '.'),
    REPLACE("Female Mortality between Age 15 and 60 (deaths under age 60 per 1,000 females alive at age 15)", ',', '.'),
    REPLACE("Net Number of Migrants (thousands)", ',', '.'),
    REPLACE("Net Migration Rate (per 1,000 population)", ',', '.')
FROM pop
WHERE "Year" IS NOT NULL
  AND "Location code" IS NOT NULL
  AND "Location code" IN (SELECT location_code FROM subregion);

-- =====================================================================
-- 7. REQUÊTES DE VÉRIFICATION
-- =====================================================================

SELECT
    r.name AS region,
    SUM(f.Total_Population_as_of_1_July_thousands) AS total_pop_2000
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
JOIN subregion s ON c.parent_code = s.location_code
JOIN region r ON s.parent_code = r.location_code
WHERE f.years = 2000
GROUP BY r.name
ORDER BY total_pop_2000 DESC;

-- =====================================================================
-- Étape 7 : Évolution de la population de Algérie/Japon entre 1950 et 2023 (courbe) 
-- =====================================================================

SELECT 
    year,
    CAST(REPLACE("Total Population, as of 1 July (thousands)", ',', '.') AS REAL) AS population
FROM pop
WHERE "Region, subregion, country or area" = 'France'
  AND year BETWEEN 1950 AND 2023
ORDER BY year;

-- =====================================================================
--  THÈME 1 : Requêtes de base : exploration des données 
-- =====================================================================

-- Question 1 : Lister toutes les sous-régions et la région à laquelle elles appartiennent.
SELECT Subregion.name , Region.Name AS 'Region associés' FROM Region, Subregion
WHERE Subregion.Parent_code  = Region.Location_code;

-- Question 2 : Afficher les 10 pays ayant la plus forte population en 2020.
SELECT Name, Total_Population_as_of_1_January_thousands FROM Country, fact_pop_country
WHERE Country.location_code = fact_pop_country.location_code
AND years = 2020
ORDER BY Total_Population_as_of_1_January_thousands DESC
LIMIT 10;

-- Question 3 : Afficher la population totale mondiale pour l’année 1980.
SELECT SUM(Total_Population_as_of_1_January_thousands) AS 'WorldPopulation' FROM fact_pop_region, Region
WHERE years = 1980 AND fact_pop_region.location_code = Region.location_code;

-- Question 4 : Lister les pays dont la densité de population dépasse 500 hab/km² en 2020.
SELECT Name, Population_Density_as_of_1_July_persons_per_square_km AS 'PopulationDensity'
FROM fact_pop_country, Country
WHERE fact_pop_country.location_code = Country.location_code
AND years = 2020 AND PopulationDensity > 500
ORDER BY PopulationDensity DESC;

-- Question 5 : Afficher la population masculine et féminine pour un pays donné sur la période. 
SELECT years, Name, Male_Population_as_of_1_July_thousands, Female_Population_as_of_1_July_thousands
FROM fact_pop_country, Country
WHERE fact_pop_country.location_code = Country.location_code	
AND Name = 'France';

--========================================================================================================================
-- Thème 2 — Requêtes d’analyse et d’évolution temporelle  */
--========================================================================================================================

-- Question 1 : Afficher l’évolution de la population d’un pays sur les 50 dernières années. 
SELECT 
  year,
  "Total Population, as of 1 July (thousands)"
FROM pop
WHERE "Region, subregion, country or area" = 'France' AND year >= 1973  /* 50 DERNIERE ANNEE 1973 a 2023 */ 
ORDER BY year;

-- Question 2 : Calculer la croissance démographique moyenne par décennie pour chaque région.
-- Une décennie correspond à une période de 10 ans, c’est pourquoi j’ai regroupé les données par tranche décennale 
SELECT 
    "Region, subregion, country or area" AS region,
    (year / 10) * 10 AS decade,
    AVG("Total Population, as of 1 July (thousands)") AS croissance_moyenne
FROM pop
WHERE year BETWEEN 1950 AND 2023
    AND "Region, subregion, country or area" IN ('Africa', 'Asia', 'Europe', 'Latin America and the Caribbean',
    'Northern America', 'Oceania')
GROUP BY region, decade
ORDER BY region, decade;

-- Question 3 : Identifier les pays dont la population a doublé entre 1950 et 2023. 
-- J'ai mis une colonne coefficient multiplicateur pour savoir par combien a été multiplié cette population 
SELECT
    p1."Region, subregion, country or area" AS pays,
    p1."Total Population, as of 1 July (thousands)" AS pop_1950,
    p2."Total Population, as of 1 July (thousands)" AS pop_2023,
    ROUND(p2."Total Population, as of 1 July (thousands)" / p1."Total Population, as of 1 July (thousands)", 2) AS coeff_multiplicateur
FROM pop p1
JOIN pop p2
    ON p1."Region, subregion, country or area" = p2."Region, subregion, country or area"
WHERE p1.year = 1950
    AND p2.year = 2023
    AND p2."Total Population, as of 1 July (thousands)" >= 2 * p1."Total Population, as of 1 July (thousands)"
ORDER BY coeff_multiplicateur DESC;

-- Question 4 : Afficher le taux de natalité et le taux de mortalité moyens par région pour 2000. 
SELECT
    "Region, subregion, country or area" AS region,
    ROUND(AVG("Crude Birth Rate (births per 1,000 population)"), 2) AS taux_natalite_moyen,
    ROUND(AVG("Crude Death Rate (deaths per 1,000 population)"), 2) AS taux_mortalite_moyen
FROM pop
WHERE year = 2000
  AND "Type" = 'Region'
  AND "Crude Birth Rate (births per 1,000 population)" > 0
  AND "Crude Death Rate (deaths per 1,000 population)" > 0
GROUP BY "Region, subregion, country or area"
ORDER BY region; 

-- Question 5 : Comparer le ratio hommes/femmes entre deux années pour un même pays.
-- J'ai pris l'Algérie comme exemple ici pour comparer 
SELECT
    year,
    "Region, subregion, country or area" AS pays,
    "Population Sex Ratio, as of 1 July (males per 100 females)" AS ratio_hommes_femmes
FROM pop
WHERE "Region, subregion, country or area" = 'Algeria'
  AND year IN (1990, 2000)
ORDER BY year;

--========================================================================================================================
--THEME 3 : Requêtes hiérarchiques : régions, sous-régions et pays
--========================================================================================================================

--  Question 1 : Lister, pour une région donnée, tous les pays avec leur part dans la population régionale.
SELECT 
    c.name AS country,
    ROUND(f.Total_Population_as_of_1_July_thousands, 2) AS population,
    ROUND(
        100.0 * f.Total_Population_as_of_1_July_thousands /
        (
        /* Dénominateur : somme des populations (en milliers)
               de tous les pays de la même région et de la même année*/
            SELECT SUM(f2.Total_Population_as_of_1_July_thousands)
            FROM fact_pop_country f2
            JOIN country   c2 ON f2.location_code = c2.location_code
            JOIN subregion s2 ON c2.parent_code   = s2.location_code
            JOIN region    r2 ON s2.parent_code   = r2.location_code
           
            WHERE r2.name = r.name        -- même région que la ligne courante
              AND f2.years = f.years      -- même année que la ligne courante
        ), 2
    ) AS share_percentage  -- Part de population (%) du pays dans sa région
FROM fact_pop_country f
JOIN country   c ON f.location_code = c.location_code
JOIN subregion s ON c.parent_code   = s.location_code
JOIN region    r ON s.parent_code   = r.location_code
WHERE r.name = 'Europe' -- <<< région ciblée (à modifier)
AND f.years = 2023 -- <<< année ciblée  (à modifier)
ORDER BY share_percentage DESC; -- Tri du plus grand pourcentage au plus petit

-- Pour les regions, les noms valides : 'Nothern America' ; 'Asia' ; 'Europe' ; 'Latin America and the Caribbean'; 'Africa' ; 'Oceania'.

-- 	Question 2 : Identifier les sous-régions dont la population représente plus de 40% de la population totale de la région en 2023.
SELECT 
    s.name AS subregion, -- Nom de la sous-région (ex. "Melanesia", "Polynesia"...)
    r.name AS region,	 -- Nom de la région parente (ex. "Oceania")
    ROUND(SUM(f.Total_Population_as_of_1_July_thousands), 2) AS subregion_population,
    ROUND( 100.0 * SUM(f.Total_Population_as_of_1_July_thousands) /
        ( /* Dénominateur : somme des populations (en milliers)
          de tous les pays de la même région et de la même année*/

        	SELECT SUM(f2.Total_Population_as_of_1_July_thousands)
            FROM fact_pop_country f2
            JOIN country c2 ON f2.location_code = c2.location_code
            JOIN subregion s2 ON c2.parent_code = s2.location_code
            WHERE s2.parent_code = r.location_code -- même région (via code parent)
            AND f2.years = 2023 				   -- même année
        ), 2
    ) AS share_percentage -- Part de la sous-région dans sa région (%)
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
JOIN subregion s ON c.parent_code = s.location_code
JOIN region r ON s.parent_code = r.location_code
WHERE f.years = 2023
GROUP BY s.name, r.name
HAVING share_percentage > 40 -- Ne garder que les sous-régions > 40 %
ORDER BY region, share_percentage DESC; -- Tri : par région puis part décroissante

-- =====================================================================
--  THÈME 4 : Requêtes analytiques sur des indicateurs
-- =====================================================================

-- Requête 1 : 5 pays avec plus forte espérance de vie (tous sexes) en 2020
SELECT c.name AS pays,
       f.Life_Expectancy_at_Birth_both_sexes_years AS esperance_vie
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
WHERE f.years = 2020
ORDER BY f.Life_Expectancy_at_Birth_both_sexes_years DESC
LIMIT 5;

-- Requête 2 : espérance de vie (H / F) moyenne par région en 2020
SELECT r.name AS region,
       ROUND(AVG(f.Male_Life_Expectancy_at_Birth_years),2)   AS esperance_homme,
       ROUND(AVG(f.Female_Life_Expectancy_at_Birth_years),2) AS esperance_femme
FROM fact_pop_country AS f
JOIN country AS c ON f.location_code = c.location_code
JOIN subregion AS s ON c.parent_code = s.location_code
JOIN region    AS r ON s.parent_code = r.location_code
WHERE f.years = 2020
GROUP BY r.name
ORDER BY r.name;

-- Requête 3 : 10 pays avec natalité la plus élevée (naissances en milliers) en 1990
SELECT c.name AS pays,
       f.Births_thousands AS naissances_milliers
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
WHERE f.years = 1990
ORDER BY f.Births_thousands DESC
LIMIT 10;

-- Requête 4 : pays avec la plus forte migration nette en 2010 pour chaque sous-région
SELECT s.name AS sous_region,
       c.name AS pays,
       f.Net_Number_of_Migrants_thousands AS migrants_nets
FROM fact_pop_country AS f
JOIN country   AS c ON f.location_code = c.location_code
JOIN subregion AS s ON c.parent_code = s.location_code
WHERE f.years = 2010
  AND f.Net_Number_of_Migrants_thousands = (
      SELECT MAX(f2.Net_Number_of_Migrants_thousands)
      FROM fact_pop_country AS f2
      JOIN country AS c2 ON f2.location_code = c2.location_code
      WHERE f2.years = 2010
        AND c2.parent_code = s.location_code
  )
ORDER BY s.name;

-- =====================================================================
-- THÈME 5 : CRÉATION DE VUES (REQUÊTES NOMMÉES)
-- =====================================================================

-- Question 1 : Population moyenne, minimale et maximale par région sur toute la période
CREATE VIEW v_pop_stats_by_region AS
SELECT 
    r.name AS region_name,
    r.location_code AS region_code,
    ROUND(AVG(fr.Total_Population_as_of_1_July_thousands), 2) AS avg_population_thousands,
    MIN(fr.Total_Population_as_of_1_July_thousands) AS min_population_thousands,
    MAX(fr.Total_Population_as_of_1_July_thousands) AS max_population_thousands,
    MIN(fr.years) AS first_year,
    MAX(fr.years) AS last_year,
    COUNT(DISTINCT fr.years) AS nb_years_covered
FROM fact_pop_region fr
JOIN region r ON fr.location_code = r.location_code
WHERE fr.Total_Population_as_of_1_July_thousands IS NOT NULL
GROUP BY r.location_code, r.name
ORDER BY avg_population_thousands DESC;

-- Exemple d'utilisation :
SELECT * FROM v_pop_stats_by_region;

-- Question 2 : Évolution de la population par sous-région entre deux années données
CREATE VIEW v_subregion_pop_evolution AS
SELECT 
    s.name AS subregion_name,
    s.location_code AS subregion_code,
    fs1.years AS year_start,
    fs2.years AS year_end,
    fs1.Total_Population_as_of_1_July_thousands AS pop_start_thousands,
    fs2.Total_Population_as_of_1_July_thousands AS pop_end_thousands,
    ROUND(fs2.Total_Population_as_of_1_July_thousands - fs1.Total_Population_as_of_1_July_thousands, 2) AS pop_change_thousands,
    ROUND(
        ((fs2.Total_Population_as_of_1_July_thousands - fs1.Total_Population_as_of_1_July_thousands) / 
         fs1.Total_Population_as_of_1_July_thousands) * 100, 
        2
    ) AS pop_change_percent,
    r.name AS parent_region
FROM fact_pop_subregion fs1
JOIN fact_pop_subregion fs2 
    ON fs1.location_code = fs2.location_code
JOIN subregion s ON fs1.location_code = s.location_code
JOIN region r ON s.parent_code = r.location_code
WHERE fs1.Total_Population_as_of_1_July_thousands IS NOT NULL
  AND fs2.Total_Population_as_of_1_July_thousands IS NOT NULL
  AND fs1.years < fs2.years;

-- Exemple d'utilisation pour comparer 2000 et 2020 :
SELECT * FROM v_subregion_pop_evolution 
WHERE year_start = 2000 AND year_end = 2020
ORDER BY pop_change_percent DESC;

-- Question 3 : Quelles sont les régions avec un âge médian supérieur à 30 ans et un ratio hommes/femmes déséquilibré (supérieur à 100) ? 
CREATE VIEW v_regions_age_gender_imbalance AS
SELECT 
    r.name AS region_name,
    r.location_code AS region_code,
    fr.years AS year,
    ROUND(fr.Median_Age_as_of_1_July_years, 1) AS median_age,
    ROUND(fr.Population_Sex_Ratio_as_of_1_July_males_per_100_females, 2) AS sex_ratio_m_per_100f,
    ROUND(fr.Total_Population_as_of_1_July_thousands, 2) AS total_population_thousands,
    c.name AS continent_name,
    CASE 
        WHEN fr.Population_Sex_Ratio_as_of_1_July_males_per_100_females > 105 THEN 'Déséquilibre fort (>105)'
        WHEN fr.Population_Sex_Ratio_as_of_1_July_males_per_100_females > 102 THEN 'Déséquilibre modéré (102-105)'
        ELSE 'Déséquilibre léger (100-102)'
    END AS niveau_desequilibre
FROM fact_pop_region fr
JOIN region r ON fr.location_code = r.location_code
JOIN continent c ON r.parent_code = c.location_code
WHERE fr.Median_Age_as_of_1_July_years > 30
  AND fr.Population_Sex_Ratio_as_of_1_July_males_per_100_females > 100
  AND fr.Median_Age_as_of_1_July_years IS NOT NULL
  AND fr.Population_Sex_Ratio_as_of_1_July_males_per_100_females IS NOT NULL
ORDER BY fr.years DESC, fr.Population_Sex_Ratio_as_of_1_July_males_per_100_females DESC;

-- Exemple d'utilisation pour l'année la plus récente :
SELECT * FROM v_regions_age_gender_imbalance 
WHERE year = (SELECT MAX(years) FROM fact_pop_region)
ORDER BY sex_ratio_m_per_100f DESC;

-- =====================================================================
-- REQUÊTES DE VALIDATION
-- =====================================================================

-- Requête #1 : Vérification de la hiérarchie des zones géographiques
SELECT
    co.name AS continent_name,
    r.name AS region_name,
    s.name AS subregion_name,
    c.name AS country_name,
    co.location_code AS continent_code,
    r.parent_code AS region_parent_code
FROM continent co
JOIN region r ON co.location_code = r.parent_code
JOIN subregion s ON r.location_code = s.parent_code
JOIN country c ON s.location_code = c.parent_code;

-- Requête #2 : Population totale par continent pour l'année 2000
SELECT
    co.name AS Continent,
    co.location_code,
    r.parent_code,
    SUM(f.Total_Population_as_of_1_July_thousands) AS total_pop_2000
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
JOIN subregion s ON c.parent_code = s.location_code
JOIN region r ON s.parent_code = r.location_code
JOIN continent co ON r.parent_code = co.location_code
WHERE f.years = 2000
GROUP BY co.name
ORDER BY total_pop_2000 DESC;

-- Requête #3 : Population totale du continent Afro-Eurasien pour l'année 2013
SELECT
    co.name AS Continent,
    co.location_code,
    r.parent_code,
    SUM(f.Total_Population_as_of_1_July_thousands) AS total_pop_2013
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
JOIN subregion s ON c.parent_code = s.location_code
JOIN region r ON s.parent_code = r.location_code
JOIN continent co ON r.parent_code = co.location_code
WHERE f.years = 2013 AND co.name = 'Afro_Eurasien'
GROUP BY co.name
ORDER BY total_pop_2013 DESC;

-- Requête #4 : Population de chaque région du continent Américain pour l'année 1966
SELECT
    co.name AS Continent,
    r.name AS Region,
    co.location_code,
    r.parent_code,
    SUM(f.Total_Population_as_of_1_July_thousands) AS total_pop_1966
FROM fact_pop_country f
JOIN country c ON f.location_code = c.location_code
JOIN subregion s ON c.parent_code = s.location_code
JOIN region r ON s.parent_code = r.location_code
JOIN continent co ON r.parent_code = co.location_code
WHERE f.years = 1966 AND co.name = 'Américain'
GROUP BY r.name
ORDER BY total_pop_1966 DESC;

-- =====================================================================
-- Vues Etape 10
-- =====================================================================

-- Vue 1
CREATE VIEW v_population_par_region_par_continent AS
SELECT Region.name, fact_pop_region.Total_Population_as_of_1_January_thousands
FROM Region
JOIN fact_pop_region ON Region.location_code = fact_pop_region.location_code
JOIN Continent ON Region.parent_code = Continent.location_code
WHERE Continent.Name = 'Afro_Eurasien'
 AND years = 2000;

SELECT * FROM v_population_par_region_par_continent;

-- Vue 2
CREATE VIEW v_region_la_plus_peuple AS
SELECT Region.name, fact_pop_region.Total_Population_as_of_1_January_thousands
FROM Region
JOIN fact_pop_region ON Region.location_code = fact_pop_region.location_code
JOIN Continent ON Region.parent_code = Continent.location_code
WHERE Continent.Name = 'Afro_Eurasien' AND years = 2000
ORDER BY fact_pop_region.Total_Population_as_of_1_January_thousands DESC
LIMIT 1;

SELECT * FROM v_region_la_plus_peuple;