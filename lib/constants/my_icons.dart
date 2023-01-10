import 'package:deep_conference/constants/schedule_item_categories.dart';

class MyIcons {
  static final Map<String, String> categoryIcons = {
    'all': 'images/icons/all.png',
    'lead': 'images/icons/lead.png',
    'ops': 'images/icons/ops.png',
    'tech': 'images/icons/tech.png',
  };

  static String? getCategoryIcon(ScheduleItemCategory category) {
    String categoryName = category.name;

    return categoryIcons[categoryName];
  }

  static const String qrIcon = 'images/icons/qr_icon.png';
  static const String detailsBackground = 'images/background_details.png';
  static const String googleIcon = 'images/icons/google_icon.png';
  static const String loginLogo = 'images/icons/login_logo.png';
  static const String appIcon = 'images/icons/app_icon.png';
  static const String authBackground = 'images/backgrounds/background-cropped.jpg';
  static const String appBarBackground = 'images/backgrounds/appbar_fade_background.png';
  static const String profileScreenQrBackground = 'images/backgrounds/profile_screen_qr_background.png';
  static const String editProfileBackground = 'images/backgrounds/edit_profile_background.png';
  static const String nfcIcon = 'images/icons/nfc.png';
  static const String nfcSharing = 'images/nfc_sharing.png';
}
