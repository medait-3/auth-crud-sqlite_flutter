import 'package:flutter/material.dart';
import 'package:quiz/JsonModels/note_model.dart';
import 'package:quiz/SQLite/sqlite.dart';
import 'package:quiz/Views/notes.dart';

import '../JsonModels/users.dart';
import '../_constant/button.dart';

class CreateNote extends StatefulWidget {
  final Users? usr;
  const CreateNote({super.key,this.usr});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (formKey.currentState != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Notes()));
                }
              }),
          title: const Text("Create note"),
        ),
        body: Form(
            //I forgot to specify key
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Title"),
                      border: InputBorder.none,
                    ),
                  ),
                  TextFormField(
                    controller: content,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "password is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("password"),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 15),
                  PrimaryButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        db.createNote(
                          NoteModel(
                            noteTitle: title.text,
                            noteContent: content.text,
                            createdAt: DateTime.now().toIso8601String(),
                            userId: widget.usr!.usrId??0
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Notes()));
                      }
                    },
                    text: 'create',
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
