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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                    note?.title ??
                        "Note ${DateFormat.yMMMd().format(note!.created)}"),
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
                        Theme.of(context)
                            .colorScheme
                            .tertiaryContainer
                            .withOpacity(0.9),
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
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 48, bottom: 16),
                child: note?.lastEdited != null
                    ? Flexible(
                        child: Text(
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface),
                            'last edit: ${note?.lastEdited != null ? DateFormat.yMMMd().format(note!.lastEdited!) : "-"}'),
                      )
                    : const Spacer(),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  iconSize: 24,
                  onPressed: () {
                    print("download note");
                  },
                  icon: const Icon(Icons.download)),
            ),
          ],
        ),
      ),
    );
  }
}
