/****** Object:  StoredProcedure [dbo].[UpdateNonJsonTable]    Script Date: 6/11/2021 3:32:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Nicole Wilbur
-- Create Date: 3/15/2021
-- Description: Stored Procedure to create truncated Json table, update the FooNonJsonTrunc table from FooJson,
--              and create some custom fields
-- Run: EXEC [dbo].[UpdateNonJsonTable]
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNonJsonTable]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from 
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	/***Clears Table***/

	TRUNCATE TABLE [dbo].[FooNonJsonTrunc]

	/***Drops and Recreates FooJsonTrunc table***/
	DROP TABLE [dbo].[FooJsonTrunc]
	SELECT * INTO [dbo].[FooJsonTrunc]  
	FROM [dbo].[FooJson]
	WHERE InvitesLastSentDate > GETDATE()-1 or InvitesLastSentDate is NULL

	/***Drops the temp tables if they still exist***/
	IF OBJECT_ID('#DOBTemp', 'u') IS NOT NULL 
	  DROP TABLE #DOBTemp;
	IF OBJECT_ID('#RaceTemp', 'u') IS NOT NULL 
	  DROP TABLE #RaceTemp;
	IF OBJECT_ID('#GenderTemp', 'u') IS NOT NULL 
	  DROP TABLE #GenderTemp;
	IF OBJECT_ID('#OtherQualifiersTemp', 'u') IS NOT NULL 
	  DROP TABLE #OtherQualifiersTemp;
	IF OBJECT_ID('#TextingTemp', 'u') IS NOT NULL 
	  DROP TABLE #TextingTemp;
	IF OBJECT_ID('#PhaseTemp', 'u') IS NOT NULL 
	  DROP TABLE #PhaseTemp;
	IF OBJECT_ID('#LangTemp', 'u') IS NOT NULL 
	  DROP TABLE #LangTemp;

	/***Populates Non-Json Fields from FooJson Table***/
	INSERT INTO [dbo].[FooNonJsonTrunc] ([Id]
		  ,[OrganizationFormId]
		  ,[FirstName]
		  ,[LastName]
		  ,[Street]
		  ,[City]
		  ,[StateCode]
		  ,[PostalCode]
		  ,[Email]
		  ,[Phone]
		  ,[InvitesLastSentDate]
		  ,[InvitesSentCount]
		  ,[FirstDoseDate]
		  ,[FirstDoseType]
		  ,[SecondDoseDate]
		  ,[ProjectCode]
		  ,[DateCreated]
		  ,[DateStored]
		  ,[JsonValue]
		  ,[JsonValueHash]
		  ,[JsonValueHashMethod])
	SELECT [Id]
		  ,[OrganizationFormId]
		  ,[FirstName]
		  ,[LastName]
		  ,[Street]
		  ,[City]
		  ,[StateCode]
		  ,LEFT([PostalCode],5) AS PostalCode
		  ,[Email]
		  ,[Phone]
		  ,[InvitesLastSentDate]
		  ,[InvitesSentCount]
		  ,[FirstDoseDate]
		  ,[FirstDoseType]
		  ,[SecondDoseDate]
		  ,[ProjectCode]
		  ,[DateCreated]
		  ,[DateStored]
		  ,[JsonValue]
		  ,[JsonValueHash]
		  ,[JsonValueHashMethod]
	FROM [dbo].[FooJsonTrunc] AS A

	/****Populate DOB Temp Table****/
	SELECT Id,
	FORMAT(CONVERT(DATETIME, JSON_VALUE(answer4.value, '$.Values[0]')),'yyyy-MM-dd') AS DateOfBirth
	INTO #DOBTemp
	FROM [dbo].[FooJsonTrunc]
	cross apply openjson(JsonValue, '$.Answers') answer4
	WHERE 
	json_value(answer4.Value, '$.Type') = 'DateOfBirth'
	AND DATEDIFF(YEAR, TRY_CONVERT(DATETIME, JSON_VALUE(answer4.value, '$.Values[0]')), GETDATE()) <= 1000 

	/******* Populate Race Temp Table******/
	SELECT Id,
	(
		select string_agg(raceValues.Value, N',')
		from openjson(answer2.Value, '$.Values') raceValues
	  ) AS Race
	INTO #RaceTemp
	FROM [dbo].[FooJsonTrunc]
	CROSS APPLY OPENJSON(JsonValue, '$.Answers') answer2
	WHERE 
	JSON_VALUE(answer2.Value, '$.Type') = N'Race'

	/******* Populate Gender Temp Table******/
	SELECT Id,
	 JSON_VALUE(answer3.Value, '$.Values[0]') AS Gender
	INTO #GenderTemp
	FROM [dbo].[FooJsonTrunc]
	CROSS APPLY OPENJSON(JsonValue, '$.Answers') answer3
	WHERE 
	JSON_VALUE(answer3.Value, '$.Type') = 'Gender'

	/******* Populate Other Qualifiers Temp Table******/
	SELECT Id,
	 (
		SELECT STRING_AGG(HealthConditionsValues.Value, N',')
		FROM OPENJSON(answer1.Value, '$.Values') HealthConditionsValues
	  ) AS OtherQualifiers
	INTO #OtherQualifiersTemp
	FROM [dbo].[FooJsonTrunc]
	CROSS APPLY OPENJSON(JsonValue, '$.Answers') answer1
	WHERE 
	JSON_VALUE(answer1.Value, '$.Type') = 'Category'

	/******* Populate Language Temp Table******/
	SELECT Id,
	 JSON_VALUE(answer6.Value, '$.Values[0]') AS PrimaryLanguage
	INTO #LangTemp
	FROM [dbo].[FooJsonTrunc]
	CROSS APPLY OPENJSON(JsonValue, '$.Answers') answer6
	WHERE 
	JSON_VALUE(answer6.Value, '$.Type') = 'PrimaryLanguage'

	/******* Populate Texting Temp Table******/
	SELECT Id,
	 JSON_VALUE(answer5.Value, '$.Values[0]') AS TextConsent
	INTO #TextingTemp
	FROM [dbo].[FooJsonTrunc]
	CROSS APPLY OPENJSON(JsonValue, '$.Answers') answer5
	WHERE 
	JSON_VALUE(answer5.Value, '$.Type') = 'Consent'

	/******Updates the Json Fields in OrgRegNonJson table********/

	UPDATE [dbo].[FooNonJsonTrunc]
	SET DateOfBirth = (SELECT DateOfBirth FROM #DOBTemp WHERE [dbo].[FooNonJsonTrunc].id = #DOBTemp.Id),
		Race = (SELECT Race FROM #RaceTemp WHERE [dbo].[FooNonJsonTrunc].id = #RaceTemp.id),
		Gender = (SELECT Gender FROM #GenderTemp WHERE [dbo].[FooNonJsonTrunc].id = #GenderTemp.id),
		OtherQualifiers = (SELECT OtherQualifiers FROM #OtherQualifiersTemp WHERE [dbo].[FooNonJsonTrunc].id = #OtherQualifiersTemp.id),
		TextingConsent = (SELECT TextConsent FROM #TextingTemp WHERE [dbo].[FooNonJsonTrunc].id = #TextingTemp.id),
		PrimaryLanguage = (SELECT PrimaryLanguage FROM #LangTemp WHERE [dbo].[FooNonJsonTrunc].id = #LangTemp.id)
	UPDATE [dbo].[FooNonJsonTrunc]
	SET Age = DATEDIFF(YY, DateOfBirth, GETDATE()) - 
			 CASE WHEN DATEADD(YY, DATEDIFF(YY, DateOfBirth, GETDATE()), DateOfBirth) > GETDATE() THEN 1 ELSE 0 END

/****** Populate Phase Temp Table from non-Json fields already updated in OrgRegNonJson table*******/
	SELECT Id,
	  (CASE WHEN OtherQualifiers LIKE '%Category_HighRiskHealthCareWorker%' OR OtherQualifiers LIKE '%Category_LongTermCare%' THEN '1A'
			WHEN (Age BETWEEN 70 AND 130) OR (OtherQualifiers LIKE '%Category_FirstResponder%' OR 
				OtherQualifiers LIKE '%Category_ModerateRiskHealthCareWorker%') THEN '1B1'
			WHEN (Age BETWEEN 65 AND 69) OR (OtherQualifiers LIKE '%Category_PreK12EducatorOrChildCareWorker%' OR 
				OtherQualifiers LIKE '%Category_StateGovtExecutiveJudicial%') THEN '1B2'
			WHEN (Age BETWEEN 60 AND 64) OR OtherQualifiers Like'%Category_FoodAndAg%'
				 OR (Age BETWEEN 18 AND 64 AND OtherQualifiers LIKE '%Category_TwoHighRisk16To64%') THEN '1B3'
			WHEN (Age BETWEEN 50 AND 59) OR 
			     (OtherQualifiers LIKE '%Category_FaithLeader%' OR OtherQualifiers LIKE '%Category_FrontlineEssentialWorker%'
			     OR OtherQualifiers LIKE '%Category_StateLocalGovtOps%' OR OtherQualifiers LIKE '%Category_StudentHigherEdEmployee%' OR 
			     OtherQualifiers LIKE '%Category_PlaceboInTrial%')
			     OR (Age BETWEEN 18 AND 59 AND OtherQualifiers LIKE '%Category_OneHighRisk16To59%') THEN '1B4'
		   ELSE '2'
		   END) AS 'Phase'
	INTO #PhaseTemp
    FROM [dbo].[FooNonJsonTrunc] 

/******Updates the phase field in OrgRegNonJson Table******/

	UPDATE [dbo].[FooNonJsonTrunc]
	SET Phase = (SELECT Phase FROM #PhaseTemp WHERE [dbo].[FooNonJsonTrunc].id = #PhaseTemp.Id)

/*****Updates the HighImpact field*****/
	UPDATE [dbo].[FooNonJsonTrunc] 
		SET HighImpact = 'High Impact'
		WHERE ID IN (
		SELECT ID 
		FROM [dbo].[FooNonJsonTrunc] 
		WHERE age >= 65
		OR race like '%black%' OR race like '%Indian%' OR race like '%hawaiian%' OR race like'%latinx%'
		or PostalCode in (
		'80202', '80204', '80205', '80216', '80219', '80223', '80239', '80906', '80910', '80909', '80918', '80917', '80911', 
		'80920', '81038', '81044', '81054', '81057', '81076', '81062', '81063', '81423', '81435', '81430', '80446', '80442', 
		'80459', '80478', '80482', '81230', '81224', '81225', '80461', '81251', '80221', '80229', '80233', '80234', '80241', 
		'80260', '80601', '80022', '80031', '81504', '81501', '81503', '81507', '81520', '81521', '80011', '80012', '80013', 
		'80014', '80015', '80016', '80017', '80424', '80498', '80828', '80821', '80134', '80126', '80129', '80130', '80108', 
		'80104', '80123', '80127', '80128', '80004', '80003', '80128', '80226', '80227', '80228', '80401', '80501', '80503', 
		'80302', '80303', '80304', '80027'))

/*****Drops the temp tables*****/
	DROP TABLE #DOBTemp
	DROP TABLE #RaceTemp
	DROP TABLE #GenderTemp
	DROP TABLE #OtherQualifiersTemp
	DROP TABLE #TextingTemp
	DROP TABLE #PhaseTemp
	DROP TABLE #LangTemp
  
END
GO


