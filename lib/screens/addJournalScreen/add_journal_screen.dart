import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  AddJournalScreen({super.key, required this.journal});
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${WeekDay(journal.createdAt.weekday).long.toLowerCase()}, ${journal.createdAt.day}  |  ${journal.createdAt.month}  |  ${journal.createdAt.year}",),
        actions: [
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            JournalService service = JournalService();
            journal.content = _contentController.text;
            service.register(journal).then((value) {
              Navigator.pop(context, value);
            }); 
            
            
          },
        ),  
      ],),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: TextStyle(fontSize: 24,),
          expands: true,
          maxLines: null,
          minLines: null ,
        ),
      ),
    );
  }
}