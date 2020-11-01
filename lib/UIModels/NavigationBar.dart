import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Azienda/azienda.dart';
import 'package:gestioneprevendite/Pages/Evento/evento.dart';
import 'package:gestioneprevendite/Pages/Prevendita/prevendita.dart';
import 'package:gestioneprevendite/Pages/SottoPR/sottopr.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/FadeRouteAnimation.dart';
import 'package:gestioneprevendite/Pages/home.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  static int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index) {
        setState(() => _currentIndex = index);

        FadeRoute route;

        switch(index){
          case 0:
            route = FadeRoute(page: MyHomePage());
          break;

          case 1:
            route = FadeRoute(page: AziendaList());
          break;
          
          case 2:
            route = FadeRoute(page: SottoPRList());
          break;

          case 3:
            route = FadeRoute(page: EventoList());
          break;

          case 4:
            route = FadeRoute(page: PrevenditaList());
          break;
        }

        if(route != null)
          Navigator.pushReplacement(context, route);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          activeColor: Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.white,
          title: Text('Home'),
          icon: Icon(Icons.home)
        ),
        BottomNavyBarItem(
          activeColor: Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.white,
          title: Text(AppLocalizations.of(context).translate("aziende")),
          icon: Icon(Icons.account_balance)
        ),
        BottomNavyBarItem(
          activeColor: Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.white,
          title: Text(AppLocalizations.of(context).translate("personale")),
          icon: Icon(Icons.person)
        ),
        BottomNavyBarItem(
          activeColor: Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.white,
          title: Text(AppLocalizations.of(context).translate("eventi")),
          icon: Icon(Icons.event)
        ),
        BottomNavyBarItem(
          activeColor: Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.white,
          title: Text(AppLocalizations.of(context).translate("prevendite")),
          icon: Icon(Icons.shopping_cart)
        ),
      ],
    );
  }
}