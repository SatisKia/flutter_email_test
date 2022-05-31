import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  double contentWidth  = 0.0;
  double contentHeight = 0.0;

  String _email = '';
  String _subject = '';
  String _body = '';

  @override
  Widget build(BuildContext context) {
    contentWidth  = MediaQuery.of( context ).size.width;
    contentHeight = MediaQuery.of( context ).size.height - MediaQuery.of( context ).padding.top - MediaQuery.of( context ).padding.bottom;

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0
      ),
      body: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('email', style: TextStyle(fontSize: 20)),
        MyTextField( onChanged: (value) {
          _email = value;
        } ),
        Text('subject', style: TextStyle(fontSize: 20)),
        MyTextField( onChanged: (value) {
          _subject = value;
        } ),
        Text('body', style: TextStyle(fontSize: 20)),
        MyTextField( onChanged: (value) {
          _body = value.replaceAll('\\n', '\n');
        } ),
        Row( children: [
          ElevatedButton(
            child: const Text('launch'),
            onPressed: () async {
              String email = _email;
              String subject = Uri.encodeComponent(_subject);
              String body = Uri.encodeComponent(_body);
              String url = 'mailto:$email?subject=$subject&body=$body';
              debugPrint(url);
              if (await canLaunchUrl( Uri.parse(url) )) {
                launchUrl( Uri.parse(url), mode: LaunchMode.externalApplication );
              }
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: const Text('FlutterEmailSender'),
            onPressed: () async {
              Email email = Email(
                body: _body,
                subject: _subject,
                recipients: [ _email ],
                isHTML: false,
              );
              try {
                await FlutterEmailSender.send(email);
              } catch(e) {
              }
            },
          ),
        ] ),
      ] ),
    );
  }
}

class MyTextField extends TextField {
  MyTextField({required void Function(String) onChanged, Key? key}) : super(key: key,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
    ),
    autocorrect: false,
    keyboardType: TextInputType.text,
    onChanged: onChanged,
  );
}
