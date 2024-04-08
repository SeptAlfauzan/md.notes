import 'package:file_io_simple/core/domain/common/data_state.dart';
import 'package:file_io_simple/core/presentation/editor/editor_view.dart';
import 'package:file_io_simple/core/presentation/home/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  static const String route = "home_route";
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<NotesProvider>(context, listen: false).getAllSavedNotes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Consumer<NotesProvider>(
          builder: (BuildContext context, NotesProvider value, Widget? child) {
            return switch (value.dataState) {
              DataLoading() => const CircularProgressIndicator(),
              DataSuccess<List<String>>() => RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 400));
                    await value.getAllSavedNotes();
                  },
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                    ),
                    itemCount: value.dataState.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                      onTap: () => Navigator.pushNamed(
                              context, EditorView.route,
                              arguments: value.dataState.data?[index] ?? "-")
                          .then(
                        (_) =>
                            Provider.of<NotesProvider>(context, listen: false)
                                .getAllSavedNotes(),
                      ),
                      child: Dismissible(
                        background: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.all(16),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  Text("Delete this notes")
                                ],
                              )),
                        ),
                        key: Key(value.dataState.data?[index] ?? "-"),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) => value
                            .deleteNote(value.dataState.data?[index] ?? "-"),
                        child: Material(
                          child: ListTile(
                            title: Text(value.dataState.data?[index] ?? "-"),
                            tileColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              DataFailed() => Text(value.dataState.errMessage ?? "-"),
              DataEmpty() => const Text("no data"),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note_add),
        onPressed: () =>
            Navigator.pushNamed(context, EditorView.route, arguments: null)
                .then((_) => Provider.of<NotesProvider>(context, listen: false)
                    .getAllSavedNotes()),
      ),
    );
  }
}
