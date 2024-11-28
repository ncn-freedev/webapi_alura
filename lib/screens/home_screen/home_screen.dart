import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 11;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  int? userId;

  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refresh,
          ),
        ],
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
      body: (userId == null)
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
                userId: userId!,
                token: userToken!,
              ),
            ),
    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");
      String? email = prefs.getString("email");
      int? id = prefs.getInt("id");

      if (token != null && email != null && id != null) {
        setState(() {
          userId = id;
          userToken = token;
        });
        service
            .getAll(id: id.toString(), token: token)
            .then((List<Journal> listJournal) {
          setState(() {
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        }).catchError((error){
          Navigator.pushReplacementNamed(context, "login");
          showExceptionDialog(context, content: "O servidor não está respondendo!");          
        }, test: (error) => error is TimeoutException);
      } else {
        Navigator.pushReplacementNamed(context, "login");
      }
    }).catchError((error) {
      logout(context);
    }, test: (error) => error is TokenNotValidException).catchError((error){
      showExceptionDialog(context, content: error.message);
    }, test: (error) => error is HttpException);
  }

  
}
