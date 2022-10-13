@IsTest
public with sharing class AccountWeatherExtensionTest {
    private static ApexPages.StandardController sc;

    private static void initData() {
      Account act = new Account(
        Name = 'ExtensionTestAcc',
        BillingCity = 'Istanbul'
      );
      insert act;

      sc = new ApexPages.StandardController(act);
    }

    @IsTest
    static void testExtensionVariables() {
      initData();

      Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());

      Test.startTest();
      accountWeatherExtension ext = new accountWeatherExtension(sc);
      Test.stopTest();

      System.assertEquals('clear sky', ext.getWeatherDescription());
      System.assertEquals('295.74', ext.getTemperature());
      System.assertEquals(
        'http://openweathermap.org/img/wn/01n.png',
        ext.getWeatherIconUrl()
      );
    }
}
