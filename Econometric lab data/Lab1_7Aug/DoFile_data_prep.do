clear

cd "F:\BITMesraCQEDS\BasicEconometricsLab\Lab1_7Aug"

infix using "HouseholdVisit1.dct", using("FHH_FV.TXT")
*gen Primary ID
egen PrimaryKey=concat( Quarter Visit FSU SampleNo SSSNo SampleHhdNo)
egen PrimaryKey1=concat(FSU SampleNo SSSNo SampleHhdNo)
egen QtrVisit=concat (Quarter Visit)
tostring SurveyDate, generate(SurveyDate1)
gen Date=date(SurveyDate1,"YMD")
format Date %td
save HouseholdVisit1,replace



clear
infix using "PersonVisit1.dct", using("FPER_FV.TXT")
*gen Primary ID
egen PrimaryKey=concat( Quarter Visit FSU SampleNo SSSNo SampleHhdNo)
egen PrimaryKey1=concat(FSU SampleNo SSSNo SampleHhdNo)
egen PersonID=concat(FSU SampleNo SSSNo SampleHhdNo PersonSrlNo)
egen QtrVisit=concat (Quarter Visit)
save PersonVisit1,replace

*merge Household data with Person data Q2V1
merge m:m PrimaryKey using "HouseholdVisit1.dta"

save Visit1Merged, replace








