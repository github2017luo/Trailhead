@isTest
public class ProductTableTriggerHandlerTest {
    @testSetup 
    public static void setup() {
        OrgConfiguration__c periodTerm = new OrgConfiguration__c(
        	Period_Term__c = 5
        );
        insert periodTerm;
    }
    @isTest 
    public static void createProductWithoutAddedDate() {
        List<Product_Table__c> productSList = new List<Product_Table__c>();
        Product_Table__c product1 = new Product_Table__c(
            Name = 'Product1'
        );
        productSList.add(product1);
        
        Test.startTest();
        Database.SaveResult[] result = Database.insert(productSList, false);
        Test.stopTest();
        
        OrgConfiguration__c config = [SELECT Id, Period_Term__c FROM OrgConfiguration__c];
        Product_Table__c product = [SELECT Id, Added_Date__c, Warehouse__c FROM Product_Table__c 
                                    WHERE Id =: product1.Id];
        Warehouse__c warehouse = [SELECT Id, Period_Start__c, Period_End__c FROM Warehouse__c 
                                  WHERE Id =: product.Warehouse__c];
        
        System.assert(product.Added_Date__c == Date.today());
        System.assertEquals(product.Warehouse__c, warehouse.Id);
        System.assert(Integer.valueOf(warehouse.Period_Start__c.daysBetween(warehouse.Period_End__c)) ==
                      config.Period_Term__c);
    }
    @isTest 
    public static void createProductWithoutWarehouse() {
        List<Product_Table__c> productSList = new List<Product_Table__c>();
        Product_Table__c product1 = new Product_Table__c(
            Name = 'Product1',
            Added_Date__c = Date.today()
        );
        productSList.add(product1);
        
        Test.startTest();
        Database.SaveResult[] result = Database.insert(productSList, false);
        Test.stopTest();
        
        OrgConfiguration__c config = [SELECT Id, Period_Term__c FROM OrgConfiguration__c];
        Product_Table__c product = [SELECT Id, Warehouse__c FROM Product_Table__c WHERE Id =: product1.Id];
        Warehouse__c warehouse = [SELECT Id, Period_Start__c, Period_End__c 
                                  FROM Warehouse__c WHERE Id =: product.Warehouse__c];

        System.assertEquals(result[0].isSuccess(), true);
        System.assertEquals(product.Warehouse__c, warehouse.Id);
        System.assert(Integer.valueOf(warehouse.Period_Start__c.daysBetween(warehouse.Period_End__c)) ==
                      config.Period_Term__c);
    }
    @isTest 
    public static void createProductWithWarehouse() {
        Warehouse__c warehouse = new Warehouse__c(
            Name = 'Warehouse ' + String.valueOf(Date.today()) + ' ' + String.valueOf(Date.today() + 5),
            Period_Start__c = Date.today(),
            Period_End__c = Date.today() + 5
        );
        insert warehouse;
        
        List<Product_Table__c> productSList = new List<Product_Table__c>();
        Product_Table__c product1 = new Product_Table__c(
            Name = 'Product1',
            Added_Date__c = Date.today()
        );
        Product_Table__c product2 = new Product_Table__c(
            Name = 'Product2',
            Added_Date__c = Date.today()
        );
        productSList.add(product1);
        productSList.add(product2);
        
        Test.startTest();
        Database.SaveResult[] result = Database.insert(productSList, false);
        Test.stopTest();
        
        Warehouse__c warehouseTest = [SELECT Id FROM Warehouse__c WHERE Id =: warehouse.Id];
        Product_Table__c productTest1 = [SELECT Id, Warehouse__c FROM Product_Table__c WHERE Id =: product1.Id];
        Product_Table__c productTest2 = [SELECT Id, Warehouse__c FROM Product_Table__c WHERE Id =: product2.Id];
        
        System.assertEquals(result[0].isSuccess(), true);
        System.assertEquals(warehouseTest.Id, productTest1.Warehouse__c);
        System.assertEquals(warehouseTest.Id, productTest2.Warehouse__c);
    }
}