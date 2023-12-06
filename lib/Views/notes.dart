import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz/JsonModels/note_model.dart';
import 'package:quiz/JsonModels/users.dart';

import 'package:quiz/SQLite/sqlite.dart';
import 'package:quiz/Views/create_note.dart';
import '../Authtentication/login.dart';
import '../_constant/alertdialog.dart';

class Notes extends StatefulWidget {
  final Users? usr;
  const Notes({
    this.usr,
    super.key,
  });

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    notes = handler.getNotes(widget.usr!.usrId??0);

    handler.initDB().whenComplete(() {
      notes = getAllNotes();
    });
    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotes(widget.usr!.usrId??0);
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("My Notes"),
            actions: [
              IconButton(
                  onPressed: () async {
                    await handler.closeDatabase();
                    if(!mounted)return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateNote(usr: widget.usr))).then((value) {
                if (value) {
                  //This will be called
                  _refresh();
                }
              });
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              //Search Field here
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: keyword,
                  onChanged: (value) {
                    //When we type something in textfield
                    if (value.isNotEmpty) {
                      setState(() {
                        notes = searchNote();
                      });
                    } else {
                      setState(() {
                        notes = getAllNotes();
                      });
                    }
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: "Search"),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<NoteModel>>(
                  future: notes,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<NoteModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(child: Text("No data"));
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      final items = snapshot.data ?? <NoteModel>[];
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              subtitle: Text(DateFormat("yMd").format(
                                  DateTime.parse(items[index].createdAt))),
                              title: Text(items[index].noteTitle),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                        title: 'Delete',
                                        content:
                                            'Are you sure you want to Deleted?',
                                        yesButtonText: 'Delete',
                                        noButtonText: 'Cancel',
                                        onYes: () {
                                          db
                                              .deleteNote(
                                            items[index].noteId!,
                                          )
                                              .whenComplete(() {
                                            _refresh();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        onNo: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              onTap: () {
                                //When we click on note
                                setState(() {
                                  title.text = items[index].noteTitle;
                                  content.text = items[index].noteContent;
                                });
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (stfContext, stfSetState) {
                                        return AlertDialog(
                                          actions: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    //Now update method

                                                    db
                                                        .updateNote(
                                                      title.text,
                                                      content.text,
                                                      items[index].noteId,
                                                    )
                                                        .whenComplete(() {
                                                      //After update, note will refresh
                                                      _refresh();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text("Update"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                              ],
                                            ),
                                          ],
                                          title: const Text("Update note"),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                //We need two textfield
                                                TextFormField(
                                                  controller: title,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Title is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    label: Text("Title"),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: content,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Content is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    label: Text("Content"),
                                                  ),
                                                ),
                                              ]),
                                        );
                                      });
                                    });
                              },
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
