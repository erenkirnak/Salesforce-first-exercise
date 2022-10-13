/******************************************************
 * @Name             : AccountWeatherExtension.cls
 * @Description      : Extension for AccountWeatherPage
 * @Created By       : Eren Kırnak
 * @Created Date     : Oct 13, 2022
 * @Modification Log :
 *******************************************************/
public with sharing class AccountWeatherExtension {
    private final Account acc;
    private OpenWeatherWrapper wrapper;

    /******************************************************
     * @Name             : AccountWeatherExtension
     * @Description      : Constructor of class to initialze StandardController and acc
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Param ApexPages.StandardController StandartController reference
     *******************************************************/
    public AccountWeatherExtension(ApexPages.StandardController stdController) {
      this.acc = (Account) stdController.getRecord();
      updateWeather();
    }

    /******************************************************
     * @Name             : updateWeather
     * @Description      : Updates the weather info
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     *******************************************************/
    public void updateWeather() {
      this.wrapper = OpenWeatherChecker.checkCurrentWeather(acc.BillingCity);
    }

    /******************************************************
     * @Name             : getWeatherDescription
     * @Description      : Gets the weather description of account's billing city
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Return String Description of weather
     *******************************************************/
    public String getWeatherDescription() {
      return this.wrapper.Weather[0].description;
    }

    /******************************************************
     * @Name             : getTemperature
     * @Description      : Gets the weather description of account's billing city
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Return String Temperature info of weather
     *******************************************************/
    public String getTemperature() {
      return String.valueOf(this.wrapper.Main.temp);
    }

    /******************************************************
     * @Name             : getWeatherDescription
     * @Description      : Gets the weather description of account's billing city
     * @Created By       : Eren Kırnak
     * @Created Date     : Oct 13, 2022
     * @Return String Icon Url
     *******************************************************/
    public String getWeatherIconUrl() {
      return System.Label.Weather_Icon_URL +
        this.wrapper.Weather[0].icon +
        '.png';
    }
}
