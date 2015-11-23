/* Create another view for joinning two first tables to keep data from InventoryAdvice1 */
alter view dbo.InventoryAdvice3 as
/* Select columns from two tables. Choosing accordinngly from prefered data*/
Select distinct Iv1.item_no , 
      Iv1.loc, 
      Iv1.item_desc_1, 
      Iv1.item_desc_2, 
      Iv1.LicStatus, 
      Iv1.ProductExclude, 
      Iv1.LogoExclude, 
      Iv1.Qty_on_hand ,  
      Iv1.Qty_Allocated, 
      Iv1.vend_no, 
      Iv1.Qty_Available,  
      Iv1.reported, Iv2.RepQty,Iv2.RepDate,Iv1.upc_cd
/*Join two tables together and keep*/      
From InventoryAdvice1 Iv1 left join InventoryAdvice2 Iv2
On  Iv1.item_no=Iv2.item_no 