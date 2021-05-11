import 'package:flutter/material.dart';
import 'package:quds_db_example/data/contact.dart';
import 'package:quds_db_example/utils/datetime_utils.dart';

class AddEditContactDialog extends StatefulWidget {
  final Contact? contact;

  const AddEditContactDialog({Key? key, this.contact}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddEditContactDialog> {
  void _loadData() {
    if (widget.contact != null) {
      var c = widget.contact!;
      firstNameController.text = c.firstName;
      familyNameController.text = c.familyName;
      mobileNumberController.text = c.mobileNumber;
      isFavourite = c.isFavourite;
      color = c.color;
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildForm(), _buildBottomControls()],
        ),
      ),
    );
  }

  TextEditingController firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();

  TextEditingController familyNameController = TextEditingController();
  FocusNode familyNameFocus = FocusNode();

  TextEditingController mobileNumberController = TextEditingController();
  FocusNode mobileNumberFocus = FocusNode();

  DateTime birthDate = DateTime(2000);
  bool isFavourite = false;
  Color color = Colors.red[500]!;

  GlobalKey<FormState> keyForm = GlobalKey();
  Widget _buildForm() {
    return Form(
      key: keyForm,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: (v) => v!.length < 2 ? 'Invalid Name' : null,
          controller: firstNameController,
          focusNode: firstNameFocus,
          onFieldSubmitted: (v) => familyNameFocus.requestFocus(),
          decoration: InputDecoration(
              labelText: 'First name', prefixIcon: Icon(Icons.person)),
        ),
        TextFormField(
            textInputAction: TextInputAction.next,
            validator: (v) => v!.length < 2 ? 'Invalid Name' : null,
            controller: familyNameController,
            focusNode: familyNameFocus,
            onFieldSubmitted: (v) => mobileNumberFocus.requestFocus(),
            decoration: InputDecoration(
                labelText: 'Family name', prefixIcon: Icon(Icons.group))),
        TextFormField(
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (v) => _save(),
            controller: mobileNumberController,
            focusNode: mobileNumberFocus,
            decoration: InputDecoration(
                labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone))),
        TextButton(
          onPressed: () => showDatePicker(
                  context: context,
                  initialDate: birthDate,
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now())
              .then((value) {
            if (value != null)
              setState(() {
                birthDate = value;
              });
          }),
          child: Container(
              width: double.infinity,
              child: Row(children: [
                Text('Birthdate: '),
                Text(birthDate.toFormattedString())
              ])),
        ),
        Text(
          'Color',
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
        ),
        Container(
          child: Row(
            children: [
              Colors.red[500],
              Colors.blue[500],
              Colors.deepOrange[500],
              Colors.yellow[700]
            ]
                .map((e) => InkWell(
                    onTap: () => setState(() => color = e!),
                    child: Container(
                      child: color == e
                          ? Icon(Icons.done, color: Colors.white)
                          : null,
                      margin: EdgeInsets.all(3),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black87,
                            blurRadius: 2,
                            offset: Offset(2, 2))
                      ], borderRadius: BorderRadius.circular(50), color: e),
                    )))
                .toList(),
          ),
        ),
        SwitchListTile(
            title: Text('Is favourite'),
            value: isFavourite,
            onChanged: (v) => setState(() => isFavourite = v))
      ]),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: _save, child: Text('Save')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel'))
        ],
      ),
    );
  }

  void _save() {
    if (!keyForm.currentState!.validate()) return;

    //Save the contact
    //if (widget.contact == null)
    //then it new contact with insertion operation
    //otherwise it old contact with update operation

    Contact c = widget.contact ?? Contact();
    //Save c;
    Navigator.pop(context);
  }
}
