
Alter view dbo.InventoryAdvice2 as
/** Select columns for view*/
Select  distinct IMITMIDX_SQL.item_no, IMINVLOC_SQL.loc, IMITMIDX_SQL.item_desc_1,IMITMIDX_SQL.item_desc_2,lic.StatusCode as LicStatus, p.Exclude as ProductExclude, l.Exclude as LogoExclude , Sum( Qty_on_hand) as Qtyhand,
		Sum( Qty_Allocated) as QtyAllocated, IMINVLOC_SQL.vend_no, Sum( qty_on_hand-qty_allocated) as Qty_Available, 
--Include only Replenishment Quantity for vend number != 1002--		
		case when IMINVLOC_SQL.vend_no='1002' or IMINVLOC_SQL.vend_no='000000001002' then null 
		else Sum (pol.qty_remaining)  end as RepQty,
--Include only Replenishment Date for vend number != 1002---		
		case when IMINVLOC_SQL.vend_no='1002' or IMINVLOC_SQL.vend_no='000000001002' then null 
		else Max (pol.promise_dt) end as RepDate ,

--Create report for range of number	for report column--	
Max( CASE WHEN IMINVLOC_SQL.vend_no = '1002' or IMINVLOC_SQL.vend_no='000000001002' THEN '50'  	
ELSE (CASE WHEN (qty_on_hand-qty_allocated)>=99 THEN '100' 
WHEN (qty_on_hand-qty_allocated)>=49 THEN '50' 
WHEN (qty_on_hand-qty_allocated)>=9 THEN '10' 
WHEN (qty_on_hand-qty_allocated)>=0 THEN '0'
WHEN (qty_on_hand-qty_allocated)<0 THEN '0' 
END)
-------End all case as reported------
END) as reported,IMITMIDX_SQL.upc_cd
	 /** Reference of all columns in view from databases and tables*/	
From IMINVLOC_SQL join IMITMIDX_SQL on IMINVLOC_SQL.item_no=IMITMIDX_SQL.item_no
	  join FMPRODUCTION.FanmatsProduction.dbo.vwFM_MM_ItemInfo v on v.item_no= IMITMIDX_SQL.item_no
	  /*Additional references here*/
	  join POORDLIN_SQL pol on IMITMIDX_SQL.item_no= pol.item_no
	  join POORDHDR_SQL po on po.ord_no= pol.ord_no
	  /** End additional references*/
	  join FMPRODUCTION.FanmatsProduction.dbo.Product p on v.ProductID= p.ProductID
	  join FMPRODUCTION.FanmatsProduction.dbo.Logo l on p.LogoID= l.LogoID 
	  join FMPRODUCTION.FanmatsProduction.dbo.Licensor lic  on  lic.LicensorID= l.LicensorID
/** Required filter for view number 2*/
Where lic.StatusCode = '1'
	  And p.Exclude = '0'
	  And l.Exclude = '0'
	  and IMINVLOC_SQL.loc in ('1' , '001')
	  and po.ord_status not in ('C' ,'H')
	  and IMINVLOC_SQL.vend_no not in( '1002','000000001002')
	  
/*Group by all mutual columns with same data below*/ 	  
Group by  IMINVLOC_SQL.loc,lic.StatusCode,p.Exclude ,l.Exclude,IMINVLOC_SQL.vend_no, IMITMIDX_SQL.item_no, IMITMIDX_SQL.item_desc_1,IMITMIDX_SQL.item_desc_2,IMITMIDX_SQL.upc_cd

;


GO
