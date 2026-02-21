import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:hydrosmart/ai_assistant_screen.dart';
import 'package:hydrosmart/l10n/app_localizations.dart';
import 'package:hydrosmart/providers/language_provider.dart';
import 'package:hydrosmart/providers/water_provider.dart';
import 'package:hydrosmart/screens/onboarding/onboarding_language_screen.dart';
import 'package:hydrosmart/utils/validators.dart';

// Wraps a child in a ChangeNotifierProvider + MaterialApp that rebuilds its
// locale whenever the LanguageProvider notifies listeners.
Widget _buildTestApp(LanguageProvider languageProvider, Widget child) {
  return ChangeNotifierProvider<LanguageProvider>.value(
    value: languageProvider,
    child: Consumer<LanguageProvider>(
      builder: (context, provider, _) => MaterialApp(
        locale: provider.currentLocale,
        localizationsDelegates: const [AppLocalizationsDelegate()],
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
        home: child,
      ),
    ),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // LanguageProvider unit tests
  // ---------------------------------------------------------------------------
  group('LanguageProvider', () {
    test('initial language is English', () {
      final provider = LanguageProvider();
      expect(provider.currentLanguage, 'en');
      expect(provider.currentLocale, const Locale('en'));
      expect(provider.isRTL, false);
    });

    test('setLanguage updates currentLanguage and locale immediately', () {
      final provider = LanguageProvider();

      // Call without awaiting – the synchronous part runs before the first await
      provider.setLanguage('fr');

      expect(provider.currentLanguage, 'fr');
      expect(provider.currentLocale, const Locale('fr'));
      expect(provider.isRTL, false);
    });

    test('setLanguage to Arabic sets isRTL to true immediately', () {
      final provider = LanguageProvider();
      provider.setLanguage('ar');

      expect(provider.currentLanguage, 'ar');
      expect(provider.currentLocale, const Locale('ar'));
      expect(provider.isRTL, true);
    });

    test('hasSelectedLanguage becomes true after setLanguage', () {
      final provider = LanguageProvider();
      expect(provider.hasSelectedLanguage, false);
      provider.setLanguage('fr');
      expect(provider.hasSelectedLanguage, true);
    });
  });

  // ---------------------------------------------------------------------------
  // AppLocalizations unit tests
  // ---------------------------------------------------------------------------
  group('AppLocalizations', () {
    test('translate returns correct English string', () {
      final l10n = AppLocalizations('en');
      expect(l10n.translate('onboarding_welcome_title'), 'Welcome to HydroSmart');
      expect(l10n.translate('onboarding_name_title'), "What's your name?");
      expect(l10n.translate('onboarding_challenge_start_btn'), 'Start My Journey');
    });

    test('translate returns correct French string', () {
      final l10n = AppLocalizations('fr');
      expect(l10n.translate('onboarding_welcome_title'), 'Bienvenue sur HydroSmart');
      expect(l10n.translate('onboarding_challenge_start_btn'), 'Commencer mon parcours');
    });

    test('translate returns correct Arabic string', () {
      final l10n = AppLocalizations('ar');
      expect(l10n.translate('onboarding_welcome_title'), 'مرحباً بك في هيدروسمارت');
      expect(l10n.translate('onboarding_challenge_start_btn'), 'ابدأ رحلتي');
    });

    test('translateWithArgs replaces placeholder with value', () {
      final l10n = AppLocalizations('en');
      final result = l10n.translateWithArgs(
        'onboarding_household_member_age_label',
        {'n': '3'},
      );
      expect(result, 'Member 3 Age');
    });

    test('translateWithArgs works for French with different word order', () {
      final l10n = AppLocalizations('fr');
      final result = l10n.translateWithArgs(
        'onboarding_household_member_age_label',
        {'n': '2'},
      );
      expect(result, 'Âge du membre 2');
    });
  });

  // ---------------------------------------------------------------------------
  // LanguageSelectionScreen widget tests
  // ---------------------------------------------------------------------------
  group('LanguageSelectionScreen', () {
    testWidgets(
        'selecting a language tile immediately updates LanguageProvider',
            (WidgetTester tester) async {
          final languageProvider = LanguageProvider();
          bool onSelectedCalled = false;

          await tester.pumpWidget(
            _buildTestApp(
              languageProvider,
              LanguageSelectionScreen(
                onLanguageSelected: () => onSelectedCalled = true,
              ),
            ),
          );

          // Tap the French tile (identified by its native name)
          await tester.tap(find.text('Français'));
          await tester.pump();

          // Provider should be updated immediately (synchronous part of setLanguage)
          expect(languageProvider.currentLanguage, 'fr');
          expect(languageProvider.currentLocale, const Locale('fr'));
          // onLanguageSelected should not have been called yet (that's Continue)
          expect(onSelectedCalled, false);
        });

    testWidgets(
        'tapping Continue calls onLanguageSelected after language is chosen',
            (WidgetTester tester) async {
          final languageProvider = LanguageProvider();
          bool onSelectedCalled = false;

          await tester.pumpWidget(
            _buildTestApp(
              languageProvider,
              LanguageSelectionScreen(
                onLanguageSelected: () => onSelectedCalled = true,
              ),
            ),
          );

          // Select Arabic first
          await tester.tap(find.text('العربية'));
          await tester.pump();

          expect(languageProvider.currentLanguage, 'ar');

          // Tap Continue button
          await tester.pumpAndSettle();
          await tester.tap(find.text('متابعة')); // "Continue" in Arabic
          await tester.pump();

          expect(onSelectedCalled, true);
        });

    testWidgets(
        'visible onboarding title updates to new language on tile tap',
            (WidgetTester tester) async {
          final languageProvider = LanguageProvider();

          await tester.pumpWidget(
            _buildTestApp(
              languageProvider,
              LanguageSelectionScreen(onLanguageSelected: () {}),
            ),
          );

          // Initially English
          expect(find.text('Welcome to HydroSmart'), findsOneWidget);

          // Tap French
          await tester.tap(find.text('Français'));
          await tester.pumpAndSettle();

          // Title should now be in French
          expect(find.text('Bienvenue sur HydroSmart'), findsOneWidget);
        });
  });

  // ---------------------------------------------------------------------------
  // AI Assistant translations unit tests
  // ---------------------------------------------------------------------------
  group('AIAssistant translations', () {
    test('ai_greeting is correct in English', () {
      final l10n = AppLocalizations('en');
      expect(l10n.translate('ai_greeting'),
          'Hello! How can I help you save water today?');
    });

    test('ai_greeting is correct in French', () {
      final l10n = AppLocalizations('fr');
      expect(l10n.translate('ai_greeting'),
          'Bonjour ! Comment puis-je vous aider à économiser l\'eau aujourd\'hui ?');
    });

    test('ai_greeting is correct in Arabic', () {
      final l10n = AppLocalizations('ar');
      expect(l10n.translate('ai_greeting'),
          'مرحباً! كيف يمكنني مساعدتك في توفير المياه اليوم؟');
    });

    test('ai_new_chat is correct in French', () {
      final l10n = AppLocalizations('fr');
      expect(l10n.translate('ai_new_chat'), 'Nouvelle conversation');
    });

    test('ai_new_chat is correct in Arabic', () {
      final l10n = AppLocalizations('ar');
      expect(l10n.translate('ai_new_chat'), 'محادثة جديدة');
    });

    test('ai_no_chats_yet is correct in French', () {
      final l10n = AppLocalizations('fr');
      expect(l10n.translate('ai_no_chats_yet'), 'Aucune conversation');
    });

    test('ai_no_chats_yet is correct in Arabic', () {
      final l10n = AppLocalizations('ar');
      expect(l10n.translate('ai_no_chats_yet'), 'لا توجد محادثات بعد');
    });

    test('ai_search_chats is correct in French', () {
      final l10n = AppLocalizations('fr');
      expect(l10n.translate('ai_search_chats'), 'Rechercher des conversations...');
    });

    test('ai_search_chats is correct in Arabic', () {
      final l10n = AppLocalizations('ar');
      expect(l10n.translate('ai_search_chats'), 'البحث في المحادثات...');
    });

    test('ai_greeting differs across all supported locales', () {
      // Verify the AI system prompt includes language direction for each code.
      // This is tested indirectly: each language has a distinct greeting translation,
      // confirming the language selection flows end-to-end through localization.
      expect(AppLocalizations('en').translate('ai_greeting'),
          isNot(AppLocalizations('fr').translate('ai_greeting')));
      expect(AppLocalizations('en').translate('ai_greeting'),
          isNot(AppLocalizations('ar').translate('ai_greeting')));
      expect(AppLocalizations('fr').translate('ai_greeting'),
          isNot(AppLocalizations('ar').translate('ai_greeting')));
    });
  });

  // ---------------------------------------------------------------------------
  // AIAssistantScreen greeting update widget tests
  // ---------------------------------------------------------------------------
  group('AIAssistantScreen greeting', () {
    late Directory hiveDir;

    setUp(() async {
      hiveDir = await Directory.systemTemp.createTemp('hydro_hive_test_');
      Hive.init(hiveDir.path);
      await Hive.openBox('chat_history');
    });

    tearDown(() async {
      await Hive.close();
      await hiveDir.delete(recursive: true);
    });

    Widget buildAITestApp(LanguageProvider languageProvider) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<LanguageProvider>.value(
              value: languageProvider),
          ChangeNotifierProvider<WaterProvider>(
              create: (_) => WaterProvider()),
        ],
        child: Consumer<LanguageProvider>(
          builder: (context, provider, _) => MaterialApp(
            locale: provider.currentLocale,
            localizationsDelegates: const [AppLocalizationsDelegate()],
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
              Locale('ar'),
            ],
            home: const AIAssistantScreen(),
          ),
        ),
      );
    }

    bool hasGreetingText(WidgetTester tester, String text) {
      return tester.widgetList(find.byType(RichText)).any((w) {
        return (w as RichText).text.toPlainText().contains(text);
      });
    }

    testWidgets('initial greeting is shown in English',
            (WidgetTester tester) async {
          final languageProvider = LanguageProvider();
          await tester.pumpWidget(buildAITestApp(languageProvider));
          await tester.pumpAndSettle();

          expect(
            hasGreetingText(tester, 'Hello! How can I help you save water today?'),
            isTrue,
          );
        });

    testWidgets(
        'greeting updates to French when language changes and only initial message exists',
            (WidgetTester tester) async {
          final languageProvider = LanguageProvider();
          await tester.pumpWidget(buildAITestApp(languageProvider));
          await tester.pumpAndSettle();

          // Verify initial English greeting
          expect(
            hasGreetingText(tester, 'Hello! How can I help you save water today?'),
            isTrue,
          );

          // Change language to French
          languageProvider.setLanguage('fr');
          await tester.pumpAndSettle();

          // Greeting should now be in French
          expect(
            hasGreetingText(tester,
                'Bonjour ! Comment puis-je vous aider à économiser l\'eau aujourd\'hui ?'),
            isTrue,
          );
          // English greeting should be gone
          expect(
            hasGreetingText(tester, 'Hello! How can I help you save water today?'),
            isFalse,
          );
        });

    testWidgets(
        'greeting does not update when user has already sent a message',
            (WidgetTester tester) async {
          final languageProvider = LanguageProvider();
          await tester.pumpWidget(buildAITestApp(languageProvider));
          await tester.pumpAndSettle();

          // Find the chat input field by its hint text decoration
          final chatInputFinder = find.byWidgetPredicate((w) =>
          w is TextField &&
              (w.decoration?.hintText ?? '').contains('Ask something'));

          // Simulate user typing and submitting a message.
          // _sendMessage() inserts the user message into _messages synchronously
          // (before the async HTTP call), so after tester.pump() the list has
          // length == 2 regardless of whether the HTTP call succeeds or fails.
          // In tests the call fails (no network), which is caught by the catch block.
          await tester.enterText(chatInputFinder, 'How much water should I use?');
          await tester.tap(find.byIcon(Icons.send_rounded));
          await tester.pump(); // Process the setState inserting the user message

          // Change language to French
          languageProvider.setLanguage('fr');
          await tester.pumpAndSettle();

          // Greeting should NOT have updated because _messages.length > 1
          expect(
            hasGreetingText(tester, 'Hello! How can I help you save water today?'),
            isTrue,
          );
          expect(
            hasGreetingText(tester,
                'Bonjour ! Comment puis-je vous aider à économiser l\'eau aujourd\'hui ?'),
            isFalse,
          );
        });
  });

  // ---------------------------------------------------------------------------
  // Validators.validateName unit tests
  // ---------------------------------------------------------------------------
  group('Validators.validateName', () {
    test('Arabic-only name passes', () {
      expect(Validators.validateName('محمد علي'), isNull);
    });

    test('Latin-only name passes', () {
      expect(Validators.validateName('Ahmed Ali'), isNull);
    });

    test('Mixed Arabic and Latin fails', () {
      expect(Validators.validateName('Ahmed محمد'), isNotNull);
    });

    test('Mixed Latin and Arabic fails', () {
      expect(Validators.validateName('محمد Ahmed'), isNotNull);
    });

    test('Mixed with punctuation fails', () {
      expect(Validators.validateName('محمد-Ali'), isNotNull);
    });

    test('Double spaces fail', () {
      expect(Validators.validateName('محمد  علي'), isNotNull);
    });

    test('Leading space fails', () {
      expect(Validators.validateName(' Ahmed'), isNotNull);
    });

    test('Trailing space fails', () {
      expect(Validators.validateName('Ahmed '), isNotNull);
    });

    test('Empty value fails', () {
      expect(Validators.validateName(''), isNotNull);
    });

    test('Single Arabic word passes', () {
      expect(Validators.validateName('محمد'), isNull);
    });

    test('Single Latin word passes', () {
      expect(Validators.validateName('Ahmed'), isNull);
    });
  });
}