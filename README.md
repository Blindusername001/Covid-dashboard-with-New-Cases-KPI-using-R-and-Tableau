# Covid-dashboard-with-KPI-using-R-and-Tableau

<img src="https://github.com/Blindusername001/Self-Updating-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/u8.gif" width="1000" height="450"/>

The outline is to get UK covid data from UK Gov's web API using R and then use Tableau to create a dashboard containing KPI details.
Our aim is to downlaod the recent 7 days of data and create a dashboard showing,
1. country level new cases (England, Wales, Scotland, Northern Ireland) 
2. ltla level new cases
3. KPI showing the day to day increase in new cases (current vs previous day)


# STEP 1: Getting data from UK Gov website

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/Image%20for%20first%20step.png" width="450" height="250"/>


## Covid dataset at Local Authority Level
This is our main dataset of interest. 
We have to look into the developer's guide [https://coronavirus.data.gov.uk/details/developers-guide] to understand how a request has to be sent and how the response will be structured.
Below is the instructions from the website as on 27/02/2020. 'filter'and 'structure'are mandatory components of any request while 'format'and 'page'are optional.

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/UK%20Gov%20API%20request%20structure.png" width="700" height="200"/>

## Spatial data at Local Authority Level
Tableau does not have the UK geographical information at the level of local authority built-in. So we have to get the spatial file from https://geoportal.statistics.gov.uk/.
The tricky part here is to download the spatial file that matches with the local authority information recieved in the Covid data. 
The latest spatial file (2020) was not apt as the covid dataset contained Buckinghamshire split into its component districts. 
After some research I found the 2019 Spatial data [https://geoportal.statistics.gov.uk/datasets/1d78d47c87df4212b79fe2323aae8e08_0] to be the most suitable one as it has the local districts inline with the covid dataset.
Note: THe only mismatch with 2019 spatial data is that Hackney and City of London are mentioned as separate districts whereas in the covid dataset they are combined. But because we are matching the datasets on the area code, this does not pose a threat.

## Local Authority to country mapping data
Since the covid dataset we get has only the local authority districts, we need data to map the distrcits to their respective countries.
For this, again 2019 mapping data was the suitable one. [https://geoportal.statistics.gov.uk/datasets/5b80bff593974bf8b6dbf080a6057b09_0]

# STEP 2: Downloading covid data via API through R

First, we install the api sdk using the install_github command that is part of devtools package in R,
install_github("publichealthengland/coronavirus-dashboard-api-R-sdk")

To request data, the query has to be structured with two components,
1. the filters to be used
2. the parameters or the fields which we require

These can be viewed in the R code,
[https://github.com/Blindusername001/Covid-dashboard-with-New-Cases-KPI-using-R-and-Tableau/blob/main/R%20code/ukcovid19%20api%20code.R]

Once requested, data is returned as a dataframe. The code uses 7 requests to request data for 7 days. 


# STEP 3: Building the dashboard in Tableau
Import and relate the three datasets mentioned in Step 1 using the local authority code.

## country level data

Form a small table using circles in the Marks area as below to display [new cases on publish date] value for the latest date. The latest date can be programmed through the 'top' option in filter properties.

Next, create a basic line graph showing the level of cases across 7 days at a country level. Add the average line as reference to provide more intuition.


## Area (ltla) level map data

Create a calculated field called [newCasesOnMaxDate] to always provided [new cases on publish date] values on the max(date) in our dataset.

![image](https://user-images.githubusercontent.com/72069602/118417743-62e98280-b6ad-11eb-9466-1012fbcde128.png)


Create a map visualization using the shape file downloaded above. Add [Area Name] to details and use [newCasesOnMaxDate] field to color the map.


## Area (ltla) level KPI

This needs creation of multiple calculated fields,
1. [newCasesOnPrevDate] - to give the [new cases on publish date] values on previous date (compared to the latest date)
2. [currentVsPrevDay] - to give the difference between sum([newCasesOnMaxDate]) - sum([newCasesOnPrevDate])
3. [currentVsPrevDay%] - to give the percentage difference [(sum([newCasesOnMaxDate]) - sum([newCasesOnPrevDate]))/sum([newCasesOnPrevDate])]
4. [downArrow], [upArrow] - these are required for displaying an arrow corresponding to the percentage change specifying if there was an increase or decrease. For this the geometric shape symbol has to be copy pasted either from MS Word or from any other online resouce [https://en.wikipedia.org/wiki/Geometric_Shapes]

After creating the calculated fields, use Text in the Marks options and edit Label option to format the KPI as required.

## Are (ltla) level line graph

Create a simple line graph to display the [new cases on publish date] values across the 7 days


## Dashboard:
Create the dashboard with the above components. 
Use Action Filters to make the Dashboard interactive.
It is also advisable to use a dynamic title for shets on the dashboard to avoid confusions when filtering.

This can be interactively viewed on,
https://public.tableau.com/profile/karthik.kumar8709#!/vizhome/UK_Covid19_KPI_Dashboard_R_Tableau/Dashboard1


