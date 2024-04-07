import 'package:flutter/material.dart';

class EditTopBar extends StatelessWidget {
  static const _padding = EdgeInsets.only(left: 24, right: 24, top: 24);
  final Function() onPressed;
  const EditTopBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: _padding,
          child: TextButton(
            onPressed: () => onPressed(),
            child: const Row(
              children: [
                Text("Edit"),
                SizedBox(width: 8.0),
                Icon(
                  Icons.edit,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
