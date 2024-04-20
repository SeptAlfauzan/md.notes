import 'package:file_io_simple/core/domain/common/data_state.dart';
import 'package:file_io_simple/core/presentation/editor/editor_view.dart';
import 'package:file_io_simple/core/presentation/home/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                          onTap: () => Navigator.pushNamed(
                                  context, EditorView.route,
                                  arguments: note)
                              .then(
                            (_) => Provider.of<NotesProvider>(context,
                                    listen: false)
                                .getAllSavedNotes(),
                          ),
                          child: Dismissible(
                            background: Card(
                              color: Colors.red,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Delete this notes",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            key: Key(note?.id ?? "-"),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) =>
                                value.deleteNote(note?.id ?? "-"),
                            child: Card(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal),
                                            overflow: TextOverflow.ellipsis,
                                            note?.title ??
                                                "Note ${DateFormat.yMMMd().format(note!.created!)}"),
                                      ),
                                      Text(
                                          maxLines: 7,
                                          overflow: TextOverflow.ellipsis,
                                          note?.data ?? "-"),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.4)),
                                            'last edit: ${note?.lastEdited != null ? DateFormat.yMMMd().format(note!.lastEdited!) : "-"}'),
                                      ),
                                    ]),
                              ),
                            ),
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
        child: const Icon(Icons.note_add),
        onPressed: () =>
            Navigator.pushNamed(context, EditorView.route, arguments: null)
                .then((_) => Provider.of<NotesProvider>(context, listen: false)
                    .getAllSavedNotes()),
      ),
    );
  }
}
