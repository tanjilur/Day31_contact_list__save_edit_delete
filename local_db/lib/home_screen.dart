import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _updatecontroller = TextEditingController();

  Box? contactBox;
  @override
  void initState() {
    contactBox = Hive.box("contact_list");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
                onPressed: () {
                  var userInput = _controller.text;
                  contactBox!.add(userInput);
                },
                child: Text("Save")),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: Hive.box('Contact_list').listenable(),
              builder: (context, box, widget) {
                return ListView.builder(
                    itemCount: contactBox?.keys.toList().length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(contactBox!.getAt(index).toString()),
                          trailing: Container(
                            width: 100,
                            child: Row(children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Column(
                                              children: [
                                                TextField(
                                                  controller: _updatecontroller,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      contactBox!.putAt(
                                                          index,
                                                          _updatecontroller
                                                              .text);
                                                    },
                                                    child: Text("Update"))
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.edit_outlined)),
                              IconButton(
                                  onPressed: () {
                                    contactBox!.deleteAt(index);
                                  },
                                  icon: Icon(Icons.remove))
                            ]),
                          ),
                        ),
                      );
                    }));
              },
            ))
          ],
        ),
      ),
    );
  }
}
