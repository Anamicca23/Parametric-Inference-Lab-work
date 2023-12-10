clear

cd "E:\Informal_Elections\PLFS201718"

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


****Weight
gen Weight= Multiplier/100 if NSS== NSC
replace Weight= Multiplier/200 if NSS!= NSC

****Gender***
gen Male=1 if Sex==1
gen Female=1 if Sex==2

for varlist Male Female :replace X=0 if X==.


*****Location-rural urban
gen Rural=1 if Sector==1
recode Rural .=0

*****Employment status
drop if PrincSatusCode==91 //attended educational institution
drop if PrincSatusCode==94 //rentiers, pensioners , remittance recipients, etc.
drop if PrincSatusCode==95 //not able to work due to disability
drop if PrincSatusCode==99 //not known

gen HhdEntOAE=1 if PrincSatusCode==11 //worked in h.h. enterprise (self-employed): own account worker
gen HhdEntEmployer=1 if PrincSatusCode==12 // worked in h.h. enterprise (self-employed):employer
gen HhdEntUnpaid=1 if PrincSatusCode==21 // worked in h.h. enterprise (self-employed):worked as helper in h.h. enterprise(unpaid family worker)
gen SalariedWageEmp=1 if PrincSatusCode==31 // worked as regular salaried/ wage employee
gen CasualWagePubWork=1 if PrincSatusCode==41 // worked as casual wage labour: in public works
gen CasualWageOth=1 if PrincSatusCode==51 // worked as casual wage labour: in other types of work
gen Available4Work=1 if PrincSatusCode==81 // did not work but was seeking and/or available for work
gen DomesticDuties=1 if PrincSatusCode==92 //attended domestic duties only
gen DomesticDutiesCollection=1 if PrincSatusCode==93 //attended domestic duties and was also engaged in free collection of goods (vegetables, roots, firewood, cattle feed, etc.), sewing, tailoring, weaving, etc. for household use
gen Others=1 if PrincSatusCode==97 //others (including begging, prostitution, etc.)


for varlist HhdEntOAE HhdEntEmployer HhdEntUnpaid SalariedWageEmp CasualWagePubWork CasualWageOth Available4Work DomesticDuties DomesticDutiesCollection Others : replace X=0 if X==.

gen Employed=1 if PrincSatusCode==11|PrincSatusCode==12|PrincSatusCode==21|PrincSatusCode==31|PrincSatusCode==41|PrincSatusCode==51
recode Employed .=0

gen NCO2Digit=substr(PrincNCO3Digit,1,2)

gen Professional=1 if NCO2Digit=="11"|NCO2Digit=="12"|NCO2Digit=="13"|NCO2Digit=="21"|NCO2Digit=="22"|NCO2Digit=="23"|NCO2Digit=="24"
gen Clerical=1 if NCO2Digit=="31"|NCO2Digit=="32"|NCO2Digit=="33"|NCO2Digit=="34"|NCO2Digit=="41"|NCO2Digit=="42"
gen Farming=1 if NCO2Digit=="61"|NCO2Digit=="62"
gen HighStatus=1 if NCO2Digit=="51"|NCO2Digit=="52"
gen LowStatus=1 if  NCO2Digit=="71"|NCO2Digit=="72"|NCO2Digit=="73"|NCO2Digit=="74"|NCO2Digit=="81"|NCO2Digit=="82"|NCO2Digit=="83"
gen Elementary=1 if  NCO2Digit=="91"|NCO2Digit=="92"|NCO2Digit=="93"|NCO2Digit=="98"|NCO2Digit=="99"

gen Administration=1 if NCO2Digit=="11"
gen Managers=1 if NCO2Digit=="12"|NCO2Digit=="13"
gen ProfNCO=1 if NCO2Digit=="21"|NCO2Digit=="22"|NCO2Digit=="23"|NCO2Digit=="24"
gen AssociateProfNCO=1 if NCO2Digit=="31"|NCO2Digit=="32"|NCO2Digit=="33"|NCO2Digit=="34"
gen Clerk=1 if NCO2Digit=="41"|NCO2Digit=="42"

for varlist Professional Clerical Farming HighStatus LowStatus Elementary Administration Managers ProfNCO AssociateProfNCO Clerk :replace X=0 if X==.





****Treatment- firms with 10 or more workers
gen WorkerLess6=1 if PrincNumWorkers==1
gen Worker6to9=1 if PrincNumWorkers==2
gen Worker10to19=1 if PrincNumWorkers==3
gen Worker20above=1 if PrincNumWorkers==4
gen WorkerNotKnown=1 if PrincNumWorkers==5
gen Treatment=1 if PrincNumWorkers==3|PrincNumWorkers==4
for varlist WorkerLess6 Worker6to9 Worker10to19 Worker20above WorkerNotKnown Treatment :replace X=0 if X==.

