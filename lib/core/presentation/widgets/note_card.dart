import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:file_io_simple/core/presentation/editor/widgets/preview_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note? note;
  const NoteCard({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      surfaceTintColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
              maxLines: 2,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              overflow: TextOverflow.ellipsis,
              note?.title ??
                  "Note ${DateFormat.yMMMd().format(note!.created!)}"),
        ),

        Expanded(
          child: Container(
            alignment: Alignment.center,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).colorScheme.tertiaryContainer,
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
        ),
        // Text(maxLines: 7, overflow: TextOverflow.ellipsis, note?.data ?? "-"),
        // const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        ),
      ]),
    );
  }
}
