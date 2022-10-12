public with sharing class ContactPrimaryPhoneAsyncUpdater {
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
