import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Export extends StatefulWidget {
  Export();

  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends State<Export> {
  List items = [
    {"name": "Mots de passe", "icon": Icons.vpn_key, "checked": true, "disabled": false},
    {"name": "Notes sécurisées", "icon": Icons.description, "checked": false, "disabled": true},
    {"name": "Cartes", "icon": Icons.credit_card, "checked": false, "disabled": true},
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  test() async {
    String? password = await _showPasswordDialog();
    if (null == password || password.length < 8) {
      throw new Exception("Password must be at least 8 characters");
    }
    final storage = new FlutterSecureStorage();
    String? privateKey = await storage.read(key: 'privateKey');

    final path = await _localPath;
    if (await Permission.storage.request().isGranted) {
      String databaseFilePath = '/data/data/com.maxdeoxis.pass_manager/databases/pass_manager.db';
      var crypt = AesCrypt();
      crypt.setPassword(password);
      crypt.setOverwriteMode(AesCryptOwMode.on);
      crypt.encryptTextToFile(privateKey, '/data/data/com.maxdeoxis.pass_manager/databases/export');
      String encFilepath;
      try {
        // Encrypts './example/testfile.txt' file and save encrypted file to a file with
        // '.aes' extension added. In this case it will be './example/testfile.txt.aes'.
        // It returns a path to encrypted file.
        encFilepath = crypt.encryptFileSync(databaseFilePath);
        print('The encryption has been completed successfully.');
        print('Encrypted file: $encFilepath');
      } on AesCryptException catch (e) {
        // It goes here if overwrite mode set as 'AesCryptFnMode.warn'
        // and encrypted file already exists.
        if (e.type == AesCryptExceptionType.destFileExists) {
          print('The encryption has been completed unsuccessfully.');
          print(e.message);
        }
        return;
      }

      var encoder = ZipFileEncoder();
      encoder.create(path + '/test.zip');
      print(encFilepath);
      encoder.addFile(File(encFilepath));
      encoder.addFile(File('/data/data/com.maxdeoxis.pass_manager/databases/export'));
      encoder.close();
    }
  }

  Future<String?> _showPasswordDialog() async {
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choisissez un mot de passe'),
            children: <Widget>[
              Text("Il sera nécessaire pour importer vos données"),
              Center(
                child: TextField(
                  controller: _controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, _controller.text);
                },
                child: const Text('Valider'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: const Text('Annuler'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Column(
            children: items
                .map((field) => CheckboxListTile(
                      title: Text(field["name"]),
                      value: field["checked"],
                      onChanged: field["disabled"] ? null : (bool? value) {
                        setState(() {
                          final newItem = items.firstWhere((el) => el["name"] == field["name"]);
                          print(newItem);
                          newItem["checked"] = !newItem["checked"];
                        });
                      },
                      secondary: Icon(field["icon"]),
                    ))
                .toList()),
        ElevatedButton(child: Text('Exporter'), onPressed: () => test())
      ],
    )));
  }
}
