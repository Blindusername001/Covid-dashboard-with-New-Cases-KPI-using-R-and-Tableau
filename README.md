# Covid-dashboard-with-KPI-using-R-and-Tableau

# Building a Covid 19 dashboard which updates regularly with Google sheets and Tableau

Building the below Tableau dashboard with data from UK government website [https://coronavirus.data.gov.uk/details/about-data].
What's different is, we're building a data pipeline which gets the latest data weekly automatically without manual intervention.
This was done with the help of Google sheets and Google scripts.

<img src="/Files_used_for_Read_Me_Doc/c19uk.gif" width="1000" height="480"/>


The outline is to use Google scripts (javascript code) and Trigger functionality in Google scripts to get latest covid data from UK Gov website into a Google sheet.
We will use this google sheet as the source for our Tableau dashboard.


<img src="/Files_used_for_Read_Me_Doc/Process%20outline.png" width="600" height="500"/>


Though it sounds simple, there are a few challenges to overcome which are detailed in the below sections.

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

# STEP 2: Google Sheet and Google Script
Next step is to use javascript code to request the covid data from Gov UK API and store it as a table in a Google sheet.
The entire javascript I used can be found here [https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/UK%20Gov%20covid%2019%20data%20request.js]
It can be seen that the request has 'filter'and 'structure' componenet mentioned on the UK Gov site's developer guide. 
The javascript requests the data and saves it in a google sheet.
Below is an exceprt of the data in google sheet.

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/Google%20sheet%20data.png" width="900" height="200"/>

After this, we should create a Trigger for the script to run once a week and refresh this data.
To keep the entore process clean and simple, my script clears the sheet prior to pasting new data in it. So anytime the script runs and gets a response, only the latest data will be available in the Google sheet.
Below is a screenshot of the trigger for my script.

<img src="https://github.com/karthikkumar001/Live-Covid-19-Dashboard-with-UK-Gov-data/blob/main/Files_used_for_Read_Me_Doc/Google%20script%20trigger.png" width="300" height="200"/>


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
