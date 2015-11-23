/**Create first inventory advice table*/ 
Alter view dbo.InventoryAdvice1 as
/** Select columns for view*/
Select    IMITMIDX_SQL.item_no, IMINVLOC_SQL.loc, IMITMIDX_SQL.item_desc_1,IMITMIDX_SQL.item_desc_2,lic.StatusCode as LicStatus, p.Exclude as ProductExclude, l.Exclude as LogoExclude ,  
         Case when IMITMIDX_SQL.item_desc_2='LICPLATEFRAME' then (select  Qty_on_hand from InventoryAdvice1b where IMITMIDX_SQL.item_desc_1=InventoryAdvice1b.item_desc_1  ) else qty_on_hand end as  Qty_on_hand,
		 Qty_Allocated , IMINVLOC_SQL.vend_no, ( qty_on_hand-qty_allocated ) as Qty_Available, 
--Create report for range of number for reporting-------------------- 

--Always report 50 quantity for vendor number= 1002 for reported column----------------  		
CASE WHEN IMINVLOC_SQL.vend_no = '1002' or IMINVLOC_SQL.vend_no='000000001002' THEN '50' 
--Other vendor number cases for reported column--------------------------------- 	
ELSE (CASE WHEN (qty_on_hand-qty_allocated)>=99 THEN '100' 
WHEN (qty_on_hand-qty_allocated)>=49 THEN '50' 
WHEN (qty_on_hand-qty_allocated)>=9 THEN '10' 
WHEN (qty_on_hand-qty_allocated)>=0 THEN '0'
WHEN (qty_on_hand-qty_allocated)<0 THEN '0' 
END)
-------End all case as reported------
END as reported, IMITMIDX_SQL.upc_cd

/** Reference of all columns in view from databases and tables*/		
From  IMINVLOC_SQL join IMITMIDX_SQL on IMINVLOC_SQL.item_no=IMITMIDX_SQL.item_no
	  join FMPRODUCTION.FanmatsProduction.dbo.vwFM_MM_ItemInfo v on v.item_no= IMITMIDX_SQL.item_no
	  join FMPRODUCTION.FanmatsProduction.dbo.Product p on v.ProductID= p.ProductID
	  join FMPRODUCTION.FanmatsProduction.dbo.Logo l on p.LogoID= l.LogoID 
	  join FMPRODUCTION.FanmatsProduction.dbo.Licensor lic  on  lic.LicensorID= l.LicensorID
/** Required filter for view number 1*/

Where lic.StatusCode = '1'--Status is A---
	  And p.Exclude = '0'--Product exclude is blank--
	  And l.Exclude = '0'--Logo exclude is blank--
	  and IMINVLOC_SQL.loc in ('001', '1') --Location is 001--
  
;


