import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gestioneprevendite/Pages/Charts/IstogrammaVendite.dart';
import 'package:gestioneprevendite/Pages/Charts/PieRicaviAzienda.dart';
import 'package:gestioneprevendite/Pages/Charts/tiles.dart';
import 'package:gestioneprevendite/Pages/Impostazioni/Info.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/Pages/Utils/menu.dart';
import 'package:gestioneprevendite/Pages/Impostazioni/settings.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/UIModels/NavigationBar.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
      const StaggeredTile.count(4, 3),
      const StaggeredTile.count(2, 2),
      const StaggeredTile.count(2, 1),
      const StaggeredTile.count(2, 1),
      const StaggeredTile.count(4, 1),
    ];

    List<Widget> _tiles = <Widget>[
      IstogrammaVendite.withSampleData(Colors.green),
      PieRicavi.withSampleData(Colors.deepOrange),
      Tiles(Colors.amber, Text(AppLocalizations.of(context).translate("in_costruzione"))),
      Tiles(Colors.brown, Text(AppLocalizations.of(context).translate("in_costruzione"))),
      SizedBox(height: 220, child: AdmobBanner(
        adUnitId: "ca-app-pub-3318650813130043/3646941983", //"ca-app-pub-3940256099942544/6300978111", 
        adSize: AdmobBannerSize.LARGE_BANNER,
      )),
    ];

    List<CustomPopupMenu> choices = <CustomPopupMenu>[
      CustomPopupMenu(title: AppLocalizations.of(context).translate("info"), widget: null),
      CustomPopupMenu(title: AppLocalizations.of(context).translate("impostazioni"), widget: null)
    ];

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        PopupMenuButton<CustomPopupMenu>(
          elevation: 3.2,
          onCanceled: () {
          },
          onSelected: (item) {
            String settings = AppLocalizations.of(context).translate("impostazioni");
            String info = AppLocalizations.of(context).translate("info");
            if(item.title == settings)
              Navigator.push(context, EnterExitRoute(exitPage: MyHomePage(), enterPage: Impostazioni()));
            else if(item.title == info)
              Navigator.push(context, EnterExitRoute(exitPage: MyHomePage(), enterPage: InfoScreen()));
          },
          itemBuilder: (BuildContext context) {
            return choices.map((CustomPopupMenu choice) {
              return PopupMenuItem<CustomPopupMenu>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        )
      ]),
      bottomNavigationBar: MyNavigationBar(),
      body: new StaggeredGridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: _tiles,
        staggeredTiles: _staggeredTiles,
      )
    );
  }
}
