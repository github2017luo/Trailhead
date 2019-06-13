@isTest
private class MatchManageTest {

    private static final String TEST_DATE = '05/05/2018';
    private static final String TEST_SUCCESS_RQUEST = '[{"MatchName" : "Name","MatchDate" : "2018-05-10","MatchTeamOne" : "Team3","MatchTeamTwo" : "Team4"}]';
    private static final String TEST_ERROR_RQUEST = '[{"MatchName" : "Name","MatchDate" : "2018-05-05","MatchTeamOne" : "Team1","MatchTeamTwo" : "Team3"}]';

    @testSetup
    private static void setup() {

        List<Team__c> teams = new List<Team__c>();
        Team__c team1 = new Team__c(
                Name = 'Team1'
            );
        teams.add(team1);
        Team__c team2 = new Team__c(
                Name = 'Team2'
            );
        teams.add(team2);
        insert teams;

        Match__c match = new Match__c(
            	Name = 'Match',
                DateMatch__c = Date.parse(TEST_DATE),
                TeamOne__c = team1.Id,
                TeamTwo__c = team2.Id
        );
        insert match;

    }

	@isTest
    private static void test_success_createMatches() {

        String success = Label.Success;

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Matches';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(TEST_SUCCESS_RQUEST);
        RestContext.request = request;

        Test.startTest();
        String result = MatchManage.createMatches();
        Test.stopTest();

		System.equals(result, success);

    }

    @isTest
    private static void test_error_createMatches() {

        String error = Label.ErrorREST;

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Matches';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(TEST_ERROR_RQUEST);
        RestContext.request = request;

        Test.startTest();
        String result = MatchManage.createMatches();
        Test.stopTest();

		System.equals(result, error);

    }

}