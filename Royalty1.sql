alter VIEW dbo.ROYALTY1 AS
/** Choose column from different database*/
SELECT   OEHDRHST_SQL.inv_no, OEHDRHST_SQL.inv_dt, OEHDRHST_SQL.ord_no,OEHDRHST_SQL.ord_dt,OELINHST_SQL.item_desc_1,OELINHST_SQL.item_desc_2,
OEHDRHST_SQL.oe_po_no, OEHDRHST_SQL.cus_no ,OELINHST_SQL.item_no,OEHDRHST_SQL.orig_ord_type,cu.Reference_1,cu.CustomerName,
--Change qty_to_ship amount to negative when order type = C- 
 case when OEHDRHST_SQL.orig_ord_type='C' then OELINHST_SQL.qty_ordered*(-1) else OELINHST_SQL.qty_to_ship 
		end as qty_ship
, OELINHST_SQL.unit_price,
--Formula for extended price-- 
case when OEHDRHST_SQL.orig_ord_type='C' then OELINHST_SQL.qty_ordered*(-1)*OELINHST_SQL.unit_price else OELINHST_SQL.qty_to_ship*OELINHST_SQL.unit_price end as ext_price

From OEHDRHST_SQL join OELINHST_SQL on OEHDRHST_SQL.ord_no= OELINHST_SQL.ord_no
       inner join FMPRODUCTION.FanmatsProduction.dbo.Customer cu on  OEHDRHST_SQL.cus_no=RIGHT(REPLICATE('0', 12) + convert(varchar,cu.CustomerID),12) 
/**Filter by inventory date in July*/ 	 
 
Go

