-- Overview of the COVID-19 death data

SELECT *
FROM ..Covid_deaths
ORDER BY location, date


-- Selecting relevant data from the Covid_deaths table

SELECT iso_code, location, date, total_cases, new_cases, population, total_deaths
FROM ..Covid_deaths
ORDER BY location, date


--Comparing total deaths and total cases
--The Likelihood of dying after contacting COVID-19 in India

SELECT iso_code, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM ..Covid_deaths
WHERE location like '%india%' AND
YEAR(date) BETWEEN 2020 AND 2021
ORDER BY location, date

--The Likelihood of dying after contracting COVID-19 in Germany


SELECT iso_code, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM ..Covid_deaths
WHERE location like '%Germany%'
ORDER BY location, date

--Calculating the percentage of population that had contracted COVID-19 : INDIA

SELECT iso_code, location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
FROM ..Covid_deaths
WHERE location like '%India%' 

ORDER BY location, date

--Calculating the percentage of population that had contracted COVID-19 : Germany

SELECT iso_code, location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
FROM ..Covid_deaths
WHERE location like '%Germany%' 
ORDER BY location, date

--Looking at countries with highest COVID-19 Infection count and percentage

SELECT location, MAX(total_cases) AS HighestCases, MAX((total_cases/population))*100 AS HighestInfectionPercentage
FROM ..Covid_deaths
GROUP BY location
ORDER BY HighestInfectionPercentage DESC

--Looking at countries with highest COVID-19 Death count and percentage

SELECT location, MAX(cast(total_deaths as int)) AS HighestDeathCount, MAX((cast(total_deaths as int)/population))*100 AS HighestDeathPercentage
FROM ..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount DESC

--Looking at the highest death count for continents

SELECT  continent, MAX(cast(total_deaths as int)) AS HighestDeathCount, MAX((cast(total_deaths as int)/population))*100 AS HighestDeathPercentage
FROM ..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY Continent
ORDER BY HighestDeathCount DESC

--SUMMARY of the vaccination data

SELECT *
FROM [dbo].[Covid_vaccinations]
WHERE continent IS NOT NULL

-- Combining the death and vaccination data using a JOIN

SELECT dea.location, dea.date, dea.population, CAST(dea.total_deaths as INT) as TotalDeaths,vac.total_vaccinations  as TotalVaccinations 
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL


--Comparing vaccinated population to the total population

SELECT dea.location, dea.date, dea.population, CAST(dea.total_deaths as INT) as TotalDeaths,vac.total_vaccinations as TotalVaccinations 
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL

-- To see how new vaccinations evolve over time

SELECT dea.location, dea.date, dea.population, CONVERT(BIGINT,vac.new_vaccinations) AS NewVaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS IncreasedVaccinations
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date


-- To check the percentage of population vaccinated in India (using CTE)

WITH popVSvac (location, date, population, NewVaccination, IncreasedVaccinations)
AS
(
SELECT dea.location, dea.date, dea.population, CONVERT(BIGINT,vac.new_vaccinations) AS NewVaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS IncreasedVaccinations
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL
--ORDER BY dea.location, dea.date
)
SELECT *, (IncreasedVaccinations/population)*100 AS PercentPopulationVaccinated
FROM popVSvac
WHERE location = 'India';


--To export the data for visualtization, we create a view and export it

CREATE VIEW PercentPopulationVaccinatedIndia
AS
WITH popVSvac (location, date, population, NewVaccination, IncreasedVaccinations)
AS
(
SELECT dea.location, dea.date, dea.population, CONVERT(BIGINT,vac.new_vaccinations) AS NewVaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS IncreasedVaccinations
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL
--ORDER BY dea.location, dea.date
)
SELECT *, (IncreasedVaccinations/population)*100 AS PercentPopulationVaccinated
FROM popVSvac
WHERE location = 'India';





-- To check the percentage of population vaccinated in Germany (using CTE)

WITH popVSvac (location, date, population, NewVaccination, IncreasedVaccinations)
AS
(
SELECT dea.location, dea.date, dea.population, CONVERT(BIGINT,vac.new_vaccinations) AS NewVaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS IncreasedVaccinations
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL
--ORDER BY dea.location, dea.date
)
SELECT *, (IncreasedVaccinations/population)*100 as PercentPopulationVaccinated
FROM popVSvac
WHERE location = 'Germany';



--To export the data for visualtization, we create a view and export it

CREATE VIEW PercentaPopulationVaccinatedGermany
AS
WITH popVSvac (location, date, population, NewVaccination, IncreasedVaccinations)
AS
(
SELECT dea.location, dea.date, dea.population, CONVERT(BIGINT,vac.new_vaccinations) AS NewVaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS IncreasedVaccinations
FROM ..Covid_deaths as dea
JOIN ..Covid_vaccinations as vac
on dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL
--ORDER BY dea.location, dea.date
)
SELECT *, (IncreasedVaccinations/population)*100 AS PercentPopulationVaccinated
FROM popVSvac
WHERE location = 'Germany';



