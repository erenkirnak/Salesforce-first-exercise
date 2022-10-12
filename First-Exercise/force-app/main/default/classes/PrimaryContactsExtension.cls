public with sharing class PrimaryContactsExtension {
  private final Account acct;
  public String searchVar { get; set; }
  public boolean displayPopup { get; set; }
  public String primContactId { get; set; }

  public PrimaryContactsExtension(ApexPages.StandardController stdController) {
    this.acct = (Account) stdController.getRecord();
  }

  public List<Contact> getRelatedContacts() {
    try {
      if (searchVar == null || searchVar == '') {
        return [
          SELECT Id, Name, Title, Phone, Is_Primary_Contact__c
          FROM Contact
          WHERE AccountId = :acct.Id
        ];
      } else {
        String escapedString = string.escapeSingleQuotes(searchVar);
        escapedString = '%' + escapedString + '%';
        return [
          SELECT Id, Name, Title, Phone, Is_Primary_Contact__c
          FROM Contact
          WHERE AccountId = :acct.Id AND Name LIKE :escapedString
        ];
      }
    } catch (QueryException e) {
      throw new HandledException(e.getMessage());
    }
  }
  public void setPrimaryContact() {
    closePopup();
    Contact primContact = getPrimContact();

    List<Contact> contactsToUpdate = new List<Contact>();
    try {
      for (Contact contact : [
        SELECT Id, Is_Primary_Contact__c
        FROM Contact
        WHERE AccountId = :acct.Id AND Is_Primary_Contact__c = TRUE
      ]) {
        contact.Is_Primary_Contact__c = false;
        contactsToUpdate.add(contact);
      }
    } catch (QueryException e) {
      throw new HandledException(e.getMessage());
    }
    primContact.Is_Primary_Contact__c = true;

    try {
      update contactsToUpdate;
      update primContact;
    } catch (DmlException e) {
      throw new HandledException(e.getMessage());
    }
  }

  private Contact getPrimContact() {
    Contact primContact = null;
    try {
      primContact = [
        SELECT Id, AccountId, Is_Primary_Contact__c
        FROM Contact
        WHERE Id = :primContactId
        LIMIT 1
      ];
    } catch (QueryException e) {
      throw new NoSuchElementException('No contact exist with the given id.');
    }

    if (primContact.AccountId != acct.Id) {
      throw new IllegalArgumentException(
        'Given contact does not belong to this account.'
      );
    }

    return primContact;
  }

  public void closePopup() {
    displayPopup = false;
  }

  public void showPopup() {
    displayPopup = true;
  }
}
