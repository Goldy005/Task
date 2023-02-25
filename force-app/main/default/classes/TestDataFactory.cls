/**
 * @description       : Test Data Factory: Here will have all the methods of creation of data
 *                      that will be used in Test classes to create data.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
public inherited sharing class TestDataFactory {

    public static Contact createContact(String lastName, String firstName, Boolean doInsert) {
        Contact contact = new Contact(LastName = lastName, FirstName = firstName);
        if (doInsert) insert contact;
        return contact;
    }
    public static Case createCase(String status,String origin,Id conId,Boolean doDml) {
        Case ca = new Case();
        ca.Origin = origin;
        ca.Status = status;
        ca.ContactId = conId;
        if(doDml){
            insert ca;
        }
        return ca;
    }

    public static Pricebook2 createStandardPriceBook(String pricebookName) {
        Pricebook2 standardPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                Name = pricebookName,
                IsActive = true
        );
        update standardPricebook;

        return standardPricebook;
    }

    public static List<Product2> createProducts(Integer numberOfRecords, String productName, Decimal atmFee, Boolean doDml) {
        final List<Product2> productsList = new List<Product2>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            productsList.add(
                    new Product2(
                            Name = productName + '-' + i,
                            ATM_Fee__c = atmFee,
                            IsActive = true
                    )
            );
        }

        if (doDml) {
            insert productsList;
        }

        return productsList;
    }

    public static Pricebook2 createCustomPricebook(String pricebookName) {
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = pricebookName;
        pricebook.IsActive = true;

        insert pricebook;

        return pricebook;
    }
    

    public static List<PricebookEntry> createPricebookEntries(Id pricebookId, List<Product2> productsList, String currencyIsoCode, Decimal price,Boolean doDml) {
        final List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();

        for (Integer i = 0; i < productsList.size(); i++) {
            pricebookEntryList.add(
                    new PricebookEntry(
                            Pricebook2Id = pricebookId,
                            Product2Id = productsList[i].Id,
                            CurrencyIsoCode = currencyIsoCode,
                            UnitPrice = price,
                            IsActive = true
                    )
            );
        }

        if (doDml) {
            insert pricebookEntryList;
        }

        return pricebookEntryList;

    }
}