/**
 * @description       : CustomerInformationManager that will show to external system the product information.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
@RestResource(urlMapping='/api/CustomerInformation/*')
global with sharing class CustomerInformationManager {

    // Wrapper class for combined data
    global class ProductWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public String monthlyCost;
        @AuraEnabled public String atmFee;
        @AuraEnabled public String cardReplacementCost;
    }

    /*********************************************************************************************************
     * @name            doGet
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Method where external system passes an external id of contact and response we return
     *                  product information.
     *                                                        
    **********************************************************************************************************/
    @HttpGet
    global static ProductWrapper doGet() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String cutomerExternalId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        List<Contact> customer = [select Product__c,Home_Country__c,Product__r.Name,Product__r.Image_Url__c,Product__r.ATM_Fee__c from Contact where External_Id__c =: cutomerExternalId WITH SECURITY_ENFORCED];
        

        
        CustomerInformationManager.ProductWrapper productInfo = new CustomerInformationManager.ProductWrapper();

        if(!customer.isEmpty()){

            //Details information
            productInfo.name = customer[0].Product__r.Name;
            productInfo.imageUrl = customer[0].Product__r.Image_Url__c;
            productInfo.atmFee = customer[0].Product__r.ATM_Fee__c + ' %';

            String country = customer[0].Home_Country__c;
            Id productId = customer[0].Product__c;
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