import 'package:file_io_simple/core/presentation/editor/editor_view.dart';
import 'package:file_io_simple/core/presentation/editor/providers/editor_provider.dart';
import 'package:file_io_simple/core/presentation/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Markdowns',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      initialRoute: HomeView.route,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        HomeView.route: (context) => const HomeView(),
        EditorView.route: (context) => ChangeNotifierProvider<EditorProvider>(
            create: (context) => EditorProvider(), child: const EditorView()),
      },
    );
  }
}
