
SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4 

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4 

----SELECTING THE DATA THAT WILL BE USED FOR ANALYSIS

SELECT location, date, total_cases, new_deaths, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

---Looking at the total cases vs total deaths
---This shows the likelihood of dying if you contract covid in your country.

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%States%'
ORDER BY 1, 2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1, 2

---Looking at the total cases verses the population
---Shows what percentage of population got covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%States%'
ORDER BY 1, 2

SELECT location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1, 2

---Removing the null Values from the data.

SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE total_cases NOT LIKE '%NULL'
ORDER BY 1, 2

---Countries with highest infection rate compared to the population
SELECT location, population, MAX(total_cases) AS HigestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE total_cases NOT LIKE '%NULL'
GROUP BY location, population
ORDER BY 1, 2

---Without null values
SELECT location, population, MAX(total_cases) AS HigestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE total_cases NOT LIKE '%NULL'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 1, 2

---Arranging in descending order and ordering by PercentaPopulationInfected
SELECT location, population, MAX(total_cases) AS HigestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE total_cases NOT LIKE '%NULL'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

---Looking at countries with the highest Deathcount or population
SELECT location, MAX(Total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE total_cases NOT LIKE '%NULL'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc

---N.B Total_death at this point is an nvarchar data type which is read as a string. For it to work for the aggregate function - MAX
---It has to be converted to a numerical Data Type.

---chnaging the data type by casting into an integer
SELECT location, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE total_cases NOT LIKE '%NULL'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc

----Grouping into continents
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT location, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE total_cases NOT LIKE '%NULL'   
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount desc


---LET'S BREAK THINGS DOWN BY CONTINENTS

---showing the continents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE total_cases NOT LIKE '%NULL'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc



---GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS total_case, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%States%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2


---Removing dates
SELECT SUM(new_cases) AS total_case, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%States%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2


---TOTAL POPULATION VS TOTAL VACCINATION

SELECT *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
---AND population NOT LIKE '%NULL'
ORDER BY 1,2,3

---REMOVING NULLS IN LOCATION

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND population NOT LIKE '%NULL'
ORDER BY 1,2,3

---
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND population NOT LIKE '%NULL'
ORDER BY 2,3 


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location)
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND population NOT LIKE '%NULL'
ORDER BY 1,2,3

---OR

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location) ---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND population NOT LIKE '%NULL'
ORDER BY 1,2,3


---ordering by
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND new_vaccinations IS NOT NULL
---NOT LIKE '%NULL'
ORDER BY 1,2,3


---CREATING A TEMP TABLE OR A CTE

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND new_vaccinations IS NOT NULL
---NOT LIKE '%NULL'
ORDER BY 1,2,3

---USING A CTE

with PopvsVac (Continent, Location, Date, Population, new_Vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND new_vaccinations IS NOT NULL
---NOT LIKE '%NULL'
--ORDER BY 2,3
)
SELECT *
FROM PopvsVac

with PopvsVac (Continent, Location, Date, Population, new_Vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND population IS NOT NULL
---NOT LIKE '%NULL'
--ORDER BY 2,3 
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-----TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations  numeric,
RollingPeopleVaccinated numeric
)

----To insert values into the created table

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND population IS NOT NULL
---NOT LIKE '%NULL'
--ORDER BY 2,3 

---To select Tenp_Table

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated




---Suppose that there has been a chnage in the values in the table, Use DROP to alter/create another temp_table
---This is highly recommeded when you plan t make alterations.

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations  numeric,
RollingPeopleVaccinated numeric
)

----To insert values into the created table

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent IS NOT NULL
WHERE population IS NOT NULL
---NOT LIKE '%NULL'
--ORDER BY 2,3 

---To select Tenp_Table

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated




----CREATING VIEWS TO STOR DATA FOR LATER VISUALIZATIONS\

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,	SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
	dea.date) AS RollingPeopleVaccinated---CAST can be written this way too.
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--WHERE population IS NOT NULL
---NOT LIKE '%NULL'
---ORDER BY 2,3 



----Now you can go to the stored table and query it since it is now permanent
SELECT *
FROM PercentPopulationVaccinated