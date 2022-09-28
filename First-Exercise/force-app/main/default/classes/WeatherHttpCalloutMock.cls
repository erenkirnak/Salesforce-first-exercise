@IsTest
global class WeatherHttpCalloutMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    // Create a fake response

    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody(System.Label.OpenWeather_HttpCalloutMock);
    response.setStatusCode(200);
    return response;
  }
}
