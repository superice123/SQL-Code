USE [Data_09]
GO

/****** Object:  View [dbo].[Royalty3]    Script Date: 09/16/2014 15:35:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[ROYALTY3] as 
select r1.inv_no 
,r1.inv_dt 
,r1.ord_no 
,r1.ord_dt
,r2.AuthoritativeName
,r1.item_desc_1 
,r1.item_desc_2 
,r1.oe_po_no 
,r1.cus_no 
,r2.CustomerName       
,r1.item_no     
,r1.orig_ord_type       
,r1.qty_ship 
,r1.unit_price 
,r1.ext_price  
,r2.RoyalAmount 
,r2.DisplayName 
,r2.LicensorID 
,r2.RoyaltyPercentage 
,r2.StatusCode 
,r1.Reference_1    

from ROYALTY1 r1 left join ROYALTY2 r2 on
       r1.item_no=r2.item_no
    and r1.inv_no=r2.inv_no 
    and r1.inv_dt=r2.inv_dt
    and r1.ord_no=r2.ord_no 
    and r1.ord_dt=r2.ord_dt 
    and r1.oe_po_no=r2.oe_po_no 
    and r1.cus_no=r2.cus_no 
    and r1.orig_ord_type =r2.orig_ord_type
    and r1.qty_ship =r2.qty_ship
    and r1.unit_price=r2.unit_price 
    and r1.ext_price =r2.ext_price
    and r1.item_desc_2=r2.item_desc_2
    and r1.item_desc_1 =r2.item_desc_1 
where r1.inv_dt between 20140801 and 20140831   

GO


