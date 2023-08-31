select * from
CovidVaccinations
ORDER BY 3,4;

select * from
CovidDeaths;

--Selecting data to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2;

-- Looking at the total cases vs total deaths %
SELECT location, date, total_cases, total_deaths, ( CAST(total_deaths as INT )/ CAST (total_cases AS int)) as DeathPercentage
From CovidDeaths
order by 1,2;
-- causes an error

	-- Checking the valid data types
select * 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'CovidDeaths'
and COLUMN_NAME in ('total_cases', 'total_deaths');
	-- Sample conversion
select total_cases, CAST(total_cases AS int)
from CovidDeaths

-- updated total_cases vs total_deaths %

SELECT location, date, total_cases, total_deaths, ( CAST(total_deaths as INT )/ CAST (total_cases AS int)) as DeathPercentage
From CovidDeaths
order by 4 DESC;

-- data doesnt look right, why?

SELECT location, date, total_cases, total_deaths
From CovidDeaths
order by 4 DESC;

-- casting does not seem to work, trying convert
select total_cases, CONVERT(INT, total_cases), CAST(total_cases AS int)
from CovidDeaths

SELECT location, date, total_cases, total_deaths, ( CONVERT(INT, total_cases)/ CONVERT(INT, total_deaths)) as DeathPercentage
From CovidDeaths
order by 4 DESC;


-- comparing casting and converting
select total_cases, CONVERT(INT, total_cases), CAST(total_cases AS int)
from CovidDeaths;

SELECT 
	location, date, total_cases, total_deaths,
	CONVERT(INT, total_cases)/ CONVERT(INT, total_deaths) as TotalDeathsConvertPercentage,  CAST(total_cases AS int)/CAST(total_deaths AS int) as TotalDeathsCastPercentage
From CovidDeaths
order by 4 DESC;

-- above is an error in logic 
-- below is logic corrected

SELECT 
	location, date, total_cases, total_deaths,
	CONVERT(float, total_deaths)/ CONVERT(float, total_cases) * 100 as DeathsTotalsConvertPercentage,  CAST(total_deaths AS float)/CAST(total_cases AS float) * 100 as DeathsTotalsCastPercentage
From CovidDeaths;


SELECT 
	location, date, total_cases, total_deaths,
	CONVERT(int, total_deaths)/ CONVERT(int, total_cases) * 100 as DeathsTotalsConvertPercentage,  CAST(total_deaths AS int)/CAST(total_cases AS int) * 100 as DeathsTotalsCastPercentage
From CovidDeaths;

-- both covert and cast seem to work, when paired w floats for division, i will work w both convert and cast from now on.
-- but why does the data seem  weird, i.e. why are there more deaths than cases in some instances?
--SELECT 
--	location, date, total_cases, total_deaths,
--	CONVERT(float, total_deaths)/ CONVERT(float, total_cases) * 100 as DeathsTotalsConvertPercentage
--From CovidDeaths
--WHERE DeathsTotalsConvertPercentage is not null
--order by 5;

-- using an aliased column name raises an error, how about using the original column names?
SELECT 
	location, date, total_cases, total_deaths,
	CONVERT(float, total_deaths)/ CONVERT(float, total_cases) * 100 as DeathsTotalsConvertPercentage
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null
order by 5 desc;
-- why does France's data seem off?

-- focusing specifically on France
SELECT 
	date, total_cases, total_deaths,
	CONVERT(float, total_deaths)/ CONVERT(float, total_cases) * 100 as DeathsTotalsConvertPercentage
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null and location = 'France'
group by date, total_deaths, total_cases ;


-- comparing France and my home, Nigeria:

SELECT 
	location, date, total_cases, total_deaths,
	CONVERT(float, total_deaths)/ CONVERT(float, total_cases) * 100 as DeathsTotalsConvertPercentage
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null and location in ('France', 'Nigeria')
group by location, date, total_deaths, total_cases ;

-- France seems much higher, but which has the higher population compared to higher cases and deaths?
select sum(population)
from CovidDeaths
where location = 'France';

select sum(population)
from CovidDeaths
where location = 'Nigeria';

-- checking for US, the country I am currently in
-- showing the likelihood of death due to COVID
SELECT 
	location, date, total_cases, total_deaths,
	CONVERT(float, total_deaths)/ CONVERT(float, total_cases) * 100 as DeathsTotalsConvertPercentage
From CovidDeaths
WHERE location = 'United States'  and total_cases is not null and total_deaths is not null
order by 2 desc;

