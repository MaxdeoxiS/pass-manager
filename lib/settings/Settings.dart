import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
      children: <Widget>[
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/settings/language");
                },
                child: ListTile(
                  leading: Icon(Icons.flag),
                  title: Text('Langue'),
                ))),
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/settings/export");
                },
                child: ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('Exporter les données'),
                ))),
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/settings/import");
                },
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('Importer les données'),
                ))),
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/settings/about");
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('A propos'),
                ))),
      ],
    )));
  }
}
