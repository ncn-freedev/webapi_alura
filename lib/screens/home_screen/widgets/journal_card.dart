import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  final int userId;
  final String token;
  
  const JournalCard({
    super.key,
    this.journal,
    required this.showedDate,
    required this.refreshFunction,
    required this.userId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt.weekday).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (journal != null) {
                    showConfirmationDialog(
                      context,
                      content: "Deseja realmente excluir este registro",
                      affimativeOption: "Remover",
                    ).then((value){
                      if(value != null && value){
                        deleteItem(context, journal!.id);
                      }
                    });
                    
                  }
                },
                icon: Icon(Icons.delete),
              )
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate.weekday).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Journal innerJournal = Journal(
      id: Uuid().v1(),
      content: "",
      createdAt: showedDate,
      updatedAt: showedDate,
      userID: userId,
    );
    Map<String, dynamic> arguments = {};

    if (journal != null) {
      innerJournal = journal;
      arguments["isUpdate"] = true;
    } else {
      arguments["isUpdate"] = false;
    }

    arguments["journal"] = innerJournal;

    Navigator.pushNamed(
      context,
      "addJournal",
      arguments: arguments,
    ).then((value) {
      refreshFunction();
      if (value != null && value == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registro salvo com sucesso!"),
          ),
        );
      }
    });
  }

  deleteItem(BuildContext context, String id) {
    JournalService service = JournalService();
    service.delete(id, token).then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registro excluído com sucesso!"),
          ),
        );
        refreshFunction();
      }
    }).catchError((error) {
      logout(context);
    }, test: (error) => error is TokenNotValidException).catchError((error){
      showExceptionDialog(context, content: error.message);
    }, test: (error) => error is HttpException);
  }
}
