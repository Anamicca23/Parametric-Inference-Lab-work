###Complete the codes.The codes were written for a different data set.
##Make appropriate changes to extract the data we are using in the class.
##Install the necessary packages

rm(list = ls())
# Define the widths based on the provided layout
widths <- c(
  4,  # File Identification
  3,  # Schedule
  2,  # Quarter
  2,  # Visit
  1,  # Sector
  2,  # State/Ut Code
  2,  # District Code
  3,  # NSS-Region
  2,  # Stratum
  2,  # Sub-Stratum
  1,  # Sub-Sample
  4,  # Fod Sub-Region
  5,  # FSU
  1,  # Sample Sg/Sb No.
  1,  # Second Stage Stratum No.
  2,  # Sample Household Number
  2,  # Month of Survey
  1,  # Response Code
  1,  # Survey Code
  1   # Reason for Substitution of original household
)

# Define the column names
col.names <- c(
  "File_Identification",
  "Schedule",
  "Quarter",
  "Visit",
  "Sector",
  "State_Ut_Code",
  "District_Code",
  "NSS_Region",
  "Stratum",
  "Sub_Stratum",
  "Sub_Sample",
  "Fod_Sub_Region",
  "FSU",
  "Sample_Sg_Sb_No",
  "Second_Stage_Stratum_No",
  "Sample_Household_Number",
  "Month_of_Survey",
  "Response_Code",
  "Survey_Code",
  "Reason_for_Substitution"
)

# Read the data
level1 <- read.fwf(
  file = "C:/Users/hp/Downloads/Lab1_7Aug/FHH_FV.TXT",
  widths = widths,
  col.names = col.names, n= 102063)

level1
                 
## By including 'common-id'
level2<-read.fwf(file="C:/Users/hp/Downloads/Lab1_7Aug/FPER_FV.TXT", 
                 widths=c(35,2,5,2,5,3,1,1,1,1,1,1,2,8,8,50,3,3,10), 
                 col.names=c("common-id", "level","filler", "hhsize", "NIC", "NCO", 
                             "hhtype","religion", "socialgrp", "latrinetype", "drainagetype",
                             "source_of_drink_water", "primary_source_of_cookingenergy", "amt_med_insurance", 
                             "hh_cons_exp", "blank","NSS", "NSC","MLT"), 
                 n=65932)
level2

#install.packages("readr")
library(readr)
## using the 'readr' package
level3<-read_fwf(file="C:/Users/hp/Downloads/Lab1_7Aug/FHH_FV.TXT", fwf_cols(fsuslno=c(4,8), sector=c(15, 15), subblockno=c(32,32),sssno=c(33,33),hhno=c(34,35),level=c(36,37),filler=c(38,40), personid=c(41,42), sex=c(43,43),ageatdeath=c(44,46),
                                                                 medicalatn=c(47,47),hospitalised=c(48,48),numhospitalised=c(49,50),pregnant=c(51,51),timeofdeath=c(52,52), nss=c(127,129), nsc=c(130,132), mlt=c(133, 142)),
                 col_types = cols(fsuslno=col_character(),sector=col_character(),subblockno=col_character(),sssno=col_character(),hhno=col_character(),level = col_character(),filler = col_character(),personid=col_character(), sex=col_integer(),ageatdeath=col_integer(),
                                  medicalatn=col_integer(), hospitalised=col_integer(), numhospitalised=col_integer(), pregnant=col_integer(), timeofdeath=col_integer(), nss=col_character(), nsc=col_character(),mlt=col_character()))

level3
## using the 'readr' package
level4<-read_fwf(file="C:/Users/hp/Downloads/Lab1_7Aug/FPER_FV.TXT",fwf_cols(fsuslno=c(4,8), sector=c(15, 15), subblockno=c(32,32),sssno=c(33,33),hhno=c(34,35),level=c(36,37),filler=c(38,40), personid=c(41,42),rltntohead=c(43,43),sex=c(44,44), age=c(45,47),
                                                                maritalstatus=c(48,48),education=c(49,50), resident_hostel=c(51,51),hospitalised=c(52,52), numhospitalised=c(53,54),chronicailment=c(55,55),othrailment15days=c(56,56),othrailmentdaybefore=c(57,57),
                                                                healthscheme=c(58,58),reporting=c(59,59), nss=c(127,129), nsc=c(130,132),mlt=c(133,142)),
                 col_types = cols(fsuslno=col_character(),sector=col_character(),subblockno=col_character(),sssno=col_character(),hhno=col_character(),level = col_character(),filler = col_character(),personid=col_character(), rltntohead=col_integer(), sex=col_integer(),age=col_integer(),
                                  maritalstatus=col_integer(),education=col_integer(),resident_hostel=col_integer(),hospitalised=col_integer(),numhospitalised=col_integer(),chronicailment=col_integer(),othrailment15days=col_integer(),othrailmentdaybefore=col_integer(),
                                  healthscheme=col_integer(), reporting=col_integer(),nss=col_character(), nsc=col_character(), mlt=col_character()))

level4