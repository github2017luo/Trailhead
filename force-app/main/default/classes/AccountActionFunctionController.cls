/**
* Form create account.
*
* <P> View mode account after his created.
* <P> Show time to page with using Action Function.
* <P> Show or hide Input File component.
*
* @author Bogdanets Irina
* @version 1.0
*/

public class AccountActionFunctionController {
    public String SystemFormat = Label.SystemFormat;
    public String UserFormat = Label.UserFormat;
    public String urlAllAccount = Label.urlAllAccount;
    public String urlFormCreateAccount = Label.urlFormCreateAccount;
    public String Error_uploading_file = Label.Error_uploading_file;
    public String File_uploaded_successfully = Label.File_uploaded_successfully;
    
    public Account account {get;set;} 
    public String currentTime {get;set;}
    public String createdDate {get;set;}
    public String userTime {get;set;}
    public Boolean showAccountView {get; set;}
    public Boolean inputComponent {get;set;}
    public String nameAttach {get;set;}
    
    public AccountActionFunctionController() {
        account = new Account();
        getCurrentTime();
        showAccountView = false;
        inputComponent = false;
    }
    
    public void getCurrentTime() {
        currentTime = DateTime.now().format(SystemFormat);
    }
    
    // Create account.
    public void save() {
        try {
            insert account; 
            showAccountView = true;
            createdDate = System.now().format(SystemFormat);
            userTime = getUserTime().format(UserFormat);
            
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        } 
    }
    
    // Redirect on all accounts page. 
    public PageReference cancel() {
        PageReference cancel = new PageReference(urlAllAccount);
        cancel.setRedirect(true);
        return cancel;
    }
    
    // Redirect on start page.
    public PageReference refresh() {
        PageReference refresh = new PageReference(urlFormCreateAccount);
        refresh.setRedirect(true);
        return refresh;
    }
    
    // Show or hide attachment form. 
    public void showHideComponent() {
        inputComponent = !inputComponent ? true : false;
    }
    
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    // Add attachment for account.
    public void upload() {    
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = account.Id;
        
        try {
            insert attachment;
            if (nameAttach==null) {
                nameAttach = attachment.Name;
            } else {
                nameAttach += ', ' + attachment.Name; 
            }   
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_uploading_file));
            //return null;
        } finally {
            attachment = new Attachment(); 
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, File_uploaded_successfully));
        //return null;
    }
    
    private Datetime getUserTime() {
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        return local;
    }
}