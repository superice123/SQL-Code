Alter view dbo.InventoryAdvice1b as
Select IMITMIDX_SQL.item_desc_1,IMITMIDX_SQL.item_desc_2, Qty_on_hand
From  IMINVLOC_SQL join IMITMIDX_SQL on IMINVLOC_SQL.item_no=IMITMIDX_SQL.item_no
Where IMITMIDX_SQL.item_desc_2='LICPLATESTICKER'