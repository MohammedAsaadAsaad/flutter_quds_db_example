import 'package:quds_db/quds_db.dart';
import 'package:quds_db_example/data/contact.dart';

ContactsProvider provider = ContactsProvider();

class ContactsProvider extends DbTableProvider<Contact> {
  ContactsProvider() : super(() => Contact());

  @override
  String get tableName => 'Contacts';
}
