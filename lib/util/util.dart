class Util {
  //URL Production
  static const BASE_URL = "URL PRODUCTION";

  //URL Development/Staging
  static const BASE_DEVELOPMENT_URL = "http://35.240.205.140:3000";
  static const BASE_DEVELOPMENT_URL_PORT ="http://35.240.205.140:6000";


  //Post Endpoint
  static const ENDPOINT_AUTH_LOGIN = "/auth/login";
  static const ENDPOINT_AUTH_REGISTER  = '/auth/register';
  static const ENDPOINT_AUTH_FORGOTPASSWORD = '/auth/forgotPassword';
  static const ENDPOINT_AUTH_RESETPASSWORD = '/auth/resetPassword';

  //Get EndPoint
  static const ENDPOINT_API_COLOR = "/api/colour";
  static const ENDPOINT_API_PRODUCT ='api/product';
  static const ENDPOINT_API_PRODUCTYPE= '/api/productType';
  static const ENDPOINT_API_USER = '/api/user';
  static const ENDPOINT_API_PRODUCTSEARCH ='/api/productSearch';
  static const ENDPOINT_API_PRODUCTSEARCH_BY_OBJECT ='api/productSearchByObject';

  //Menu
  static const String history = "History";
  static const String setting = "Setting";
  static const String logout = "Logout";
  static const String goodInbound = "Good Inbound";
  static const String putaway = "Putaway Process";
  static const String goodInboundImage = "assets/images/gdin.svg";
  static const String storeMallImage = "assets/images/storemall.svg";

  //ASCERO Logo

  // UI String 
  static const String appName = "BeMe";
  static const String appDescription = "Your personal makeup assistant";

  //Onboarding 
  static const String onboardingOneTitle = "Beautified Me";
  static const String onboardingOneDesc = "Pamper yourself with our AI & AR technology tailored  your specific makeup and filter";  

  static const String onboardingTwoTitle = "Adjust Facial Contours";
  static const String onboardingTwoDesc = "Satisfy your skin's unique cravings with our platform that works for you";

  static const String onboardingThreeTitle =  "Realistic Makeup Filter";
  static const String onboardingThreeDesc = "Switch different looks and products including lipstick, mascara, blush & more";

  static const String username = "Username";
  static const String password = "Password";
  static const String continueButton = "NEXT";
  static const String backButton = "BACK";
  static const String signIn = "SIGN IN";
  static const String register = "REGISTER"; 
  static const String login_with_facebook = "LOGIN WITH FACEBOOK";
  static const String ok = "Ok";
  static const String cancel = "Cancel";
  static const String yes = "Yes";
  static const String no = "No";
  static const String forget_password = "Forget Password ?";
  static const String password_error = "Please Enter the Password";
  static const String login_error ="Invalid username and/or password";
  static const String network_error = "No Internet Connection";
  static const String network_good = "Back Online";
  static const String email = 'E-mail Address';
  static const String forget_password_title = "Please Type your Current UserName and Email. We will send temporary password to your email address.";
  static const String current_password = "Current Password";
  static const String new_password = "New Password";
  static const String new_password_again = "Confirm New Password";
  static const String forget_password_button = "Recover Password";
  static const String loading = "Loading";
  static const String please_try_again = "Please enter your credential and Try Again";
  static const String congrutulation = "Congratulation";
  static const String message_activation = "Please enter your email for account activation";
  static const String message_already = "Either this email has already been registered or Username is already Taken. Please try again.";
  static const String empty_username = "Username cannot be empty";
  static const String emtpty_useremail = "Email Address cannot be empty";
  static const String empty_password ="Password cannot be empty";
  static const String current_username_email = "Couldnt find username and email address. Please Register your account";
  static const String get_profile_data = "ProfileData";
  static const String profile = "Profile";
  static const String update_profile = "Update Profile";
  static const String edit_profile = "Edit Profile";
  static const String make_up = "Make Up";
  static const String tone = "Tones";

  //Menu 
  static const String home = "Home";
  static const String see_profile =  "See profile";
  static const String privacy_settings = "Privacy Settings";
  static const String about = "About";

  
  //Profile 
  static const String profile_name = "Name";
  static const String profile_email = "Email";
  static const String profile_age = "Age";
  static const String profile_address_one = "Address 1";
  static const String profile_address_two = "Address 2";
  static const String profile_phone =" Phone Number";
  static const String profile_gender = "Gender";
  static const String profile_gender_male = "Male";
  static const String profile_gender_female ="Female";

  //error
  static const String unknown = "Unknown error";
  static const String projectCodeError = "Failed to get platform version.";
  static const String login_error_title = "Opps...";
  static const String success_title = "Yay!";
  static const String login_error_description = "Invalid Username/Password or If you registered succesfful, Account May Not activated. Please activate your account..";
  static const String alert_title = "Are you sure?";
  static const String alert_desc = "Do you want to exit an App";
  static const String default_tap_activity_scan = "Tap here to start the Scan Your facial";
  static const String already_signin = "Logout Facebook";


  //Dimens
  static const double bemeSize = 50.0;
  static const double bemeSubSize = 15.0;
  static const double bemeTextSize = 17.0;
  static const double bemeTabTextSize = 16.0;
  static const int bemeSplash = 5;
  static const double asceroWelcomeTextSize = 30.0;
  static const double letterSpacing = 2.0;
  static const double blurRadius = 0.5;


  //Token
  static const String token = 'token';
  static const String authId = 'id';
  static const String companyInfo = 'company-info';
  static const String floorInfo = 'floor-info';
  static const String staffcode = 'staffCode';
  static const String staffname = 'staffName';

  //Fonts
  static const String BemeLogo = 'DancingScript-Regular';
  static const String BemeRegular = 'AvenirNextLTProRegular';
  static const String BemeBold = 'AvernirNextLTProBoldCN';
  static const String BemeTextRegular = 'UbuntuRegular';
  static const String BemeMediumRegular = 'UbuntuMedium';
  static const String BemeMediumItalic = 'UbuntuMediumItalic';
  static const String BemeLight = 'UbuntuLight';

  //Color
  static const int blue = 0xff0000ff;
  static const int red = 0xffff0000;
  static const int black = 0xff000000;
  static const int white = 0xffffffff;
  static const int transparent = 0x00000000;
  static const int green = 0xff00ff00;
  static const int grey = 0xff888888;
  static const int white30 = 0xffe2e2e2;
  static const int white57 = 0xFF6E6E6E;
  static const int purple = 0xFF3A007C;
  
  //Theme Color
  static const int main_default_primary = 0xFFF5CFCD;
  static const int main_default_secondary = 0xFF00C853;


  
}