abstract class AppConstants {
  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Tables
  static const String usersTable = 'users';
  static const String factoriesTable = 'factories';
  static const String requestsTable = 'requests';
  static const String offersTable = 'offers';

  // Storage buckets
  static const String requestImagesBucket = 'request-images';
  static const String factoryImagesBucket = 'factory-images';

  // Market price ranges (EGP / piece) — MVP static data
  static const Map<String, Map<String, dynamic>> marketPriceRanges = {
    'تيشيرت': {'min': 35, 'max': 55, 'rangeStr': '35–55 ج'},
    'جينز': {'min': 60, 'max': 95, 'rangeStr': '60–95 ج'},
    'فستان': {'min': 70, 'max': 120, 'rangeStr': '70–120 ج'},
    'هوودي': {'min': 45, 'max': 80, 'rangeStr': '45–80 ج'},
    'سبور': {'min': 40, 'max': 70, 'rangeStr': '40–70 ج'},
    'أخرى': {'min': 35, 'max': 80, 'rangeStr': '35–80 ج'},
  };

  // Product types
  static const List<Map<String, String>> productTypes = [
    {'label': 'تيشيرت', 'emoji': '👕'},
    {'label': 'جينز', 'emoji': '👖'},
    {'label': 'فستان', 'emoji': '👗'},
    {'label': 'هوودي', 'emoji': '🧥'},
    {'label': 'سبور', 'emoji': '🩳'},
    {'label': 'أخرى', 'emoji': '📦'},
  ];

  // Material types
  static const List<String> materialTypes = [
    'مش محدد',
    'قطن 100%',
    'بوليستر',
    'ليكرا',
    'بوليستر+قطن',
  ];

  // Cities
  static const List<String> egyptCities = [
    'القاهرة',
    'الإسكندرية',
    'الجيزة',
    'المنصورة',
    'الإسماعيلية',
    'بورسعيد',
    'طنطا',
    'الفيوم',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'أسوان',
    'الأقصر',
    'أخرى',
  ];

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;

  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusPill = 100.0;

  // UI
  static const double navBarHeight = 60.0;
  static const double buttonHeight = 50.0;
  static const double buttonHeightSm = 40.0;
  static const double inputHeight = 50.0;

  // Pagination
  static const int pageSize = 20;
}
