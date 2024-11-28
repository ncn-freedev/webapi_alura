import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isUpdate;
  AddJournalScreen({super.key, required this.journal, required this.isUpdate});
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${WeekDay(journal.createdAt.weekday).long.toLowerCase()}, ${journal.createdAt.day}  |  ${journal.createdAt.month}  |  ${journal.createdAt.year}",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                String? token = prefs.getString("accessToken");
                if (token != null) {
                  journal.content = _contentController.text;
                  JournalService service = JournalService();
                  if (isUpdate == true) {
                    service.update(journal, token).then((value) {
                      Navigator.pop(context, value);
                    }).catchError((error) {
                      logout(context);
                    },
                        test: (error) =>
                            error is TokenNotValidException).catchError(
                        (error) {
                      showExceptionDialog(context, content: error.message);
                    }, test: (error) => error is HttpException);
                    return;
                  } else {
                    service.register(journal, token).then((value) {
                      Navigator.pop(context, value);
                    }).catchError((error) {
                      logout(context);
                    },
                        test: (error) =>
                            error is TokenNotValidException).catchError(
                        (error) {
                      showExceptionDialog(context, content: error.message);
                    }, test: (error) => error is HttpException);
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            fontSize: 24,
          ),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }
}
