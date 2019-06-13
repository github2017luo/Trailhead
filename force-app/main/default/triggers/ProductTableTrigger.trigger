trigger ProductTableTrigger on Product_Table__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ProductTableTriggerHandler.updateRecords(Trigger.new);
    }
}