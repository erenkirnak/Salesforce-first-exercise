@IsTest
public with sharing class PrimaryContactsExtensionTest {
    private static PrimaryContactsExtension ext;

    private static void initData(String actionToDo) {
      switch on actionToDo {
        when 'Test With Contact' {
          Account accWithContact = new Account(Name = 'Test w/ Contact');
          insert accWithContact;

          List<Contact> testContacts = new List<Contact>();
          for (Integer i = 0; i < 500; i++) {
            testContacts.add(
              new Contact(
                LastName = 'primcontacttest' + i,
                Salutation = 'Ms.',
                AccountId = accWithContact.Id
              )
            );
          }
          testContacts[0].Is_Primary_Contact__c = true;

          insert testContacts;

          PageReference testPage = Page.AccountDetailPage;
          Test.setCurrentPage(testPage);
          testPage.getParameters().put('Id', String.valueOf(accWithContact.Id));

          ApexPages.StandardController sc = new ApexPages.StandardController(
            accWithContact
          );
          ext = new PrimaryContactsExtension(sc);
          ext.primContactId = testContacts[100].Id;
        }
        when 'Test No Contact' {
          Account accWithoutContact = new Account(Name = 'Test No Contact');
          insert accWithoutContact;

          Contact someContact = new Contact(LastName = 'throwaway');
          insert someContact;

          PageReference testPage = Page.AccountDetailPage;
          Test.setCurrentPage(testPage);
          testPage.getParameters()
            .put('Id', String.valueOf(accWithoutContact.Id));

          ApexPages.StandardController sc = new ApexPages.StandardController(
            accWithoutContact
          );
          ext = new PrimaryContactsExtension(sc);
          ext.primContactId = someContact.Id;
        }
      }
    }

    @IsTest
    static void testContactDoesntBelong() {
      initData('Test No Contact');

      Test.startTest();
      IllegalArgumentException thrown;
      try {
        ext.setPrimaryContact();
      } catch (IllegalArgumentException e) {
        thrown = e;
      }
      Test.stopTest();

      System.assertEquals(
        'Given contact does not belong to this account.',
        thrown.getMessage()
      );
    }

    @IsTest
    static void testContactDoesntExist() {
      initData('Test With Contact');

      ext.primContactId = 'SOMERANDOMTXT';

      NoSuchElementException thrown;
      Test.startTest();
      try {
        ext.setPrimaryContact();
      } catch (NoSuchElementException e) {
        thrown = e;
      }
      Test.stopTest();

      System.assertEquals(
        'No contact exist with the given id.',
        thrown.getMessage()
      );
    }

    @IsTest
    static void testPrimContactSet() {
      initData('Test With Contact');

      Test.startTest();
      ext.setPrimaryContact();
      Test.stopTest();

      for (Contact contact : [
        SELECT Id, Is_Primary_Contact__c
        FROM Contact
        WHERE LastName LIKE 'primcontacttest%'
      ]) {
        if (contact.Id != ext.primContactId) {
          System.assertEquals(false, contact.Is_Primary_Contact__c);
        } else {
          System.assertEquals(true, contact.Is_Primary_Contact__c);
        }
      }
    }

    @IsTest
    static void testGetRelatedContacts() {
      initData('Test With Contact');

      ext.searchVar = 'primcontacttest10';

      Test.startTest();
      List<Contact> results = ext.getRelatedContacts();
      Test.stopTest();

      System.assertEquals(11, results.size());
    }
}
