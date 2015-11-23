/* Create a temporary table to adjust Quantity of functional dependent columns in view*/
-----Choose property and optional constraints as same as InventoryAdvice3-- 
CREATE TABLE #Temptable ([item_no] [char](15) NULL,
	[loc] [char](3) NULL,
	[item_desc_1] [char](30) NULL,
	[item_desc_2] [char](30) NULL,
	[LicStatus] [int] NULL,
	[ProductExclude] [bit] NULL,
	[LogoExclude] [bit] NULL,
	[Qty_on_hand] [decimal](13, 4) NULL,
	[Qty_Allocated] [decimal](13, 4) NULL,
	[vend_no] [char](12) NULL,
	[Qty_Available] [decimal](14, 4) NULL,
	[reported] [varchar](3) NULL,
	[RepQty][decimal](13,4) NULL,
	[RepDate] [int] NULL,upc_cd char(16) NULL);
---Address all columns to insert data-------
Insert into #Temptable( item_no, 
      loc, 
      item_desc_1, 
      item_desc_2, 
      LicStatus, 
      ProductExclude, 
      LogoExclude, 
      Qty_on_hand, 
      Qty_Allocated, 
      vend_no, 
      Qty_Available, 
      reported,RepQty,RepDate,upc_cd 
     )
---Insert data by Bulk insert-------------------     
Select item_no , 
      loc, 
      item_desc_1, 
      item_desc_2, 
      LicStatus, 
      ProductExclude, 
      LogoExclude, 
      Qty_on_hand, 
      Qty_Allocated, 
      vend_no, 
      Qty_Available, 
      reported,RepQty,RepDate,upc_cd 
--Address table where data come from--      
From InventoryAdvice3

/*Updating data accrodingly to requirements*/
-----------------HITCHCOVER Quantity equals EMBLEM Quantity-------------------------------------
Update t1
SET t1.qty_available = t2.qty_available
FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='HITCHCOVER' AND t2.item_desc_2 = 'EMBLEM'
-----------------HITCHCOVER Reported Quantity equals EMBLEM Reported Quantity-------------------------------------
Update t1
SET t1.reported = t2.reported
FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='HITCHCOVER' AND t2.item_desc_2 = 'EMBLEM'

-----------------2GETAGRIP Quantity equals a half of GETAGRIP Quantity-------------------------------------
Update t1
SET t1.qty_available = ROUND((t2.qty_available/2),0)--Round some decimal result--
FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='2GETAGRIP' AND t2.item_desc_2 = 'GETAGRIP'
-----------------2GETAGRIP Reported Quantity following fomular after dividing Quantity a half------------------------------------- 
Update t1
SET t1.reported = (CASE WHEN (t2.qty_available/2)>=99 THEN '100' 
WHEN ROUND((t2.qty_available/2),0)>=49 THEN '50' 
WHEN ROUND((t2.qty_available/2),0)>=9 THEN '10' 
WHEN ROUND((t2.qty_available/2),0)>=0 THEN '0'
WHEN ROUND((t2.qty_available/2),0)<0 THEN '0' 
END)
FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='2GETAGRIP' AND t2.item_desc_2 = 'GETAGRIP'
-----------------2FANBRAN Quantity equals a half of FANBRAN Quantity-------------------------------------
Update t1
SET t1.qty_available = ROUND((t2.qty_available/2),0)
FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='2FANBRAN' AND t2.item_desc_2 = 'FANBRAN'
-----------------2FANBRAN Reported Quantity following fomular after dividing Quantity a half------------------------------------- 
Update t1
SET t1.reported = (CASE WHEN (t2.qty_available/2)>=99 THEN '100' 
WHEN ROUND((t2.qty_available/2),0)>=49 THEN '50' 
WHEN ROUND((t2.qty_available/2),0)>=9 THEN '10' 
WHEN ROUND((t2.qty_available/2),0)>=0 THEN '0'
WHEN ROUND((t2.qty_available/2),0)<0 THEN '0' 
END)
/* Update LICPLATEFRAME 's Qty_Available*/
 FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='2FANBRAN' AND t2.item_desc_2 = 'FANBRAN'
Update #Temptable
set Qty_Available= Qty_on_hand-Qty_Allocated
where item_desc_2='LICPLATEFRAME'
/* Update LICPLATEFRAME 's reported*/
Update #Temptable
set reported= (CASE WHEN (Qty_on_hand-Qty_Allocated)>=99 THEN '100' 
WHEN (Qty_on_hand-Qty_Allocated)>=49 THEN '50' 
WHEN (Qty_on_hand-Qty_Allocated)>=9 THEN '10' 
WHEN (Qty_on_hand-Qty_Allocated)>=0 THEN '0'
WHEN (Qty_on_hand-Qty_Allocated)<0 THEN '0' 
When vend_no = '1002' or vend_no='000000001002' THEN '50' 
END)
where item_desc_2='LICPLATEFRAME'

Update #Temptable
set RepDate=Null
where RepQty=0

Update #Temptable
set RepDate=Null
where vend_no = '1002' or vend_no='000000001002'

Update t1
SET t1.RepDate = t2.RepDate
FROM #Temptable t1 INNER JOIN #Temptable t2 ON t1.item_desc_1 = t2.item_desc_1 and t1.item_desc_2='HITCHCOVER' AND t2.item_desc_2 = 'EMBLEM'
/* Display result*/
select * from #Temptable
/* Drop table for the next times testing*/
DROP TABLE #Temptable