*****Location of firms
gen PlaceOwnDwelling=1 if PrincWorkplaceLocation==10|PrincWorkplaceLocation==11|PrincWorkplaceLocation==12|PrincWorkplaceLocation==13|PrincWorkplaceLocation==20|PrincWorkplaceLocation==21|PrincWorkplaceLocation==22|PrincWorkplaceLocation==23
gen PlaceEmployerDwelling=1 if PrincWorkplaceLocation==15|PrincWorkplaceLocation==25
gen PlaceOwnOffice=1 if PrincWorkplaceLocation==14|PrincWorkplaceLocation==24
gen PlaceEmployerOffice=1 if PrincWorkplaceLocation==16|PrincWorkplaceLocation==26
gen PlaceStreetFixed=1 if PrincWorkplaceLocation==17|PrincWorkplaceLocation==27
gen PlaceConstructionSite=1 if PrincWorkplaceLocation==18|PrincWorkplaceLocation==28
gen PlaceStreetNoFixed=1 if PrincWorkplaceLocation==99
gen PlaceOther=1 if PrincWorkplaceLocation==19|PrincWorkplaceLocation==29
for varlist PlaceOwnDwelling PlaceEmployerDwelling PlaceOwnOffice PlaceEmployerOffice PlaceStreetFixed PlaceConstructionSite PlaceStreetNoFixed PlaceOther: replace X=0 if X==.


*****Type of firms
gen MaleProp=1 if PrincEnterpriseType==1
gen FemaleProp=1 if PrincEnterpriseType==2
gen PartSameHhd=1 if PrincEnterpriseType==3
gen PartOthHhd=1 if PrincEnterpriseType==4
gen GovtPubSec=1 if PrincEnterpriseType==5|PrincEnterpriseType==6
gen PvtLtdCom=1 if PrincEnterpriseType==8
gen NonProfit=1 if PrincEnterpriseType==11
gen EmployeesHhd=1 if PrincEnterpriseType==12
gen OtherEntTyp=1 if PrincEnterpriseType==19
gen FormalLarge=1 if PrincEnterpriseType==5|PrincEnterpriseType==6|PrincEnterpriseType==8
for varlist MaleProp FemaleProp PartSameHhd PartOthHhd GovtPubSec PvtLtdCom NonProfit EmployeesHhd OtherEntTyp FormalLarge : replace X=0 if X==.



gen PubPvtLtd=1 if GovtPubSec==1|PvtLtdCom==1
recode PubPvtLtd .=0


*****Contract with employer
gen NoContract=1 if PrincJobContract==1
gen Contract1yr=1 if PrincJobContract==2
gen Contract1to3yr=1 if PrincJobContract==3
gen Contract3yr=1 if PrincJobContract==4
gen AnyContract=1 if PrincJobContract==2| PrincJobContract==3|PrincJobContract==4
for varlist NoContract Contract1yr Contract1to3yr Contract3yr Contract3yr AnyContract: replace X=0 if X==.

****Eligible for paid leave

gen PaidLeave=1 if  PrincPaidLeave==1
recode PaidLeave .=0

*****Social Security benefits
gen PFPensionNoHealth=1 if PrincSocialSecurity==1| PrincSocialSecurity==2| PrincSocialSecurity==4
gen Health=1 if PrincSocialSecurity==3| PrincSocialSecurity==5| PrincSocialSecurity==7
gen AnySocialSecurity=1 if PrincSocialSecurity==1| PrincSocialSecurity==2| PrincSocialSecurity==4|PrincSocialSecurity==3| PrincSocialSecurity==5| PrincSocialSecurity==7
for varlist PFPensionNoHealth Health AnySocialSecurity : replace X=0 if X==.

gen MaternityBen=1 if PrincSocialSecurity==3|PrincSocialSecurity==5|PrincSocialSecurity==6|PrincSocialSecurity==7
recode MaternityBen .=0

gen AnySocialSecurityBen=1 if PrincSocialSecurity==2|PrincSocialSecurity==5|PrincSocialSecurity==6|PrincSocialSecurity==7|PrincSocialSecurity==1|PrincSocialSecurity==3|PrincSocialSecurity==4
recode AnySocialSecurityBen .=0

gen FormalEmpWithMatBen=1 if  MaternityBen==1 & SalariedWageEmp==1
recode FormalEmpWithMatBen .=0

gen FormalEmpWithAnySSBen=1 if  AnySocialSecurityBen==1 & SalariedWageEmp==1
recode FormalEmpWithAnySSBen .=0

gen InformalWage=1 if CasualWagePubWork==1 | CasualWageOth==1
recode InformalWage .=0

gen InformalSector=1 if InformalWage==1| HhdEntOAE==1| HhdEntEmployer==1| HhdEntUnpaid==1
recode InformalSector .=0

****Individual controls

gen AgeSquare=Age*Age

gen Married=1 if MaritalStatus==2
recode Married .=0


gen RelnSelf=1 if RelationToHead==1
gen RelnSpouseHead=1 if RelationToHead==2
gen RelnHeadsChild=1 if RelationToHead==3| RelationToHead==5
gen RelnHeadsChildSpouse=1 if RelationToHead==4
gen RelnHeadOther=1 if RelationToHead==6| RelationToHead==7| RelationToHead==8| RelationToHead==9
for varlist RelnSelf RelnSpouseHead RelnHeadsChild RelnHeadsChildSpouse RelnHeadOther : replace X=0 if X==.


