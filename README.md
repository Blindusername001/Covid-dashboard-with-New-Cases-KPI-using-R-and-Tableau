# Covid-dashboard-with-KPI-using-R-and-Tableau

<img src="https://github.com/Blindusername001/Self-Updating-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/u8.gif" width="1000" height="350"/>

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

## worksheet 1
Build a worksheet to show country level data. The image below has details on building it.

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/worksheet-1.png" width="400" height="250"/>

## worksheet 2
Build a worksheet showing local authority districts and cumulative, new cases in each district.
We will be using the spatial file from geoportal.statistics.gov.uk in this worksheet.
When building this, we have to create,
1. 4 calculated parameters, one for each country and use each in a map layer before merging all 4 map layers
2. A calculated parameter for Max date so that we can dynamically update the dashboard title with the date of dataset


<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/worksheet%202.png" width="400" height="200"/>


## Worksheets 3 and 4:
Build bar graphs for cumulative and new cases by local authority districts

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/worksheet3%264.png" width="400" height="200"/>

## Dashboard:
Create the dashboard with the four worksheets and add a dynamically updating title
This can be interactively viewed on,
https://public.tableau.com/shared/QG6X2K3FM?:display_count=y&:origin=viz_share_link

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/dashboard.png" width="400" height="200"/>
