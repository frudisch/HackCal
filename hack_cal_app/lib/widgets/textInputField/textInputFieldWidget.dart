import 'package:flutter/material.dart';

class TextInputFieldWidget extends StatelessWidget {
  final TextStyle _descrFontStyle = const TextStyle(fontSize: 18.0);
  final TextStyle _inputFontStyle =
      const TextStyle(fontSize: 22.0, color: Colors.black);
  final TextEditingController _controller = TextEditingController();

  final String name;
  final bool required;

  TextInputFieldWidget({this.name, this.required = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${name}:',
          style: _descrFontStyle,
        ),
        TextFormField(
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          style: _inputFontStyle,
          validator: required
              ? (value) {
                  if (value.isEmpty) {
                    return 'Bitte gebe einen Wert an.';
                  }
                }
              : null,
        ),
      ],
    );
  }

  getTextValue() {
    return _controller.text.isEmpty ? null : _controller.text;
  }
}
