/******************************************************
 * @Name             : OppSumarizeSchedular.cls
 * @Description      : Schedules SummarizeAllOppAmountsPerAccount Batch job
 * @Created By       : Eren Kırnak
 * @Created Date     : Oct 13, 2022
 * @Modification Log :
 *******************************************************/
global with sharing class OppSummarizeSchedular implements Schedulable {
    public static String dailySched = '0 0 10 1/1 * ? *'; //Every Day 10:00AM
    public static String weeklySched = '0 0 13 ? * FRI *'; //once a week (Friday at 1:00 PM)
    public static String monthlySched = '0 0 18 ? 1/1 FRI#4 *'; //once a month(Last Friday of the Month at 6:00 PM)

    /******************************************************
     * @Name             : schedulaDaily
     * @Description      : Schedules the batch job Every Day at 10:00AM
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param
     * @Param
     * @Return
     *******************************************************/
    global static String scheduleDaily() {
      OppSummarizeSchedular sc = new OppSummarizeSchedular();
      return System.schedule('Daily Opportunity Summarize', dailySched, sc);
    }
    /******************************************************
     * @Name             : scheduleWeekly
     * @Description      : Schedules the batch job once a week (Friday at 1:00 PM)
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param
     * @Param
     * @Return
     *******************************************************/
    global static String scheduleWeekly() {
      OppSummarizeSchedular sc = new OppSummarizeSchedular();
      return System.schedule('Weekly Opportunity Summarize', weeklySched, sc);
    }
    /******************************************************
     * @Name             : scheduleMonthly
     * @Description      : Schedules the batch job once a month(Last Friday of the Month at 6:00 PM)
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param
     * @Param
     * @Return
     *******************************************************/
    global static String scheduleMonthly() {
      OppSummarizeSchedular sc = new OppSummarizeSchedular();
      return System.schedule('Monthly Opportunity Summarize', weeklySched, sc);
    }
    /******************************************************
     * @Name             : execute
     * @Description      : Calls the batch job for execution.
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param SchedulableContext
     *******************************************************/
    global void execute(SchedulableContext sc) {
      SummarizeAllOppAmountsPerAccount batch = new SummarizeAllOppAmountsPerAccount();
      Id batchId = Database.executeBatch(batch);
    }
}
