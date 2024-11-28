import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/addJournalScreen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = await verifyLogin();
  runApp(MyApp(isLogged: isLogged,));
}

Future<bool> verifyLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("accessToken");
  if (token != null) {
    return true;
  }
  return false;
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.bitterTextTheme(),
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.white,
            ),
          )),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: (isLogged)?"home" : "login",
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) => LoginScreen(),
        
      },
      onGenerateRoute: (settings) {
        if (settings.name == "addJournal") {
          Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
          final Journal journal = arguments["journal"] as Journal;
          final bool isUpdate = arguments["isUpdate"];
          return MaterialPageRoute(
            builder: (context) => AddJournalScreen(
              journal: journal, isUpdate: isUpdate,
            ),
          );
        }
        return null;
      },
    );
  }
}