-- Taking a look at total cases vs population
 SELECT 
	location, date, population, total_cases,
	CONVERT(float, total_cases)/ CONVERT(float, population) * 100 as CasesPopulationConvertPercentage
From CovidDeaths
WHERE location = 'United States'  and total_cases is not null and total_deaths is not null
order by 1,2;


-- looking at countries with highest infection rates, compared to population
 SELECT 
	location, population, max(total_cases) as HighestInfectionCount,
	MAX(CONVERT(float, total_cases)/ CONVERT(float, population) * 100) as MaxCasesPopulationConvertPercentage
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null
group by location, population
order by MaxCasesPopulationConvertPercentage desc;

-- what is the max ratio for the US?
 SELECT 
	population, 
	MAX(CONVERT(float, total_cases)/ CONVERT(float, population) * 100) as MaxCasesPopulationConvertPercentage
From CovidDeaths
WHERE location = 'United States' 
group by population

-- for specific countries?
 SELECT 
	location, 
	MAX(CONVERT(float, total_cases)/ CONVERT(float, population) * 100) as MaxofCasesOverPopulationConvertPercentage
From CovidDeaths
WHERE location in ('United States', 'Nigeria', 'France', 'Cyprus') 
group by location
order by 2 desc;

-- checking out countries with highest death count per population to later compare w max infected
 SELECT 
	location, max(CAST(total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null
group by location
order by 2 desc

-- above logic is weird; it displays weird additives like 'Africa, World, high income, upper middle income' to the output why?
--noticing it is whenever continents are added w a 'Null' entry
select * from CovidDeaths
where continent is not null;

--therefore
 SELECT 
	location, max(CAST(total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null and continent is not null
group by location
order by 2 desc

-- comparing comparing contient input as null vs not null

 SELECT 
	location, max(CAST(total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null and continent is null
group by location
order by 2 desc

--- breaking up data by continents to visualize later
 SELECT 
	continent, max(CAST(total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE total_cases is not null and total_deaths is not null and continent is not null
group by continent
order by 2 desc


-- Global Numbers
select date, sum(new_cases) as TotalOfNewCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases) as NewDeathsOverNewCasesPercent
from CovidDeaths
where new_cases <> 0
group by date
order by 1,2;

	--Getting the death percentage of the entire world
select sum(new_cases) as TotalOfNewCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases) as NewDeathsOverNewCasesPercent
from CovidDeaths
where new_cases <> 0
order by 1,2

-- working w Covid Vaccinations Tables
-- intro
select * from CovidVaccinations;

-- joining both tables
select * 
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date;


 -- looking at total population vs vaccinations
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2,3;

 -- good, but not very informative, need to partition by the location/continent, which one makes more sense?
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--sum(cast(vac.new_vaccinations as int)) over (partition by dea.location)
--from CovidDeaths dea
--Join CovidVaccinations vac
-- on dea.location = vac.location
-- and dea.date = vac.date
-- where dea.continent is not null
-- order by 1,2,3;

		--- casting as an int causes a error, it seems the sum is causing an overflow, trying w big int.
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location)
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2,3;

	-- big int works, but not very informative
	-- turns out we can add an ordering inside a partition
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationsCount
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null and vac.new_vaccinations is not null
 order by 1,2,3;

 --using a cte to help my partition

 With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinationsCount)
 as 
 (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationsCount
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null and vac.new_vaccinations is not null
 )

 select *, (RollingVaccinationsCount/Population)*100 as RollingVaccinationsCountPercent
 From PopVsVac


 -- same thing, but with temp tables
Drop table if exists #PercentPopulationVaccinatedNullRemoved
create table #PercentPopulationVaccinatedNullRemoved
(
Continent nvarchar(255),
Location nvarchar(255),
Date dateTime,
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated numeric
)

 -- same thing, but with views
Insert into #PercentPopulationVaccinatedNullRemoved
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationsCount
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null and vac.new_vaccinations is not null

 select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedCountPercent
 From #PercentPopulationVaccinatedNullRemoved;


--Creating view to store data for later vizualisations
--drop view if exists PercentPopulationVaccinated
create view PercentPopulationVaccinatedNullRemoved as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationsCount
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null


create view PercentPopulationVaccinatedWithNulls as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationsCount
from CovidDeaths dea
Join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
 
-- working w views
select * from PercentPopulationVaccinatedNullRemoved;