@IsTest
public with sharing class OpenWeatherCheckerTest {
  @IsTest
  static void testCurrentWeather() {
    Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());

    Test.startTest();
    OpenWeatherWrapper wrapper = OpenWeatherChecker.checkCurrentWeather(
      'istanbul'
    );
    Test.stopTest();

    // Verify that the response received contains fake values
    System.assertEquals('Clear', wrapper.weather.get(0).main);
    System.assertEquals('clear sky', wrapper.weather.get(0).description);
  }
}
