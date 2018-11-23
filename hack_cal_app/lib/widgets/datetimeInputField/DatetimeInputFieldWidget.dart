import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimeInputFieldWidget extends StatelessWidget {
  final TextStyle _descrFontStyle = const TextStyle(fontSize: 18.0);
  final TextStyle _inputFontStyle =
      const TextStyle(fontSize: 22.0, color: Colors.black);
  final TextEditingController _controller = TextEditingController();
  final dateFormat = DateFormat("dd.MM.yyyy HH:mm");

  final String name;
  final bool required;

  DatetimeInputFieldWidget({this.name, this.required = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$name:', style: _descrFontStyle),
        DateTimePickerFormField(
          controller: _controller,
          format: dateFormat,
          style: _inputFontStyle,
          validator: required
              ? (value) {
                  if (value == null) {
                    return 'Bitte gebe ein Datum an.';
                  }
                }
              : null,
        ),
      ],
    );
  }

  getValue() {
    return dateFormat.parse(_controller.text);
  }
}
