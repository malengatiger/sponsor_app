import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fbui;
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';
import 'package:sponsor_app/app/app.bottomsheets.dart';
import 'package:sponsor_app/app/app.dialogs.dart';
import 'package:sponsor_app/app/app.locator.dart';
import 'package:sponsor_app/app/app.router.dart';
import 'package:sponsor_app/util/dark_light_control.dart';
import 'package:sponsor_app/util/environment.dart';
import 'package:sponsor_app/util/functions.dart';
import 'package:sponsor_app/util/prefs.dart';
import 'package:sponsor_app/util/register_services.dart';
import 'package:stacked_services/stacked_services.dart';

import 'firebase_options.dart';

const String mx = '🍎 🍎 🍎 main: ';
ModeAndColor? modeAndColor;
// final actionCodeSettings = ActionCodeSettings(
//   url: 'https://sgela-ai-33.firebaseapp.com',
//   handleCodeInApp: true,
//   androidMinimumVersion: '1',
//   androidPackageName: 'com.boha.edu_chatbot',
//   iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
// );
// final emailLinkProviderConfig = fbui.EmailLinkAuthProvider(
//   actionCodeSettings: actionCodeSettings,
// );
Future<void> main() async {
  pp('$mx SgelaAI Sponsor App starting .... $mx');
  WidgetsFlutterBinding.ensureInitialized();
  var app = await Firebase.initializeApp(
    name: ChatbotEnvironment.getFirebaseName(),
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  pp('$mx Firebase has been initialized!! $mx name: ${app.name}');

  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  //

  // fbui.FirebaseUIAuth.configureProviders([
  //   fbui.EmailAuthProvider(),
  //   emailLinkProviderConfig,
  //   fbui.PhoneAuthProvider(),
  // ]);
  // pp('$mx Firebase Auth providers have been setup!!');
  pp('${app.options.asMap}');

  var geminiAPIKey = ChatbotEnvironment.getGeminiAPIKey();
  var chatGPTAPIKey = ChatbotEnvironment.getChatGPTAPIKey();

  OpenAI.apiKey = chatGPTAPIKey;
  OpenAI.requestsTimeOut = const Duration(seconds: 180); // 3 minutes.
  OpenAI.showLogs = true;
  OpenAI.showResponsesLogs = true;

  pp('$mx OpenAI has been initialized and timeOut set!!');

  Gemini.init(
      apiKey: ChatbotEnvironment.getGeminiAPIKey(),
      enableDebugging: ChatbotEnvironment.isChatDebuggingEnabled());
  pp('$mx Gemini AI API has been initialized!! \n$mx'
      ' 🔵🔵 Gemini apiKey: $geminiAPIKey 🔵🔵 ChatGPT apiKey: $chatGPTAPIKey');
  // Register services
  await registerServices();
  //
  var prefs = GetIt.instance<Prefs>();
  var mode = prefs.getMode();
  var colorIndex = prefs.getColorIndex();
  modeAndColor = ModeAndColor(mode, colorIndex);
  //
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}
