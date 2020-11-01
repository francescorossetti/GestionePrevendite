import 'package:flutter/material.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/UIModels/NavigationBar.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[]),
      bottomNavigationBar: MyNavigationBar(),
      body: ListView(
        children: <Widget>[
          Center(child: Image(image: AssetImage('assets/images/icon.png'), width: 250)),
          SizedBox(height: 20),
          InkWell(child: Center(child: Text(AppLocalizations.of(context).translate("creato_da") + "Francesco Rossetti", style: TextStyle(fontSize: 25))),
            onTap: () => launch('https://github.com/fraross')
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot){
              if(snapshot.hasData) {
                return Center(child: Text(AppLocalizations.of(context).translate("versione") + ": " + snapshot.data.version + "." + snapshot.data.buildNumber, style: TextStyle(fontSize: 20)));
              }
              else {
                return Container();
              }
            }
          ),
          SizedBox(height: 50),
          InkWell(child: Center(child: Text(AppLocalizations.of(context).translate("informativa_privacy"))),
            onTap: () => launch('https://gestione-prevendite.flycricket.io/privacy.html'),
          ),
          SizedBox(height: 10),
          InkWell(child: Center(child: Text(AppLocalizations.of(context).translate("termini_di_servizio"))),
            onTap: () => launch('https://gestione-prevendite.flycricket.io/terms.html'),
          ),
        ],
      )
    );
  }
}