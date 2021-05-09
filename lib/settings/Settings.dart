import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ListView(
          children: const <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.flag),
                title: Text('Langue'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Exporter les données'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.file_download),
                title: Text('Importer des données'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('A propos'),
              ),
            ),
          ],
        )
      )
    );
  }
}
