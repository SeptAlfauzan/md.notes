import 'package:file_io_simple/core/presentation/editor/editor_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  static const String route = "home_route";
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.note_add),
          onPressed: () => Navigator.pushNamed(context, EditorView.route)),
    );
  }
}
