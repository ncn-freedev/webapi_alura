import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

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
              journal.content = _contentController.text;
              JournalService service = JournalService();
              if (isUpdate == true) {
                service.update(journal).then((value) {
                  Navigator.pop(context, value);
                });
                return;
              } else {
                service.register(journal).then((value) {
                Navigator.pop(context, value);
                });
              }
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
