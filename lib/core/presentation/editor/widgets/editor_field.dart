import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  final Function(String) onUpdate;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  const EditorField({
    super.key,
    required this.onUpdate,
    required this.textEditingController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onChanged: onUpdate,
      maxLines: null,
      expands: true,
      decoration: InputDecoration(
          filled: true,
          fillColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          border: InputBorder.none),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      controller: textEditingController,
    );
  }
}
