import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/services/Prevendita.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class IstogrammaVendite extends StatelessWidget {
  final Color backgroundColor;
  final bool animate;

  IstogrammaVendite({ this.animate, this.backgroundColor });

  /// Creates a [BarChart] with initial selection behavior.
  factory IstogrammaVendite.withSampleData(Color backColor) {
    return new IstogrammaVendite(
      backgroundColor: backColor,
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _createSampleData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          var chart = new charts.BarChart(
            snapshot.data,
            animate: animate,
            barGroupingType: charts.BarGroupingType.grouped,
            vertical: false,
            primaryMeasureAxis: new charts.NumericAxisSpec(
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
            secondaryMeasureAxis: new charts.NumericAxisSpec(
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
          );
          var chartWidget = new Padding(
            padding: new EdgeInsets.all(2.0),
            child: new SizedBox(
              height: 250.0,
              child: chart,
            ),
          );

          return Card(
            color: backgroundColor,
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    AppLocalizations.of(context).translate("riassunto_vendite"),
                    style: TextStyle(fontSize: 21),
                  ),
                  chartWidget,
                ],
              ),
            ),
          );
        } else {
          return Card(
            color: backgroundColor
          );
        }
      }
    );
  }

  /// Create one series with sample hard coded data.
  static Future<List<charts.Series<Vendite, String>>> _createSampleData() async {
    var map = await PrevenditaService().getPrevendit4Isto();
    var list = new List<Vendite>();
    map.forEach((x) => list.add(new Vendite(x["Data"], x["Vendite"])));

    return list.length > 0 ? [
      new charts.Series<Vendite, String>(
        id: 'Vendite',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Vendite sales, _) => sales.data,
        measureFn: (Vendite sales, _) => sales.vendite,
        data: list
      )
    ] : [];
  }
}

/// Sample ordinal data type.
class Vendite {
  final String data;
  final int vendite;

  Vendite(this.data, this.vendite);
}