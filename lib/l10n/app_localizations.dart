import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Health Sync',
      'languageEnglish': 'English',
      'languageArabic': 'Arabic',
      'settings': 'Settings',
      'applicationSection': 'Application',
      'appLanguage': 'App language',
      'notificationsToggle': 'Enable notifications',
      'darkModeToggle': 'Dark mode',
      'supportSection': 'Support',
      'contactSupport': 'Contact support',
      'contactSupportMessage': 'Support email will be available soon.',
      'rateApp': 'Rate the app',
      'rateAppMessage': 'App store rating will be available after launch.',
      'themeLightBackground': 'light',
      'themeDarkBackground': 'dark',
      'back': 'Back',
      'next': 'Next',
      'snackInvalidHeight': 'Please enter a valid height in centimetres',
      'snackInvalidWeight': 'Please enter a valid weight in kilograms',
      'snackSelectGender': 'Please select your gender',
      'snackSelectDiabetes': 'Let us know if you have diabetes',
      'snackSelectHypertension': 'Let us know if you have hypertension',
      'snackSelectGoal': 'Please choose your primary goal',
      'summaryTitle': 'Summary',
      'dailySnapshot': 'Daily snapshot',
      'dailySnapshotDetails':
          'Calories consumed today: {calories}\nSleep hours logged this week: {sleep}\nActivity minutes this week: {activity}',
      'home': 'Home',
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'history': 'History',
      'settingsLabel': 'Settings',
      'logout': 'Log Out',
      'openSettings': 'Open Settings',
      'welcomeBack': 'Welcome back',
      'welcomeBackMessage':
          'Keep logging your habits and let Health Sync guide your routine.',
      'mealsNutrition': 'Meals & Nutrition',
      'todayOverview': 'Today\'s overview',
      'foodLog': 'Food log',
      'sleepTracking': 'Sleep Tracking',
      'activityTracking': 'Activity Tracking',
      'medication': 'Medication',
      'vitalsHealth': 'Vitals & Health',
      'vitalsAndHealth': 'Vitals & health',
      'caloriesConsumed': 'Calories consumed',
      'hoursSlept': 'Hours slept',
      'activityMinutes': 'Activity minutes',
      'healthReadingSaved': 'Reading saved to history.',
      'addHealthReadingTitle': 'Add health reading',
      'selectReadingType': 'Select what you want to track',
      'bloodPressure': 'Blood pressure',
      'bloodPressureHint': 'Record systolic/diastolic values',
      'bloodSugar': 'Blood sugar',
      'bloodSugarHint': 'Track glucose levels in mg/dL',
      'bloodPressureInputLabel': 'Blood pressure (e.g. 120/80)',
      'bloodPressureRequired': 'Enter the blood pressure reading',
      'bloodSugarInputLabel': 'Blood sugar (mg/dL)',
      'bloodSugarRequired': 'Enter the blood sugar reading',
      'dateAndTime': 'Date & time',
      'saveReading': 'Save reading',
      'addHealthReadingButton': 'Add reading',
      'recentReadings': 'Recent readings',
      'todayLabel': 'Today',
      'yesterdayLabel': 'Yesterday',
      'healthSummaryPlaceholder':
          'Log a reading to see personalised insights here.',
      'latestBloodPressure': 'Latest blood pressure: {value}',
      'latestBloodSugar': 'Latest blood sugar: {value} mg/dL',
      'todayInsight': 'Today\'s insight',
      'noReadingsYet': 'No readings yet',
      'noReadingsHint':
          'Track your blood pressure and glucose to build your history.',
      'addMeal': 'Add meal',
      'mealName': 'Meal name',
      'mealNameHint': 'What did you eat?',
      'mealCalories': 'Estimated calories (kcal)',
      'mealCaloriesHint': 'Enter calories',
      'mealAnalyse': 'Analyse meal',
      'mealNameError': 'Please enter what you ate',
      'mealCaloriesErrorEmpty': 'Please enter the calorie estimate',
      'mealCaloriesErrorNumber': 'Calories must be a number',
      'mealDescriptionLabel': 'Meal description',
      'mealDescriptionHint': 'e.g. Chicken sandwich with salad',
      'mealDescriptionError': 'Please describe the meal',
      'mealTypeLabel': 'Meal type',
      'mealType_breakfast': 'Breakfast',
      'mealType_lunch': 'Lunch',
      'mealType_dinner': 'Dinner',
      'drinkLabel': 'Drink',
      'dessertLabel': 'Dessert',
      'optional': 'Optional',
      'water': 'Water',
      'coffee': 'Coffee',
      'tea': 'Tea',
      'juice': 'Juice',
      'fruit': 'Fruit',
      'cake': 'Cake',
      'iceCream': 'Ice cream',
      'none': 'None',
      'mealAnalysis': 'Meal analysis',
      'analysingMealPlaceholder': 'Our assistant is reviewing your meal...',
      'calories': 'Calories',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'saveToHistory': 'Save to history',
      'mealHistory': 'Meal history',
      'noMealsPlaceholder':
          'No meals recorded yet. Add your first meal to start tracking.',
      'mealSavedMessage': 'Meal saved to your log.',
      'remainingCaloriesMessage':
          'You can still enjoy {remaining} kcal within your goal.',
      'calorieGoalReached': 'Nice work! You have reached your calorie target.',
      'accountCreated':
          'Account created. Let\'s personalize your plan.',
      'signIn': 'Sign in',
      'createAccount': 'Create account',
      'registerTitle': 'Create your Health Sync account',
      'fullName': 'Full name',
      'emailAddress': 'Email address',
      'password': 'Password',
      'createPassword': 'Create a password',
      'nameRequired': 'Please enter your name',
      'passwordRule': 'Password must be at least 6 characters long',
      'alreadyHaveAccount': 'Already have an account?',
      'dontHaveAccount': 'Don\'t have an account?',
      'loginTitle': 'Log in to Health Sync',
      'loginButton': 'Sign in',
      'emailRequired': 'Please enter your email address',
      'passwordRequired': 'Please enter your password',
      'loginFailed':
          'Incorrect email or password. Please try again.',
      'heightQuestion': 'What is your height?',
      'heightLabel': 'Height (cm)',
      'heightHint': 'e.g. 170',
      'weightQuestion': 'What is your weight?',
      'weightLabel': 'Weight (kg)',
      'weightHint': 'e.g. 70',
      'genderQuestion': 'How do you identify?',
      'genderMale': 'Male',
      'genderFemale': 'Female',
      'genderOther': 'Prefer not to say',
      'diabetesQuestion': 'Do you have diabetes?',
      'diabetesDescription':
          'This helps us tailor nutrition and medication reminders to your needs.',
      'optionYes': 'Yes',
      'optionNo': 'No',
      'hypertensionQuestion': 'Do you have hypertension?',
      'hypertensionDescription':
          'We use this information to personalise reminders and health tips.',
      'goalQuestion': 'What is your main goal?',
      'goalLoseWeight': 'Lose weight',
      'goalMaintain': 'Maintain weight',
      'goalGain': 'Gain muscle',
      'summaryScreenTitle': 'Your wellness summary',
      'viewSummary': 'View summary',
      'summaryGreeting': 'Almost there, {name}!',
      'summaryDescription':
          'Review your details before we personalise your Health Sync experience.',
      'finishSetup': 'Finish setup',
      'backToEdit': 'Back to edit',
      'ageLabel': 'Age',
      'heightShort': 'Height',
      'weightShort': 'Weight',
      'genderLabel': 'Gender',
      'goalLabel': 'Goal',
      'diabetesLabel': 'Diabetes',
      'hypertensionLabel': 'Hypertension',
      'defaultDisplayName': 'Health Sync member',
      'ageValue': '{age} years',
      'heightValue': '{height} cm',
      'weightValue': '{weight} kg',
      'ageQuestion': 'How old are you?',
      'finish': 'Finish',
      'startTracking': 'Start tracking',
      'sleepTitle': 'Sleep tracking',
      'sleepAddEntry': 'Log sleep',
      'sleepHours': 'Hours slept',
      'sleepNotes': 'Notes (optional)',
      'sleepSubmit': 'Analyse sleep',
      'sleepHoursError': 'Please enter how many hours you slept',
      'sleepEnterValidHours':
          'Enter a valid number of hours between 0 and 24',
      'sleepResultTitle': 'Sleep analysis',
      'sleepResultSummary': 'Summary',
      'sleepResultRecommendation': 'Recommendation',
      'sleepResultBack': 'Back to sleep tracking',
      'activitySummary': 'Summary',
      'activityAdvice':
          'Stay consistent and mix light and intense workouts to balance your week.',
      'recentSessions': 'Recent sessions',
      'noWorkouts':
          'No workouts recorded yet. Add your first activity to begin tracking.',
      'activitySaved': 'Activity saved to your log.',
      'activityName': 'Activity name',
      'activityMinutesLabel': 'Duration (minutes)',
      'activityCaloriesLabel': 'Estimated calories (kcal)',
      'activitySave': 'Save activity',
      'activityNameError': 'Please enter the activity name',
      'activityMinutesError': 'Please enter the duration in minutes',
      'activityCaloriesError': 'Please enter the calorie estimate',
      'activityMinutesNumberError':
          'Duration must be a positive number',
      'activityCaloriesNumberError':
          'Calories must be a positive number',
      'sleepAnalysisLoading': 'Analysing your sleep...',
      'activityAnalysisLoading': 'Processing activity data...',
      'foodAnalysisLoading': 'Analysing your meal...',
      'foodAnalysisTitle': 'Meal insights',
      'foodSummary': 'Summary',
      'foodMacros': 'Macronutrients',
      'foodRecommendations': 'Recommendations',
      'foodAddTitle': 'Add meal',
      'profileTitle': 'Profile',
      'historyTitle': 'History',
      'dashboardTitle': 'Dashboard',
      'medicineTitle': 'Medication',
      'medicineAddTitle': 'Add medicine',
      'medicineDisease': 'Condition',
      'medicineName': 'Medicine name',
      'medicineDuration': 'Duration (days)',
      'medicineTime': 'Reminder time',
      'medicineReminder': 'Enable reminder',
      'medicineSave': 'Save medicine',
      'medicineDiseaseError': 'Please enter the condition',
      'medicineNameError': 'Please enter the medicine name',
      'medicineDurationError': 'Enter how many days to take it',
      'medicineDurationNumberError':
          'Duration must be a positive number',
      'generalError': 'Something went wrong. Please try again.',
      'splashTitle': 'Health Sync',
      'splashLoading': 'Loading...',
    },
    'ar': {
      'appTitle': 'مزامنة الصحة',
      'languageEnglish': 'الإنجليزية',
      'languageArabic': 'العربية',
      'settings': 'الإعدادات',
      'applicationSection': 'التطبيق',
      'appLanguage': 'لغة التطبيق',
      'notificationsToggle': 'تفعيل الإشعارات',
      'darkModeToggle': 'الوضع الداكن',
      'supportSection': 'الدعم',
      'contactSupport': 'التواصل مع الدعم',
      'contactSupportMessage': 'سيكون بريد الدعم متاحًا قريبًا.',
      'rateApp': 'قيّم التطبيق',
      'rateAppMessage': 'سيكون التقييم في المتجر متاحًا بعد الإطلاق.',
      'themeLightBackground': 'فاتح',
      'themeDarkBackground': 'داكن',
      'back': 'رجوع',
      'next': 'التالي',
      'snackInvalidHeight': 'يرجى إدخال طول صالح بالسنتيمتر',
      'snackInvalidWeight': 'يرجى إدخال وزن صالح بالكيلوغرام',
      'snackSelectGender': 'يرجى اختيار جنسكم',
      'snackSelectDiabetes': 'أخبرنا إذا كنت مصابًا بالسكري',
      'snackSelectHypertension': 'أخبرنا إذا كنت مصابًا بارتفاع الضغط',
      'snackSelectGoal': 'يرجى اختيار الهدف الرئيسي',
      'summaryTitle': 'الملخص',
      'dailySnapshot': 'نظرة يومية',
      'dailySnapshotDetails':
          'السعرات الحرارية المستهلكة اليوم: {calories}\nساعات النوم المسجلة هذا الأسبوع: {sleep}\nدقائق النشاط هذا الأسبوع: {activity}',
      'home': 'الرئيسية',
      'dashboard': 'لوحة التحكم',
      'profile': 'الملف الشخصي',
      'history': 'السجل',
      'settingsLabel': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'openSettings': 'فتح الإعدادات',
      'welcomeBack': 'أهلًا بعودتك',
      'welcomeBackMessage':
          'استمر بتسجيل عاداتك ودع مزامنة الصحة ترشد نمطك اليومي.',
      'mealsNutrition': 'الوجبات والتغذية',
      'todayOverview': 'نظرة عامة اليوم',
      'foodLog': 'سجل الطعام',
      'sleepTracking': 'تتبع النوم',
      'activityTracking': 'تتبع النشاط',
      'medication': 'الأدوية',
      'vitalsHealth': 'العلامات الحيوية والصحة',
      'caloriesConsumed': 'السعرات الحرارية',
      'hoursSlept': 'ساعات النوم',
      'activityMinutes': 'دقائق النشاط',
      'addMeal': 'إضافة وجبة',
      'mealName': 'اسم الوجبة',
      'mealNameHint': 'ماذا أكلت؟',
      'mealCalories': 'السعرات التقديرية (سعرة)',
      'mealCaloriesHint': 'أدخل السعرات',
      'mealAnalyse': 'تحليل الوجبة',
      'mealNameError': 'يرجى إدخال ما تناولته',
      'mealCaloriesErrorEmpty': 'يرجى إدخال تقدير السعرات',
      'mealCaloriesErrorNumber': 'يجب أن تكون السعرات رقمًا',
      'mealDescriptionLabel': 'وصف الوجبة',
      'mealDescriptionHint': 'مثال: ساندويتش دجاج مع سلطة',
      'mealDescriptionError': 'يرجى وصف الوجبة',
      'mealTypeLabel': 'نوع الوجبة',
      'mealType_breakfast': 'فطور',
      'mealType_lunch': 'غداء',
      'mealType_dinner': 'عشاء',
      'drinkLabel': 'مشروب',
      'dessertLabel': 'تحلية',
      'optional': 'اختياري',
      'water': 'ماء',
      'coffee': 'قهوة',
      'tea': 'شاي',
      'juice': 'عصير',
      'fruit': 'فاكهة',
      'cake': 'كيك',
      'iceCream': 'آيس كريم',
      'none': 'بدون',
      'mealAnalysis': 'تحليل الوجبة',
      'analysingMealPlaceholder': 'نقوم بمراجعة وجبتك...',
      'calories': 'السعرات',
      'protein': 'البروتين',
      'carbs': 'الكربوهيدرات',
      'fats': 'الدهون',
      'saveToHistory': 'حفظ في السجل',
      'mealHistory': 'سجل الوجبات',
      'noMealsPlaceholder':
          'لم يتم تسجيل أي وجبات بعد. أضف أول وجبة للبدء.',
      'mealSavedMessage': 'تم حفظ الوجبة في السجل.',
      'remainingCaloriesMessage':
          'لا يزال بإمكانك تناول {remaining} سعرة ضمن هدفك.',
      'calorieGoalReached': 'عمل رائع! لقد حققت هدفك من السعرات.',
      'accountCreated': 'تم إنشاء الحساب. لنخصص خطتك.',
      'signIn': 'تسجيل الدخول',
      'createAccount': 'إنشاء حساب',
      'registerTitle': 'أنشئ حساب مزامنة الصحة الخاص بك',
      'fullName': 'الاسم الكامل',
      'emailAddress': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'createPassword': 'إنشاء كلمة المرور',
      'nameRequired': 'يرجى إدخال اسمك',
      'passwordRule': 'يجب ألا تقل كلمة المرور عن 6 أحرف',
      'alreadyHaveAccount': 'لديك حساب مسبقًا؟',
      'dontHaveAccount': 'ليس لديك حساب؟',
      'loginTitle': 'سجّل الدخول إلى مزامنة الصحة',
      'loginButton': 'تسجيل الدخول',
      'emailRequired': 'يرجى إدخال بريدك الإلكتروني',
      'passwordRequired': 'يرجى إدخال كلمة المرور',
      'loginFailed': 'البريد أو كلمة المرور غير صحيحة. حاول مجددًا.',
      'heightQuestion': 'ما طولك؟',
      'heightLabel': 'الطول (سم)',
      'heightHint': 'مثال: 170',
      'weightQuestion': 'ما وزنك؟',
      'weightLabel': 'الوزن (كجم)',
      'weightHint': 'مثال: 70',
      'genderQuestion': 'كيف تُعرّف نفسك؟',
      'genderMale': 'ذكر',
      'genderFemale': 'أنثى',
      'genderOther': 'أفضل عدم الإفصاح',
      'diabetesQuestion': 'هل تعاني من السكري؟',
      'diabetesDescription':
          'يساعدنا ذلك على تخصيص التغذية وتذكيرات الأدوية حسب احتياجاتك.',
      'optionYes': 'نعم',
      'optionNo': 'لا',
      'hypertensionQuestion': 'هل تعاني من ارتفاع الضغط؟',
      'hypertensionDescription':
          'نستخدم هذه المعلومات لتخصيص التذكيرات ونصائح الصحة.',
      'goalQuestion': 'ما هدفك الرئيسي؟',
      'goalLoseWeight': 'إنقاص الوزن',
      'goalMaintain': 'الحفاظ على الوزن',
      'goalGain': 'اكتساب العضلات',
      'summaryScreenTitle': 'ملخص العافية الخاص بك',
      'viewSummary': 'عرض الملخص',
      'summaryGreeting': 'اقتربنا يا {name}!',
      'summaryDescription':
          'راجع بياناتك قبل أن نخصص تجربة مزامنة الصحة لك.',
      'finishSetup': 'إكمال الإعداد',
      'backToEdit': 'العودة للتعديل',
      'ageLabel': 'العمر',
      'heightShort': 'الطول',
      'weightShort': 'الوزن',
      'genderLabel': 'الجنس',
      'goalLabel': 'الهدف',
      'diabetesLabel': 'السكري',
      'hypertensionLabel': 'ارتفاع الضغط',
      'defaultDisplayName': 'عضو مزامنة الصحة',
      'ageValue': '{age} سنة',
      'heightValue': '{height} سم',
      'weightValue': '{weight} كجم',
      'ageQuestion': 'كم عمرك؟',
      'finish': 'إنهاء',
      'startTracking': 'ابدأ التتبع',
      'sleepTitle': 'تتبع النوم',
      'sleepAddEntry': 'تسجيل النوم',
      'sleepHours': 'ساعات النوم',
      'sleepNotes': 'ملاحظات (اختياري)',
      'sleepSubmit': 'تحليل النوم',
      'sleepHoursError': 'يرجى إدخال عدد ساعات النوم',
      'sleepEnterValidHours': 'أدخل عدد ساعات بين 0 و 24',
      'sleepResultTitle': 'تحليل النوم',
      'sleepResultSummary': 'الملخص',
      'sleepResultRecommendation': 'التوصيات',
      'sleepResultBack': 'العودة لتتبع النوم',
      'activitySummary': 'الملخص',
      'activityAdvice':
          'حافظ على الاستمرارية ووازن بين التمارين الخفيفة والمكثفة خلال الأسبوع.',
      'recentSessions': 'الجلسات الأخيرة',
      'noWorkouts':
          'لا توجد تمارين مسجلة بعد. أضف نشاطك الأول للبدء بالتتبع.',
      'activitySaved': 'تم حفظ النشاط في سجلك.',
      'activityName': 'اسم النشاط',
      'activityMinutesLabel': 'المدة (دقائق)',
      'activityCaloriesLabel': 'السعرات التقديرية (سعرة)',
      'activitySave': 'حفظ النشاط',
      'activityNameError': 'يرجى إدخال اسم النشاط',
      'activityMinutesError': 'يرجى إدخال مدة التمرين بالدقائق',
      'activityCaloriesError': 'يرجى إدخال تقدير السعرات',
      'activityMinutesNumberError':
          'يجب أن تكون المدة رقمًا موجبًا',
      'activityCaloriesNumberError':
          'يجب أن تكون السعرات رقمًا موجبًا',
      'sleepAnalysisLoading': 'جاري تحليل النوم...',
      'activityAnalysisLoading': 'جاري معالجة بيانات النشاط...',
      'foodAnalysisLoading': 'جاري تحليل وجبتك...',
      'foodAnalysisTitle': 'رؤى الوجبة',
      'foodSummary': 'الملخص',
      'foodMacros': 'العناصر الغذائية',
      'foodRecommendations': 'التوصيات',
      'foodAddTitle': 'إضافة وجبة',
      'profileTitle': 'الملف الشخصي',
      'historyTitle': 'السجل',
      'dashboardTitle': 'لوحة التحكم',
      'medicineTitle': 'الأدوية',
      'medicineAddTitle': 'إضافة دواء',
      'medicineDisease': 'الحالة',
      'medicineName': 'اسم الدواء',
      'medicineDuration': 'المدة (أيام)',
      'medicineTime': 'وقت التذكير',
      'medicineReminder': 'تفعيل التذكير',
      'medicineSave': 'حفظ الدواء',
      'medicineDiseaseError': 'يرجى إدخال الحالة المرضية',
      'medicineNameError': 'يرجى إدخال اسم الدواء',
      'medicineDurationError': 'أدخل عدد الأيام لتناول الدواء',
      'medicineDurationNumberError':
          'يجب أن تكون المدة رقمًا موجبًا',
      'generalError': 'حدث خطأ ما. حاول مرة أخرى.',
      'splashTitle': 'مزامنة الصحة',
      'splashLoading': 'جارٍ التحميل...',
    },
  };

  String translate(String key) {
    final languageCode = supportedLocales
            .any((locale) => locale.languageCode == this.locale.languageCode)
        ? this.locale.languageCode
        : 'en';
    final localeMap =
        _localizedValues[languageCode] ?? _localizedValues['en']!;
    return localeMap[key] ?? _localizedValues['en']![key] ?? key;
  }

  String dailySnapshotDetails({
    required int calories,
    required double sleepHours,
    required int activityMinutes,
  }) {
    final template = translate('dailySnapshotDetails');
    return template
        .replaceAll('{calories}', calories.toString())
        .replaceAll('{sleep}', sleepHours.toStringAsFixed(1))
        .replaceAll('{activity}', activityMinutes.toString());
  }

  String get languageEnglish => translate('languageEnglish');
  String get languageArabic => translate('languageArabic');

  String languageName(String code) {
    switch (code) {
      case 'ar':
        return languageArabic;
      case 'en':
      default:
        return languageEnglish;
    }
  }

  String summaryGreeting(String name) {
    final template = translate('summaryGreeting');
    return template.replaceAll('{name}', name);
  }

  String ageLabelValue(int age) {
    final template = translate('ageValue');
    return template.replaceAll('{age}', age.toString());
  }

  String heightLabelValue(double height) {
    final template = translate('heightValue');
    return template.replaceAll('{height}', height.toStringAsFixed(1));
  }

  String weightLabelValue(double weight) {
    final template = translate('weightValue');
    return template.replaceAll('{weight}', weight.toStringAsFixed(1));
  }

  String booleanLabel(bool value) {
    return value ? translate('optionYes') : translate('optionNo');
  }

  String genderLabel(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('female')) {
      return translate('genderFemale');
    }
    if (normalized.contains('male')) {
      return translate('genderMale');
    }
    if (normalized.contains('prefer')) {
      return translate('genderOther');
    }
    if (normalized == 'female' || normalized == 'male') {
      return translate('gender${value[0].toUpperCase()}${value.substring(1)}');
    }
    return translate(value);
  }

  String goalLabel(String value) {
    switch (value) {
      case 'goalLoseWeight':
      case 'Lose weight':
        return translate('goalLoseWeight');
      case 'goalMaintain':
      case 'Maintain weight':
        return translate('goalMaintain');
      case 'goalGain':
      case 'Gain weight':
      case 'Gain muscle':
        return translate('goalGain');
      default:
        return translate(value);
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String loc(String key) => l10n.translate(key);
}
