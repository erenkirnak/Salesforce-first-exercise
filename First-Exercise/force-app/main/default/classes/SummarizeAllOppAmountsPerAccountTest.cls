@IsTest
private with sharing class SummarizeAllOppAmountsPerAccountTest {
    private static void initData() {
      Account acc = new Account(Name = 'BatchTestAccount');
      insert acc;

      List<Opportunity> opps = new List<Opportunity>();
      for (Integer i = 0; i < 20; i++) {
        opps.add(
          new Opportunity(
            Name = 'opp' + i,
            StageName = 'Open',
            Amount = 1500.0,
            AccountId = acc.Id,
            CloseDate = Date.newInstance(2021, 8, 6)
          )
        );
      }
      insert opps;

      insert new Contact(
        LastName = 'TestPrimaryContact',
        AccountId = acc.Id,
        Email = 'batchtest@testmail.com',
        Is_Primary_Contact__c = true
      );
    }

    @IsTest
    static void testBatchExecutes() {
      initData();

      Test.startTest();
      SummarizeAllOppAmountsPerAccount batch = new SummarizeAllOppAmountsPerAccount();
      Id batchId = Database.executeBatch(batch);
      Test.stopTest();

      AsyncApexJob job = [
        SELECT
          Id,
          Status,
          NumberOfErrors,
          JobItemsProcessed,
          TotalJobItems,
          CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :batchId
      ];

      System.assertEquals('Completed', job.Status);
    }
}
