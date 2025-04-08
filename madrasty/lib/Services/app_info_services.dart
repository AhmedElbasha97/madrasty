import '../Models/country_code_model.dart';
import '../Models/social_media_linnks_model.dart';
import '../Models/terms_and_privacy_model.dart';
import '../Utils/api_service.dart';
import '../Utils/services.dart';

class AppInfoServices{
  static ApiService api = ApiService();
  static Future<List<CountryCodeModel>?>getSchoolsList() async {
    List<CountryCodeModel>? countriesCodesList = [];
    var data = await api.request(Services.countriesCodesEndPoint, "POST",queryParamters: {
    });
    if (data != null) {
      for(var countryCodeData  in data){
        countriesCodesList.add(CountryCodeModel.fromJson(countryCodeData));
      }
      return countriesCodesList;
    }
    return null;
  }
  static Future<TermsAndPrivacyModel?>getTermsAndConditions() async {

    var data = await api.request(Services.getTermsAndConditionsEndPoint, "POST");
    if (data != null) {
      return TermsAndPrivacyModel.fromJson(data[0]);
    }
    return null;
  }
  static Future<TermsAndPrivacyModel?>getPrivacyPolicy() async {

    var data = await api.request(Services.getPrivacyPolicyEndPoint, "POST");
    if (data != null) {
      return TermsAndPrivacyModel.fromJson(data[0]);
    }
    return null;
  }
  static Future<SocialMediaLinksModel?>getSocialMediaLinks() async {

    var data = await api.request(Services.getSocialMediaLinksEndPoint, "POST");
    if (data != null) {
      return SocialMediaLinksModel.fromJson(data[0]);
    }
    return null;
  }

}