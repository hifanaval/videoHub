class ApiUrls {
static String baseUrl = 'https://frijo.noviindus.in/api/';

 
  static String verifyMobile() {
    return '${baseUrl}otp_verified';
  }

  static String getHomeData() {
    return '${baseUrl}home';
  }

  static String getCategoryData() {
    return '${baseUrl}category_list';
  }

  static String postFeedData() {
    return '${baseUrl}my_feed';
  }
}