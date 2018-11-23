import 'package:flutter/material.dart';

class TextInputFieldWidget extends StatelessWidget {
  final TextStyle _descrFontStyle = const TextStyle(fontSize: 18.0);
  final TextStyle _inputFontStyle =
      const TextStyle(fontSize: 22.0, color: Colors.black);
  final TextEditingController _controller = TextEditingController();

  final String name;
  final bool required;
  final ValidatorFunction validator;

  TextInputFieldWidget(
      {this.name, this.required = true, this.validator = null});

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
          validator: (value) {
            if (required && value.isEmpty) {
              return 'Bitte gebe einen Wert an.';
            }
            if (validator != null) {
              return validator(value);
            }
          },
        ),
      ],
    );
  }

  getTextValue() {
    return _controller.text.isEmpty ? null : _controller.text;
  }
}

typedef ValidatorFunction = Function(String value);
