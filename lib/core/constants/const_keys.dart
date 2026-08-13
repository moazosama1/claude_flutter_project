abstract final class ConstKeys {
  static const String kUserLogin = "user_login";
  static const String kUserPassword = "user_password";
  static const String kRememberMe = "remember_me";
  static const String kUserGuest = "user_guest";
  static const String kUserToken = "user_token";
  static const String kRefreshToken = "refresh_token";
  static const String kNoToken = "no_token";
  static const String kUserStatus = "user_status";
  static const String kUserProfile = "user_profile";
  static const String kLocale = "locale";
  static const String robotFont = "Roboto";
  static const String outfitFont = "Outfit";
  static const String cairoFont = "Cairo";
  static const String interFont = "Inter";
  static const String plusJakartaSansFont = "PlusJakartaSans";
  static const String englishLangCode = "en";
  static const String appDB = "app_db";
  static const String kVisaDiscount = "visa_discount";
  // Visa discount keys for both testing and production databases
  static const String kVisaFeeRateProd = "visa_discount_rate";
  static const String kVisaFeeRateTest = "visa_fee_rate";
  static const String kLastSalesSync = "last_sales_sync";
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDesc =
      'This channel is used for important notifications.';

  // TODO: Supabase excluded from this project. Placeholder kept so the
  // AuthInterceptor (Supabase-shaped, currently unwired) compiles. Populate if
  // a Supabase-compatible backend is added later.
  static const String supabaseAnonKey = "";

  // // Roles
  static const String roleAdmin = "admin";
  static const String roleStaff = "staff";

  static const String kCash = 'Cash';
  static const String kVisa = 'Visa';
  static const String kInstapay = 'instapay';
  static const String kVodafone = 'vodafone';
  static const String kIsFirstRun = 'is_first_run';
  static const String kThemeMode = 'theme_mode';   // stored ThemeMode.name
  static const String kCurrency = 'currency_code'; // ISO-4217 code, e.g. 'USD'
  static const String kLitigationSupplierName = 'استقضاء و ورش نحاس';
  static const String kSavedEmails = 'saved_emails';
}
