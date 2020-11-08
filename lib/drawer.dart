import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120.0,
            width: 500,
            child: DrawerHeader(
              child: Text('Header'),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Mots de passe'),
                  leading: Icon(Icons.vpn_key),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/passwords");
                  },
                ),
                ListTile(
                  title: Text('Notes sécurisées'),
                  leading: Icon(Icons.description),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Cartes'),
                  leading: Icon(Icons.credit_card),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        title: Text('Paramètres'),
                        leading: Icon(Icons.settings),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))))
        ],
      ),
    );
  }
}
