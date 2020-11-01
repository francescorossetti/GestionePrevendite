import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gestioneprevendite/Pages/Intro/intro.dart';
import 'package:gestioneprevendite/Pages/home.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
Widget home = IntroScreen();

Future checkFirstSeen() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _seen = (prefs.getBool('GestionePrevendite') ?? false);

  if (_seen) {
    home = MyHomePage();
  } else {
    await prefs.setBool('GestionePrevendite', true);
  }
}

void main() async {
  await checkFirstSeen();
  
  runApp(MyApp());
  
  Admob.initialize("ca-app-pub-3318650813130043~2230806586");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        brightness: brightness,
        primarySwatch: Colors.blue,
        fontFamily: "Rubik"
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Gestione Prevendite',

          theme: theme,

          supportedLocales: [
            Locale('en', 'US'),
            Locale('it', 'IT')
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for(var supportedLocale in supportedLocales) {
              if(supportedLocale.languageCode == locale.languageCode && 
                  supportedLocale.countryCode == locale.countryCode)
                return supportedLocale;
            }

            return supportedLocales.first;
          },
          debugShowCheckedModeBanner: true,
          home: home,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
        );
      }
    );
  }
}