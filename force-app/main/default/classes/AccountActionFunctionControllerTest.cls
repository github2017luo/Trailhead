@isTest
public class AccountActionFunctionControllerTest {

	@isTest
    public static void insertAccount() {
        AccountActionFunctionController accountController = new AccountActionFunctionController();
        accountController.account = new Account(name='VRP');
        accountController.save();
        
        System.assert(accountController.account.Id != null);
    }
    
    @isTest
    public static void insertError() {
        AccountActionFunctionController accountController = new AccountActionFunctionController();
        accountController.save();

        System.assert(accountController.account.Id == null);
    }
    
    @isTest
    public static void insertAttachment() {
        
        AccountActionFunctionController accountController = new AccountActionFunctionController();
        accountController.account = new Account(name='VRP');
        accountController.save();
        
        accountController.attachment.Name = 'Unit Test Attachment';
        accountController.attachment.Body = Blob.valueOf('Unit Test Attachment Body');
        accountController.attachment.ParentId = accountController.account.Id;

        accountController.upload();

        Attachment attachment = [SELECT Id, Name FROM Attachment WHERE Name= 'Unit Test Attachment'];
        System.assertEquals('Unit Test Attachment', attachment.Name); 
    }
    
    @isTest
    public static void cancelRedirect() {
        AccountActionFunctionController accountController = new AccountActionFunctionController();
        PageReference pageRef = accountController.cancel();
        
        System.assertNotEquals(null, pageRef);
        System.assert(pageRef.getUrl().contains(Account.getSobjectType().getDescribe().getKeyPrefix()));
    }
    
    @isTest
    public static void refreshRedirect() {
        AccountActionFunctionController accountController = new AccountActionFunctionController();
        PageReference pageRef = accountController.refresh();
        
        System.assertNotEquals(null, pageRef);
        System.assert(pageRef.getUrl().toLowerCase() == Page.AccountActionFunctionPage.getUrl());
    }
}