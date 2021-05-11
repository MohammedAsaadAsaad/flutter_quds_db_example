// class Contact {
//   String firstName = '';
//   String familyName = '';
//   String mobileNumber = '';
//   Color color = Colors.blue;
//   bool isFavourite = false;
//   DateTime birthDate = DateTime(1990);
// }

import 'package:quds_db/quds_db.dart';

class Contact extends DbModel {
  StringField firstName = StringField(columnName: 'firstName');
  StringField familyName = StringField(columnName: 'familyName');
  StringField mobileNumber = StringField(columnName: 'mobileNumber');
  ColorField color = ColorField(columnName: 'color');
  BoolField isFavourite = BoolField(columnName: 'isFavourite');
  DateTimeStringField birthDate = DateTimeStringField(columnName: 'birthDate');

  @override
  List<FieldWithValue>? getFields() =>
      [firstName, familyName, mobileNumber, color, isFavourite, birthDate];
}
