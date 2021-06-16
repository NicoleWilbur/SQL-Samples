/****** Object:  StoredProcedure [dbo].[UpdateFooTables]    Script Date: 6/11/2021 3:32:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Nicole Wilbur
-- Create Date: 4/30/2021
-- Description: Stored Procedure to update FooDataWeekly, FooSummaryData, and FooDataFormatted tables daily
-- Run: EXEC [dbo].[UpdateFooTables]
CREATE PROCEDURE [dbo].[UpdateFooTables]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from 
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	/***Updates Foo data formatted table***/
	INSERT INTO [dbo].[FooDataFormatted]
	  ([Email_MyData]
      ,[First_Name_MyData]
      ,[Last_Name_MyData]
      ,[Gender_MyData]
      ,[Phone1]
      ,[Phone_Type_for_Phone_1]
      ,[Address_MyData]
      ,[Address_Line_2_MyData]
      ,[County_MyData]
      ,[City_MyData]
      ,[State_MyData]
      ,[Zip_MyData]
      ,[Cell_Phone]
      ,[Phone_Type]
      ,[Zip_Plus_4_Mydata]
      ,[Date_of_Birth_MyData]
      ,[State_Voter_ID]
      ,[Ethnicity]
      ,[Race]
      ,[Not_Home]
      ,[Refused]
      ,[Restricted_Access]
      ,[Take_Survey]
      ,[Wrong_Address]
      ,[Already_on_a_waitlist]
      ,[Already_vaccinated]
      ,[Cannot_leave_house_Special_Circumstance]
      ,[Did_not_add_to_waitlist]
      ,[Did_not_sign_up_for_vaccine_appointment]
      ,[Is_not_eligible_to_register_not_available_for_appointment]
      ,[Language_Barrier_Special_Circumstances]
      ,[Made_appointment_never_received_vaccine_Special_Circumstances]
      ,[Needs_Ride_Special_Circumstance]
      ,[Other_Special_Circumstances]
      ,[Undecided_on_vaccine_appointment]
      ,[Undecided_on_waitlist]
      ,[Yes_signed_up_for_vaccine_appointment]
      ,[Yes_added_to_the_waitlist]
      ,[Comments]
      ,[State]
      ,[UID]
      ,[ContactID]
      ,[Auraria_Campus]
      ,[Ball_Arena]
      ,[Bethlehem_MBC_of_Pueblo]
      ,[Dicks_Sporting_Goods_Park]
      ,[North_Suburban_Drive_Thru_Thornton]
      ,[Pueblo_County_High_School]
      ,[Pueblo_West_High_School]
      ,[Sky_Ridge_Medical_Center_Lone_Tree]
      ,[The_Medical_Center_of_Aurora]
      ,[The_Montbello_Campus])
