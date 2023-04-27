

SELECT * FROM SQLPROJECT..CovidDeaths
ORDER BY 3,4

SELECT * 
FROM SQLPROJECT..CovidVaccinations
ORDER BY 3,4

select location,date,total_cases,new_cases,total_deaths,new_deaths,population
FROM SQLPROJECT..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM SQLPROJECT..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths in US
--shows what percentage of population is dead who got covid in INDIA

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM SQLPROJECT..CovidDeaths
where location like '%ndia%'
order by 1,2


--Looking at Total Cases vs Population in US
--shows what percentage of population got covid in INDIA

select location,date,population,total_cases,(total_cases/population)*100 as CasePercentage
FROM SQLPROJECT..CovidDeaths
where location like '%ndia%'
order by 1,2


--Looking at countries with highest Infection Rate compared to population

select location,population,MAX(total_cases) as HighestCaseCount,MAX((total_cases/population))*100 as PercentsPopulationInfected
FROM SQLPROJECT..CovidDeaths
--where location like '%ndia%'
group by location,population
order by PercentsPopulationInfected DESC

----Looking at continents with highest Infection Rate compared to population

select continent,population,MAX(total_cases) as HighestCaseCount,MAX((total_cases/population))*100 as PercentsPopulationInfected
FROM SQLPROJECT..CovidDeaths
where continent is not null
group by continent,population
order by PercentsPopulationInfected DESC


--Looking at countries with Total Death Count

select location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM SQLPROJECT..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount DESC

--Breaking ata into continents

-- showing continents with highest death count per population

select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM SQLPROJECT..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC

--Playing with global numbers
--summing up cases by date in all countries

select date,SUM(new_cases) as Totalcases,SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentageperDay
FROM SQLPROJECT..CovidDeaths
where  continent is not null 
Group by date
order by 1,2

--to check overall death percentage

select SUM(new_cases) as Totalcases,SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentageperDay
FROM SQLPROJECT..CovidDeaths
where  continent is not null 
order by 1,2

--join Vaccination table

Select * 
From SQLPROJECT..CovidDeaths as death
join SQLPROJECT..CovidVaccinations as vacc
    on death.location=vacc.location
    and death.date=vacc.date

--Get appropriate data

Select death.continent,death.location,death.date,death.population,vacc.new_vaccinations
From SQLPROJECT..CovidDeaths as death
join SQLPROJECT..CovidVaccinations as vacc
    on death.location=vacc.location
    and death.date=vacc.date
where death.continent is not null 
order by 2,3


--using partition and convert to change data type
--summing up vaccination values by order of location and date

Select death.continent,death.location,death.date,death.population,vacc.new_vaccinations
,SUM(convert(int,vacc.new_vaccinations)) OVER (Partition by death.location Order by death.location,death.date)
From SQLPROJECT..CovidDeaths as death
join SQLPROJECT..CovidVaccinations as vacc
    on death.location=vacc.location
    and death.date=vacc.date
where death.continent is not null 


--USE CTE

with popvsvac(Continent,Location,Date,Population,new_vaccinations)
as
(
Select death.continent,death.location,death.date,death.population,vacc.new_vaccinations
From SQLPROJECT..CovidDeaths as death
join SQLPROJECT..CovidVaccinations as vacc
    on death.location=vacc.location
    and death.date=vacc.date
where death.continent is not null 

)


Select *,(new_vaccinations/population)*100 FROM popvsvac


--Temp Table


Drop Table if exists #PopulationVaccinated
Create Table #PopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric
)

Insert into #PopulationVaccinated
Select death.continent,death.location,death.date,death.population,vacc.new_vaccinations
From SQLPROJECT..CovidDeaths as death
join SQLPROJECT..CovidVaccinations as vacc
    on death.location=vacc.location
    and death.date=vacc.date
where death.continent is not null 

select * FROM #PopulationVaccinated



--creating views to store data for visualizations

Create view peoplevaccinated as 
Select death.continent,death.location,death.date,death.population,vacc.new_vaccinations
From SQLPROJECT..CovidDeaths as death
join SQLPROJECT..CovidVaccinations as vacc
    on death.location=vacc.location
    and death.date=vacc.date
where death.continent is not null 















































