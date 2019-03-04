drop table biggestmarketplayerscleaned
select b1.* 
	,b2.company as CompanyType
into BiggestMarketPlayersCleaned
from biggestmarketplayers b1

outer apply
(
select TOP 1 company
from biggestmarketplayers b2
where [RANK] IS NULL AND b2.biggestmarketplayersID<=b1.biggestmarketplayersid
ORDER BY BIGGESTMARKETPLAYERSID DESC
) B2

WHERE [RANK] IS NOT NULL


select * from BiggestMarketPlayersCleaned