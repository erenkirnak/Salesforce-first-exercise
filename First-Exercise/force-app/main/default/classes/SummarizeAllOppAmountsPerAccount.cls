/******************************************************
 * @Name             : SummarizeAllOppAmountsPerAccount
 * @Description      : Batch class that summarizes CLosed Won, Open, Closed Lost Opportunities per Account and sends the result as email.
 * @Created By       : Eren Kırnak
 * @Created Date     : Oct 13, 2022
 * @Modification Log :
 *******************************************************/
public class SummarizeAllOppAmountsPerAccount implements Database.Batchable<sObject>, Database.Stateful {
    private Map<Id, Map<String, Decimal>> accountOpportunities = new Map<Id, Map<String, Decimal>>();
    private List<String> stages = new List<String>();
    private final String CLOSED_WON = 'Closed Won';
    private final String OPEN = 'Open';
    private final String CLOSED_LOST = 'Closed Lost';
    private final String QUERY_LOCATOR = 
    'SELECT Id, Account.Name, AccountId, Amount, StageName, TotalOpportunityQuantity FROM Opportunity WHERE StageName IN :stages';

    /******************************************************
     * @Name             : start
     * @Description      : Defines the scope of the batch
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param Database.BatchableContext
     * @Return Database.QueryLocator query results
     *******************************************************/
    public Database.QueryLocator start(Database.BatchableContext bc) {
      stages.add(CLOSED_WON);
      stages.add(OPEN);
      stages.add(CLOSED_LOST);
      return Database.getQueryLocator(
        QUERY_LOCATOR
      );
    }
    /******************************************************
     * @Name             : execute
     * @Description      : Summarizes the opportunity amounts per Account per StageName
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param Database.BatchableContext
     * @Param List<Opportunity> oppurtinity records
     *******************************************************/
    public void execute(Database.BatchableContext bc, List<Opportunity> records) {
      // process each batch of records
      for (Opportunity opp : records) {
        if (accountOpportunities.get(opp.AccountId) == null) {
          accountOpportunities.put(opp.AccountId, new Map<String, Decimal>());
        }

        Map<String, Decimal> stageAmountMap = accountOpportunities.get(
          opp.AccountId
        );

        String stage = opp.StageName;
        if (stage == CLOSED_WON) {
          stageAmountMap.put(stage, opp.Amount);
        } else if (stage == OPEN) {
          stageAmountMap.put(stage, opp.TotalOpportunityQuantity);
        } else {
          stageAmountMap.put(stage, opp.TotalOpportunityQuantity - opp.Amount);
        }
      }
    }
    /******************************************************
     * @Name             : finish
     * @Description      : Creates and sends emails to all primary contacts with the summarized opportunity amounts.
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param Database.BatchableContext
     *******************************************************/
    public void finish(Database.BatchableContext bc) {
      // execute any post-processing operations
      List<Contact> primContacts;
      try {
        primContacts = [
          SELECT Id, Email, AccountId, Account.Name
          FROM Contact
          WHERE Is_Primary_Contact__c = TRUE
        ];
      } catch (QueryException e) {
        throw new HandledException(e.getMessage());
      }

      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      for (Contact primContact : primContacts) {
        String body =
          '<h4>Belows is a table of opportunities related to the acount: ' +
          primContact.Account.Name +
          '.</h4>';
        body +=
          '<table>' +
          '<tbody>' +
          '<tr>' +
          '<td><strong>Account</strong></td>' +
          '<td><strong>Stage</strong></td>' +
          '<td><strong>Amount</strong></td>' +
          '</tr>';

        Map<String, Decimal> summarizedOpp = accountOpportunities.get(
          primContact.AccountId
        );
        if (summarizedOpp.isEmpty()) {
          continue;
        }
        for (String stage : stages) {
          Decimal amount = summarizedOpp.get(stage);
          String amountStr = '';
          if (amount != null) {
            amountStr = '€' + String.valueOf(amount);
          }

          body +=
            '<tr>' +
            '<td>' +
            primContact.Account.Name +
            '</td>' +
            '<td>' +
            stage +
            '</td>' +
            '<td>' +
            amountStr +
            '</td>' +
            '</tr>';
        }

        body += '</tbody>' + '</table>';

        System.debug(primContact.Email);
        System.debug(body);

        mails.add(
          createEmail(
            primContact.Email,
            primContact.Account.Name + ' Opportunity Summary',
            body
          )
        );
      }

      Messaging.sendEmail(mails);
    }

    /******************************************************
     * @Name             : createEmail
     * @Description      : Create Email Template
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param String address to whom the mail will be sent
     * @Param String subject of email
     * @Param String body of email
     * @Return Messagingg.SingleEmailMessage emailMessage Template
     *******************************************************/
    private Messaging.SingleEmailMessage createEmail(
      String to,
      String subject,
      String body
    ) {
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      email.setToAddresses(new List<String>{ to });
      email.setSubject(subject);
      email.setHtmlBody(body);
      email.setUseSignature(true);
      System.debug(email);
      System.debug(to);

      return email;
    }
}
