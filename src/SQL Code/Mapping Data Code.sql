select Filing_ID
		,Company_ID
		,Company
		,County
		,_Insurance_Type_
		,_Insurance_Type_Code_
		,_Number_of_Claims_
		,_Closed_Claims__paid__
		,_Closed_Claims__not_paid__
		,_Number_Claims_Open_
		,REPLACE(REPLACE(_Paid_Loss_,'$',''),' ',0) AS _Paid_Loss_
		,_Number_Claims_with_AOB_
		,NAIC_Number

		INTO Mapping_DataCleaned
from mapping_data

SELECT * FROM Mapping_DataCleaned