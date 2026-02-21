import 'package:flutter/material.dart';

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations('en');
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'app_name': 'HydroSmart',

      // Greetings
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'good_night': 'Good Night',

      // Navigation
      'nav_home': 'Home',
      'nav_ai_chat': 'AI Chat',
      'nav_settings': 'Settings',
      'log_reading': 'Log Reading',

      // Dashboard
      'weekly_progress': 'Weekly Progress',
      'monthly_progress': 'Monthly Progress',
      'status_on_track': 'Status: On Track ✅',
      'status_over_limit': 'Over Limit! ⚠️',
      'daily_usage': 'Daily Usage (Last 7 Days)',
      'liters': 'Liters',
      'leak_status': 'Leak Status',
      'daily_avg': 'Daily Avg',
      'secure': 'Secure',
      'alert': 'ALERT',
      'off': 'OFF',
      'points': 'points',
      'day_streak': 'day streak',

      // Achievements
      'achievements': 'Achievements',
      'total_points': 'Total Points',
      'unlocked': 'Unlocked',
      'water_warrior': 'Water Warrior',
      'water_warrior_desc': 'Complete your first week',
      'drop_by_drop': 'Drop by Drop',
      'drop_by_drop_desc': 'Save 100L total',
      'consistency_king': 'Consistency King',
      'consistency_king_desc': 'Maintain a 30-day streak',
      'eco_hero': 'Eco Hero',
      'eco_hero_desc': 'Save 1000L total',
      'hot_streak': 'Hot Streak',
      'hot_streak_desc': 'Stay under goal for 7 days',
      'perfect_week': 'Perfect Week',
      'perfect_week_desc': 'Every day under daily target',
      'leak_detective': 'Leak Detective',
      'leak_detective_desc': 'Detect your first leak',
      'ai_friend': 'AI Friend',
      'ai_friend_desc': 'Have 50 AI conversations',
      'unlocked_on': 'Unlocked',

      // Profile
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'full_name': 'Full Name',
      'email_address': 'Email Address',
      'family_size': 'Family Size',
      'phone_number': 'Phone Number',
      'save': 'Save',
      'cancel': 'Cancel',
      'saved': 'Saved',
      'member_since': 'Member Since',
      'profile_updated': 'Profile updated successfully!',

      // Settings
      'settings': 'Settings',
      'preferences': 'Preferences',
      'water_tracking': 'Water Tracking',
      'household_members': 'Household Members',
      'challenge_management': 'Challenge Management',
      'weekly_goal': 'Weekly Goal',
      'adjust_goal': 'Adjust your weekly water usage goal',
      'leak_detection': 'Leak Detection',
      'notifications': 'Notifications',
      'daily_usage_reminders': 'Daily Usage Reminders',
      'goal_achievement_alerts': 'Goal Achievement Alerts',
      'leak_alerts': 'Leak Alerts',
      'vacation_mode_alerts': 'Vacation Mode Alerts',
      'language': 'Language',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'account': 'Account',
      'logout': 'Logout',
      'about': 'About',
      'app_version': 'App Version',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'logout_confirm': 'Are you sure you want to logout?',
      'yes': 'Yes',
      'no': 'No',

      // Auth
      'login': 'Login',
      'signup': 'Sign Up',
      'create_account': 'Create Account',
      'already_have_account': 'Already have an account? Login',
      'dont_have_account': "Don't have an account? Sign Up",
      'join_hydrosmart': 'Join HydroSmart and start saving water today',
      'password': 'Password',
      'create_strong_password': 'Create a strong password',
      'family_size_hint': 'Number of family members',
      'phone_hint': '+1 234 567 8900',
      'phone_optional': 'Phone Number (Optional)',

      // Validation
      'name_required': 'Name is required',
      'name_min_length': 'Name must be at least 2 characters',
      'name_invalid': 'Name must contain only Arabic or only Latin letters and single spaces (no mixing)',
      'email_required': 'Email is required',
      'email_invalid': 'Please enter a valid email',
      'password_required': 'Password is required',
      'password_min_length': 'Password must be at least 8 characters',
      'password_uppercase': 'Password must contain at least one uppercase letter',
      'password_lowercase': 'Password must contain at least one lowercase letter',
      'password_number': 'Password must contain at least one number',
      'password_strength_weak': 'Weak',
      'password_strength_fair': 'Fair',
      'password_strength_good': 'Good',
      'password_strength_strong': 'Strong',
      'password_hint_text': 'Use 8+ characters with uppercase, lowercase, and numbers',
      'family_size_required': 'Family size is required',
      'family_size_invalid': 'Please enter a valid number',
      'family_size_range': 'Family size must be between 1 and 20',
      'phone_invalid': 'Please enter a valid phone number',

      // AI Assistant
      'ai_assistant': 'AI Assistant',
      'ask_something': 'Ask something...',
      'typing': 'Typing...',
      'ai_greeting': 'Hello! How can I help you save water today?',
      'ai_new_chat': 'New Chat',
      'ai_search_chats': 'Search chats...',
      'ai_no_chats_yet': 'No chats yet',
      'ai_no_results_found': 'No results found',
      'ai_new_session': 'New session. How can I help?',
      'today': 'Today',

      // Vacation Mode
      'vacation_mode': 'Vacation Mode?',
      'vacation_detected': 'We noticed zero usage for 3 consecutive days. Are you away? Would you like to pause your weekly goal tracking?',
      'enable': 'Enable',
      'im_here': "No, I'm here",
      'vacation_enabled': 'Vacation mode enabled',

      // Onboarding
      'onboarding_welcome_title': 'Welcome to HydroSmart',
      'onboarding_language_prompt': 'Choose your preferred language',
      'continue': 'Continue',
      // Onboarding – Name screen
      'onboarding_name_title': "What's your name?",
      'onboarding_name_subtitle': "Let's personalize your water-saving journey",
      'onboarding_name_hint': 'Enter your full name',
      'onboarding_name_rule_letters': 'Only Arabic or Latin letters and single spaces (no mixing)',
      'onboarding_name_rule_min_length': 'At least 2 characters',
      'onboarding_name_rule_no_spaces': 'No spaces at start or end',
      // Onboarding – Age screen
      'onboarding_age_greeting': 'Hi',
      'onboarding_age_title': "What's your age?",
      'onboarding_age_hint': 'Your age',
      // Onboarding – Household screen
      'onboarding_household_title': 'Tell us about your household',
      'onboarding_household_subtitle': 'This helps us estimate your water usage',
      'onboarding_household_size_question': 'How many people live in your household?',
      'onboarding_household_members_age_title': 'Age of other household members',
      'onboarding_household_member_age_label': 'Member {n} Age',
      // Onboarding – Meter screen
      'onboarding_meter_title': 'Set up your water meter',
      'onboarding_meter_subtitle': "We'll track your water usage to help you save",
      'onboarding_meter_reading_label': 'Current Meter Reading (m³)',
      'onboarding_meter_hint_text':
      "Find this number on your water meter. It's usually displayed in cubic meters (m³).",
      'onboarding_reminder_time_label': 'Daily Reminder Time',
      'onboarding_reminder_hint_text':
      "We'll remind you daily to record your water meter reading.",
      // Onboarding – Challenge screen
      'onboarding_challenge_title': 'Choose your challenge',
      'onboarding_challenge_subtitle': 'Start saving water with a personalized goal',
      'onboarding_challenge_weekly_title': 'Weekly Challenge',
      'onboarding_challenge_weekly_desc': '7-day water saving goal',
      'onboarding_challenge_weekly_duration': '1 week',
      'onboarding_challenge_monthly_title': 'Monthly Challenge',
      'onboarding_challenge_monthly_desc': '30-day water saving goal',
      'onboarding_challenge_monthly_duration': '1 month',
      'onboarding_challenge_progressive_title': 'Progressive Challenges',
      'onboarding_challenge_progressive_desc':
      'Each time you complete a challenge, your next goal will be slightly more ambitious, helping you save even more water!',
      'onboarding_challenge_start_btn': 'Start My Journey',
    },
    'ar': {
      // App
      'app_name': 'هيدروسمارت',

      // Greetings
      'good_morning': 'صباح الخير',
      'good_afternoon': 'مساء الخير',
      'good_evening': 'مساء الخير',
      'good_night': 'تصبح على خير',

      // Navigation
      'nav_home': 'الرئيسية',
      'nav_ai_chat': 'محادثة الذكاء',
      'nav_settings': 'الإعدادات',
      'log_reading': 'تسجيل القراءة',

      // Dashboard
      'weekly_progress': 'التقدم الأسبوعي',
      'monthly_progress': 'التقدم الشهري',
      'status_on_track': 'الحالة: على المسار الصحيح ✅',
      'status_over_limit': 'تجاوز الحد! ⚠️',
      'daily_usage': 'الاستخدام اليومي (آخر 7 أيام)',
      'liters': 'لتر',
      'leak_status': 'حالة التسرب',
      'daily_avg': 'المعدل اليومي',
      'secure': 'آمن',
      'alert': 'تنبيه',
      'off': 'متوقف',
      'points': 'نقاط',
      'day_streak': 'سلسلة أيام',

      // Achievements
      'achievements': 'الإنجازات',
      'total_points': 'مجموع النقاط',
      'unlocked': 'مفتوحة',
      'water_warrior': 'محارب المياه',
      'water_warrior_desc': 'أكمل أسبوعك الأول',
      'drop_by_drop': 'قطرة قطرة',
      'drop_by_drop_desc': 'وفر 100 لتر إجمالاً',
      'consistency_king': 'ملك الاتساق',
      'consistency_king_desc': 'حافظ على سلسلة 30 يوماً',
      'eco_hero': 'بطل البيئة',
      'eco_hero_desc': 'وفر 1000 لتر إجمالاً',
      'hot_streak': 'سلسلة ساخنة',
      'hot_streak_desc': 'ابق تحت الهدف لمدة 7 أيام',
      'perfect_week': 'أسبوع مثالي',
      'perfect_week_desc': 'كل يوم تحت الهدف اليومي',
      'leak_detective': 'محقق التسرب',
      'leak_detective_desc': 'اكتشف أول تسرب لك',
      'ai_friend': 'صديق الذكاء الاصطناعي',
      'ai_friend_desc': 'أجري 50 محادثة مع الذكاء الاصطناعي',
      'unlocked_on': 'فتحت في',

      // Profile
      'profile': 'الملف الشخصي',
      'edit_profile': 'تعديل الملف الشخصي',
      'full_name': 'الاسم الكامل',
      'email_address': 'عنوان البريد الإلكتروني',
      'family_size': 'حجم العائلة',
      'phone_number': 'رقم الهاتف',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'saved': 'تم الحفظ',
      'member_since': 'عضو منذ',
      'profile_updated': 'تم تحديث الملف الشخصي بنجاح!',

      // Settings
      'settings': 'الإعدادات',
      'preferences': 'التفضيلات',
      'water_tracking': 'تتبع المياه',
      'household_members': 'أفراد المنزل',
      'challenge_management': 'إدارة التحديات',
      'weekly_goal': 'الهدف الأسبوعي',
      'adjust_goal': 'اضبط هدف استخدام المياه الأسبوعي',
      'leak_detection': 'كشف التسرب',
      'notifications': 'الإشعارات',
      'daily_usage_reminders': 'تذكيرات الاستخدام اليومي',
      'goal_achievement_alerts': 'تنبيهات تحقيق الهدف',
      'leak_alerts': 'تنبيهات التسرب',
      'vacation_mode_alerts': 'تنبيهات وضع الإجازة',
      'language': 'اللغة',
      'appearance': 'المظهر',
      'dark_mode': 'الوضع الداكن',
      'account': 'الحساب',
      'logout': 'تسجيل الخروج',
      'about': 'حول',
      'app_version': 'إصدار التطبيق',
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_service': 'شروط الخدمة',
      'logout_confirm': 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
      'yes': 'نعم',
      'no': 'لا',

      // Auth
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'create_account': 'إنشاء حساب',
      'already_have_account': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'dont_have_account': 'ليس لديك حساب؟ إنشاء حساب',
      'join_hydrosmart': 'انضم إلى هيدروسمارت وابدأ توفير المياه اليوم',
      'password': 'كلمة المرور',
      'create_strong_password': 'أنشئ كلمة مرور قوية',
      'family_size_hint': 'عدد أفراد العائلة',
      'phone_hint': '+20 123 456 7890',
      'phone_optional': 'رقم الهاتف (اختياري)',

      // Validation
      'name_required': 'الاسم مطلوب',
      'name_min_length': 'يجب أن يكون الاسم على الأقل حرفين',
      'name_invalid': 'يجب أن يحتوي الاسم على أحرف عربية فقط أو لاتينية فقط ومسافات منفردة (لا خلط)',
      'email_required': 'البريد الإلكتروني مطلوب',
      'email_invalid': 'الرجاء إدخال بريد إلكتروني صحيح',
      'password_required': 'كلمة المرور مطلوبة',
      'password_min_length': 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
      'password_uppercase': 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل',
      'password_lowercase': 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل',
      'password_number': 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل',
      'password_strength_weak': 'ضعيفة',
      'password_strength_fair': 'مقبولة',
      'password_strength_good': 'جيدة',
      'password_strength_strong': 'قوية',
      'password_hint_text': 'استخدم 8+ أحرف مع أحرف كبيرة وصغيرة وأرقام',
      'family_size_required': 'حجم العائلة مطلوب',
      'family_size_invalid': 'الرجاء إدخال رقم صحيح',
      'family_size_range': 'يجب أن يكون حجم العائلة بين 1 و 20',
      'phone_invalid': 'الرجاء إدخال رقم هاتف صحيح',

      // AI Assistant
      'ai_assistant': 'مساعد الذكاء الاصطناعي',
      'ask_something': 'اسأل شيئاً...',
      'typing': 'يكتب...',
      'ai_greeting': 'مرحباً! كيف يمكنني مساعدتك في توفير المياه اليوم؟',
      'ai_new_chat': 'محادثة جديدة',
      'ai_search_chats': 'البحث في المحادثات...',
      'ai_no_chats_yet': 'لا توجد محادثات بعد',
      'ai_no_results_found': 'لم يتم العثور على نتائج',
      'ai_new_session': 'جلسة جديدة. كيف يمكنني المساعدة؟',
      'today': 'اليوم',

      // Vacation Mode
      'vacation_mode': 'وضع الإجازة؟',
      'vacation_detected': 'لاحظنا صفر استخدام لمدة 3 أيام متتالية. هل أنت بعيد؟ هل تريد إيقاف تتبع الهدف الأسبوعي؟',
      'enable': 'تفعيل',
      'im_here': 'لا، أنا هنا',
      'vacation_enabled': 'تم تفعيل وضع الإجازة',

      // Onboarding
      'onboarding_welcome_title': 'مرحباً بك في هيدروسمارت',
      'onboarding_language_prompt': 'اختر لغتك المفضلة',
      'continue': 'متابعة',
      // Onboarding – Name screen
      'onboarding_name_title': 'ما اسمك؟',
      'onboarding_name_subtitle': 'دعنا نخصص رحلة توفير المياه الخاصة بك',
      'onboarding_name_hint': 'أدخل اسمك الكامل',
      'onboarding_name_rule_letters': 'أحرف عربية أو لاتينية فقط ومسافات منفردة (لا خلط)',
      'onboarding_name_rule_min_length': 'حرفان على الأقل',
      'onboarding_name_rule_no_spaces': 'لا مسافات في البداية أو النهاية',
      // Onboarding – Age screen
      'onboarding_age_greeting': 'مرحباً',
      'onboarding_age_title': 'كم عمرك؟',
      'onboarding_age_hint': 'عمرك',
      // Onboarding – Household screen
      'onboarding_household_title': 'أخبرنا عن منزلك',
      'onboarding_household_subtitle': 'هذا يساعدنا في تقدير استهلاكك للمياه',
      'onboarding_household_size_question': 'كم عدد الأشخاص الذين يعيشون في منزلك؟',
      'onboarding_household_members_age_title': 'أعمار أفراد المنزل الآخرين',
      'onboarding_household_member_age_label': 'عمر العضو {n}',
      // Onboarding – Meter screen
      'onboarding_meter_title': 'إعداد عداد المياه',
      'onboarding_meter_subtitle': 'سنتتبع استهلاكك للمياه لمساعدتك على التوفير',
      'onboarding_meter_reading_label': 'قراءة العداد الحالية (م³)',
      'onboarding_meter_hint_text':
      'ابحث عن هذا الرقم على عداد المياه. عادةً ما يُعرض بالأمتار المكعبة (م³).',
      'onboarding_reminder_time_label': 'وقت التذكير اليومي',
      'onboarding_reminder_hint_text': 'سنذكّرك يومياً بتسجيل قراءة عداد المياه.',
      // Onboarding – Challenge screen
      'onboarding_challenge_title': 'اختر تحديك',
      'onboarding_challenge_subtitle': 'ابدأ توفير المياه بهدف مخصص',
      'onboarding_challenge_weekly_title': 'التحدي الأسبوعي',
      'onboarding_challenge_weekly_desc': 'هدف توفير المياه لمدة 7 أيام',
      'onboarding_challenge_weekly_duration': 'أسبوع واحد',
      'onboarding_challenge_monthly_title': 'التحدي الشهري',
      'onboarding_challenge_monthly_desc': 'هدف توفير المياه لمدة 30 يوماً',
      'onboarding_challenge_monthly_duration': 'شهر واحد',
      'onboarding_challenge_progressive_title': 'التحديات التدريجية',
      'onboarding_challenge_progressive_desc':
      'في كل مرة تكمل فيها تحدياً، سيكون هدفك التالي أكثر طموحاً قليلاً، مما يساعدك على توفير المزيد من المياه!',
      'onboarding_challenge_start_btn': 'ابدأ رحلتي',
    },
    'fr': {
      // App
      'app_name': 'HydroSmart',

      // Greetings
      'good_morning': 'Bonjour',
      'good_afternoon': 'Bon après-midi',
      'good_evening': 'Bonsoir',
      'good_night': 'Bonne nuit',

      // Navigation
      'nav_home': 'Accueil',
      'nav_ai_chat': 'Chat IA',
      'nav_settings': 'Paramètres',
      'log_reading': 'Enregistrer',

      // Dashboard
      'weekly_progress': 'Progrès hebdomadaire',
      'monthly_progress': 'Progrès mensuel',
      'status_on_track': 'Statut: Sur la bonne voie ✅',
      'status_over_limit': 'Dépassement! ⚠️',
      'daily_usage': 'Utilisation quotidienne (7 derniers jours)',
      'liters': 'Litres',
      'leak_status': 'État de fuite',
      'daily_avg': 'Moyenne quotidienne',
      'secure': 'Sécurisé',
      'alert': 'ALERTE',
      'off': 'DÉSACTIVÉ',
      'points': 'points',
      'day_streak': 'série de jours',

      // Achievements
      'achievements': 'Réalisations',
      'total_points': 'Points totaux',
      'unlocked': 'Débloquées',
      'water_warrior': 'Guerrier de l\'eau',
      'water_warrior_desc': 'Complétez votre première semaine',
      'drop_by_drop': 'Goutte à goutte',
      'drop_by_drop_desc': 'Économisez 100L au total',
      'consistency_king': 'Roi de la constance',
      'consistency_king_desc': 'Maintenez une série de 30 jours',
      'eco_hero': 'Héros écologique',
      'eco_hero_desc': 'Économisez 1000L au total',
      'hot_streak': 'Série chaude',
      'hot_streak_desc': 'Restez sous l\'objectif pendant 7 jours',
      'perfect_week': 'Semaine parfaite',
      'perfect_week_desc': 'Chaque jour sous la cible quotidienne',
      'leak_detective': 'Détective de fuite',
      'leak_detective_desc': 'Détectez votre première fuite',
      'ai_friend': 'Ami IA',
      'ai_friend_desc': 'Ayez 50 conversations IA',
      'unlocked_on': 'Débloqué le',

      // Profile
      'profile': 'Profil',
      'edit_profile': 'Modifier le profil',
      'full_name': 'Nom complet',
      'email_address': 'Adresse e-mail',
      'family_size': 'Taille de la famille',
      'phone_number': 'Numéro de téléphone',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'saved': 'Enregistré',
      'member_since': 'Membre depuis',
      'profile_updated': 'Profil mis à jour avec succès!',

      // Settings
      'settings': 'Paramètres',
      'preferences': 'Préférences',
      'water_tracking': 'Suivi de l\'eau',
      'household_members': 'Membres du foyer',
      'challenge_management': 'Gestion des défis',
      'weekly_goal': 'Objectif hebdomadaire',
      'adjust_goal': 'Ajustez votre objectif d\'utilisation d\'eau hebdomadaire',
      'leak_detection': 'Détection de fuite',
      'notifications': 'Notifications',
      'daily_usage_reminders': 'Rappels d\'utilisation quotidienne',
      'goal_achievement_alerts': 'Alertes d\'atteinte d\'objectif',
      'leak_alerts': 'Alertes de fuite',
      'vacation_mode_alerts': 'Alertes de mode vacances',
      'language': 'Langue',
      'appearance': 'Apparence',
      'dark_mode': 'Mode sombre',
      'account': 'Compte',
      'logout': 'Déconnexion',
      'about': 'À propos',
      'app_version': 'Version de l\'application',
      'privacy_policy': 'Politique de confidentialité',
      'terms_of_service': 'Conditions d\'utilisation',
      'logout_confirm': 'Êtes-vous sûr de vouloir vous déconnecter?',
      'yes': 'Oui',
      'no': 'Non',

      // Auth
      'login': 'Connexion',
      'signup': 'S\'inscrire',
      'create_account': 'Créer un compte',
      'already_have_account': 'Vous avez déjà un compte? Connexion',
      'dont_have_account': 'Vous n\'avez pas de compte? S\'inscrire',
      'join_hydrosmart': 'Rejoignez HydroSmart et commencez à économiser l\'eau aujourd\'hui',
      'password': 'Mot de passe',
      'create_strong_password': 'Créez un mot de passe fort',
      'family_size_hint': 'Nombre de membres de la famille',
      'phone_hint': '+33 1 23 45 67 89',
      'phone_optional': 'Numéro de téléphone (optionnel)',

      // Validation
      'name_required': 'Le nom est requis',
      'name_min_length': 'Le nom doit comporter au moins 2 caractères',
      'name_invalid': 'Le nom doit contenir uniquement des lettres arabes ou latines et des espaces simples (sans mélange)',
      'email_required': 'L\'e-mail est requis',
      'email_invalid': 'Veuillez entrer un e-mail valide',
      'password_required': 'Le mot de passe est requis',
      'password_min_length': 'Le mot de passe doit comporter au moins 8 caractères',
      'password_uppercase': 'Le mot de passe doit contenir au moins une lettre majuscule',
      'password_lowercase': 'Le mot de passe doit contenir au moins une lettre minuscule',
      'password_number': 'Le mot de passe doit contenir au moins un chiffre',
      'password_strength_weak': 'Faible',
      'password_strength_fair': 'Moyen',
      'password_strength_good': 'Bon',
      'password_strength_strong': 'Fort',
      'password_hint_text': 'Utilisez 8+ caractères avec majuscules, minuscules et chiffres',
      'family_size_required': 'La taille de la famille est requise',
      'family_size_invalid': 'Veuillez entrer un nombre valide',
      'family_size_range': 'La taille de la famille doit être entre 1 et 20',
      'phone_invalid': 'Veuillez entrer un numéro de téléphone valide',

      // AI Assistant
      'ai_assistant': 'Assistant IA',
      'ask_something': 'Demandez quelque chose...',
      'typing': 'En train d\'écrire...',
      'ai_greeting': 'Bonjour ! Comment puis-je vous aider à économiser l\'eau aujourd\'hui ?',
      'ai_new_chat': 'Nouvelle conversation',
      'ai_search_chats': 'Rechercher des conversations...',
      'ai_no_chats_yet': 'Aucune conversation',
      'ai_no_results_found': 'Aucun résultat trouvé',
      'ai_new_session': 'Nouvelle session. Comment puis-je vous aider ?',
      'today': 'Aujourd\'hui',

      // Vacation Mode
      'vacation_mode': 'Mode vacances?',
      'vacation_detected': 'Nous avons remarqué une utilisation nulle pendant 3 jours consécutifs. Êtes-vous absent? Souhaitez-vous suspendre le suivi de votre objectif hebdomadaire?',
      'enable': 'Activer',
      'im_here': 'Non, je suis là',
      'vacation_enabled': 'Mode vacances activé',

      // Onboarding
      'onboarding_welcome_title': 'Bienvenue sur HydroSmart',
      'onboarding_language_prompt': 'Choisissez votre langue préférée',
      'continue': 'Continuer',
      // Onboarding – Name screen
      'onboarding_name_title': 'Quel est votre nom ?',
      'onboarding_name_subtitle': "Personnalisons votre parcours d'économie d'eau",
      'onboarding_name_hint': 'Entrez votre nom complet',
      'onboarding_name_rule_letters': 'Uniquement lettres arabes ou latines et espaces simples (sans mélange)',
      'onboarding_name_rule_min_length': 'Au moins 2 caractères',
      'onboarding_name_rule_no_spaces': "Pas d'espaces au début ou à la fin",
      // Onboarding – Age screen
      'onboarding_age_greeting': 'Bonjour',
      'onboarding_age_title': 'Quel est votre âge ?',
      'onboarding_age_hint': 'Votre âge',
      // Onboarding – Household screen
      'onboarding_household_title': 'Parlez-nous de votre foyer',
      'onboarding_household_subtitle': 'Cela nous aide à estimer votre consommation d\'eau',
      'onboarding_household_size_question': 'Combien de personnes vivent dans votre foyer ?',
      'onboarding_household_members_age_title': 'Âge des autres membres du foyer',
      'onboarding_household_member_age_label': 'Âge du membre {n}',
      // Onboarding – Meter screen
      'onboarding_meter_title': "Configurer votre compteur d'eau",
      'onboarding_meter_subtitle': "Nous suivrons votre consommation d'eau pour vous aider à économiser",
      'onboarding_meter_reading_label': 'Relevé actuel du compteur (m³)',
      'onboarding_meter_hint_text':
      'Ce numéro se trouve sur votre compteur d\'eau. Il est généralement affiché en mètres cubes (m³).',
      'onboarding_reminder_time_label': 'Heure du rappel quotidien',
      'onboarding_reminder_hint_text':
      "Nous vous rappellerons quotidiennement d'enregistrer votre relevé de compteur.",
      // Onboarding – Challenge screen
      'onboarding_challenge_title': 'Choisissez votre défi',
      'onboarding_challenge_subtitle': "Commencez à économiser l'eau avec un objectif personnalisé",
      'onboarding_challenge_weekly_title': 'Défi hebdomadaire',
      'onboarding_challenge_weekly_desc': "Objectif d'économie d'eau sur 7 jours",
      'onboarding_challenge_weekly_duration': '1 semaine',
      'onboarding_challenge_monthly_title': 'Défi mensuel',
      'onboarding_challenge_monthly_desc': "Objectif d'économie d'eau sur 30 jours",
      'onboarding_challenge_monthly_duration': '1 mois',
      'onboarding_challenge_progressive_title': 'Défis progressifs',
      'onboarding_challenge_progressive_desc':
      "Chaque fois que vous terminez un défi, votre prochain objectif sera légèrement plus ambitieux, vous aidant à économiser encore plus d'eau !",
      'onboarding_challenge_start_btn': 'Commencer mon parcours',
    },
  };

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }

  /// Translates a key and replaces `{placeholder}` tokens with the given args.
  String translateWithArgs(String key, Map<String, String> args) {
    String value = translate(key);
    for (final entry in args.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }

  String get appName => translate('app_name');
  String get goodMorning => translate('good_morning');
  String get goodAfternoon => translate('good_afternoon');
  String get goodEvening => translate('good_evening');
  String get goodNight => translate('good_night');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale.languageCode);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}