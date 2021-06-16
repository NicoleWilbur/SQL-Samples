SELECT HighImpact, Total, ROUND(HighImpact/Total*100, 2) AS Percentage, Organization
FROM(
	SELECT TRY_CONVERT(FLOAT, HighImpact) AS HighImpact, TRY_CONVERT(FLOAT, Total) AS Total, t1.Organization 
	FROM (
		SELECT COUNT(ID) AS HighImpact, (CASE WHEN OrganizationFormId IN ('11111111', '0000000') THEN 'FOO' ELSE 'BOO' END) AS Organization
		FROM [dbo].[OrganizationTable] 
		WHERE InvitesSentCount IS NULL
		AND (Age >= 65
		OR Race LIKE '%black%' OR Race LIKE '%Indian%' OR Race LIKE '%hawaiian%' OR Race LIKE '%latinx%'
		OR PostalCode IN (
		'80202', '80204', '80205', '80216', '80219', '80223', '80239', '80906', '80910', '80909', '80918', '80917', '80911', 
		'80920', '81038', '81044', '81054', '81057', '81076', '81062', '81063', '81423', '81435', '81430', '80446', '80442', 
		'80459', '80478', '80482', '81230', '81224', '81225', '80461', '81251', '80221', '80229', '80233', '80234', '80241', 
		'80260', '80601', '80022', '80031', '81504', '81501', '81503', '81507', '81520', '81521', '80011', '80012', '80013', 
		'80014', '80015', '80016', '80017', '80424', '80498', '80828', '80821', '80134', '80126', '80129', '80130', '80108', 
		'80104', '80123', '80127', '80128', '80004', '80003', '80128', '80226', '80227', '80228', '80401', '80501', '80503', 
		'80302', '80303', '80304', '80027'))
		GROUP BY (CASE WHEN OrganizationFormId IN ('11111111', '0000000') THEN 'FOO' ELSE 'BOO' END)
		)t1
JOIN 
	(SELECT * 
	FROM (
		SELECT COUNT(ID) AS Total, (CASE WHEN OrganizationFormId IN ('11111111', '0000000') THEN 'FOO' ELSE 'BOO' END) AS Organization2 
		FROM [dbo].[OrganizationTable] 
		GROUP BY (CASE WHEN OrganizationFormId IN ('11111111', '0000000') THEN 'FOO' ELSE 'BOO' END))t2
	)t3
ON t3.Organization2 = t1.Organization
)t4