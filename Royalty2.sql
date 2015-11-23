

alter VIEW dbo.ROYALTY2 AS
/** Choose column from different database*/
SELECT distinct OEHDRHST_SQL.inv_no, OEHDRHST_SQL.inv_dt, OEHDRHST_SQL.ord_no,OEHDRHST_SQL.ord_dt,OELINHST_SQL.item_desc_1,OELINHST_SQL.item_desc_2,
OEHDRHST_SQL.oe_po_no, OEHDRHST_SQL.cus_no,cu.CustomerName,OELINHST_SQL.item_no,OEHDRHST_SQL.orig_ord_type,
--Change qty_to_ship amount to negative when order type = C- 
case when OEHDRHST_SQL.orig_ord_type='C' then OELINHST_SQL.qty_ordered*(-1) else OELINHST_SQL.qty_to_ship 
		end as qty_ship
, OELINHST_SQL.unit_price,
--Formula for extended price-- 
case when OEHDRHST_SQL.orig_ord_type='C' then OELINHST_SQL.qty_ordered*(-1)*OELINHST_SQL.unit_price else OELINHST_SQL.qty_to_ship*OELINHST_SQL.unit_price end as ext_price,

lic.DisplayName,lic.LicensorID,lic.RoyaltyPercentage,lic.StatusCode,au.AuthoritativeName,cu.Reference_1, 
--Formula for Royal Amount--
Case when OEHDRHST_SQL.orig_ord_type='C' then Round((lic.RoyaltyPercentage * OELINHST_SQL.unit_price * OELINHST_SQL.qty_ordered*(-1))/100,2) else Round((lic.RoyaltyPercentage * OELINHST_SQL.unit_price * OELINHST_SQL.qty_to_ship)/100,2) end As RoyalAmount
/**Join all necessary table together*/
From OEHDRHST_SQL join OELINHST_SQL on OEHDRHST_SQL.ord_no= OELINHST_SQL.ord_no
	 /** Convert two different datatype and add necessary number 0 to match data from two tables*/
 inner join FMPRODUCTION.FanmatsProduction.dbo.Customer cu on  OEHDRHST_SQL.cus_no=RIGHT(REPLICATE('0', 12) + convert(varchar,cu.CustomerID),12)  
	 join FMPRODUCTION.FanmatsProduction.dbo.Product po on convert(varchar,OELINHST_SQL.item_no)= convert (varchar, po.ProductID)
	 join FMPRODUCTION.FanmatsProduction.dbo.Logo l on po.LogoID= l.LogoID 
	 join FMPRODUCTION.FanmatsProduction.dbo.Licensor lic  on  lic.LicensorID= l.LicensorID
	 join FMPRODUCTION.FanmatsProduction.dbo.AuthoritativeBody au on au.AuthoritativeID=lic.AuthoritativeID
/**Filter by inventory date in July*/ 	 

Go








