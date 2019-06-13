public class testController {
	public Account account {get;set;} 
    public String createdDate {get;set;}
    public String userTime {get;set;}
    public Boolean inputComponent {get;set;}
    
    public testController() {
        account = new Account();
        inputComponent = false;
    }
    
    private Datetime getUserTime() {
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        return local;
    }
    
    public PageReference cancel() {
        PageReference cancel = new PageReference('/001/o');
        cancel.setRedirect(true);
        return cancel;
    }
    public PageReference refresh() {
        PageReference refresh = new PageReference('/apex/AccountActionFunctionPage');
        refresh.setRedirect(true);
        return refresh;
    }
    
    public void save() {
        try {
            insert account; 
            createdDate = System.now().format('MM/dd/yy hh:mm:ss');
            userTime = getUserTime().format('d:MMMM:yyyy hh:mm:ss');
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        } 
    }
    public void showHideComponent() {
        inputComponent = !inputComponent ? true : false;
    }
    
    public Document document {
        get {
            if (document == null)
                document = new Document();
            return document;
        }
        set;
    }
    
    public PageReference upload() {
        
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        
        try {
            insert document;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            return null;
        } finally {
            document.body = null;
            document = new Document();
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        return null;
    }
}