/**
 * @description       : In the class you will find all basics methods related to currency.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
public inherited sharing class CurrencyUtils {

    public static final Map<String, String> CURRENCY_TO_SYMBOL = new Map<String, String>{
        'EUR' => '€',
        'GBP' => '£'
    };

    /*********************************************************************************************************
     * @name            getCurrencyIsoCodebyCountry
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Get the currency ISO code passing the country.
     *                                                        
    **********************************************************************************************************/
    public static String getCurrencyIsoCodebyCountry(String country){
        
        String currencyIsoCode = '';

        List<Country_Currency_Mapping__mdt> currencyMap = [select Currency_Iso_Code__c from Country_Currency_Mapping__mdt where Country__c =:country WITH SECURITY_ENFORCED];

        if(!currencyMap.isEmpty()){
            currencyIsoCode = currencyMap[0].Currency_Iso_Code__c;
        }
        return currencyIsoCode;
    }
}