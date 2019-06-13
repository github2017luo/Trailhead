@isTest
private class OrderTest {
    private static final String TEST_EMAIL = 'irinabogdanets@gmail.com';
    private static final String TEST_FIRST_NAME = 'Irina';
    private static final String TEST_LAST_NAME = 'Bogdanets';
    private static final String TEST_ANOTHER_LAST_NAME = 'Levkovets';

    private static final String TEST_NEW_EMAIL = 'marinaegorova@gmail.com';
    private static final String TEST_NEW_LAST_NAME = 'Egorova';

    private static final Integer TEST_UNIT = 1;
    private static final Integer TEST_ZERO_UNIT = 0;

    private static Boolean findMessage(String text) {
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean message;
        for(Apexpages.Message msg : msgs) {
            message = msg.getDetail().contains(text);
        }
        return message;
    }

    private static void putProductId() {
        Product_Table__c product = [
            SELECT Id
            FROM Product_Table__c
            LIMIT 1
        ];
        PageReference orderPage = Page.ProductOrder;
        Test.setCurrentPage(orderPage);
        ApexPages.currentPage().getParameters().put('id', product.Id);
    }

    @isTest
    private static void test_insert_findContact() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.customer.email = TEST_NEW_EMAIL;
        controller.customer.lastname = TEST_NEW_LAST_NAME;
        controller.findContact();

        System.assert(!String.isEmpty(controller.customer.Id));
        System.assertNotEquals(controller.customer.Id, null);
    }

    @isTest
    private static void test_update_findContact() {
        DataForProductTable.createContact();
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.customer.email = TEST_EMAIL;
        controller.customer.firstname = TEST_FIRST_NAME;
        controller.customer.lastname = TEST_ANOTHER_LAST_NAME;
        controller.findContact();

        Contact updateContact = [
            SELECT Id, lastName
            FROM Contact
            WHERE Id =: controller.customer.Id
        ];

        System.assertEquals(updateContact.lastName, TEST_ANOTHER_LAST_NAME);
    }

    @isTest
    private static void test_findContact() {
        DataForProductTable.createContact();
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.customer.email = TEST_EMAIL;
        controller.customer.firstname = TEST_FIRST_NAME;
        controller.customer.lastname = TEST_LAST_NAME;
        controller.findContact();

        List<Contact> contacts = [
            SELECT Id, firstName, lastName, email
            FROM Contact
            WHERE email = :TEST_EMAIL
            AND firstName = :TEST_FIRST_NAME
            AND lastName = :TEST_LAST_NAME
        ];

        System.assertEquals(contacts.size(), 1);
    }

    @isTest
    private static void test_success_createOrderTable() {
        DataForProductTable.createContact();
        Contact user = [SELECT Id FROM Contact LIMIT 1];
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.order.Units__c = TEST_UNIT;
        controller.customer.Id = user.Id;
        controller.createOrderTable();

        System.assert(!String.isEmpty(controller.order.Id));
        System.assertNotEquals(controller.order.Id, null);
    }

    @isTest
    private static void test_error_createOrderTable() {
        String OrderNotCreated = System.label.Order_not_created;

        DataForProductTable.createContact();
        Contact user = [
            SELECT Id
            FROM Contact
            LIMIT 1
        ];
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.order.Units__c = TEST_ZERO_UNIT;
        controller.customer.Id = user.Id;
        controller.createOrderTable();

        System.assert(findMessage(OrderNotCreated));
    }

    @isTest
    private static void test_success_updateUnitAvailableInProductTable() {
        String PurchaseMade = System.label.Purchase_made;

        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.order.Units__c = TEST_UNIT;
        controller.updateUnitAvailableInProductTable();

        System.assert(findMessage(PurchaseMade));
    }

    @isTest
    private static void test_error_updateUnitAvailableInProductTable() {
        String NoPurchaseMade = System.label.No_purchase_made;

        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.order.Units__c = TEST_ZERO_UNIT;
        controller.updateUnitAvailableInProductTable();

        System.assert(findMessage(NoPurchaseMade));
    }

    @isTest
    private static void test_clearForm() {
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.clearForm();

        System.assertEquals(controller.customer.Id, null);
        System.assertEquals(controller.order.Id, null);
    }

    @isTest
    private static void test_buyProduct() {
        DataForProductTable.createContact();
        DataForProductTable.createWarehouse();
        DataForProductTable.createProduct();
        putProductId();

        ProductOrderController controller = new ProductOrderController();
        controller.customer.email = TEST_EMAIL;
        controller.customer.firstname = TEST_FIRST_NAME;
        controller.customer.lastname = TEST_ANOTHER_LAST_NAME;
        controller.order.Units__c = TEST_UNIT;
        controller.buyProduct();

        Contact updateContact = [
            SELECT Id, lastName
            FROM Contact
            WHERE email = :TEST_EMAIL
        ];

        System.assertEquals(updateContact.lastName, TEST_ANOTHER_LAST_NAME);
    }

}