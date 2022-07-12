
Select *
from PortfolioProject..CovidDeaths


--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2


--Looking at Total cases vs Total deaths
--Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100  DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%nigeria%'
order by 1,2 


--Looking at Total cases vs Population
--Shows percentage of population that has covid in your country

Select location, date, population, total_cases, (total_cases/population)*100  CovidPercentage
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
order by 1,2 


--Looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases)  HighestInfectionCount, MAX((total_cases/population))*100  PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by location, population
order by PercentPopulationInfected desc

--Showing the countries with the highest deathcount per population

Select location, MAX(CAST(total_deaths as int))  TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT


--Showing Continents with the highest death count per population

Select continent, MAX(CAST(total_deaths as int))  TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--TOTAL GLOBAL NUMBERS 

Select SUM(new_cases)  total_cases, SUM(CAST(new_deaths as int))  total_deaths, SUM(CAST(new_deaths as int)) / SUM(new_cases)  DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
--Group by date
order by 1,2 


--GLOBAL NUMBERS BY DATE

Select date, SUM(new_cases)  total_cases, SUM(CAST(new_deaths as int))  total_deaths, SUM(CAST(new_deaths as int)) / SUM(new_cases)  DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by date
order by 1,2 


--Looking at Total population vs Vaccinations

--Using CTE's

With Pop_vs_Vac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations
, SUM(CONVERT(int, vacc.new_vaccinations)) OVER (Partition by deaths.location Order by deaths.location, deaths.date)  RollingPeopleVaccinated

From PortfolioProject..CovidDeaths  deaths
Join PortfolioProject..CovidVaccinations  vacc
	On deaths.location = vacc.location
	and deaths.date = vacc.date
where deaths.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From Pop_vs_Vac


--Using TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations
, SUM(CONVERT(int, vacc.new_vaccinations)) OVER (Partition by deaths.location Order by deaths.location, deaths.date)  RollingPeopleVaccinated

From PortfolioProject..CovidDeaths  deaths
Join PortfolioProject..CovidVaccinations  vacc
	On deaths.location = vacc.location
	and deaths.date = vacc.date
where deaths.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations
, SUM(CONVERT(int, vacc.new_vaccinations)) OVER (Partition by deaths.location Order by deaths.location, deaths.date)  RollingPeopleVaccinated

From PortfolioProject..CovidDeaths  deaths
Join PortfolioProject..CovidVaccinations  vacc
	On deaths.location = vacc.location
	and deaths.date = vacc.date
where deaths.continent is not null
--order by 2,3


Select *
From PercentPopulationVaccinated

Create View GlobalDeathCount as
Select continent, MAX(CAST(total_deaths as int))  TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by continent
--order by TotalDeathCount desc

Select *
From GlobalDeathCount


Create View NigeriasDeathCount as
Select location, date, total_cases, total_deaths
from PortfolioProject..CovidDeaths
where location like '%nigeria%'
--order by 1,2

Select *
From NigeriasDeathCount
