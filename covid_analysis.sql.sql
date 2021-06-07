

--1 Calculate Total Number Cases, Total number if deaths and Death Percentage

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from covid_death$
where continent is not   null
order by 1,2


--2.Calculating Total number of Death  based on continent

select location, sum(cast(new_deaths as int)) as TotalDeathCount
from covid_death$
where continent is null
and location not in('World', 'European Union','International')
group by location
order by TotalDeathCount desc

-- 3.Calculating infected percentage of population based on the specific location

select location, population, Max(total_cases) as HighestInfectedCount, Max(total_cases/population)*100 as PercentPopulationInfected
from covid_death$
group by location, population
order by PercentPopulationInfected desc

-- 4.showing countries with highest deathcount per population


Select location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_death$
--Where location like '%states%'
Group by location, Population, date
order by PercentPopulationInfected desc

--5.

select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
from covid_death$ dea
join covid_vaccination$ vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3


--6.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covid_death$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--7.
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From covid_death$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--8.
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_death$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--9.
Select Location, date, population, total_cases, total_deaths
From covid_death$
--Where location like '%states%'
where continent is not null 
order by 1,2

--10.
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_death$ dea
Join covid_vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac

--11.
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_death$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc







