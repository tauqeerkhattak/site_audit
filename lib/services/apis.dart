class Api {
  //https://securesiteauditbe01.com/site_audit/public/api/engineer/login
  // static String middleware = "/site_audit/api";
  static String middleware = '/site_audit/api';
  static String login = "$middleware/engineer/login";
  static String updateDetails = "$middleware/engineer/update/details";
  static String siteDetails = "$middleware/get/project/site/";
  static String postDetails = "$middleware/store/site/details";
  static String physicalType = '$middleware/get/physical_type/details/';
  static String weatherType = '$middleware/get/weather_details/details/';
  static String getModules = '$middleware/project/modules/';
  static String getForms = '$middleware/module/form/';
  static String postFile = '$middleware/post/file';
  static String postJson = '$middleware/post/json';
}
