/**
 * @description       : Apec controller of lwc productInformation.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
public with sharing class ProductInformationController {

    // Wrapper class for combined data
    public class ProductWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public String monthlyCost;
        @AuraEnabled public String atmFee;
        @AuraEnabled public String cardReplacementCost;
    }

    /*********************************************************************************************************
     * @name            getProductInformation
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Method to get all infromation related of the products(standard card, metal card, black card).
     *                                                        
    **********************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static ProductWrapper getProductInformation(Id caseId){

        List<Case> caseInfo = [select Contact.Home_Country__c,Contact.Product__c,Contact.Product__r.Name,Contact.Product__r.Image_Url__c,
                               Contact.Product__r.ATM_Fee__c from Case where ID =: caseId WITH SECURITY_ENFORCED];
        
        ProductWrapper productInfo = new ProductWrapper();

        if(!caseInfo.isEmpty()){

            //Details information
            productInfo.name = caseInfo[0].Contact.Product__r.Name;
            productInfo.imageUrl = caseInfo[0].Contact.Product__r.Image_Url__c;
            productInfo.atmFee = caseInfo[0].Contact.Product__r.ATM_Fee__c + ' %';

            String country = caseInfo[0].Contact.Home_Country__c;
            Id productId = caseInfo[0].Contact.Product__c;
            String currencyIsoCode = CurrencyUtils.getCurrencyIsoCodebyCountry(country);
            String currencySymbol = CurrencyUtils.CURRENCY_TO_SYMBOL.get(currencyIsoCode);
            Decimal cardReplacementCost = PriceService.getPrice(productId,ConstantsObject.STANDARD_PRICEBOOK,currencyIsoCode);
            Decimal monthlyCost = PriceService.getPrice(productId,ConstantsObject.MONTHLY_SUBSCRIPTION,currencyIsoCode);

            //Price information
            productInfo.cardReplacementCost = cardReplacementCost + ' ' + currencySymbol;
            productInfo.monthlyCost = monthlyCost == null ? ConstantsObject.NOT_APPLICABLE : monthlyCost + ' ' + currencySymbol;

        }
        
        return productInfo;
    }
}