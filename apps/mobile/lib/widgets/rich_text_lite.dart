import 'package:flutter/material.dart';

/// Rendu minimal du markdown des slides de règles : `**gras**` et listes
/// `- item`. Rien de plus n'est utilisé dans le contenu.
class RichTextLite extends StatelessWidget {
  const RichTextLite(this.source, {super.key, this.style});
  final String source;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyLarge!;
    final lines = source.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            const SizedBox(height: 10)
          else if (line.startsWith('- '))
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: base),
                  Expanded(child: Text.rich(_spans(line.substring(2), base))),
                ],
              ),
            )
          else
            Text.rich(_spans(line, base)),
      ],
    );
  }

  TextSpan _spans(String text, TextStyle base) {
    // Gras du même texte, pas une autre couleur : `Colors.white` fixe
    // rendait ce texte invisible sur fond clair (mode light, §10).
    final bold = base.copyWith(fontWeight: FontWeight.w700);
    final children = <InlineSpan>[];
    final re = RegExp(r'\*\*(.+?)\*\*');
    var last = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > last) children.add(TextSpan(text: text.substring(last, m.start)));
      children.add(TextSpan(text: m.group(1), style: bold));
      last = m.end;
    }
    if (last < text.length) children.add(TextSpan(text: text.substring(last)));
    return TextSpan(style: base, children: children);
  }
}
