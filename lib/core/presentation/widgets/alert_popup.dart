import 'package:file_io_simple/core/presentation/home/home_view.dart';
import 'package:flutter/material.dart';

Future<void> triggerAlert(
        {required String title,
        required String text,
        required BuildContext context}) async =>
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(text),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Discard'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeView.route, (route) => false);
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
