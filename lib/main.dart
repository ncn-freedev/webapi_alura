import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/addJournalScreen/add_journal_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
        
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
