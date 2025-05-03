import 'package:encfile/views/components/custom_buttom.dart';
import 'package:flutter/material.dart';

Future<void> customDialog(
  BuildContext context, {
  required String text,
  String? title,
}) async {
  final size = MediaQuery.of(context).size;
  final theme = Theme.of(context);

  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      contentPadding: const EdgeInsets.all(4.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SelectableText(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SelectableText(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              CustomButton(
                width: size.width,
                text: "OK",
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
