/**
* REST Service.
*
* <P>Inserting new matches.
*
* @author Irina Bogdanets
* @version 1.0
*/

@RestResource(urlMapping='/Matches/*')
global with sharing class MatchManage {

    // Search Names Teams from JSON.
    private static Set<String> findTeamNames(List<MatchWrapper> matches) {
        Set<String> teamNames = new Set<String>();

        for (MatchWrapper match : matches) {
            teamNames.add(match.matchTeamOne);
            teamNames.add(match.matchTeamTwo);
        }

        return teamNames;
    }

    private static void addExistedTeams(Map<String, Id> NameMatchToId, Set<String> NameWithIdTeamList, Set<String> teamNames) {
        List<Team__c> teams = [
            SELECT Id, Name
            FROM Team__c
            WHERE Name = :teamNames
        ];

        for (Team__c team : teams) {
            NameMatchToId.put(team.Name, team.Id);
            NameWithIdTeamList.add(team.Name);
        }
    }

    private static void addNewTeams(Set<String> teamNames, Set<String> NameWithIdTeamList, Map<String, Id> NameMatchToId) {
        List<Team__c> newTeams = new List<Team__c>();

        teamNames.removeAll(NameWithIdTeamList);
        List<String> teamList = new List<String>(teamNames);

        for (String item : teamList) {
            newTeams.add(new Team__c(
                Name = item
            ));
        }

        try {
            insert newTeams;
        } catch (DmlException dmlError) {
            dmlError.getMessage();
        }

        for (Team__c item : newTeams) {
            NameMatchToId.put(item.Name, item.Id);
        }
    }

    // Creating Map Name to Id Match.
    private static Map<String, Id> setNameMatchToId(Set<String> teamNames) {
        Map<String, Id> NameMatchToId = new Map<String, Id>();
        Set<String> NameWithIdTeamList = new Set<String>();

        addExistedTeams(NameMatchToId, NameWithIdTeamList, teamNames);
        addNewTeams(teamNames, NameWithIdTeamList, NameMatchToId);

        return NameMatchToId;
    }

    private static void generationDataFromJSON(List<MatchWrapper> records, List<Match__c> matches, Set<Date> dates, Map<String, Id> NameMatchToId) {
        for (MatchWrapper item : records) {
            matches.add(new Match__c(
                name = item.matchTeamOne + ' & ' + item.matchTeamTwo,
                DateMatch__c = item.matchDate,
                TeamOne__c = NameMatchToId.get(item.matchTeamOne),
                TeamTwo__c = NameMatchToId.get(item.matchTeamTwo)
            ));
            dates.add(item.matchDate);
        }
    }

    // Searhing existed record where one team has match this day already.
    private static List<Match__c> searhingRecordsWithCondition(Set<Date> dates, Set<String> teamNames) {
        return [
            SELECT Id, Name, DateMatch__c, TeamOne__r.Name, TeamTwo__r.Name
            FROM Match__c
            WHERE (DateMatch__c = :dates
                   AND (TeamOne__r.Name = :teamNames
                        OR TeamTwo__r.Name = :teamNames))
        ];
    }

    @HttpPost
    global static String createMatches() {
        List<Match__c> matches = new List<Match__c>();
        Set<Date> dates = new Set<Date>();

        List<MatchWrapper> records = (List<MatchWrapper>) System.JSON.deserialize( RestContext.request.requestBody.toString()
                                                                                  , List<MatchWrapper>.class
                                                                                 );
        Set<String> teamNames = new Set<String>(findTeamNames(records));
        Map<String, Id> NameMatchToId = setNameMatchToId(new Set<String>(teamNames));
        generationDataFromJSON(records, matches, dates, NameMatchToId);
        List<Match__c> matchDatabaseList = searhingRecordsWithCondition(dates, teamNames);

        if (matchDatabaseList.size() == 0) {
            try {
                insert matches;
                return Label.Success;
            } catch (DmlException dmlError) {
                dmlError.getMessage();
            }
        }
        return Label.ErrorREST;
    }

}