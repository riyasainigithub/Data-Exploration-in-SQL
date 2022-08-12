
SELECT *

  
  FROM portfolioProject..CovidDeaths
  ORDER BY 3,4
 

 --SELECT *

  
 -- FROM portfolioProject..CovidVaccinations
 -- ORDER BY 3,4
 
 SELECT location, date, total_cases, new_cases, total_deaths, population
   FROM portfolioproject..CovidDeaths
   ORDER BY 1,2

   --looking at total cases vs total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
   FROM portfolioproject..CovidDeaths
   WHERE location like '%india%'
   AND continent is not null
   ORDER BY 1,2
  
   --looking at total cases vs population
   -- shows what percentage of population got Covid

   SELECT location, date,population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
   FROM portfolioproject..CovidDeaths
   WHERE location like '%india%'
   ORDER BY 1,2


   

   SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
   FROM PortfolioProject..CovidDeaths
   --where location like '%india%'
   WHERE continent is not null
   --group by date
   order by 1,2

   


   SELECT location, SUM(CAST(new_deaths as int)) as TotalDeathCount
   from PortfolioProject..CovidDeaths
   --where location like '%india%'
   WHERE continent is null 
   and location not in ('world', 'european union', 'international')
   GROUP BY location
   ORDER BY TotalDeathCount desc


   

   --looking at countries with highest infection rate compared to population


   SELECT location,population, MAX (total_cases) as highestInfectionCount, MAX ((total_cases/population))*100 as  PercentPopulationInfected
   FROM portfolioproject..CovidDeaths
  -- WHERE location like '%india%'
  GROUP BY location, population
   ORDER BY PercentPopulationInfected desc

   

   SELECT location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
   FROM PortfolioProject..CovidDeaths
   --where location like '%india%'
   group by location, population, date
   order by PercentPopulationInfected desc




   -- showing countries and continents with highest death count per population


   SELECT location, MAX (cast (total_deaths as int)) as totaldeathcount
   FROM portfolioproject..CovidDeaths
  -- WHERE location like '%india%'
  WHERE continent is not null
  GROUP BY location
   ORDER BY totaldeathcount desc
  

   SELECT continent, MAX (cast (total_deaths as int)) as totaldeathcount
   FROM portfolioproject..CovidDeaths
  -- WHERE location like '%india%'
  WHERE continent is not null
  GROUP BY continent
   ORDER BY totaldeathcount desc

   --GLOBAL NUMBERS

   SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths ,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
   FROM portfolioproject..CovidDeaths
  -- WHERE location like '%india%'
   WHERE continent is not null
  -- GROUP BY date
   ORDER BY 1,2
  
 


  SELECT *
  FROM portfolioproject..coviddeaths dea
  JOIN portfolioproject..covidvaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date

	  --looking at total population vs vaccinations

	  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	  , SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
	  FROM portfolioproject..coviddeaths dea
	  join portfolioproject..covidvaccinations vac
	      on dea.location = vac.location
		  and dea.date = vac.date
	 WHERE dea.continent is not null
	 order by 2,3
	
	  --USE CTE
	
	WITH popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
	as
	(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
	FROM portfolioproject..coviddeaths dea
	join portfolioproject..covidvaccinations vac
	   on dea.location = vac.location
	   and dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3
	)
	SELECT *, (RollingPeopleVaccinated/population)*100
	FROM popvsvac

--TEMP TABLE


	CREATE TABLE #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	INSERT INTO #PercentPopulationVaccinated
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
	FROM portfolioproject..coviddeaths dea
	join portfolioproject..covidvaccinations vac
	   on dea.location = vac.location
	   and dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3

	SELECT *, (RollingPeopleVaccinated/population)*100
	FROM #PercentPopulationVaccinated



	DROP TABLE if exists #PercentPopulationVaccinated
	CREATE TABLE #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	INSERT INTO #PercentPopulationVaccinated
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
	FROM portfolioproject..coviddeaths dea
	join portfolioproject..covidvaccinations vac
	   on dea.location = vac.location
	   and dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3

	SELECT *, (RollingPeopleVaccinated/population)*100
	FROM #PercentPopulationVaccinated


	






	