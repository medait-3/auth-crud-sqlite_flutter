showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: 'Update',
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            //We need two textfield
                                            TextFormField(
                                              controller: title,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Title is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("Title"),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: content,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Content is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("Content"),
                                              ),
                                            ),
                                          ]),
                                      yesButtonText: 'Update',
                                      noButtonText: 'Cancel',
                                      onYes: () {
                                        db
                                                    .updateNote(
                                                  databaseName:
                                                      widget.databaseName,
                                                  title: title.text,
                                                  content: content.text,
                                                  noteId: items[index].noteId,
                                                )
                                                    .whenComplete(() {
                                                  //After update, note will refresh
                                                  _refresh();
                                                  Navigator.pop(context);},
                                      onNo: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },