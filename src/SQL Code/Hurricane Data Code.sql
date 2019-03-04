SELECT  RIGHT(H1.column1,2)+'/'+SUBSTRING(H1.column1,5,2)+'/'+LEFT(H1.column1,4) AS Date
		,H1.Hurricane_DataID
		,MaxHurricaneWindSpeed
		,H2.column1 AS Cyclone_Code
		,H2.column2 AS Name
		,H2.column3 AS TotalNumberOfRows
		,H1.column1
		,H1.column2 AS Minutes
		,H1.column3 AS RecordIdentifier
		,H1.column4 AS StatusofSystem
		,CASE	WHEN RIGHT(column5,1)='N' THEN REPLACE(column5,RIGHT(column5,1),'')
				END AS Latitude	--Convert latitude to decimal degrees and remove blank space after number. Didn't need to convert South latitude values
								--since we are only considering Florida.
		,CASE	WHEN RIGHT(column6,1)='W' THEN '-'+REPLACE(REPLACE(column6,RIGHT(column6,1),''),' ','')
				WHEN RIGHT(column6,1)='E' THEN REPLACE(column6,RIGHT(column6,1),'')
				END AS Longitude --Same as above but for longitude and adding a minus sign to the West values.
		,H1.column5
		,H1.column6
		,H1.column7 AS MaximumSustainedWind
		,H1.column8 AS MinimumPressure
		,H1.column9
		,H1.column10
		,H1.column11
		,H1.column12
		,H1.column13
		,H1.column14
		,H1.column15
		,H1.column16
		,H1.column17
		,H1.column18
		,H1.column19
		,H1.column20


FROM HURRICANE_DATA H1

OUTER APPLY(
			SELECT	TOP 1 Hurricane_DataID,column1,column2,column3
			FROM	Hurricane_Data H2
			WHERE	H2.Hurricane_DataID<=H1.Hurricane_DataID AND column4 IS NULL
			ORDER BY Hurricane_DataID DESC
			) H2 --Adding the corresponding hurricane code to each row

LEFT JOIN ( 
			SELECT	MAX(CAST(column7 AS NUMERIC)) AS MaxHurricaneWindSpeed --CAST to numeric since MAX function didn't work properly without it.
					,h2.column1
			
			FROM	HURRICANE_DATA H1

			OUTER APPLY(
						SELECT	TOP 1 Hurricane_DataID,column1,column2,column3
						FROM	Hurricane_Data H2
						WHERE	H2.Hurricane_DataID<=H1.Hurricane_DataID AND column4 IS NULL
						ORDER BY Hurricane_DataID DESC
						) H2

			--WHERE h1.column4 IS NOT NULL and H1.COLUMN1>=19500101 --and h2.column1='AL011950'
				GROUP BY h2.column1
			) H3 ON H3.column1=H2.column1 --This join is to find the maximum wind speed for each hurricane
											--so that we can categorise each hurricane accordingly.
			
WHERE column4 IS NOT NULL --to remove the header rows for each hurricane
	 --and H1.COLUMN1>=19500101 --only consider hurricanes passed a certain date.