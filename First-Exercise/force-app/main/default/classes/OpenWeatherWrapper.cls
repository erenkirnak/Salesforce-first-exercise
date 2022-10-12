public with sharing class OpenWeatherWrapper {
  public class Weather {
    public Integer id;
    public String main;
    public String description; //display
    public String icon; //display
  }

  public class Coord {
    public Double lon;
    public Double lat;
  }

  public class Wind {
    public Double speed;
    public Integer deg;
  }

  public Coord coord;
  public List<Weather> weather;
  public String base;
  public Main main;
  public Integer visibility;
  public Wind wind;
  public Clouds clouds;
  public Integer dt;
  public Sys sys;
  public Integer timezone;
  public Integer id;
  public String name;
  public Integer cod;

  public class Clouds {
    public Integer all;
  }

  public class Sys {
    public Integer type;
    public Integer id;
    public String country;
    public Integer sunrise;
    public Integer sunset;
  }

  public class Main {
    public Double temp; //display
    public Double feels_like;
    public Double temp_min;
    public Double temp_max;
    public Integer pressure;
    public Integer humidity;
  }

  public static OpenWeatherWrapper parse(String json) {
    return (OpenWeatherWrapper) System.JSON.deserialize(
      json,
      OpenWeatherWrapper.class
    );
  }
}
