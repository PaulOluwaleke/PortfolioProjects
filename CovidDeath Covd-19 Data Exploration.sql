-- Covid-19 Dataset Exploration Analysis

select * 
from PortfolioProject..covidDeath
where continent is not null
order by 3,4

select * 
from PortfolioProject..covidVaccination
where continent is not null

--select * 
--from PortfolioProject..covidVaccination
--order by 3,4

--- select data that we are going to be using

select location, date , total_cases, new_cases, total_deaths, population
from PortfolioProject..covidDeath
where continent is not null
order by 1, 2

-- looking at total cases vs total deaths

select location, date , total_cases, new_cases, total_deaths, (cast(total_deaths as int)/total_cases)*100 as DeathPercentage
from PortfolioProject..covidDeath
where location like '%states'
and where continent is not null
order by 1, 2

-- looking at total cases vs population
--- shows what percenatage of population got covid

select location, date, population, total_cases,  (total_cases/population)*100 as DeathPercentage
from PortfolioProject..covidDeath
--where location like '%states'
where continent is not null
order by 1,2


-- looking at country with highest infection rate compared to population

select location, population, Max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..covidDeath
--where location like '%states'
group by location, population
where continent is not null
order by PercentPopulationInfected desc;

-- showing countries wuth highest death count per population

select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeath
--where location like '%states'
where continent is not null
group by location
order by TotalDeathCount desc;

-- LET'S BREAK THINGS DOWN BY CONTINENT
-- showing the continent with the highest death count per population

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeath
--where location like '%states'
where continent is not null
group by continent
order by TotalDeathCount desc;

-- the appropriate way to write the query

select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeath
--where location like '%states'
where continent is null
group by location
order by TotalDeathCount desc;

-- global numbers

select count(*);

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/
sum(cast(new_cases as int))*100
as DeathPercentage
from PortfolioProject..covidDeath
--where location like '%states'
where continent is not null
--group by date
order by 1, 2

select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/ sum(new_cases)*100
as DeathPercentage
from PortfolioProject..covidDeath
--group by date
order by 1,2;

 select sum(new_cases) as TotalNewCases
 from PortfolioProject..covidDeath;

 select *
 from PortfolioProject..covidVaccination;

 select * 
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
 on dea.location = vac.location
 and dea.date = vac.date;

 -- looking at Total Population vs vaccination

  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
     on dea.location = vac.location
     and dea.date = vac.date
 where dea.continent is not null
 order by 2, 3;

  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location)
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
     on dea.location = vac.location
     and dea.date = vac.date
 where dea.continent is not null
 order by 2, 3;

 
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, 
  dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
     on dea.location = vac.location
     and dea.date = vac.date
 where dea.continent is not null
 order by 2, 3;

 -- USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, 
  dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
     on dea.location = vac.location
     and dea.date = vac.date
 where dea.continent is not null
-- order by 2,3
)
Select * (RollingPeopleVaccinated/Population)*100
From PopsvVac



-- TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
  dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
     on dea.location = vac.location
     and dea.date = vac.date
 where dea.continent is not null
--order by 2,3

Select * (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--creating view to store data for later visualization
create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
  dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
 from PortfolioProject..covidDeath dea
 join PortfolioProject..covidVaccination vac
     on dea.location = vac.location
     and dea.date = vac.date
 where dea.continent is not null
--order by 2,3

select *
from PercentPopulationvaccinated



--Queries used for Tableau Project

-- 1.

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from PortfolioProject..covidDeath
--where location like '%states%'
where continent is not null
--Group by date
order by 1, 2

-- just a double check based off the data provided 
-- numbers are extremely close so we will keep them. The second includes "International" location


-- select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
-- SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
-- from portfolioProject..CovidDeaths
-- where location like '%states%'
-- where location = 'world'
-- Group by date
-- order by 1, 2


-- 2. 

-- we take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeath
--where location like '%states%'
where continent is null
and location not in ('World', 'European Union', 'High income', 'Upper Middle Income', 'Lower Middle Income', 'Low Income')
Group by location
order by TotalDeathCount desc;


--3.

select Location, Population, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..covidDeath
-- where location like '%states%'
group by location, population
order by PercentPopulationInfected desc;


-- 4.

select location, population, date, MAX(total_cases) as HighestInfectedCount, 
MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..covidDeath
-- where location like '%states%'
group by location, population, date
order by PercentPopulationInfected desc;

















