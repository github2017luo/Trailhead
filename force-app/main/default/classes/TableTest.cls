@isTest
private class TableTest {

    @isTest
    private static void test_getProductTables() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();

        Test.startTest();
        ProductTableController controller = new ProductTableController();
        List<Product_Table__c> productList = controller.getProductTables();
        Test.stopTest();

        System.assert(!productList.isEmpty());
    }

    @isTest
    private static void test_goDetail() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        Product_Table__c product = [
            SELECT Id
            FROM Product_Table__c
            LIMIT 1
        ];
        PageReference tablePage = Page.ProductTableList;
        ProductTableController controller = new ProductTableController();
        controller.productId = product.Id;
        PageReference detailPage = controller.goDetail();

        System.assertNotEquals(tablePage, detailPage);
    }

    @isTest
    private static void test_goBuy() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        Product_Table__c product = [
            SELECT Id
            FROM Product_Table__c
            LIMIT 1
        ];
        PageReference tablePage = Page.ProductTableList;
        ProductTableController controller = new ProductTableController();
        controller.productId = product.Id;
        PageReference orderPage = controller.goBuy();

        System.assertNotEquals(tablePage, orderPage);
    }

}