/******************************************************
 * @Name             : OpenWeatherChecker.cls
 * @Description      : Invokes OpenWeather API to receive weather condition
 * @Created By       : Eren Kırnak
 * @Created Date     : Oct 13, 2022
 * @Modification Log :
 *******************************************************/
public with sharing class OpenWeatherChecker {
    //Created custom label for security and reusability
    private static String API_KEY = System.Label.OpenWeather_API_Key;
    private static String ENDPOINT = System.Label.OpenWeather_EndPoint;

    /******************************************************
     * @Name             : checkCurrentWeather
     * @Description      : Retrieves the current weather condition of the given city from openweathermap api
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param String Billing City Name
     *******************************************************/
    //Retrieves the current weather condition of the given city from openweathermap api
    public static OpenWeatherWrapper checkCurrentWeather(String cityName) {
      if (String.isBlank(cityName)) {
        throw new HandledException(System.Label.CityName_Null);
      }

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(ENDPOINT + cityName + '&appid=' + API_KEY);
      request.setMethod('GET');
      HttpResponse response;
      try {
        response = http.send(request);
      } catch (CalloutException e) {
        throw new HandledException(e.getMessage());
      }

      // If the request is successful, parse the JSON response.
      if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
        // Deserialize the JSON string into collections of primitive data types.
        return OpenWeatherWrapper.parse(response.getBody());
      } else if (
        response.getStatusCode() >= 400 &&
        response.getStatusCode() < 500
      ) {
        throw new HandledException(System.Label.City_Not_Found);
      } else {
        throw new HandledException(System.Label.Current_Weather_Error);
      }
    }
}
