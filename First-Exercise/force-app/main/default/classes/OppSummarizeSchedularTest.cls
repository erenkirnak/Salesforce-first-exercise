// Test Class for OppSummarizeSchedular.class
@IsTest
private class OppSummarizeSchedularTest{
  public static final String CRON_EXP = '0 0 0 12 12 ? 2022';
  @IsTest
  static void testScheduledJob() {
    Test.startTest();
    Opportunity op = new Opportunity(
      Name = 'TestOpp',
      CloseDate = System.Date.Today() - 1,
      StageName = 'Closed Won'
    );
    insert op;

    // This test runs a scheduled job at midnight Sept. 3rd. 2022

    // Schedule the test job
    String jobId = System.schedule(
      'SchedularTest',
      CRON_EXP,
      new OppSummarizeSchedular()
    );
    // Get the information from the CronTrigger API object
    CronTrigger ct = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];
    // Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression);
    // Verify the job has not run
    System.assertEquals(0, ct.TimesTriggered);
    // Verify the next time the job will run
    System.assertEquals('2022-12-12 00:00:00', String.valueOf(ct.NextFireTime));
    Test.stopTest();
  }
  
}
