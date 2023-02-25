/**
 * @description       : Test class that test the funtionality of ProductInformationController.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
@isTest
private class ProductInformationControllerTest {
    
    
    /*********************************************************************************************************
     * @name            setup
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Method that created all sample data that will use in the test methods.
     *                                                        
    **********************************************************************************************************/
    @testSetup static void setup() {

		//Creation of all data need in the test methods.
		
		//Product Information        
        List<Product2> products = TestDataFactory.createProducts(1,'Standard Card',1.7,true);
        Pricebook2 customPriceBook = TestDataFactory.createCustomPricebook(ConstantsObject.MONTHLY_SUBSCRIPTION);
        Pricebook2 standardPriceBook = TestDataFactory.createStandardPriceBook(ConstantsObject.STANDARD_PRICEBOOK);
        List<PricebookEntry> createStandardPricebookEntries = TestDataFactory.createPricebookEntries(Test.getStandardPricebookId(),products,ConstantsObject.EUR_ISO_CODE,6,true);
        List<PricebookEntry> createPricebookEntries = TestDataFactory.createPricebookEntries(customPriceBook.Id,products,ConstantsObject.EUR_ISO_CODE,0,true);
        
        //Customer Information
        Contact con = TestDataFactory.createContact('Test','User',false);
        con.Home_Country__c = ConstantsObject.SPAIN_COUNTRY_CODE;
        con.Product__c = products[0].id;
        insert con;
        
        Case caso = TestDataFactory.createCase('New','Web',con.id,true);
    }
    
    /*********************************************************************************************************
     * @name            getProductInformationTest
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Method that test if the getProductInformation return products data.
     *                                                        
    **********************************************************************************************************/
    @isTest static void getProductInformationTest(){
        
        Case caso = [select id from Case limit 1];

        ProductInformationController.ProductWrapper wrapper;
        Test.startTest();
        
         wrapper = ProductInformationController.getProductInformation(caso.id);
        
        Test.stopTest();
        Assert.areEqual('Standard Card-0', wrapper.name);
        Assert.areEqual('1.70 %', wrapper.atmFee);
        Assert.areEqual('0.00 €', wrapper.monthlyCost);
        Assert.areEqual('6.00 €', wrapper.cardReplacementCost);


    }
}