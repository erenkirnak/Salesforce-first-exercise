global with sharing class OppSummarizeSchedular implements Schedulable {
  public static String dailySched = '0 0 10 1/1 * ? *'; //Every Day 10:00AM
  public static String weeklySched = '0 0 13 ? * FRI *'; //once a week (Friday at 1:00 PM)
  public static String monthlySched = '0 0 18 ? 1/1 FRI#4 *'; //once a month(Last Friday of the Month at 6:00 PM)

  global static String scheduleDaily() {
    OppSummarizeSchedular sc = new OppSummarizeSchedular();
    return System.schedule('Daily Opportunity Summarize', dailySched, sc);
  }

  global static String scheduleWeekly() {
    OppSummarizeSchedular sc = new OppSummarizeSchedular();
    return System.schedule('Weekly Opportunity Summarize', weeklySched, sc);
  }

  global static String scheduleMonthly() {
    OppSummarizeSchedular sc = new OppSummarizeSchedular();
    return System.schedule('Monthly Opportunity Summarize', weeklySched, sc);
  }

  global void execute(SchedulableContext sc) {
    SummarizeAllOppAmountsPerAccount batch = new SummarizeAllOppAmountsPerAccount();
    Id batchId = Database.executeBatch(batch);
  }
}