gen GenEdu_NotLiterate=1 if GenEduLevel==1
gen GenEdu_BelowSecondary=1 if GenEduLevel==2|GenEduLevel==3|GenEduLevel==4|GenEduLevel==5|GenEduLevel==6|GenEduLevel==7
gen GenEdu_Secondary=1 if GenEduLevel==8
gen GenEdu_HigherSecondary=1 if GenEduLevel==10
gen GenEdu_Diploma=1 if GenEduLevel==11
gen GenEdu_Graduate=1 if GenEduLevel==12
gen GenEdu_PGAbove=1 if GenEduLevel==13

gen HSAbove=1 if GenEdu_HigherSecondary==1| GenEdu_Diploma==1| GenEdu_Graduate==1| GenEdu_PGAbove==1

for varlist GenEdu_NotLiterate GenEdu_BelowSecondary GenEdu_Secondary GenEdu_HigherSecondary GenEdu_Diploma GenEdu_Graduate GenEdu_PGAbove HSAbove : replace X=0 if X==.


gen NoTechnicalEdu=1 if TechnicalEduLevel==1
gen TechnicalDegree=1 if TechnicalEduLevel==2|TechnicalEduLevel==3|TechnicalEduLevel==4|TechnicalEduLevel==5|TechnicalEduLevel==6
gen TechnicalGraduateDiploma=1 if TechnicalEduLevel==12|TechnicalEduLevel==13|TechnicalEduLevel==14|TechnicalEduLevel==15|TechnicalEduLevel==16
gen TechnicalDiploma=1 if TechnicalEduLevel==7|TechnicalEduLevel==8|TechnicalEduLevel==9|TechnicalEduLevel==10|TechnicalEduLevel==11

for varlist NoTechnicalEdu TechnicalDegree TechnicalGraduateDiploma TechnicalDiploma : replace X=0 if X==.

*****Household controls

rename HouseholdSize HouseholdSize


***Religion
gen Hindu=1 if Religion==1
gen Muslim=1 if Religion==2
gen Other=1 if Religion==3| Religion==4| Religion==5| Religion==6| Religion==7| Religion==9
for varlist Hindu Muslim Other: replace X=0 if X==.

**Social group
gen ST=1 if SocialGroup==1
gen SC=1 if SocialGroup==2
gen OBC=1 if SocialGroup==3
gen Gen=1 if SocialGroup==9
for varlist ST SC OBC Gen: replace X=0 if X==.

gen Activity1Weekhrs = HoursWorkedAct1Day7+ HoursWorkedAct1Day6+ HoursWorkedAct1Day5+ HoursWorkedAct1Day4+ HoursWorkedAct1Day3+ HoursWorkedAct1Day2+ HoursWorkedAct1Day1

*****TimeDistrictFE
rename DistrictCode District
egen DistrictCode=concat( StateCode District)
gen Round="17"
egen DistTimeFE=concat( DistrictCode Round)


rename FSU Fsu


gen Post=1

keep Fsu Round StateCode DistrictCode Male Female Rural Weight HhdEntOAE HhdEntEmployer HhdEntUnpaid SalariedWageEmp CasualWagePubWork ///
CasualWageOth DomesticDuties DomesticDutiesCollection Others Employed WorkerLess6 Worker6to9 Worker10to19 Worker20above WorkerNotKnown ///
Treatment PlaceOwnDwelling PlaceOwnOffice PlaceEmployerDwelling PlaceEmployerOffice PlaceStreetFixed PlaceConstructionSite PlaceStreetNoFixed ///
PlaceOther MaleProp FemaleProp PartSameHhd PartOthHhd GovtPubSec PvtLtdCom NonProfit EmployeesHhd OtherEntTyp FormalLarge NoContract Contract1yr ///
Contract1to3yr Contract3yr AnyContract PaidLeave PFPensionNoHealth Health AnySocialSecurity MaternityBen AnySocialSecurityBen FormalEmpWithMatBen ///
 FormalEmpWithAnySSBen InformalWage InformalSector Age AgeSquare Married RelnSelf RelnSpouseHead RelnHeadsChild RelnHeadsChildSpouse RelnHeadOther ///
 GenEdu_NotLiterate GenEdu_BelowSecondary GenEdu_Secondary GenEdu_HigherSecondary GenEdu_Diploma GenEdu_Graduate GenEdu_PGAbove NoTechnicalEdu ///
 TechnicalDegree TechnicalGraduateDiploma TechnicalDiploma HouseholdSize Hindu Muslim Other ST SC OBC Gen DistTimeFE Post Activity1Weekhrs ///
 ManagerProfessional MaleProp FemaleProp PartSameHhd PartOthHhd GovtPubSec PvtLtdCom NonProfit EmployeesHhd OtherEntTyp PubPvtLtd Administration Managers ProfNCO AssociateProfNCO Clerk


keep if Employed==1

save "E:\Informal_Elections\PLFS201718\Round17_A", replace
