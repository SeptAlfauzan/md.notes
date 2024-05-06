import 'package:flutter/material.dart';

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "Delete this notes",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            )),
      ),
    );
  }
}
