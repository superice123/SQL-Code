/** Create a temporary table to make some change in Royal Amount and Extended price*/
Create table #tem( inv_no int,
      inv_dt int
      ,ord_no char(8)
      ,ord_dt int,item_desc_2 char(30)
      ,oe_po_no char(25)
      ,cus_no char(12)
     ,CustomerName varchar(40)
    ,item_no char(15)
      ,orig_ord_type char(1)
      ,qty_to_ship decimal(13,4)
      ,unit_price decimal(13,6)
    , ext_price decimal(27,10)
      ,DisplayName varchar(30)
     , LicensorID int
      ,RoyaltyPercentage float
      ,StatusCode int
      ,AuthoritativeName varchar(50)
     , RoyalAmount float
     ,Reference_1 varchar(250)
)
/** Insert and choose data from Royal view*/
Insert into #tem(inv_no, 
      inv_dt 
      ,ord_no 
      ,ord_dt,item_desc_2  
      ,oe_po_no 
      ,cus_no 
     ,CustomerName 
    ,item_no 
      ,orig_ord_type 
      ,qty_to_ship 
      ,unit_price 
    , ext_price 
      ,DisplayName 
     , LicensorID 
      ,RoyaltyPercentage 
      ,StatusCode 
      ,AuthoritativeName 
     , RoyalAmount 
     , Reference_1
)
select inv_no, 
      inv_dt 
      ,ord_no 
      ,ord_dt ,item_desc_2 
      ,oe_po_no 
      ,cus_no 
     ,CustomerName 
     ,item_no 
      ,orig_ord_type 
      ,qty_ship 
      ,unit_price 
    , ext_price 
      ,DisplayName 
     , LicensorID 
      ,RoyaltyPercentage 
      ,StatusCode 
      ,AuthoritativeName 
     , RoyalAmount 
     ,Reference_1
from ROYALTY3;
/**Update Royal Amount and Extended price to negative*/
Update #tem
set ext_price=qty_to_ship*unit_price
, RoyalAmount=Round((RoyaltyPercentage * unit_price * qty_to_ship)/100,2) 
where orig_ord_type ='C'
/**Display temporary table*/   
  Select *
  from #tem;
/** Drop temporary table*/  
  Drop table #tem
