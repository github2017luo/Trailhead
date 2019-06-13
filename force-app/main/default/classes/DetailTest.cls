@isTest
private class DetailTest {

    @isTest
    private static void test_getRecord() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        Product_Table__c product = [
            SELECT Id
            FROM Product_Table__c
            LIMIT 1
        ];
        PageReference detailPage = Page.ProductDetailPage;
        Test.setCurrentPage(detailPage);
        detailPage.getParameters().put('Id', String.valueOf(product.Id));
        ApexPages.StandardController stdController = new ApexPages.StandardController(product);
        ProductDetailController custController = new ProductDetailController(stdController);

        System.assertEquals(custController.product.Id, product.Id);
    }

    @isTest
    private static void test_goShopping() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        Product_Table__c product = [
            SELECT Id
            FROM Product_Table__c
            LIMIT 1
        ];
        PageReference detailPage = Page.ProductDetailPage;
        ApexPages.StandardController stdController = new ApexPages.StandardController(product);
        ProductDetailController controller = new ProductDetailController(stdController);
        PageReference tablePage = controller.goShopping();

        System.assertNotEquals(detailPage, tablePage);
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
        PageReference detailPage = Page.ProductDetailPage;
        ApexPages.StandardController stdController = new ApexPages.StandardController(product);
        ProductDetailController controller = new ProductDetailController(stdController);
        PageReference orderPage = controller.goBuy();

        System.assertNotEquals(detailPage, orderPage);
    }

}