import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/preview_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note? note;
  final Function()? onTap;
  const NoteCard({super.key, this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      surfaceTintColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildNoteTitle(context, note),
              _buildPreview(context, note),
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 48, bottom: 16),
                  child: _buildLastEditText(context, note)),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: _buildDownloadButton(
                onDowload: () {
                  print("pressed download button");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPreview(BuildContext context, Note? note) {
  return Expanded(
    child: Container(
      alignment: Alignment.center,
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(context).colorScheme.tertiaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.9),
            Theme.of(context).cardColor.withOpacity(0),
          ],
        ),
      ),
      child: PreviewField(
        scrollPhysics: const NeverScrollableScrollPhysics(),
        backgroundColor: Colors.transparent,
        data: note?.data ?? "-",
      ),
    ),
  );
}

Widget _buildNoteTitle(BuildContext context, Note? note) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
        maxLines: 2,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        overflow: TextOverflow.ellipsis,
        note?.title ?? "Note ${DateFormat.yMMMd().format(note!.created)}"),
  );
}

Widget _buildLastEditText(BuildContext context, Note? note) {
  return note?.lastEdited != null
      ? Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
          'last edit: ${note?.lastEdited != null ? DateFormat.yMMMd().format(note!.lastEdited!) : "-"}')
      : const SizedBox.shrink();
}

class _buildDownloadButton extends StatelessWidget {
  final Function() onDowload;
  const _buildDownloadButton({super.key, required this.onDowload});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 24, onPressed: onDowload, icon: const Icon(Icons.download));
  }
}
