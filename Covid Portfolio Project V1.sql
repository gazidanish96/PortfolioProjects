select *
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2
 
select location,date,total_cases,population,total_cases,(total_cases/population)*100 as PopulationInfectedPercentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
order by 1,2

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as InfectionRate
from PortfolioProject..CovidDeaths
group by location,population
order by InfectionRate desc

select location,max(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

select location,max(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is  null
group by location
order by TotalDeathCount desc

select continent,max(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2

select date,sum(new_cases) as SumofNewCases,sum(Cast(new_deaths as int)) as SumofNewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathPercentage
--total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select *
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int))  over (partition by dea.location) as TotalVaccinations
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Getting error
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations))  over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Getting error
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations))  over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3



with PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
( 
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations))  over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac





drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations))  over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select *,(RollingPeopleVaccinated/population)*100 as VaccinationPercentage
from #PercentPopulationVaccinated



Create view PercentPopulationVaccinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations))  over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated




