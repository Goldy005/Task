/**
 * @description       : Test class that test the funtionality of CustomerInformationManager.
 * @group             : 
 * @last modified on  :  24/02/2023
 * @last modified by  :  Shajinder Singh
 * Modifications Log 
 * Ver   Date         Author                                            Modification
 * 1.O   24/02/2023   Shajinder Singh                                   Intial version.
 **/
@IsTest
private class  CustomerInformationManagerTest {
    
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
        con.External_Id__c = 'd1de8404-b53b-11ed-afa1-0242ac120002';
        insert con;
        
    }
    
    /*********************************************************************************************************
     * @name            testGetMethod
     * @author          Shajinder Singh
     * @created         24/02/2023
     * @description     Method that test if the get method of the Rest Api.
     *                                                        
    **********************************************************************************************************/
    static testMethod void testGetMethod(){
        
        Contact customerInformation = [select External_Id__c from Contact limit 1];
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/api/CustomerInformation/'+customerInformation.External_Id__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        CustomerInformationManager.ProductWrapper wrapper = new CustomerInformationManager.ProductWrapper();
        Test.startTest();
        wrapper = CustomerInformationManager.doGet();
        Test.stopTest();
        Assert.areEqual('Standard Card-0', wrapper.name);
        Assert.areEqual('1.70 %', wrapper.atmFee);
        Assert.areEqual('0.00 €', wrapper.monthlyCost);
        Assert.areEqual('6.00 €', wrapper.cardReplacementCost);

    }

}