public with sharing class AccountWeatherExtension {
    private final Account acc;
    private OpenWeatherWrapper wrapper;

    public AccountWeatherExtension(ApexPages.StandardController stdController) {

        this.acc = (Account)stdController.getRecord();
        updateWeather();
    }

    public void updateWeather() {

        this.wrapper = OpenWeatherChecker.checkCurrentWeather(acc.BillingCity);
    }

    public String getWeatherDescription () {

        return this.wrapper.Weather[0].description;
    }

    public String getTemperature() {

        return String.valueOf((this.wrapper.Main.temp - 273.15).intValue());
    }

    public String getWeatherIconUrl() {

        return 'http://openweathermap.org/img/wn/' + this.wrapper.Weather[0].icon + '.png';
    }
}
