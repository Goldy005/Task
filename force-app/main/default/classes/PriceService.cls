/**
 * @description       : Class where you find all the methods related to calculation of the price.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
public inherited sharing class PriceService {


    /*********************************************************************************************************
     * @name            getPrice
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Get the price of the products by passing the pricebook and the currenct you want.
     *                                                        
    **********************************************************************************************************/
    public static Decimal getPrice(Id productId,String priceBookName,String currencyIsoCode){
        
        Decimal price = null;
        List<PricebookEntry> priceBook = [select UnitPrice from PricebookEntry where Product2Id =:productId AND Pricebook2.Name =:priceBookName and CurrencyIsoCode =: currencyIsoCode WITH SECURITY_ENFORCED];
        
        if(!priceBook.isEmpty()){
            price = priceBook[0].UnitPrice;
        }
        return price;
    }
}