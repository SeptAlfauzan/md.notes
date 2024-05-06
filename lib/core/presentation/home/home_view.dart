import 'package:file_io_simple/core/domain/common/data_state.dart';
import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/presentation/editor/editor_view.dart';
import 'package:file_io_simple/core/presentation/home/providers/notes_provider.dart';
import 'package:file_io_simple/core/presentation/widgets/delete_background.dart';
import 'package:file_io_simple/core/presentation/widgets/note_card.dart';
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
              DataSuccess() => RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 400));
                    await value.getAllSavedNotes();
                  },
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: value.dataState.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final note = value.dataState.data?[index];
                        return GestureDetector(
                          onTap: () => _navigateEditor(note),
                          child: Dismissible(
                            background: const DeleteBackground(),
                            key: Key(note?.id ?? "-"),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) =>
                                value.deleteNote(note?.id ?? "-"),
                            child: NoteCard(note: note),
                          ),
                        );
                      }),
                ),
              DataFailed() => Text(value.dataState.errMessage ?? "-"),
              DataEmpty() => const Text("no data"),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateEditor(null),
        child: const Icon(Icons.note_add),
      ),
    );
  }

  void _navigateEditor(Note? note) =>
      Navigator.pushNamed(context, EditorView.route, arguments: note).then(
        (_) => Provider.of<NotesProvider>(context, listen: false)
            .getAllSavedNotes(),
      );
}
