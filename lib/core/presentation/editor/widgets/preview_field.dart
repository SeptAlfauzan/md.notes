import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class PreviewField extends StatelessWidget {
  final String data;
  final Color? backgroundColor;
  final ScrollPhysics? scrollPhysics;
  const PreviewField(
      {super.key,
      required this.data,
      this.backgroundColor,
      this.scrollPhysics});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ??
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      child: Markdown(
        selectable: false,
        physics: scrollPhysics,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          <md.InlineSyntax>[
            md.EmojiSyntax(),
            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
          ],
        ),
        data: data,
      ),
    );
  }
}
