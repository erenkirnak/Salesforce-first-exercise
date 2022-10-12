// Extension for Standard Account Controller that provides popup, search
public with sharing class PrimaryContactsExtension {
  private final Account acct;
  public String searchVar { get; set; }
  public boolean displayPopup { get; set; }
  public String primContactId { get; set; }

  // Constructor of class to initialze StandardController and acct
  public PrimaryContactsExtension(ApexPages.StandardController stdController) {
    this.acct = (Account) stdController.getRecord();
  }

  // Search mechanism that can be used by Visualforce Pages.
  public List<Contact> getRelatedContacts() {
    try {
      if (String.isBlank(searchVar)) {
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
  // Sets the current accounts PrimaryContact to given Contact
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

  // Helper function that validates the given primary contact.
  private Contact getPrimContact() {
    Contact primContact;
    try {
      primContact = [
        SELECT Id, AccountId, Is_Primary_Contact__c
        FROM Contact
        WHERE Id = :primContactId
        LIMIT 1
      ];
    } catch (QueryException e) {
      throw new NoSuchElementException(System.Label.NoSuchElement);
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
