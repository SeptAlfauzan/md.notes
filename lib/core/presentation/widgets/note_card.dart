import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note? note;
  const NoteCard({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
                note?.title ??
                    "Note ${DateFormat.yMMMd().format(note!.created!)}"),
          ),
          Text(maxLines: 7, overflow: TextOverflow.ellipsis, note?.data ?? "-"),
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
    );
  }
}
