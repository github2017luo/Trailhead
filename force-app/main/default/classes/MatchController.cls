public without sharing class MatchController {
    
    @AuraEnabled
    public static List<Match__c> getRecordsWithPeriod(String dateStart, String dateEnd) {

        Date start = Date.valueOf(dateStart);
        Date finish = Date.valueOf(dateEnd);

        List<Match__c> matches = [
            SELECT Id, Name, DateMatch__c, TeamOne__c, TeamOne__r.Name, TeamTwo__c, TeamTwo__r.Name
            FROM Match__c
            WHERE DateMatch__c >= :start
            AND DateMatch__c <= :finish
        ];

        return matches;
    }
    
}