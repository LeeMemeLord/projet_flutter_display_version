import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_final_firebase/firebase_options.dart';
import 'package:tp_final_firebase/page/page1.dart';
import 'package:tp_final_firebase/page/page_authentification.dart';
import 'package:tp_final_firebase/providers/provider_calendrier.dart';
import 'page/add_day_period_page.dart';
import 'page/change_student_page.dart';
import 'page/change_teacher_page.dart';
import 'page/create_class_page.dart';
import 'providers/provider_classe.dart';
import 'providers/provider_search.dart';
import 'providers/provider_user_acftif.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// main.dart dans votre MaterialApp

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderUserinfo(),
        ),
        ChangeNotifierProvider(create: (context) => ProviderCalendar()),
        ChangeNotifierProvider(create: (context) => ProviderSearch()),
        ChangeNotifierProvider(create: (context) => ProviderClasse()),
      ],
      child: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // Nous attendons l'initialisation
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return MaterialApp(
            title: 'Gestion cours',
            theme: ThemeData(
              primarySwatch: Colors.amber,
              appBarTheme: const AppBarTheme(
                color: Colors.amber,
              ),
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // Anglais, sans code de pays
              Locale('fr', ''), // Français, sans code de pays
            ],
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Builder(
                  builder: (context) {
                    return const PageProfile();
                  }
                );
                }
                return const PageAuthentification();
              },
            ),
            routes: {
              '/createClass': (context) => const CreateClassPage(),
              '/addDayPeriod': (context) => const AddDayPeriodPage(),
              '/assignTeacher': (context) => const AssignTeacherPage(),
              '/assignStudent': (context) => const AssignStudentPage(),
            },
          );
        },
      ),
    );
  }
}
