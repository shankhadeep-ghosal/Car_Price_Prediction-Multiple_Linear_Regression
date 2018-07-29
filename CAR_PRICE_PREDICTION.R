# # Data Dictionary 
# #-----------------------------------------------------
# # Car_ID			Unique id of each observation (Interger)		
# # Symboling 			Its assigned insurance risk rating, A value of +3 indicates that the auto is risky, -3 that it is probably pretty safe.(Categorical) 		
# # carCompany			Name of car company (Categorical)		
# # fueltype			Car fuel type i.e gas or diesel (Categorical)		
# # aspiration			Aspiration used in a car (Categorical)		
# # doornumber			Number of doors in a car (Categorical)		
# # carbody			body of car (Categorical)		
# # drivewheel			type of drive wheel (Categorical)		
# # enginelocation			Location of car engine (Categorical)		
# # wheelbase			Weelbase of car (Numeric)		
# # carlength			Length of car (Numeric)		
# # carwidth			Width of car (Numeric)		
# # carheight			height of car (Numeric)		
# # curbweight			The weight of a car without occupants or baggage. (Numeric)		
# # enginetype			Type of engine. (Categorical)		
# # cylindernumber			cylinder placed in the car (Categorical)		
# # enginesize			Size of car (Numeric)		
# # fuelsystem			Fuel system of car (Categorical)		
# # boreratio			Boreratio of car (Numeric)		
# # stroke			Stroke or volume inside the engine (Numeric)		
# # compressionratio			compression ratio of car (Numeric)		
# # horsepower			Horsepower (Numeric)		
# # peakrpm			car peak rpm (Numeric)		
# # citympg			Mileage in city (Numeric)		
# # highwaympg			Mileage on highway (Numeric)		
# # 26	price(Dependent variable)			Price of car (Numeric)
# #---------------------------------------------------------
# #Install packages
# #-------------------
# install.packages("dplyr")
# library("dplyr")
# install.packages("stringr")
# library("stringr")
# install.packages("lubridate")
# library("lubridate")
# install.packages("ggplot2")
# library("ggplot2")
# install.packages("MASS")
# library("MASS")
# install.packages("car")
# library("car")
# install.packages("caTools")
# library("caTools")
# install.packages("ggcorrplot")
# library("ggcorrplot")
# #Load data and understanding the datastructure
# #---------------------------------------------
# options(scipen=999)
# car_price_df <- read.csv("CarPrice_Assignment.csv")
# 
# View(car_price_df)
# #checking for NA Values
# #----------------------
# 
# sapply(car_price_df,function(x) sum(is.na(x)))
# 
# #conclusion <- There is no NA values
# 
# #checking  the data structure
# #-----------------------------
# 
# glimpse(car_price_df)
# 
# #data cleaning and preperation
# #------------------------------
# 
# #Convert CarName to lower case
# car_price_df$CarName<- tolower(car_price_df$CarName)
# 
# #Replace all "-" with " "
# car_price_df$CarName <- str_replace_all(car_price_df$CarName, "-"," ")
# 
# #Create separate column with Company name
# car_price_df$Company <- word(car_price_df$CarName,1)
# 
# #look into the Company column
# table(car_price_df$Company)
# 
# #Found data inconsistancy in spelling
# 
# # correct spelling mistakes in Company names
# car_price_df$Company <- str_replace_all(car_price_df$Company,"maxda","mazda")
# car_price_df$Company <- str_replace_all(car_price_df$Company,"porcshce","porsche")
# car_price_df$Company <- str_replace_all(car_price_df$Company,"vokswagen","volkswagen")
# car_price_df$Company <- str_replace_all(car_price_df$Company,"vw","volkswagen")
# car_price_df$Company <- str_replace_all(car_price_df$Company,"toyouta","toyota")
# 
# car_price_df$Company<-as.factor(car_price_df$Company)
# 
# #Outliers checking
# 
# outlier_detection <- function(data,var){
#   var <- eval(substitute(var),eval(data))
#   na_1 <- sum(is.na(var))
#   par(mfrow = c(2,2))
#   boxplot(var, horizontal = T)
#   hist(var, main = "With Outliers")
#   outlier <- boxplot.stats(var)$out
#   length(outlier)
#   
#   upper_limit <- as.numeric(quantile(var)[4] + 1.5*IQR(var))
#   # var_within_upper_limit <- ifelse(var <= upper_limit,var,NA)
#   var <- ifelse(var %in% outlier, NA, var)
#   boxplot(var, horizontal = T)
#   hist(var, main = "Without Outliers")
#   
#   title("Outlier Check", outer=TRUE)
#   
#   na_2 <- sum(is.na(var))
#   cat("Outliers identified:", na_2 - na_1, " ")
#   cat("Propotion of outliers:", round((na_2 - na_1) / sum(!is.na(var))*100, 1), "%")
#   return(upper_limit)
# }
# 
# 
# outlier_detection(car_price_df,wheelbase)
# # wheelbase has outliers but it is very low.NoACTION
# outlier_detection(car_price_df,carlength)
# # carlength has outliers but it is very low.NoACTION
# 
# upper_carwidth <- outlier_detection(car_price_df,carwidth)
# 
# car_price_df$carwidth <- ifelse(car_price_df$carwidth >= upper_carwidth,NA,car_price_df$carwidth)
# 
# sum(is.na(car_price_df$carwidth))
# 
# car_price_df$carwidth <- ifelse(is.na(car_price_df$carwidth)
#                                 ,ave(car_price_df$carwidth, FUN = function(x) mean(x, na.rm = TRUE)),
#                                 car_price_df$carwidth)
# 
# #carwidth has outliers and we replaced them with mean
# 
# outlier_detection(car_price_df,carheight)
# outlier_detection(car_price_df,curbweight)
# 
# #curbweight,carheight has no outliers
# 
# upper_enginesize <- outlier_detection(car_price_df,enginesize)
# 
# car_price_df$enginesize <- ifelse(car_price_df$enginesize >= upper_enginesize,NA,car_price_df$enginesize)
# 
# sum(is.na(car_price_df$enginesize))
# 
# car_price_df$enginesize <- ifelse(is.na(car_price_df$enginesize)
#                                 ,ave(car_price_df$enginesize, FUN = function(x) mean(x, na.rm = TRUE)),
#                                 car_price_df$enginesize)
# 
# #car_price_df$enginesize has outliers and we replaced them with mean
# 
# 
# outlier_detection(car_price_df,boreratio)
# 
# #boreratio has no outliers
# 
# upper_stroke <- outlier_detection(car_price_df,stroke)
# 
# car_price_df$stroke <- ifelse(car_price_df$stroke >= upper_stroke,NA,car_price_df$stroke)
# 
# sum(is.na(car_price_df$stroke))
# 
# car_price_df$stroke <- ifelse(is.na(car_price_df$stroke)
#                                   ,ave(car_price_df$stroke, FUN = function(x) mean(x, na.rm = TRUE)),
#                                   car_price_df$stroke)
# 
# #stroke has outliers and we replaced them with mean
# 
# upper_compressionratio <- outlier_detection(car_price_df,compressionratio)
# 
# car_price_df$compressionratio <- ifelse(car_price_df$compressionratio >= upper_compressionratio,NA,car_price_df$stroke)
# 
# sum(is.na(car_price_df$compressionratio))
# 
# car_price_df$compressionratio <- ifelse(is.na(car_price_df$compressionratio)
#                                   ,ave(car_price_df$compressionratio, FUN = function(x) mean(x, na.rm = TRUE)),
#                                   car_price_df$compressionratio)
# 
# #compressionratio has outliers and we replaced them with mean
# 
# 
# upper_horsepower <- outlier_detection(car_price_df,horsepower)
# 
# car_price_df$horsepower <- ifelse(car_price_df$horsepower >= upper_horsepower,NA,car_price_df$horsepower)
# 
# sum(is.na(car_price_df$horsepower))
# 
# car_price_df$horsepower <- ifelse(is.na(car_price_df$horsepower)
#                                         ,ave(car_price_df$horsepower, FUN = function(x) mean(x, na.rm = TRUE)),
#                                          car_price_df$horsepower)
# 
# #horsepower has outliers and we replaced them with mean
# 
# outlier_detection(car_price_df,peakrpm)
# 
# #peakrpm has outliers but it is very low.NoACTION
# 
# outlier_detection(car_price_df,citympg)
# 
# #citympg has outliers but it is very low.NoACTION
# 
# outlier_detection(car_price_df,highwaympg)
# 
# #highwaympg has outliers but it is very low.NoACTION
# 
# upper_price <- outlier_detection(car_price_df,price)
# 
# car_price_df$price <- ifelse(car_price_df$price >= upper_price,NA,car_price_df$horsepower)
# 
# sum(is.na(car_price_df$price))
# 
# car_price_df$price <- ifelse(is.na(car_price_df$price)
#                                   ,ave(car_price_df$price, FUN = function(x) mean(x, na.rm = TRUE)),
#                                    car_price_df$price)
# 
# #Outliers check and handling is completed here.................
# 
# 
# 
# 
# 
# 
# #Create 2 bins for each column and convert them into numeric
# levels(car_price_df$fueltype)<-c(0,1)
# car_price_df$fueltype<- as.numeric(car_price_df$fueltype)
# 
# levels(car_price_df$aspiration)<-c(0,1)
# car_price_df$aspiration<- as.numeric(car_price_df$aspiration)
# 
# levels(car_price_df$doornumber)<-c(0,1)
# car_price_df$doornumber<- as.numeric(car_price_df$doornumber)
# 
# levels(car_price_df$enginelocation)<-c(0,1)
# car_price_df$enginelocation<- as.numeric(car_price_df$enginelocation)
# 
# #Creation of dummy variables for factors
# 
# #creation of levels/bins
# # levels(car_price_df$Company)[1:5]<-"Car1"
# # levels(car_price_df$Company)[2:6]<-"Car2"
# # levels(car_price_df$Company)[3:7]<-"Car3"
# # levels(car_price_df$Company)[4:8]<-"Car4"
# # levels(car_price_df$Company)[5:9]<-"Car5"
# 
# car_price_df$symboling <- as.factor(car_price_df$symboling)
# levels(car_price_df$symboling)
# 
# levels(car_price_df$symboling)[1:2] <- "very_safe"
# levels(car_price_df$symboling)
# levels(car_price_df$symboling)[2:3] <- "safe"
# levels(car_price_df$symboling)
# levels(car_price_df$symboling)[3:4] <- "risky"
# levels(car_price_df$symboling)
# 
# #checking NA in symboling
# sum(is.na(car_price_df$symboling))
# 
# 
# 
# dummy_1<-data.frame(model.matrix(~Company,data=car_price_df))
# dummy_1<-dummy_1[,-1] 
# car_price_df<-cbind(car_price_df[,-3], dummy_1)
# car_price_df <- subset(car_price_df, select=-c(Company))
# 
# #creation of dummy variables for carbody
# dummy2<-data.frame(model.matrix(~carbody, data=car_price_df))
# dummy2<-dummy2[,-1]
# car_price_df<-cbind(car_price_df[,-6],dummy2)
# 
# #creation of dummy variables for drivewheel
# dummy3<-data.frame(model.matrix(~drivewheel, data=car_price_df))
# dummy3<-dummy3[,-1]
# car_price_df<-cbind(car_price_df[,-6],dummy3)
# 
# #Creation of level/bin for enginetype
# # levels(car_price_df$enginetype)[1:3]<-"low"
# # levels(car_price_df$enginetype)[2:3]<-"Meduim"
# # levels(car_price_df$enginetype)[3:5]<-"High"
# 
# dummy4<-data.frame(model.matrix(~enginetype, data=car_price_df))
# dummy4<-dummy4[,-1]
# car_price_df<-cbind(car_price_df[,-12],dummy4)
# 
# #Creation of level/bin for cylindernuber
# 
# car_price_df$cylindernumber <- as.character(car_price_df$cylindernumber)
# 
# for(i in 1:nrow(car_price_df))
# {
#   if ((car_price_df$cylindernumber[i]=="two") | (car_price_df$cylindernumber[i]=="three") ) {
#     car_price_df$cylindernumber[i]<-"Basic"
#   } else if ((car_price_df$cylindernumber[i]=="four") | (car_price_df$cylindernumber[i]=="five")) {
#     car_price_df$cylindernumber[i]<-"Mid"
#   } else{
#     car_price_df$cylindernumber[i]<-"Premium"
#   }
# }
# 
# car_price_df$cylindernumber <- as.factor(car_price_df$cylindernumber)
# 
# 
# dummy5<-data.frame(model.matrix(~cylindernumber, data=car_price_df))
# dummy5<-dummy5[,-1]
# car_price_df<-cbind(car_price_df[,-12],dummy5)
# 
# #Creation of level/bin for fuelsystem
# table(car_price_df$fuelsystem)
# 
# 
# levels(car_price_df$fuelsystem)[1:2]<-"system1"
# levels(car_price_df$fuelsystem)[2:3]<-"system2"
# levels(car_price_df$fuelsystem)[3:4]<-"system3"
# levels(car_price_df$fuelsystem)[4:5]<-"system4"
# 
# 
# dummy6<-data.frame(model.matrix(~fuelsystem, data=car_price_df))
# dummy6<-dummy6[,-1]
# car_price_df<-cbind(car_price_df[,-13],dummy6)
# 
# 
# dummy_7<-data.frame(model.matrix(~symboling,data=car_price_df))
# dummy_7<-dummy_7[,-1] 
# car_price_df<-cbind(car_price_df[,-2], dummy_7)
# 
# 
# str(car_price_df)
# #All have been converted to numeric/int variables to start the model
# 
# #To convert the data in Test and Train
# set.seed(100)
# trainindices= sample(1:nrow(car_price_df), 0.7*nrow(car_price_df))
# train = car_price_df[trainindices,]
# 
# test = car_price_df[-trainindices,]
# 
# 
# 
# model_1<-lm(price~., data=train)
# summary(model_1)
# 
# #Applying StepAIC
# step <- stepAIC(model_1,direction="both")
# step
# 
# 
# model1_2 <- lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#                  wheelbase + curbweight + enginesize + boreratio + stroke + 
#                  compressionratio + horsepower + citympg + highwaympg + Companyaudi + 
#                  Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#                  Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#                  Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                  drivewheelfwd + enginetypeohc + enginetypeohcv + enginetyperotor + 
#                  cylindernumberMid + symbolingrisky + drivewheelrwd + fuelsystemsystem2, 
#                data = train)
# 
# sort(vif(model1_2),decreasing = TRUE)
# summary(model1_2)
# 
# # Residual standard error: 4.585 on 108 degrees of freedom
# # Multiple R-squared:  0.9814,	Adjusted R-squared:  0.9755 
# # F-statistic: 167.6 on 34 and 108 DF,  p-value: < 0.00000000000000022
# 
# #* citympg vif = 45.928777 and p>0.05, so we will remove this in next model
# 
# model_3<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  highwaympg + Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#               drivewheelfwd + enginetypeohc + enginetypeohcv + enginetyperotor + 
#               cylindernumberMid + symbolingrisky + drivewheelrwd + fuelsystemsystem2, 
#             data = train)
# 
# sort(vif(model_3),decreasing = TRUE)
# summary(model_3)
# 
# # Residual standard error: 4.609 on 109 degrees of freedom
# # Multiple R-squared:  0.981,	Adjusted R-squared:  0.9753 
# # F-statistic: 170.8 on 33 and 109 DF,  p-value: < 0.00000000000000022
# # drivewheelrwd  vif = 15.081319 and p>0.05, So we will remove it in next model
# 
# model_4<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  highwaympg + Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#               drivewheelfwd + enginetypeohc + enginetypeohcv + enginetyperotor + 
#               cylindernumberMid + symbolingrisky + fuelsystemsystem2, 
#             data = train)
# 
# sort(vif(model_4),decreasing = TRUE)
# summary(model_4)
# # Residual standard error: 4.635 on 110 degrees of freedom
# # Multiple R-squared:  0.9806,	Adjusted R-squared:  0.975 
# # F-statistic: 174.2 on 32 and 110 DF,  p-value: < 0.00000000000000022
# # fuelsystemsystem2  vif =  13.680071  and p>0.05
# 
# model_5<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  highwaympg + Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#               drivewheelfwd + enginetypeohc + enginetypeohcv + enginetyperotor + 
#               cylindernumberMid + symbolingrisky , 
#             data = train)
# 
# sort(vif(model_5),decreasing = TRUE)
# summary(model_5)
# 
# # Residual standard error: 4.647 on 111 degrees of freedom
# # Multiple R-squared:  0.9804,	Adjusted R-squared:  0.9749 
# # F-statistic: 178.8 on 31 and 111 DF,  p-value: < 0.00000000000000022
# # highwaympg   vif = 8.606364  and p>0.05, so we will remove it in next model
# 
# model_6<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  highwaympg + Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#               drivewheelfwd + enginetypeohc + enginetypeohcv + enginetyperotor + 
#               cylindernumberMid + symbolingrisky, 
#             data = train)
# 
# sort(vif(model_6),decreasing = TRUE)
# summary(model_6)
# 
# # Residual standard error: 4.659 on 112 degrees of freedom
# # Multiple R-squared:  0.9801,	Adjusted R-squared:  0.9748 
# # F-statistic: 183.8 on 30 and 112 DF,  p-value: < 0.00000000000000022
# # highwaympg  vif = 0.088490  and p>0.05, will remove it in next model
# 
# model_7<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#               drivewheelfwd + enginetypeohc + enginetypeohcv + enginetyperotor + 
#               cylindernumberMid + symbolingrisky, 
#             data = train)
# 
# sort(vif(model_7),decreasing = TRUE)
# summary(model_7)
# # Residual standard error: 4.633 on 112 degrees of freedom
# # Multiple R-squared:  0.9803,	Adjusted R-squared:  0.975 
# # F-statistic: 185.9 on 30 and 112 DF,  p-value: < 0.00000000000000022
# # drivewheelfwd  vif = 3.752944  and p>0.05, so we will remove it in the next model
# 
# model_8<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetypeohcv + enginetyperotor + 
#               cylindernumberMid + symbolingrisky, 
#             data = train)
# 
# sort(vif(model_8),decreasing = TRUE)
# summary(model_8)
# # Residual standard error: 4.648 on 113 degrees of freedom
# # Multiple R-squared:   0.98,	Adjusted R-squared:  0.9749 
# # F-statistic:   191 on 29 and 113 DF,  p-value: < 0.00000000000000022
# 
# # enginetypeohcv vif = 2.656896 and p>0.05, so we are removing it in next model
# 
# model_9<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#               wheelbase + curbweight + enginesize + boreratio + stroke + 
#               compressionratio + horsepower +  Companyaudi + 
#               Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#               Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#               Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#               enginetypeohc + enginetyperotor + 
#               cylindernumberMid + symbolingrisky, 
#             data = train)
# 
# sort(vif(model_9),decreasing = TRUE)
# summary(model_9)
# 
# # Residual standard error: 4.693 on 114 degrees of freedom
# # Multiple R-squared:  0.9794,	Adjusted R-squared:  0.9744 
# # F-statistic: 193.9 on 28 and 114 DF,  p-value: < 0.00000000000000022
# #  symbolingrisky vif = 2.397500 and p>0.05, so we are removing it in next model
# 
# 
# model_10<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#                wheelbase + curbweight + enginesize + boreratio + stroke + 
#                compressionratio + horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#                Companynissan + Companyplymouth + Companyporsche + Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_10),decreasing = TRUE)
# summary(model_10)
# 
# # Residual standard error: 4.76 on 116 degrees of freedom
# # Multiple R-squared:  0.9785,	Adjusted R-squared:  0.9737 
# # F-statistic: 202.8 on 26 and 116 DF,  p-value: < 0.00000000000000022
# # Companyporsche  vif =  6.053803 and p>0.05, so we are removing it in next model
# 
# model_11<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#                wheelbase + curbweight + enginesize + boreratio + stroke + 
#                compressionratio + horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_11),decreasing = TRUE)
# summary(model_11)
# 
# # Residual standard error: 4.777 on 116 degrees of freedom
# # Multiple R-squared:  0.9783,	Adjusted R-squared:  0.9735 
# # F-statistic: 201.4 on 26 and 116 DF,  p-value: < 0.00000000000000022
# 
# corr_subset <- subset(car_price_df, select=c(car_ID ,           
#                                              aspiration ,         
#                                              doornumber ,        
#                                              enginelocation ,  
#                                              wheelbase ,        
#                                              curbweight ,       
#                                              enginesize ,        
#                                              boreratio ,        
#                                              stroke ,           
#                                              compressionratio   ,
#                                              horsepower,          
#                                              Companyaudi  ,        
#                                              Companybmw  ,       
#                                              Companychevrolet ,  
#                                              Companymercury ,    
#                                              Companymitsubishi  , 
#                                              Companynissan  ,     
#                                              Companyplymouth  , 
#                                              Companyrenault,    
#                                              Companysubaru   ,   
#                                              Companytoyota  ,    
#                                              Companyvolkswagen ,
#                                              carbodywagon   ,    
#                                              enginetypeohc  ,  
#                                              enginetyperotor  ,  
#                                              cylindernumberMid )) 
# corr <- round(cor(corr_subset), 1)
# p.mat <- cor_pmat(corr_subset)
# 
# ggcorrplot(corr, hc.order = TRUE, lab = TRUE)
# 
# # from the plot we can see stroke and compressionration are highly correlated
# cor(car_price_df$stroke,car_price_df$compressionratio)# 0.9457332
# 
# #As stroke has higher vif and high p value than compressionration
# #so we will remove it
# 
# 
# model_12<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#                wheelbase + curbweight + enginesize + boreratio +
#                compressionratio + horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_12),decreasing = TRUE)
# summary(model_12)
# 
# # Residual standard error: 5.072 on 117 degrees of freedom
# # Multiple R-squared:  0.9754,	Adjusted R-squared:  0.9701 
# # F-statistic: 185.2 on 25 and 117 DF,  p-value: < 0.00000000000000022
# # compressionratio vif = 3.059104 and p>0.05, so we will remove it
# 
# 
# model_13<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#                wheelbase + curbweight + enginesize + boreratio +
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury + Companymitsubishi + 
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_13),decreasing = TRUE)
# summary(model_13)
# 
# # Residual standard error: 5.073 on 118 degrees of freedom
# # Multiple R-squared:  0.9751,	Adjusted R-squared:  0.9701 
# # F-statistic: 192.8 on 24 and 118 DF,  p-value: < 0.00000000000000022
# # Companymitsubishi vif =  1.195992 and p>0.05, so we are removing it
# 
# 
# model_14<-lm(formula = price ~ car_ID + aspiration + doornumber + enginelocation + 
#                wheelbase + curbweight + enginesize + boreratio +
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_14),decreasing = TRUE)
# summary(model_14)
# 
# # Residual standard error: 5.114 on 119 degrees of freedom
# # Multiple R-squared:  0.9745,	Adjusted R-squared:  0.9696 
# # F-statistic: 197.8 on 23 and 119 DF,  p-value: < 0.00000000000000022
# # aspiration  vif =  1.869808 and p>0.05, we are removing it
# 
# 
# model_15<-lm(formula = price ~ car_ID +  doornumber + enginelocation + 
#                wheelbase + curbweight + enginesize + boreratio +
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_15),decreasing = TRUE)
# summary(model_15)
# 
# # Residual standard error: 5.171 on 120 degrees of freedom
# # Multiple R-squared:  0.9737,	Adjusted R-squared:  0.9689 
# # F-statistic: 202.1 on 22 and 120 DF,  p-value: < 0.00000000000000022
# # curbweight and wheelbase are correlated
# cor(car_price_df$curbweight,car_price_df$wheelbase) #0.7763863
# 
# #wheelbase has higher p value than curbweight, so we will remove it
# 
# 
# 
# model_16<-lm(formula = price ~ car_ID +  doornumber + enginelocation + 
#                 curbweight + enginesize + boreratio +
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_16),decreasing = TRUE)
# summary(model_16)
# 
# # Residual standard error: 5.544 on 121 degrees of freedom
# # Multiple R-squared:  0.9695,	Adjusted R-squared:  0.9643 
# # F-statistic: 183.4 on 21 and 121 DF,  p-value: < 0.00000000000000022
# # doornumber   is insignificant , so we are removing it
# 
# 
# model_17<-lm(formula = price ~ car_ID +  enginelocation + 
#                curbweight + enginesize + boreratio +
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_17),decreasing = TRUE)
# summary(model_17)
# 
# # Residual standard error: 5.587 on 122 degrees of freedom
# # Multiple R-squared:  0.9688,	Adjusted R-squared:  0.9637 
# # F-statistic: 189.5 on 20 and 122 DF,  p-value: < 0.00000000000000022
# # from the correlation plot we can see curbweight and horsepower are highly correlated
# 
# 
# 
# cor(car_price_df$curbweight,car_price_df$cylindernumberMid)#-0.4806959
# cor(car_price_df$curbweight,car_price_df$boreratio) #0.6484797
# cor(car_price_df$cylindernumberMid,car_price_df$boreratio) # -0.1865825
# 
# # Let's remove boreratio as removal of this have less impact on R^2 and adjusted R^2
# 
# model_18<-lm(formula = price ~ car_ID +  enginelocation + 
#                curbweight + enginesize + 
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + Companyvolkswagen + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_18),decreasing = TRUE)
# summary(model_18)
# 
# # Residual standard error: 6.898 on 123 degrees of freedom
# # Multiple R-squared:  0.9521,	Adjusted R-squared:  0.9447 
# # F-statistic: 128.6 on 19 and 123 DF,  p-value: < 0.00000000000000022
# 
# # Companyvolkswagen became insignificant and has high vif than carbodywagon, so we will remove it.
# 
# 
# model_19<-lm(formula = price ~ car_ID +  enginelocation + 
#                curbweight + enginesize + 
#                horsepower +  Companyaudi + 
#                Companybmw + Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_19),decreasing = TRUE)
# summary(model_19)
# 
# # Residual standard error: 6.941 on 124 degrees of freedom
# # Multiple R-squared:  0.9511,	Adjusted R-squared:  0.944 
# # F-statistic: 133.9 on 18 and 124 DF,  p-value: < 0.00000000000000022
# # Companybmw  became insignificant , we will remove it
# 
# model_20<-lm(formula = price ~ car_ID +  enginelocation + 
#                curbweight + enginesize + 
#                horsepower +  Companyaudi + 
#               Companychevrolet + Companymercury +  
#                Companynissan + Companyplymouth +  Companyrenault + 
#                Companysubaru + Companytoyota + carbodywagon + 
#                enginetypeohc + enginetyperotor + 
#                cylindernumberMid , 
#              data = train)
# 
# sort(vif(model_20),decreasing = TRUE)
# summary(model_20)
# 
# # Residual standard error: 6.94 on 125 degrees of freedom
# # Multiple R-squared:  0.9507,	Adjusted R-squared:  0.944 
# # F-statistic: 141.8 on 17 and 125 DF,  p-value: < 0.00000000000000022
# 
# # Companychevrolet became insignificant , we will remove it
# 
# model_21 <- lm(formula = price ~ car_ID +  enginelocation + 
#                     curbweight + enginesize + 
#                     horsepower +  Companyaudi + 
#                      Companymercury +  
#                     Companynissan + Companyplymouth +  Companyrenault + 
#                     Companysubaru + Companytoyota + carbodywagon + 
#                     enginetypeohc + enginetyperotor + 
#                     cylindernumberMid , 
#                   data = train)
# 
# 
# sort(vif(model_21),decreasing = TRUE)
# summary(model_21)
# 
# 
# # Companyplymouth became nsignificant , we will remove it
# # Residual standard error: 7.008 on 126 degrees of freedom
# # Multiple R-squared:  0.9493,	Adjusted R-squared:  0.9429 
# # F-statistic: 147.5 on 16 and 126 DF,  p-value: < 0.00000000000000022
# 
# 
# model_22 <- lm(formula = price ~ car_ID +  enginelocation + 
#                  curbweight + enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companymercury +  
#                  Companynissan +  Companyrenault + 
#                  Companysubaru + Companytoyota + carbodywagon + 
#                  enginetypeohc + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_22),decreasing = TRUE)
# summary(model_22)
# 
# 
# # Companymercury became nsignificant , we will remove it
# # Residual standard error: 7.038 on 127 degrees of freedom
# # Multiple R-squared:  0.9485,	Adjusted R-squared:  0.9424 
# # F-statistic: 155.9 on 15 and 127 DF,  p-value: < 0.00000000000000022
# 
# model_23 <- lm(formula = price ~ car_ID +  enginelocation + 
#                  curbweight + enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companynissan +  Companyrenault + 
#                  Companysubaru + Companytoyota + carbodywagon + 
#                  enginetypeohc + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_23),decreasing = TRUE)
# summary(model_23)
# 
# # Residual standard error: 7.077 on 128 degrees of freedom
# # Multiple R-squared:  0.9475,	Adjusted R-squared:  0.9418 
# # F-statistic:   165 on 14 and 128 DF,  p-value: < 0.00000000000000022
# # curbweight  and horsepower are highly correlated
# cor(car_price_df$curbweight,car_price_df$horsepower)#0.7654989
# 
# # lets remove curbweight as impact is less than horsepower or enginesize
# 
# model_24 <- lm(formula = price ~ car_ID +  enginelocation + 
#                   enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companynissan +  Companyrenault + 
#                  Companysubaru + Companytoyota + carbodywagon + 
#                  enginetypeohc + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_24),decreasing = TRUE)
# summary(model_24)
# 
# # Residual standard error: 11.56 on 129 degrees of freedom
# # Multiple R-squared:  0.8589,	Adjusted R-squared:  0.8446 
# # F-statistic: 60.39 on 13 and 129 DF,  p-value: < 0.00000000000000022
# # enginetypeohc vif = 2.594423 ,became insignificant
# 
# model_25 <- lm(formula = price ~ car_ID +  enginelocation + 
#                  enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companynissan +  Companyrenault + 
#                  Companysubaru + Companytoyota + carbodywagon + 
#                   + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_25),decreasing = TRUE)
# summary(model_25)
# 
# 
# # Residual standard error: 11.59 on 130 degrees of freedom
# # Multiple R-squared:  0.8571,	Adjusted R-squared:  0.8439 
# # F-statistic: 64.97 on 12 and 130 DF,  p-value: < 0.00000000000000022
# #car_id became insignificant
# model_26 <-  lm(formula = price ~   enginelocation + 
#                              enginesize + 
#                              horsepower +  Companyaudi + 
#                              Companynissan +  Companyrenault + 
#                              Companysubaru + Companytoyota + carbodywagon + 
#                              + enginetyperotor + 
#                              cylindernumberMid , 
#                            data = train)
# 
# 
# sort(vif(model_26),decreasing = TRUE)
# summary(model_26)
# 
# 
# # Residual standard error: 11.65 on 131 degrees of freedom
# # Multiple R-squared:  0.8543,	Adjusted R-squared:  0.8421 
# # F-statistic: 69.85 on 11 and 131 DF,  p-value: < 0.00000000000000022
# #enginelocation became insignificant
# 
# model_27 <-  lm(formula = price ~   
#                   enginesize + 
#                   horsepower +  Companyaudi + 
#                   Companynissan +  Companyrenault + 
#                   Companysubaru + Companytoyota + carbodywagon + 
#                   + enginetyperotor + 
#                   cylindernumberMid , 
#                 data = train)
# 
# 
# sort(vif(model_27),decreasing = TRUE)
# summary(model_27)
# 
# 
# # Companynissan     Companytoyota     Companysubaru       Companyaudi 
# # 1.086082          1.079904          1.058266          1.057857 
# # carbodywagon    Companyrenault 
# # 1.055209          1.03872
# # one by one we will remove all these insignificant vars from model( 28 -33 )
# #Companynissan		 
# model_28 <- lm(formula = price ~   
#                  enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companyrenault + 
#                  Companysubaru + Companytoyota + carbodywagon + 
#                  + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_28),decreasing = TRUE)
# summary(model_28)
# 
# #Companytoyota
# model_29 <- lm(formula = price ~   
#                  enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companyrenault + 
#                  Companysubaru + carbodywagon + 
#                  + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_29),decreasing = TRUE)
# summary(model_29)
# 
# #Companysubaru
# model_30 <- lm(formula = price ~   
#                  enginesize + 
#                  horsepower +  Companyaudi + 
#                  Companyrenault + 
#                  carbodywagon + 
#                  + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_30),decreasing = TRUE)
# summary(model_30)
# 
# #Companyaudi
# model_31 <- lm(formula = price ~   
#                  enginesize + 
#                  horsepower +  
#                  Companyrenault + 
#                  carbodywagon + 
#                  + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_31),decreasing = TRUE)
# summary(model_31)
# 
# 
# #carbodywagon
# model_32 <- lm(formula = price ~   
#                  enginesize + 
#                  horsepower +  
#                  Companyrenault +  
#                  + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_32),decreasing = TRUE)
# summary(model_32)
# 
# #Companyrenault
# model_33 <- lm(formula = price ~   
#                  enginesize + 
#                  horsepower +  
#                  
#                  + enginetyperotor + 
#                  cylindernumberMid , 
#                data = train)
# 
# 
# sort(vif(model_33),decreasing = TRUE)
# summary(model_33)
# 
# # Residual standard error: 11.55 on 138 degrees of freedom
# # Multiple R-squared:  0.8493,	Adjusted R-squared:  0.8449 
# # F-statistic: 194.5 on 4 and 138 DF,  p-value: < 0.00000000000000022
# 
# 
# # Coefficients:
# #   Estimate Std. Error t value             Pr(>|t|)    
# 
# #   enginesize          0.31312    0.04403   7.112      0.0000000000563 ***
# #   horsepower          0.72587    0.03810  19.051 < 0.0000000000000002 ***
# #   enginetyperotor    39.21885    7.87883   4.978      0.0000018866146 ***
# #   cylindernumberMid  22.43706    3.33271   6.732      0.0000000004121 ***
# 
# Predict1<-predict(model_33, test[, -19])
# 
# cor(test$price,Predict1)^2 #RSuared= 0.8337421
# #----------------------------------------------------------------------------
# # the end.....................