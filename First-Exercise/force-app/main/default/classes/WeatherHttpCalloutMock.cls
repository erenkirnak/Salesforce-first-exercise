@IsTest
global class WeatherHttpCalloutMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    // Create a fake response

    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody(
      '{\"coord\":{\"lon\":28.9833,\"lat\":41.0351},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"clear sky\",\"icon\":\"01n\"}],\"base\":\"stations\",\"main\":{\"temp\":295.74,\"feels_like\":296.09,\"temp_min\":293.19,\"temp_max\":295.83,\"pressure\":1008,\"humidity\":78},\"visibility\":10000,\"wind\":{\"speed\":3.09,\"deg\":180},\"clouds\":{\"all\":0},\"dt\":1664395911,\"sys\":{\"type\":1,\"id\":6970,\"country\":\"TR\",\"sunrise\":1664337432,\"sunset\":1664380339},\"timezone\":10800,\"id\":745042,\"name\":\"Istanbul\",\"cod\":200}"}'
    );
    response.setStatusCode(200);
    return response;
  }
}
