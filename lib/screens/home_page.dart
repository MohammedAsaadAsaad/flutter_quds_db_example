import 'package:flutter/material.dart';
import 'package:quds_db/quds_db.dart';
import 'package:quds_db_example/data/contact.dart';
import 'package:quds_db_example/data/contacts_provider.dart';
import 'package:quds_db_example/screens/add_edit_contact.dart';
import 'package:quds_db_example/widgets/contact_list_tile.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HomePage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    provider.addEntryChangeListner((changeType, entry) {
      setState(() {
        switch (changeType) {
          case EntryChangeType.Insertion:
            contacts.add(entry);
            break;
          case EntryChangeType.Deletion:
            contacts.remove(entry);
            break;
          case EntryChangeType.Modification:
            break;
        }
      });
    });
    _fillResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Address Book'),
    );
  }

  Widget _buildBody() {
    return Container(
        child: Column(
      children: [
        _buildSearchBox(),
        Expanded(
          child: ListView(
            children: [
              for (var c in contacts)
                ContactListTile(
                  contact: c,
                )
            ],
          ),
        )
      ],
    ));
  }

  TextEditingController searchController = TextEditingController();
  bool justFavourite = false;
  bool justChildren = false;
  Widget _buildSearchBox() {
    return Container(
        padding: EdgeInsets.all(5),
        child: Row(children: [
          Expanded(
              child: TextField(
            onChanged: (v) => _fillResults(),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            controller: searchController,
          )),
          SizedBox(
            width: 4,
          ),
          Column(
            children: [
              Checkbox(
                  value: justFavourite,
                  onChanged: (v) {
                    setState(() => justFavourite = v!);
                    _fillResults();
                  }),
              Icon(Icons.favorite)
            ],
          ),
          SizedBox(
            width: 4,
          ),
          Column(
            children: [
              Checkbox(
                  value: justChildren,
                  onChanged: (v) {
                    setState(() => justChildren = v!);
                    _fillResults();
                  }),
              Icon(Icons.child_care_rounded)
            ],
          ),
        ]));
  }

  Widget _buildFAB() => FloatingActionButton(
      child: Icon(Icons.person_add_alt),
      onPressed: () =>
          showDialog(context: context, builder: (c) => AddEditContactDialog()));

  Future<void> _fillResults() async {
    contacts.clear();

    //Fill contacts list with whom name contains search text,
    //And if favourite is checked then fill with just favourite
    //And if just children box is checked then fill with just contacts
    //with age <18

    String str = searchController.text;
    contacts.addAll(await provider.select(
        orderBy: (c) => [c.firstName.ascOrder],
        where: (c) {
          var result = c.firstName.contains(str) | c.familyName.contains(str);
          if (justFavourite) result &= c.isFavourite.isTrue;
          if (justChildren) result &= c.birthDate.age < 18;
          return result;
        }));

    setState(() {});
  }
}