SELECT
	   [column1]
      ,[column2]
      ,[column3]
      ,[column4]
      ,[column5]
      ,[column6]
      ,[column7]
      ,[column8]
      ,[column9]
      ,[column10]
      ,[column11]
      ,[column12]
      ,[column13]
      ,[column14]
      ,[column15]
      ,[column16]
      ,[column17]
      ,[column18]
      ,[column19]
      ,[column20]
      ,[column21]
      ,[column22]
      ,[column23]
      ,[column24]
      ,[column25]
      ,[column26]
      ,[column27]
      ,[column28]
      ,[column29]
      ,[column30]
      ,[column31]
      ,[column32]
      ,[column33]
      ,[column34]
      ,[column35]
      ,[column36]
      ,[column37]
      ,[column38]
      ,[column39]
      ,[column40]
      ,[column41]
      ,[column42]
      ,[column43]
      ,[column44]
      ,[column45]
      ,[column46]
      ,[column47]
      ,[column48]
      ,[column49]
      ,[column50]
      ,[column51]
	  ,[column52]
  FROM [dbo].[FooYesterday] AS A

  /***Updates CavassDate and AssignedID fields***/
  UPDATE [dbo].[FooDataFormatted] 
  SET canvassDate = GETDATE()-2, AssignedID = NEWID(),
		AgeRange = CASE WHEN DATEDIFF(YY,[Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY,[Date_of_Birth_MyData] , GETDATE()), [Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END < 19 THEN '0-18'
		WHEN DATEDIFF(YY, [Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY, [Date_of_Birth_MyData], GETDATE()), [Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END between 19 AND 29 THEN '19-29'
		WHEN DATEDIFF(YY, [Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY,[Date_of_Birth_MyData] , GETDATE()),[Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END between 30 AND 39 THEN '30-39'
		WHEN DATEDIFF(YY,[Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY,[Date_of_Birth_MyData] , GETDATE()), [Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END between 40 AND 49 THEN '40-49'
		WHEN DATEDIFF(YY, [Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY,[Date_of_Birth_MyData], GETDATE()), [Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END between 50 AND 59 THEN '50-59'
		WHEN DATEDIFF(YY, [Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY,[Date_of_Birth_MyData] , GETDATE()), [Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END between 60 AND 69 THEN '60-69'
		WHEN DATEDIFF(YY, [Date_of_Birth_MyData], GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY,[Date_of_Birth_MyData] , GETDATE()), [Date_of_Birth_MyData]) > GETDATE() THEN 1 ELSE 0 END > 69 THEN '70+'
		ELSE NULL
		END
  WHERE AssignedID IS NULL AND CanvassDate IS NULL AND AgeRange IS NULL

SELECT SUM([Yes_signed_up_for_vaccine_appointment])+ SUM([Yes_added_to_the_waitlist]) AS AppointmentMade, canvassdate
FROM [dbo].[FooDataFormatted]
WHERE FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd') >= GETDATE()- 14
GROUP BY [CanvassDate]


/***Truncates Foo Summary Data Daily Table***/
TRUNCATE TABLE FooSummaryData

/***Populates Summary Data Daily Table with Previous Day's Data***/
INSERT INTO FooSummaryData 
SELECT t1.[City_MyData] + ' ' + CASE WHEN AgeRange IS NULL THEN 'Unknown' ELSE AgeRange END AS CityAgeRange, TotalCanvassed,
	SUM(Take_Survey) TakeSurvey,
	SUM(Already_vaccinated + Already_on_a_waitlist) AlreadyVaccinatedWaitlisted,
	(SUM(Already_Vaccinated + Already_on_a_waitlist)*100/SUM(Take_Survey)) AS AlreadyVaccinatedWaitlistedPercent,
	SUM(CASE WHEN [Cannot_leave_house_Special_Circumstance] = 1 OR 
		[Is_not_eligible_to_register_not_available_for_appointment] = 1 or
		[Language_Barrier_Special_Circumstances] = 1 or
		[Made_appointment_never_received_vaccine_Special_Circumstances] = 1 or
		[Needs_Ride_Special_Circumstance] = 1 OR [Other_Special_Circumstances] = 1 THEN 1 ELSE 0 END) Barriers,
	(SUM(CASE WHEN [Cannot_leave_house_Special_Circumstance] = 1 OR 
		[Is_not_eligible_to_register_not_available_for_appointment] = 1 or
		[Language_Barrier_Special_Circumstances] = 1 or
		[Made_appointment_never_received_vaccine_Special_Circumstances] = 1 or
		[Needs_Ride_Special_Circumstance] = 1 OR [Other_Special_Circumstances] = 1 THEN 1 ELSE 0 END)*100/SUM(Take_Survey)) AS BarriersPercent,
	SUM(CASE WHEN [Undecided_on_vaccine_appointment] =  1 OR [Undecided_on_waitlist] = 1 THEN 1 ELSE 0 END) Undecided,
	(SUM(CASE WHEN [Undecided_on_vaccine_appointment] =  1 OR [Undecided_on_waitlist] = 1 THEN 1 ELSE 0 END)*100/SUM(Take_Survey)) AS UndecidedPercent,
	SUM([Yes_signed_up_for_vaccine_appointment] + [Yes_added_to_the_waitlist]) SignedUp,
	(SUM([Yes_signed_up_for_vaccine_appointment] + [Yes_added_to_the_waitlist])*100/SUM(Take_Survey)) AS SignedUpPercent,
	SUM(CASE WHEN [Did_not_add_to_waitlist] = 1 OR [Did_not_sign_up_for_vaccine_appointment] = 1 THEN 1 ELSE 0 END) DidNotSignUp,
	(SUM(CASE WHEN [Did_not_add_to_waitlist] = 1 OR [Did_not_sign_up_for_vaccine_appointment] = 1 THEN 1 ELSE 0 END) * 100/ SUM(Take_Survey)) AS DidNotSignUpPercent,
	FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd') AS canvassdate
FROM FooDataFormatted t1
LEFT JOIN (SELECT COUNT(AssignedID)TotalCanvassed, City_mydata FROM [dbo].[FooDataFormatted] WHERE FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd') >= GETDATE()- 8 GROUP BY City_myData)t2 
			ON t1.city_mydata = t2.city_mydata
WHERE FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd') >= GETDATE() - 8 AND Take_Survey > 0
GROUP BY
	t1.[City_MyData] + ' ' + CASE WHEN AgeRange IS NULL THEN 'Unknown' ELSE AgeRange END, TotalCanvassed, FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd')


/**** Truncate Weekly Table ****/
Truncate table FooDataWeekly

/*** Update Weekly Table ***/
INSERT INTO FooDataWeekly
SELECT t1.[City_MyData] City, TotalCanvassed,
	SUM(Take_Survey) TakeSurvey,
	SUM(Already_vaccinated + Already_on_a_waitlist) AlreadyVaccinatedWaitlisted,
	(SUM(Already_Vaccinated + Already_on_a_waitlist)*100/SUM(Take_Survey)) AS AlreadyVaccinatedWaitlistedPercent,
	SUM(CASE WHEN [Cannot_leave_house_Special_Circumstance] = 1 OR 
		[Is_not_eligible_to_register_not_available_for_appointment] = 1 or
		[Language_Barrier_Special_Circumstances] = 1 or
		[Made_appointment_never_received_vaccine_Special_Circumstances] = 1 or
		[Needs_Ride_Special_Circumstance] = 1 OR [Other_Special_Circumstances] = 1 THEN 1 ELSE 0 END) Barriers,
	(SUM(CASE WHEN [Cannot_leave_house_Special_Circumstance] = 1 OR 
		[Is_not_eligible_to_register_not_available_for_appointment] = 1 or
		[Language_Barrier_Special_Circumstances] = 1 or
		[Made_appointment_never_received_vaccine_Special_Circumstances] = 1 or
		[Needs_Ride_Special_Circumstance] = 1 OR [Other_Special_Circumstances] = 1 THEN 1 ELSE 0 END)*100/SUM(Take_Survey)) AS BarriersPercent,
	SUM(CASE WHEN [Undecided_on_vaccine_appointment] =  1 OR [Undecided_on_waitlist] = 1 THEN 1 ELSE 0 END) Undecided,
	(SUM(CASE WHEN [Undecided_on_vaccine_appointment] =  1 OR [Undecided_on_waitlist] = 1 THEN 1 ELSE 0 END)*100/SUM(Take_Survey)) AS UndecidedPercent,
	SUM([Yes_signed_up_for_vaccine_appointment] + [Yes_added_to_the_waitlist]) SignedUp,
	(SUM([Yes_signed_up_for_vaccine_appointment] + [Yes_added_to_the_waitlist])*100/SUM(Take_Survey)) AS SignedUpPercent,
	SUM(CASE WHEN [Did_not_add_to_waitlist] = 1 OR [Did_not_sign_up_for_vaccine_appointment] = 1 THEN 1 ELSE 0 END) DidNotSignUp,
	(SUM(CASE WHEN [Did_not_add_to_waitlist] = 1 OR [Did_not_sign_up_for_vaccine_appointment] = 1 THEN 1 ELSE 0 END) * 100/ SUM(Take_Survey)) AS DidNotSignUpPercent
FROM FooDataFormatted t1
LEFT JOIN (SELECT COUNT(AssignedID)TotalCanvassed, City_mydata FROM [dbo].[FooDataFormatted] WHERE FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd') >= GETDATE()- 8 GROUP BY City_myData)t2 
			ON t1.city_mydata = t2.city_mydata
WHERE FORMAT(CONVERT(DATETIME, canvassdate),'yyyy-MM-dd') >= GETDATE() - 8 AND Take_Survey > 0
GROUP BY
	t1.[City_MyData], TotalCanvassed

DROP TABLE FooYesterday
END
GO


