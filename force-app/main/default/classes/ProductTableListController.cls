public class ProductTableListController {
    public Id productId { get;set; }
    public Product_Table__c product { get;set; }
    public List<Product_Table__c> products { get;set; }
    public String emailContact { get;set; }
    public String firstNameContact { get;set; }
    public String lastNameContact { get;set; }
    public Decimal productUnitAvailable { get;set; }

    public ProductTableListController() {
        products = [SELECT Id, Name, Image_url__c, Title__c, Product_Description__c, Unit_Price__c, Units_Available__c
                    FROM Product_Table__c];
    }
    public void findSelectedProduct() {
        product = new Product_Table__c();
        //productId=ApexPages.currentPage().getParameters().get('productId');
        product = [SELECT Id, Name, Image_url__c, Unit_Price__c, Units_Available__c, Title__c, Product_Description__c
                                    FROM Product_Table__c WHERE Id =: productId];
    }
    public PageReference moreDetailProduct() {
        findSelectedProduct();
        PageReference pageRef = Page.ProductDetailPage;
        return pageRef;
    }
    public PageReference buyProduct() {
		findSelectedProduct();
        PageReference pageRef = Page.ProductOrder;
        return pageRef;
    }
    public PageReference toShopping() {
        PageReference pageRef = Page.ProductTableList;
        return pageRef;
    }
}