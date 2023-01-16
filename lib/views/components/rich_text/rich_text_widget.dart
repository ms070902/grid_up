import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:nexus/views/components/rich_text/link_text.dart';

import 'base_text.dart';

class RichTextWidget extends StatelessWidget {
  final TextStyle? styleForAll;
  final Iterable<BaseText> texts;
  const RichTextWidget({
    Key? key,
    required this.texts,
    this.styleForAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map(
          (baseText) {
            if (baseText is LinkText) {
              return TextSpan(
                text: baseText.text,
                style: styleForAll?.merge(baseText.style),
                recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
              );
            } else {
              return TextSpan(
                text: baseText.text,
                style: styleForAll?.merge(baseText.style),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
