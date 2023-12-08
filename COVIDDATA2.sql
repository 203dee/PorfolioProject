select * 
From coviddeaths
--order by 3,4

--select * 
--From ProfolioProject.dbo.CovidVaccinations

Select Location, date, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2

Select Location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
From CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2

Select Location, population, MAX(total_cases) AS HightestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulatinInfected
From CovidDeaths
Group by location, population
Order by PercentagePopulatinInfected desc

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ProfolioProject.dbo.COVIDDeaths
--Where location like '%states%'
Where continent is  null 
Group by continent
order by TotalDeathCount desc

Select date, SUM(new_cases) AS TOTAL_DEATHS, SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/(SUM(new_cases)*100 AS DeathPercentage,
FROM ProfolioProject.dbo.COVIDDeaths
--Where location like '%states%'
WHERE continent is not null
Group by date
order by 1,2

 Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From ProfolioProject.dbo.COVIDDeaths
--Where location like '%states%'
where continent is not null 
Group By date
order by 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, dea.date rows unbounded preceding) as RollingPeopleVaccinated
From ProfolioProject.dbo.COVIDDeaths dea
JOIN ProfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


With PopvsVac (continent, location, date, population, New_Vaccination, RollingPeopleVaccinated)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, dea.date rows unbounded preceding) as RollingPeopleVaccinated
From ProfolioProject.dbo.COVIDDeaths dea
JOIN ProfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null)
--Order by 2,3

Select *
from PopvsVas

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date rows unbounded preceding) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProfolioProject.dbo.COVIDDeaths dea
Join ProfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date rows unbounded preceding) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProfolioProject.dbo.COVIDDeaths dea
Join ProfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Create View for to store data for later visualization

USE ProfolioProject
go
Create View PercentPopulationVaccinated AS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date rows unbounded preceding) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProfolioProject.dbo.COVIDDeaths dea
Join ProfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *
From PercentPopulationVaccinated


USE ProfolioProject
go
Create View 


USE ProfolioProject
go
Create View RollingPeopleVaccinated AS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, dea.date rows unbounded preceding) as RollingPeopleVaccinated
From ProfolioProject.dbo.COVIDDeaths dea
JOIN ProfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

USE ProfolioProject
go
Create View TotalDeathCount AS

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
