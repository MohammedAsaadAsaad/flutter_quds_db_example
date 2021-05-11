import 'package:flutter/material.dart';
import 'package:quds_db_example/data/contact.dart';
import 'package:quds_db_example/data/contacts_provider.dart';
import 'package:quds_db_example/screens/add_edit_contact.dart';
import 'package:quds_db_example/utils/datetime_utils.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;

  const ContactListTile({Key? key, required this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var c = this.contact;
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => showDialog(
                  context: context,
                  builder: (c) => AddEditContactDialog(
                        contact: this.contact,
                      ))),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => _delete(context))
        ],
      ),
      leading: Icon(
        c.isFavourite.value! ? Icons.favorite : Icons.favorite_border,
        color: c.color.value,
      ),
      title: Text('${c.firstName} ${c.familyName}'),
      subtitle: Text(c.mobileNumber.value! +
          '  -  ' +
          c.birthDate.value!.toFormattedString()),
    );
  }

  Future<void> _delete(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (c) => Dialog(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sure to delete?'),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context, 'yes'),
                              child: Text('Yes')),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context, 'no'),
                              child: Text('No'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));

    if (result == 'yes') {
      provider.deleteEntry(contact);
    }
  }
}
