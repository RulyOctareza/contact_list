import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
// import 'package:d_method/d_method.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _MasteringCRUDState();
}

class _MasteringCRUDState extends State<ContactList> {
  List<Map> listdata = [];
  bool ascending = false;

  create() {
    final controllerName = TextEditingController();
    final controllerphoneNumber = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create new Contact'),
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            contentPadding: const EdgeInsets.all(16),
            children: [
              DInput(
                autofocus: true,
                controller: controllerName,
                hint: 'Name',
              ),
              const SizedBox(
                height: 16,
              ),
              DInput(
                textAlign: TextAlign.start,
                controller: controllerphoneNumber,
                inputType: TextInputType.number,
                hint: 'phoneNumber',
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (controllerName.text.isEmpty ||
                      controllerphoneNumber.text.isEmpty) {
                    DInfo.toastError('Name and phoneNumber cannot be empty');
                    // DInfo.snackBarError(
                    //     context, 'Name and phoneNumber cannot be empty');
                  } else {
                    Map item = {
                      'id': UniqueKey().toString(),
                      'name': controllerName.text,
                      'phoneNumber': controllerphoneNumber.text,
                    };
                    listdata.add(item);

                    Navigator.pop(context);
                    DInfo.snackBarSuccess(context, 'Success Create New data');
                  }

                  setState(() {});
                  DMethod.printTitle('Create', listdata.toString());
                },
                child: const Text('Confirm'),
              )
            ],
          );
        });
  }

  read() {
    //get data from data base/api/collection
    DMethod.printTitle('Read - before get data', listdata.toString());
    // move data

    List<Map> initialList = [
      {
        'id': 001,
        'name': 'Adi',
        'phoneNumber': '08131831938',
      },
      {
        'id': 002,
        'name': 'Neumorphism',
        'phoneNumber': '0876434313',
      },
    ];

    listdata = initialList;

//refresh ui
    setState(() {});

    DMethod.printTitle('read - after get data', listdata.toString());
  }

  update(Map oldItemData, int index) {
    final controllerName = TextEditingController(text: oldItemData['Name']);
    final controllerphoneNumber =
        TextEditingController(text: oldItemData['phoneNumber']);
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Update data'),
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            contentPadding: const EdgeInsets.all(16),
            children: [
              DInput(
                autofocus: true,
                controller: controllerName,
                hint: 'Name',
              ),
              const SizedBox(
                height: 16,
              ),
              DInput(
                textAlign: TextAlign.start,
                controller: controllerphoneNumber,
                inputType: TextInputType.number,
                hint: 'phoneNumber',
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (controllerName.text.isEmpty ||
                      controllerphoneNumber.text.isEmpty) {
                    DInfo.toastError('Name and phoneNumber cannot be empty');
                  } else {
                    Map newItem = {
                      'id': oldItemData['id'],
                      'name': controllerName.text,
                      'phoneNumber': controllerphoneNumber.text,
                    };
                    listdata[index] = newItem;

                    Navigator.pop(context);
                    DInfo.snackBarSuccess(context, 'Success Update data');
                  }

                  setState(() {});
                  DMethod.printTitle('Update', listdata.toString());
                },
                child: const Text('Confirm'),
              )
            ],
          );
        });
  }

  delete(int index) {
    DMethod.printTitle('Delete - before', listdata.toString());

    listdata.removeAt(index);
    setState(() {});

    DInfo.toastSuccess('Data terdelete');

    DMethod.printTitle('Delete - after', listdata.toString());
  }

  deleteById(String id) {
    DMethod.printTitle('Delete by id - before', listdata.toString());

    listdata.removeWhere((element) => element['id'] == id);
    setState(() {});

    DInfo.toastSuccess('Data Deleted');

    DMethod.printTitle('Delete by Id - after', listdata.toString());
  }

  sort() {
    ascending = !ascending;

    if (ascending) {
      listdata.sort(
        (a, b) => a['title'].compareTo(b['title']),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    read();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak'),
        backgroundColor: Colors.blue,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () => sort(),
                icon: const Icon(Icons.sort_by_alpha_outlined),
                tooltip: ascending ? 'Ascending' : 'Descending',
              ),
              Icon(
                ascending ? Icons.arrow_downward : Icons.arrow_upward,
                size: 15,
              )
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
              child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Kontak',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Menu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ],
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          create();
        },
        child: const Icon(Icons.add),
      ),
      body: listdata.isEmpty
          ? const Center(child: Text('No Data'))
          : ListView.builder(
              itemCount: listdata.length,
              itemBuilder: (context, index) {
                Map item = listdata[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(item['phoneNumber']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == "Update") {
                        update(item, index);
                      }
                      if (value == "Delete") {
                        // delete(index);

                        deleteById(item['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Update",
                        child: Text("Update"),
                      ),
                      const PopupMenuItem(
                        value: "Delete",
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const ButtonBar(),
    );
  }
}
