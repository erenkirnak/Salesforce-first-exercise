/******************************************************
 * @Name             : PrimaryContactsExtension.cls
 * @Description      : Extension for Standard Account Controller that provides popup, search
 * @Created By       : Eren Kırnak
 * @Created Date     : Oct 13, 2022
 * @Modification Log :
 *******************************************************/
public with sharing class PrimaryContactsExtension {
    private final Account acct;
    public String searchVar { get; set; }
    public boolean displayPopup { get; set; }
    public String primContactId { get; set; }

    /******************************************************
     * @Name             : PrimaryContactsExtension
     * @Description      : Constructor of class to initialze StandardController and acct
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param ApexPages.StandardController stdController
     *******************************************************/
    public PrimaryContactsExtension(ApexPages.StandardController stdController) {
      this.acct = (Account) stdController.getRecord();
    }

    /******************************************************
     * @Name             : getRelatedContacts
     * @Description      : Search mechanism that can be used by Visualforce Pages.
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Return List<Contact> related Contacts
     *******************************************************/
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

    /******************************************************
     * @Name             : setPrimaryContact
     * @Description      : Sets the current accounts PrimaryContact to given Contact
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     *******************************************************/
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

        primContact.Is_Primary_Contact__c = true;
        contactsToUpdate.add(primContact);
      } catch (QueryException e) {
        throw new HandledException(e.getMessage());
      }

      try {
        update contactsToUpdate;
      } catch (DmlException e) {
        throw new HandledException(e.getMessage());
      }
    }

    /******************************************************
     * @Name             : getPrimContact
     * @Description      : Helper function that validates the given primary contact.
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Return Contact return selected contact to be primary
     *******************************************************/
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
          System.Label.Not_Belong_Account
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
