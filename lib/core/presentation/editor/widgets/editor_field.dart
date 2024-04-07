import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  final Function(String) onUpdate;
  final TextEditingController textEditingController;
  const EditorField(
      {super.key, required this.onUpdate, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onUpdate,
      maxLines: null,
      expands: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      controller: textEditingController,
    );
  }
}
