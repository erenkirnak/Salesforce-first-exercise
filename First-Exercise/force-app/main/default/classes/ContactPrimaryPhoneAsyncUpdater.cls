/******************************************************
 * @Name             : ContactPrimaryPhoneAsyncUpdater.cls
 * @Description      : Contains async method for ContactTriggerHandler.cls
 * @Created By       : Eren Kırnak
 * @Created Date     : Oct 13, 2022
 * @Modification Log :
 *******************************************************/
public with sharing class ContactPrimaryPhoneAsyncUpdater {
    /******************************************************
     * @Name             : updatePrimaryPhoneOfAccount
     * @Description      : Async method that updates all the contacts belonging to given account's Primary_Contact_Phone field
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     *******************************************************/
    @future
    public static void updatePrimaryPhoneOfAccount(
      Map<Id, String> accPrimPhoneMap
    ) {
      List<Contact> contacts;
      try {
        contacts = [
          SELECT Id, AccountId, Primary_Contact_Phone__c
          FROM Contact
          WHERE AccountId IN :accPrimPhoneMap.keySet()
        ];
      } catch (QueryException e) {
        throw new HandledException(e.getMessage());
      }

      for (Contact cnt : contacts) {
        cnt.Primary_Contact_Phone__c = accPrimPhoneMap.get(cnt.AccountId);
      }

      try {
        Database.update(contacts, false);
      } catch (DmlException e) {
        throw new HandledException(e.getMessage());
      }
    }
}
