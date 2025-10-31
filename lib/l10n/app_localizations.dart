import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const supportedLocales = <Locale>[
    Locale('en'),
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
      'summaryTitle': 'Summary',
      'dailySnapshot': 'Daily snapshot',
      'dailySnapshotDetails':
          'Calories consumed today: {calories}\nSleep hours logged this week: {sleep}\nActivity minutes this week: {activity}',
      'home': 'Home',
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'history': 'History',
      'hederaBadge': 'Hedera sync',
      'hederaBadgeShort': 'Hedera',
      'historySyncedViaHedera': 'Synced via Hedera mirror',
      'historyRecordedOn': 'Recorded on {date}',
      'historyFoodTitle': 'Meal logged: {name}',
      'historyFoodSubtitle':
          '{calories} kcal | {protein} g protein | {carbs} g carbs',
      'historySleepTitle': 'Sleep session: {hours} h',
      'historySleepRecommendation': 'Recommendation: {tip}',
      'historySleepRecommendationPending': 'Recommendation pending',
      'historyActivityTitle': 'Activity: {name}',
      'historyActivitySubtitle': '{minutes} min | {calories} kcal burned',
      'historyMedicineTitle': 'Medication: {name}',
      'historyMedicineSubtitle':
          '{dosage} | {frequency}x per day | {duration} days{taken}',
      'historyMedicineTakenSuffix': ' | taken',
      'historyHealthTitle': 'Health reading',
      'historyHealthSubtitle':
          'Blood pressure: {bloodPressure} mmHg | Blood sugar: {bloodSugar} mg/dL',
      'historyHealthRecommendation': 'AI insight: {tip}',
      'historyHealthRecommendationPending': 'AI insight pending',
      'historyEmptyTitle': 'No activity recorded yet.',
      'historyEmptyDescription':
          'Log meals, sleep, workouts or medication to build your personal history.',
      'historyStartTracking': 'Start tracking',
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
      'sleepHistoryTitle': 'History',
      'sleepHistoryEmpty':
          'No sleep sessions logged yet. Add your first sleep record.',
      'sleepAddSessionButton': 'Add sleep session',
      'sleepSummaryLastSession': 'Last session: {hours} hours',
      'sleepSummaryNoData': 'No sleep data recorded yet',
      'sleepSummaryAverage': 'Average duration: {hours} hours',
      'sleepSummaryWeek': 'Past 7 days total: {hours} hours',
      'sleepLatestRecommendation': 'Latest AI tip',
      'sleepResultTitle': 'Sleep summary',
      'sleepResultHoursLabel': '{hours} hours',
      'sleepResultQualityLabel': 'Sleep quality: {score}%',
      'activityTracking': 'Activity Tracking',
      'medication': 'Medication',
      'vitalsHealth': 'Vitals & Health',
      'vitalsAndHealth': 'Vitals & health',
      'caloriesConsumed': 'Calories consumed',
      'hoursSlept': 'Hours slept',
      'activityMinutes': 'Activity minutes',
      'activitySummaryTitle': 'Summary',
      'activitySummaryCalories': 'Calories burned: {calories}',
      'activitySummaryMinutes': 'Total minutes: {minutes}',
      'activitySummarySessions': 'Sessions logged: {count}',
      'activitySummaryTip':
          'Stay consistent and mix light and intense workouts to balance your week.',
      'activityHistoryTitle': 'Recent sessions',
      'activityHistoryEmpty':
          'No workouts recorded yet. Add your first activity to begin tracking.',
      'activitySessionDetail': '{minutes} min | {calories} kcal',
      'activitySavedMessage': 'Activity saved to your log.',
      'activityResultTitle': 'Workout analysis',
      'activityResultDuration': 'Duration',
      'activityResultDurationValue': '{minutes} min',
      'activityResultCalories': 'Estimated calories',
      'activityResultCaloriesValue': '{calories} kcal',
      'healthReadingSaved': 'Reading saved to history.',
      'addHealthReadingTitle': 'Add health reading',
      'selectReadingType': 'Select what you want to track',
      'bloodPressure': 'Blood pressure',
      'bloodPressureHint': 'Record systolic/diastolic values',
      'bloodSugar': 'Blood sugar',
      'bloodSugarHint': 'Track glucose levels in mg/dL',
      'heartRate': 'Heart rate',
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
      'healthRecordedAt': 'Recorded at {time}',
      'healthRecommendationHeading': 'AI recommendation',
      'healthRecommendationFallback':
          'No recommendation provided yet. Log a new reading to receive guidance.',
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
      'mealDescriptionDetailError':
          'Add quantity or ingredients (e.g. 200g grilled chicken with rice)',
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
      'cholesterol': 'Cholesterol',
      'saveToHistory': 'Save to history',
      'mealHistory': 'Meal history',
      'noMealsPlaceholder':
          'No meals recorded yet. Add your first meal to start tracking.',
      'mealSavedMessage': 'Meal saved to your log.',
      'remainingCaloriesMessage':
          'You can still enjoy {remaining} kcal within your goal.',
      'calorieGoalReached': 'Nice work! You have reached your calorie target.',
      'accountCreated': 'Account created. Let\'s personalize your plan.',
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
      'loginFailed': 'Incorrect email or password. Please try again.',
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
      'sleepEnterValidHours': 'Enter a valid number of hours between 0 and 24',
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
      'activityMinutesNumberError': 'Duration must be a positive number',
      'activityCaloriesNumberError': 'Calories must be a positive number',
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
      'medicineDurationNumberError': 'Duration must be a positive number',
      'generalError': 'Something went wrong. Please try again.',
      'splashTitle': 'Health Sync',
      'splashLoading': 'Loading...',
    },
    'ar': {
      'hederaBadge': 'Hedera sync',
      'hederaBadgeShort': 'Hedera',
      'heartRate': 'Heart rate',
      'healthRecordedAt': 'Recorded at {time}',
      'healthRecommendationHeading': 'AI recommendation',
      'healthRecommendationFallback':
          'No recommendation provided yet. Log a new reading to receive guidance.',
      'activitySummaryTitle': 'Summary',
      'activitySummaryCalories': 'Calories burned: {calories}',
      'activitySummaryMinutes': 'Total minutes: {minutes}',
      'activitySummarySessions': 'Sessions logged: {count}',
      'activitySummaryTip':
          'Stay consistent and mix light and intense workouts to balance your week.',
      'activityHistoryTitle': 'Recent sessions',
      'activityHistoryEmpty':
          'No workouts recorded yet. Add your first activity to begin tracking.',
      'activitySessionDetail': '{minutes} min | {calories} kcal',
      'activitySavedMessage': 'Activity saved to your log.',
      'sleepHistoryTitle': 'History',
      'sleepHistoryEmpty':
          'No sleep sessions logged yet. Add your first sleep record.',
      'sleepAddSessionButton': 'Add sleep session',
      'sleepSummaryLastSession': 'Last session: {hours} hours',
      'sleepSummaryNoData': 'No sleep data recorded yet',
      'sleepSummaryAverage': 'Average duration: {hours} hours',
      'sleepSummaryWeek': 'Past 7 days total: {hours} hours',
      'sleepLatestRecommendation': 'Latest AI tip',
      'historySyncedViaHedera': 'Synced via Hedera mirror',
      'historyRecordedOn': 'Recorded on {date}',
      'historyFoodTitle': 'Meal logged: {name}',
      'historyFoodSubtitle':
          '{calories} kcal | {protein} g protein | {carbs} g carbs',
      'historySleepTitle': 'Sleep session: {hours} h',
      'historySleepRecommendation': 'Recommendation: {tip}',
      'historySleepRecommendationPending': 'Recommendation pending',
      'historyActivityTitle': 'Activity: {name}',
      'historyActivitySubtitle': '{minutes} min | {calories} kcal burned',
      'historyMedicineTitle': 'Medication: {name}',
      'historyMedicineSubtitle':
          '{dosage} | {frequency}x per day | {duration} days{taken}',
      'historyMedicineTakenSuffix': ' | taken',
      'historyHealthTitle': 'Health reading',
      'historyHealthSubtitle':
          'Blood pressure: {bloodPressure} mmHg | Heart rate: {heartRate} bpm',
      'historyHealthRecommendation': 'AI insight: {tip}',
      'historyHealthRecommendationPending': 'AI insight pending',
      'historyEmptyTitle': 'No activity recorded yet.',
      'historyEmptyDescription':
          'Log meals, sleep, workouts or medication to build your personal history.',
      'historyStartTracking': 'Start tracking',
      'healthResultTitle': 'Health analysis',
      'healthResultRecordedOn': 'Recorded on {timestamp}',
      'healthStatusLow': 'Low blood pressure',
      'healthStatusHealthy': 'Healthy range',
      'healthStatusElevated': 'Elevated',
      'healthStatusHigh': 'High blood pressure',
      'healthVitalBloodPressure': 'Blood pressure',
      'healthVitalSugar': 'Blood sugar',
      'healthVitalHeartRate': 'Heart rate',
      'aiAnalysisTitle': 'AI Analysis',
      'aiRecommendationTitle': 'AI Recommendation',
      'aiTipTitle': 'AI Tip',
      'backToHomeButton': 'Back to home',
      'medicineResultTitle': 'Medication insights',
      'medicineResultDosage': 'Dosage: {dosage}',
      'medicineResultFrequency': 'Frequency per day',
      'medicineResultDuration': 'Course length',
      'medicineResultFrequencyValue': '{count}×',
      'medicineResultDurationValue': '{days} days',
      'medicineResultDone': 'Done',
      'appTitle': 'Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø©',
      'languageEnglish': 'Ø§Ù„Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ©',
      'languageArabic': 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
      'settings': 'Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª',
      'applicationSection': 'Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
      'appLanguage': 'Ù„ØºØ© Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
      'notificationsToggle': 'ØªÙØ¹ÙŠÙ„ Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª',
      'darkModeToggle': 'Ø§Ù„ÙˆØ¶Ø¹ Ø§Ù„Ø¯Ø§ÙƒÙ†',
      'supportSection': 'Ø§Ù„Ø¯Ø¹Ù…',
      'contactSupport': 'Ø§Ù„ØªÙˆØ§ØµÙ„ Ù…Ø¹ Ø§Ù„Ø¯Ø¹Ù…',
      'contactSupportMessage':
          'Ø³ÙŠÙƒÙˆÙ† Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¯Ø¹Ù… Ù…ØªØ§Ø­Ù‹Ø§ Ù‚Ø±ÙŠØ¨Ù‹Ø§.',
      'rateApp': 'Ù‚ÙŠÙ‘Ù… Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
      'rateAppMessage':
          'Ø³ÙŠÙƒÙˆÙ† Ø§Ù„ØªÙ‚ÙŠÙŠÙ… ÙÙŠ Ø§Ù„Ù…ØªØ¬Ø± Ù…ØªØ§Ø­Ù‹Ø§ Ø¨Ø¹Ø¯ Ø§Ù„Ø¥Ø·Ù„Ø§Ù‚.',
      'themeLightBackground': 'ÙØ§ØªØ­',
      'themeDarkBackground': 'Ø¯Ø§ÙƒÙ†',
      'back': 'Ø±Ø¬ÙˆØ¹',
      'next': 'Ø§Ù„ØªØ§Ù„ÙŠ',
      'snackInvalidHeight':
          'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø·ÙˆÙ„ ØµØ§Ù„Ø­ Ø¨Ø§Ù„Ø³Ù†ØªÙŠÙ…ØªØ±',
      'snackInvalidWeight':
          'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ ÙˆØ²Ù† ØµØ§Ù„Ø­ Ø¨Ø§Ù„ÙƒÙŠÙ„ÙˆØºØ±Ø§Ù…',
      'snackSelectGender': 'ÙŠØ±Ø¬Ù‰ Ø§Ø®ØªÙŠØ§Ø± Ø¬Ù†Ø³ÙƒÙ…',
      'snackSelectDiabetes':
          'Ø£Ø®Ø¨Ø±Ù†Ø§ Ø¥Ø°Ø§ ÙƒÙ†Øª Ù…ØµØ§Ø¨Ù‹Ø§ Ø¨Ø§Ù„Ø³ÙƒØ±ÙŠ',
      'snackSelectHypertension':
          'Ø£Ø®Ø¨Ø±Ù†Ø§ Ø¥Ø°Ø§ ÙƒÙ†Øª Ù…ØµØ§Ø¨Ù‹Ø§ Ø¨Ø§Ø±ØªÙØ§Ø¹ Ø§Ù„Ø¶ØºØ·',
      'snackSelectGoal': 'Please continue to the summary',
      'summaryTitle': 'Ø§Ù„Ù…Ù„Ø®Øµ',
      'dailySnapshot': 'Ù†Ø¸Ø±Ø© ÙŠÙˆÙ…ÙŠØ©',
      'dailySnapshotDetails':
          'Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø§Ù„Ø­Ø±Ø§Ø±ÙŠØ© Ø§Ù„Ù…Ø³ØªÙ‡Ù„ÙƒØ© Ø§Ù„ÙŠÙˆÙ…: {calories}\nØ³Ø§Ø¹Ø§Øª Ø§Ù„Ù†ÙˆÙ… Ø§Ù„Ù…Ø³Ø¬Ù„Ø© Ù‡Ø°Ø§ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹: {sleep}\nØ¯Ù‚Ø§Ø¦Ù‚ Ø§Ù„Ù†Ø´Ø§Ø· Ù‡Ø°Ø§ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹: {activity}',
      'home': 'Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠØ©',
      'dashboard': 'Ù„ÙˆØ­Ø© Ø§Ù„ØªØ­ÙƒÙ…',
      'profile': 'Ø§Ù„Ù…Ù„Ù Ø§Ù„Ø´Ø®ØµÙŠ',
      'history': 'Ø§Ù„Ø³Ø¬Ù„',
      'settingsLabel': 'Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª',
      'logout': 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬',
      'openSettings': 'ÙØªØ­ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª',
      'welcomeBack': 'Ø£Ù‡Ù„Ù‹Ø§ Ø¨Ø¹ÙˆØ¯ØªÙƒ',
      'welcomeBackMessage':
          'Ø§Ø³ØªÙ…Ø± Ø¨ØªØ³Ø¬ÙŠÙ„ Ø¹Ø§Ø¯Ø§ØªÙƒ ÙˆØ¯Ø¹ Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø© ØªØ±Ø´Ø¯ Ù†Ù…Ø·Ùƒ Ø§Ù„ÙŠÙˆÙ…ÙŠ.',
      'mealsNutrition': 'Ø§Ù„ÙˆØ¬Ø¨Ø§Øª ÙˆØ§Ù„ØªØºØ°ÙŠØ©',
      'todayOverview': 'Ù†Ø¸Ø±Ø© Ø¹Ø§Ù…Ø© Ø§Ù„ÙŠÙˆÙ…',
      'foodLog': 'Ø³Ø¬Ù„ Ø§Ù„Ø·Ø¹Ø§Ù…',
      'sleepTracking': 'ØªØªØ¨Ø¹ Ø§Ù„Ù†ÙˆÙ…',
      'activityTracking': 'ØªØªØ¨Ø¹ Ø§Ù„Ù†Ø´Ø§Ø·',
      'medication': 'Ø§Ù„Ø£Ø¯ÙˆÙŠØ©',
      'vitalsHealth': 'Ø§Ù„Ø¹Ù„Ø§Ù…Ø§Øª Ø§Ù„Ø­ÙŠÙˆÙŠØ© ÙˆØ§Ù„ØµØ­Ø©',
      'caloriesConsumed': 'Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø§Ù„Ø­Ø±Ø§Ø±ÙŠØ©',
      'hoursSlept': 'Ø³Ø§Ø¹Ø§Øª Ø§Ù„Ù†ÙˆÙ…',
      'activityMinutes': 'Ø¯Ù‚Ø§Ø¦Ù‚ Ø§Ù„Ù†Ø´Ø§Ø·',
      'addMeal': 'Ø¥Ø¶Ø§ÙØ© ÙˆØ¬Ø¨Ø©',
      'mealName': 'Ø§Ø³Ù… Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'mealNameHint': 'Ù…Ø§Ø°Ø§ Ø£ÙƒÙ„ØªØŸ',
      'mealCalories': 'Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø§Ù„ØªÙ‚Ø¯ÙŠØ±ÙŠØ© (Ø³Ø¹Ø±Ø©)',
      'mealCaloriesHint': 'Ø£Ø¯Ø®Ù„ Ø§Ù„Ø³Ø¹Ø±Ø§Øª',
      'mealAnalyse': 'ØªØ­Ù„ÙŠÙ„ Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'mealNameError': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ù…Ø§ ØªÙ†Ø§ÙˆÙ„ØªÙ‡',
      'mealCaloriesErrorEmpty': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ ØªÙ‚Ø¯ÙŠØ± Ø§Ù„Ø³Ø¹Ø±Ø§Øª',
      'mealCaloriesErrorNumber':
          'ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø±Ù‚Ù…Ù‹Ø§',
      'mealDescriptionLabel': 'ÙˆØµÙ Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'mealDescriptionHint':
          'Ù…Ø«Ø§Ù„: Ø³Ø§Ù†Ø¯ÙˆÙŠØªØ´ Ø¯Ø¬Ø§Ø¬ Ù…Ø¹ Ø³Ù„Ø·Ø©',
      'mealDescriptionError': 'ÙŠØ±Ø¬Ù‰ ÙˆØµÙ Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'mealTypeLabel': 'Ù†ÙˆØ¹ Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'mealType_breakfast': 'ÙØ·ÙˆØ±',
      'mealType_lunch': 'ØºØ¯Ø§Ø¡',
      'mealType_dinner': 'Ø¹Ø´Ø§Ø¡',
      'drinkLabel': 'Ù…Ø´Ø±ÙˆØ¨',
      'dessertLabel': 'ØªØ­Ù„ÙŠØ©',
      'optional': 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ',
      'water': 'Ù…Ø§Ø¡',
      'coffee': 'Ù‚Ù‡ÙˆØ©',
      'tea': 'Ø´Ø§ÙŠ',
      'juice': 'Ø¹ØµÙŠØ±',
      'fruit': 'ÙØ§ÙƒÙ‡Ø©',
      'cake': 'ÙƒÙŠÙƒ',
      'iceCream': 'Ø¢ÙŠØ³ ÙƒØ±ÙŠÙ…',
      'none': 'Ø¨Ø¯ÙˆÙ†',
      'mealAnalysis': 'ØªØ­Ù„ÙŠÙ„ Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'analysingMealPlaceholder': 'Ù†Ù‚ÙˆÙ… Ø¨Ù…Ø±Ø§Ø¬Ø¹Ø© ÙˆØ¬Ø¨ØªÙƒ...',
      'calories': 'Ø§Ù„Ø³Ø¹Ø±Ø§Øª',
      'protein': 'Ø§Ù„Ø¨Ø±ÙˆØªÙŠÙ†',
      'carbs': 'Ø§Ù„ÙƒØ±Ø¨ÙˆÙ‡ÙŠØ¯Ø±Ø§Øª',
      'fats': 'Ø§Ù„Ø¯Ù‡ÙˆÙ†',
      'saveToHistory': 'Ø­ÙØ¸ ÙÙŠ Ø§Ù„Ø³Ø¬Ù„',
      'mealHistory': 'Ø³Ø¬Ù„ Ø§Ù„ÙˆØ¬Ø¨Ø§Øª',
      'noMealsPlaceholder':
          'Ù„Ù… ÙŠØªÙ… ØªØ³Ø¬ÙŠÙ„ Ø£ÙŠ ÙˆØ¬Ø¨Ø§Øª Ø¨Ø¹Ø¯. Ø£Ø¶Ù Ø£ÙˆÙ„ ÙˆØ¬Ø¨Ø© Ù„Ù„Ø¨Ø¯Ø¡.',
      'mealSavedMessage': 'ØªÙ… Ø­ÙØ¸ Ø§Ù„ÙˆØ¬Ø¨Ø© ÙÙŠ Ø§Ù„Ø³Ø¬Ù„.',
      'remainingCaloriesMessage':
          'Ù„Ø§ ÙŠØ²Ø§Ù„ Ø¨Ø¥Ù…ÙƒØ§Ù†Ùƒ ØªÙ†Ø§ÙˆÙ„ {remaining} Ø³Ø¹Ø±Ø© Ø¶Ù…Ù† Ù‡Ø¯ÙÙƒ.',
      'calorieGoalReached':
          'Ø¹Ù…Ù„ Ø±Ø§Ø¦Ø¹! Ù„Ù‚Ø¯ Ø­Ù‚Ù‚Øª Ù‡Ø¯ÙÙƒ Ù…Ù† Ø§Ù„Ø³Ø¹Ø±Ø§Øª.',
      'accountCreated': 'ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„Ø­Ø³Ø§Ø¨. Ù„Ù†Ø®ØµØµ Ø®Ø·ØªÙƒ.',
      'signIn': 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„',
      'createAccount': 'Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨',
      'registerTitle':
          'Ø£Ù†Ø´Ø¦ Ø­Ø³Ø§Ø¨ Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø© Ø§Ù„Ø®Ø§Øµ Ø¨Ùƒ',
      'fullName': 'Ø§Ù„Ø§Ø³Ù… Ø§Ù„ÙƒØ§Ù…Ù„',
      'emailAddress': 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
      'password': 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
      'createPassword': 'Ø¥Ù†Ø´Ø§Ø¡ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
      'nameRequired': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù…Ùƒ',
      'passwordRule':
          'ÙŠØ¬Ø¨ Ø£Ù„Ø§ ØªÙ‚Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø¹Ù† 6 Ø£Ø­Ø±Ù',
      'alreadyHaveAccount': 'Ù„Ø¯ÙŠÙƒ Ø­Ø³Ø§Ø¨ Ù…Ø³Ø¨Ù‚Ù‹Ø§ØŸ',
      'dontHaveAccount': 'Ù„ÙŠØ³ Ù„Ø¯ÙŠÙƒ Ø­Ø³Ø§Ø¨ØŸ',
      'loginTitle': 'Ø³Ø¬Ù‘Ù„ Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø¥Ù„Ù‰ Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø©',
      'loginButton': 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„',
      'emailRequired': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø¨Ø±ÙŠØ¯Ùƒ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
      'passwordRequired': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
      'loginFailed':
          'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø£Ùˆ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ØºÙŠØ± ØµØ­ÙŠØ­Ø©. Ø­Ø§ÙˆÙ„ Ù…Ø¬Ø¯Ø¯Ù‹Ø§.',
      'heightQuestion': 'Ù…Ø§ Ø·ÙˆÙ„ÙƒØŸ',
      'heightLabel': 'Ø§Ù„Ø·ÙˆÙ„ (Ø³Ù…)',
      'heightHint': 'Ù…Ø«Ø§Ù„: 170',
      'weightQuestion': 'Ù…Ø§ ÙˆØ²Ù†ÙƒØŸ',
      'weightLabel': 'Ø§Ù„ÙˆØ²Ù† (ÙƒØ¬Ù…)',
      'weightHint': 'Ù…Ø«Ø§Ù„: 70',
      'genderQuestion': 'ÙƒÙŠÙ ØªÙØ¹Ø±Ù‘Ù Ù†ÙØ³ÙƒØŸ',
      'genderMale': 'Ø°ÙƒØ±',
      'genderFemale': 'Ø£Ù†Ø«Ù‰',
      'genderOther': 'Ø£ÙØ¶Ù„ Ø¹Ø¯Ù… Ø§Ù„Ø¥ÙØµØ§Ø­',
      'diabetesQuestion': 'Ù‡Ù„ ØªØ¹Ø§Ù†ÙŠ Ù…Ù† Ø§Ù„Ø³ÙƒØ±ÙŠØŸ',
      'diabetesDescription':
          'ÙŠØ³Ø§Ø¹Ø¯Ù†Ø§ Ø°Ù„Ùƒ Ø¹Ù„Ù‰ ØªØ®ØµÙŠØµ Ø§Ù„ØªØºØ°ÙŠØ© ÙˆØªØ°ÙƒÙŠØ±Ø§Øª Ø§Ù„Ø£Ø¯ÙˆÙŠØ© Ø­Ø³Ø¨ Ø§Ø­ØªÙŠØ§Ø¬Ø§ØªÙƒ.',
      'optionYes': 'Ù†Ø¹Ù…',
      'optionNo': 'Ù„Ø§',
      'hypertensionQuestion': 'Ù‡Ù„ ØªØ¹Ø§Ù†ÙŠ Ù…Ù† Ø§Ø±ØªÙØ§Ø¹ Ø§Ù„Ø¶ØºØ·ØŸ',
      'hypertensionDescription':
          'Ù†Ø³ØªØ®Ø¯Ù… Ù‡Ø°Ù‡ Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ù„ØªØ®ØµÙŠØµ Ø§Ù„ØªØ°ÙƒÙŠØ±Ø§Øª ÙˆÙ†ØµØ§Ø¦Ø­ Ø§Ù„ØµØ­Ø©.',
      'goalQuestion': 'Ready to finalise your setup?',
      'goalLoseWeight': 'Healthy lifestyle focus',
      'goalMaintain': 'Stay consistent',
      'goalGain': 'Build lasting energy',
      'summaryScreenTitle': 'Ù…Ù„Ø®Øµ Ø§Ù„Ø¹Ø§ÙÙŠØ© Ø§Ù„Ø®Ø§Øµ Ø¨Ùƒ',
      'viewSummary': 'Ø¹Ø±Ø¶ Ø§Ù„Ù…Ù„Ø®Øµ',
      'summaryGreeting': 'Ø§Ù‚ØªØ±Ø¨Ù†Ø§ ÙŠØ§ {name}!',
      'summaryDescription':
          'Ø±Ø§Ø¬Ø¹ Ø¨ÙŠØ§Ù†Ø§ØªÙƒ Ù‚Ø¨Ù„ Ø£Ù† Ù†Ø®ØµØµ ØªØ¬Ø±Ø¨Ø© Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø© Ù„Ùƒ.',
      'finishSetup': 'Ø¥ÙƒÙ…Ø§Ù„ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯',
      'backToEdit': 'Ø§Ù„Ø¹ÙˆØ¯Ø© Ù„Ù„ØªØ¹Ø¯ÙŠÙ„',
      'ageLabel': 'Ø§Ù„Ø¹Ù…Ø±',
      'heightShort': 'Ø§Ù„Ø·ÙˆÙ„',
      'weightShort': 'Ø§Ù„ÙˆØ²Ù†',
      'genderLabel': 'Ø§Ù„Ø¬Ù†Ø³',
      'diabetesLabel': 'Ø§Ù„Ø³ÙƒØ±ÙŠ',
      'hypertensionLabel': 'Ø§Ø±ØªÙØ§Ø¹ Ø§Ù„Ø¶ØºØ·',
      'defaultDisplayName': 'Ø¹Ø¶Ùˆ Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø©',
      'ageValue': '{age} Ø³Ù†Ø©',
      'heightValue': '{height} Ø³Ù…',
      'weightValue': '{weight} ÙƒØ¬Ù…',
      'ageQuestion': 'ÙƒÙ… Ø¹Ù…Ø±ÙƒØŸ',
      'finish': 'Ø¥Ù†Ù‡Ø§Ø¡',
      'startTracking': 'Ø§Ø¨Ø¯Ø£ Ø§Ù„ØªØªØ¨Ø¹',
      'sleepTitle': 'ØªØªØ¨Ø¹ Ø§Ù„Ù†ÙˆÙ…',
      'sleepAddEntry': 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ù†ÙˆÙ…',
      'sleepHours': 'Ø³Ø§Ø¹Ø§Øª Ø§Ù„Ù†ÙˆÙ…',
      'sleepNotes': 'Ù…Ù„Ø§Ø­Ø¸Ø§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)',
      'sleepSubmit': 'ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ù†ÙˆÙ…',
      'sleepHoursError': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø¹Ø¯Ø¯ Ø³Ø§Ø¹Ø§Øª Ø§Ù„Ù†ÙˆÙ…',
      'sleepEnterValidHours': 'Ø£Ø¯Ø®Ù„ Ø¹Ø¯Ø¯ Ø³Ø§Ø¹Ø§Øª Ø¨ÙŠÙ† 0 Ùˆ 24',
      'sleepResultTitle': 'ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ù†ÙˆÙ…',
      'sleepResultSummary': 'Ø§Ù„Ù…Ù„Ø®Øµ',
      'sleepResultRecommendation': 'Ø§Ù„ØªÙˆØµÙŠØ§Øª',
      'sleepResultBack': 'Ø§Ù„Ø¹ÙˆØ¯Ø© Ù„ØªØªØ¨Ø¹ Ø§Ù„Ù†ÙˆÙ…',
      'activitySummary': 'Ø§Ù„Ù…Ù„Ø®Øµ',
      'activityAdvice':
          'Ø­Ø§ÙØ¸ Ø¹Ù„Ù‰ Ø§Ù„Ø§Ø³ØªÙ…Ø±Ø§Ø±ÙŠØ© ÙˆÙˆØ§Ø²Ù† Ø¨ÙŠÙ† Ø§Ù„ØªÙ…Ø§Ø±ÙŠÙ† Ø§Ù„Ø®ÙÙŠÙØ© ÙˆØ§Ù„Ù…ÙƒØ«ÙØ© Ø®Ù„Ø§Ù„ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹.',
      'recentSessions': 'Ø§Ù„Ø¬Ù„Ø³Ø§Øª Ø§Ù„Ø£Ø®ÙŠØ±Ø©',
      'noWorkouts':
          'Ù„Ø§ ØªÙˆØ¬Ø¯ ØªÙ…Ø§Ø±ÙŠÙ† Ù…Ø³Ø¬Ù„Ø© Ø¨Ø¹Ø¯. Ø£Ø¶Ù Ù†Ø´Ø§Ø·Ùƒ Ø§Ù„Ø£ÙˆÙ„ Ù„Ù„Ø¨Ø¯Ø¡ Ø¨Ø§Ù„ØªØªØ¨Ø¹.',
      'activitySaved': 'ØªÙ… Ø­ÙØ¸ Ø§Ù„Ù†Ø´Ø§Ø· ÙÙŠ Ø³Ø¬Ù„Ùƒ.',
      'activityName': 'Ø§Ø³Ù… Ø§Ù„Ù†Ø´Ø§Ø·',
      'activityMinutesLabel': 'Ø§Ù„Ù…Ø¯Ø© (Ø¯Ù‚Ø§Ø¦Ù‚)',
      'activityCaloriesLabel': 'Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø§Ù„ØªÙ‚Ø¯ÙŠØ±ÙŠØ© (Ø³Ø¹Ø±Ø©)',
      'activitySave': 'Ø­ÙØ¸ Ø§Ù„Ù†Ø´Ø§Ø·',
      'activityNameError': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù… Ø§Ù„Ù†Ø´Ø§Ø·',
      'activityMinutesError':
          'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ù…Ø¯Ø© Ø§Ù„ØªÙ…Ø±ÙŠÙ† Ø¨Ø§Ù„Ø¯Ù‚Ø§Ø¦Ù‚',
      'activityCaloriesError': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ ØªÙ‚Ø¯ÙŠØ± Ø§Ù„Ø³Ø¹Ø±Ø§Øª',
      'activityMinutesNumberError':
          'ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† Ø§Ù„Ù…Ø¯Ø© Ø±Ù‚Ù…Ù‹Ø§ Ù…ÙˆØ¬Ø¨Ù‹Ø§',
      'activityCaloriesNumberError':
          'ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø±Ù‚Ù…Ù‹Ø§ Ù…ÙˆØ¬Ø¨Ù‹Ø§',
      'sleepAnalysisLoading': 'Ø¬Ø§Ø±ÙŠ ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ù†ÙˆÙ…...',
      'activityAnalysisLoading':
          'Ø¬Ø§Ø±ÙŠ Ù…Ø¹Ø§Ù„Ø¬Ø© Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ù†Ø´Ø§Ø·...',
      'foodAnalysisLoading': 'Ø¬Ø§Ø±ÙŠ ØªØ­Ù„ÙŠÙ„ ÙˆØ¬Ø¨ØªÙƒ...',
      'foodAnalysisTitle': 'Ø±Ø¤Ù‰ Ø§Ù„ÙˆØ¬Ø¨Ø©',
      'foodSummary': 'Ø§Ù„Ù…Ù„Ø®Øµ',
      'foodMacros': 'Ø§Ù„Ø¹Ù†Ø§ØµØ± Ø§Ù„ØºØ°Ø§Ø¦ÙŠØ©',
      'foodRecommendations': 'Ø§Ù„ØªÙˆØµÙŠØ§Øª',
      'foodAddTitle': 'Ø¥Ø¶Ø§ÙØ© ÙˆØ¬Ø¨Ø©',
      'profileTitle': 'Ø§Ù„Ù…Ù„Ù Ø§Ù„Ø´Ø®ØµÙŠ',
      'historyTitle': 'Ø§Ù„Ø³Ø¬Ù„',
      'dashboardTitle': 'Ù„ÙˆØ­Ø© Ø§Ù„ØªØ­ÙƒÙ…',
      'medicineTitle': 'Ø§Ù„Ø£Ø¯ÙˆÙŠØ©',
      'medicineAddTitle': 'Ø¥Ø¶Ø§ÙØ© Ø¯ÙˆØ§Ø¡',
      'medicineDisease': 'Ø§Ù„Ø­Ø§Ù„Ø©',
      'medicineName': 'Ø§Ø³Ù… Ø§Ù„Ø¯ÙˆØ§Ø¡',
      'medicineDuration': 'Ø§Ù„Ù…Ø¯Ø© (Ø£ÙŠØ§Ù…)',
      'medicineTime': 'ÙˆÙ‚Øª Ø§Ù„ØªØ°ÙƒÙŠØ±',
      'medicineReminder': 'ØªÙØ¹ÙŠÙ„ Ø§Ù„ØªØ°ÙƒÙŠØ±',
      'medicineSave': 'Ø­ÙØ¸ Ø§Ù„Ø¯ÙˆØ§Ø¡',
      'medicineDiseaseError': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ø­Ø§Ù„Ø© Ø§Ù„Ù…Ø±Ø¶ÙŠØ©',
      'medicineNameError': 'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù… Ø§Ù„Ø¯ÙˆØ§Ø¡',
      'medicineDurationError':
          'Ø£Ø¯Ø®Ù„ Ø¹Ø¯Ø¯ Ø§Ù„Ø£ÙŠØ§Ù… Ù„ØªÙ†Ø§ÙˆÙ„ Ø§Ù„Ø¯ÙˆØ§Ø¡',
      'medicineDurationNumberError':
          'ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† Ø§Ù„Ù…Ø¯Ø© Ø±Ù‚Ù…Ù‹Ø§ Ù…ÙˆØ¬Ø¨Ù‹Ø§',
      'generalError': 'Ø­Ø¯Ø« Ø®Ø·Ø£ Ù…Ø§. Ø­Ø§ÙˆÙ„ Ù…Ø±Ø© Ø£Ø®Ø±Ù‰.',
      'splashTitle': 'Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„ØµØ­Ø©',
      'splashLoading': 'Ø¬Ø§Ø±Ù Ø§Ù„ØªØ­Ù…ÙŠÙ„...',
    },
  };

  String translate(String key) {
    final languageCode = supportedLocales
            .any((locale) => locale.languageCode == this.locale.languageCode)
        ? locale.languageCode
        : 'en';
    final localeMap = _localizedValues[languageCode] ?? _localizedValues['en']!;
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
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
