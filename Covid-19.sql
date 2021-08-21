select * from PortfolioProject.coviddeaths
order by 3,4;
select * from PortfolioProject.covidvaccinations
order by 3,4;
select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.coviddeaths
order by 1,2;
## Total Cases vs Total Deaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as Death_Percentage
from PortfolioProject.coviddeaths
where location like '%India%'
order by 1,2;
### Total Cases vs Population
select Location, date, total_cases, population, (population/total_cases)* 100 as PercentPopilationInfected
from PortfolioProject.coviddeaths
where location like '%India%'
order by 1,2;
## Looking the highest infection rate compared with population
 select location,population, max(total_cases) as HighestInfectedCount, max(total_cases/population)*100 as 
 PercentPopulationInfected
 from PortfolioProject.coviddeaths
 group by location, population
 order by PercentPopulationInfected desc;
 ## Highest death count per population
 select location, max(cast(total_deaths as float)) as Death_Count
 from PortfolioProject.coviddeaths
 group by Location
 order by Death_Count desc;
 ### Based on continent
 select continent, max(cast(total_deaths as float)) as Death_count
 from PortfolioProject.coviddeaths
 where continent is not null
 group by continent
 order by Death_count desc;
 -- Global NUmbers
 select sum(new_cases) as total_cases, sum(cast(new_deaths as float)) as total_deaths,
 sum(cast(new_deaths as float))/sum(new_cases)*100 as DeathPercentage
 from PortfolioProject.coviddeaths
 order by 1,2;
 --- exploring second dataset
 select *
 from PortfolioProject.coviddeaths dea
 join PortfolioProject.covidvaccinations vac 
 on dea.location = vac.location
 and dea.date = vac.date;
 ### total population vs vaccinations
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 from PortfolioProject.coviddeaths dea
 join PortfolioProject.covidvaccinations vac 
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3;
 ##
-- USe CTE
with Popvsvac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as float)) over(partition by dea.location order by dea.location, dea.date) as
  RollingPeopleVaccinated
 from PortfolioProject.coviddeaths dea
 join PortfolioProject.covidvaccinations vac 
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 ###order by 2,3;
 )
 select *, (RollingPeopleVaccinated/population)*100
 from Popvsvac;
 ## Creating a View
 create view PercentPopulationVaccinated as
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as float)) over(partition by dea.location order by dea.location, dea.date) as
  RollingPeopleVaccinated
 from PortfolioProject.coviddeaths dea
 join PortfolioProject.covidvaccinations vac 
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 
 
 