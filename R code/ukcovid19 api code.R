#-----------Load library
require(ukcovid19)
require(openxlsx)
#-----------Form query components
#-----ukcovid19 API requires filters and parameters in the request

dtf=data.frame(matrix(ncol=0,nrow=0))
print(dim(dtf))

parameters = list(
  areaType="areaType",
  areaName="areaName",
  areaCode="areaCode",
  date="date",
  newCasesByPublishDate="newCasesByPublishDate",
  cumCasesByPublishDate="cumCasesByPublishDate",
  cumCasesByPublishDateRate="cumCasesByPublishDateRate",
  newCasesBySpecimenDate="newCasesBySpecimenDate",
  cumCasesBySpecimenDate="cumCasesBySpecimenDate",
  cumCasesBySpecimenDateRate="cumCasesBySpecimenDateRate",
  maleCases="maleCases",
  femaleCases="femaleCases",
  newAdmissions="newAdmissions",
  cumAdmissions="cumAdmissions",
  cumAdmissionsByAge="cumAdmissionsByAge",
  cumTestsByPublishDate="cumTestsByPublishDate",
  newTestsByPublishDate="newTestsByPublishDate",
  covidOccupiedMVBeds="covidOccupiedMVBeds",
  hospitalCases="hospitalCases",
  newDeaths28DaysByPublishDate="newDeaths28DaysByPublishDate",
  cumDeaths28DaysByPublishDate="cumDeaths28DaysByPublishDate",
  cumDeaths28DaysByPublishDateRate="cumDeaths28DaysByPublishDateRate",
  newDeaths28DaysByDeathDate="newDeaths28DaysByDeathDate",
  cumDeaths28DaysByDeathDate="cumDeaths28DaysByDeathDate",
  cumDeaths28DaysByDeathDateRate="cumDeaths28DaysByDeathDateRate"
)

for (i in 1:7){
  
  query_filters <- query_filters <- c(
    'areaType=ltla',
    sprintf("date=%s", Sys.Date()-(i-1))
  )  
  
  if (is.null(dim(dtf)[1])) {
  dtf <- get_data(filters = query_filters, structure = parameters)  
  print(head(dtf))
  } else {
    tmp_df <- get_data(filters = query_filters, structure = parameters)  
    dtf <- rbind(dtf, tmp_df)
    print(head(dtf))
  }
  
}


if (file.exists("C:\\Users\\Karthik\\Desktop\\UKCovid19 API Codes\\R Excel File\\UK_7day_Covid_Data.xlsx") == FALSE) {
  wb <- createWorkbook(creator = "kk")
  addWorksheet(wb,"UK_7day_Covid_API_Data")
  writeData(wb, x = dtf, sheet = "UK_7day_Covid_API_Data")
  saveWorkbook(wb, file = "C:\\Users\\Karthik\\Desktop\\UKCovid19 API Codes\\R Excel File\\UK_7day_Covid_Data.xlsx", overwrite = TRUE)
} else {
  wb <- loadWorkbook("C:\\Users\\Karthik\\Desktop\\UKCovid19 API Codes\\R Excel File\\UK_7day_Covid_Data.xlsx")
    if("UK_7day_Covid_API_Data" == names(wb) || "UK_7day_Covid_API_Data" %in% names(wb) == TRUE){
      #removeWorksheet(wb, "UK_7day_Covid_API_Data")
      deleteData(wb, "UK_7day_Covid_API_Data", 1:25, 1:100000, gridExpand = TRUE)
      saveWorkbook(wb, file = "C:\\Users\\Karthik\\Desktop\\UKCovid19 API Codes\\R Excel File\\UK_7day_Covid_Data.xlsx", overwrite = TRUE)

    }
  #addWorksheet(wb,"UK_7day_Covid_API_Data")
  writeData(wb, x = dtf, sheet = "UK_7day_Covid_API_Data")        
  saveWorkbook(wb, file = "C:\\Users\\Karthik\\Desktop\\UKCovid19 API Codes\\R Excel File\\UK_7day_Covid_Data.xlsx", overwrite = TRUE)  
}
