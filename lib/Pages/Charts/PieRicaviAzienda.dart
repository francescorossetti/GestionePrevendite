import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gestioneprevendite/services/Prevendita.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class PieRicavi extends StatelessWidget {
  final Color backgroundColor;
  final bool animate;

  PieRicavi({ this.animate, this.backgroundColor });

  /// Creates a [BarChart] with initial selection behavior.
  factory PieRicavi.withSampleData(Color backColor) {
    return new PieRicavi(
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
          var chart = new charts.PieChart(snapshot.data,
            animate: animate,
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 60,
                arcRendererDecorators: [new charts.ArcLabelDecorator()]));
          var chartWidget = new Padding(
            padding: new EdgeInsets.all(0.0),
            child: new SizedBox(
              height: 160.0,
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
                    AppLocalizations.of(context).translate('ricavi_totali'),
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


  /// Create series list with one series
  static Future<List<charts.Series<LinearSales, String>>> _createSampleData() async {
    var map = await PrevenditaService().getPrevendit4Pie();
    var list = new List<LinearSales>();
    map.forEach((x) => list.add(new LinearSales(x["Azienda"], x["Vendite"])));

    return list.length > 0 ? [
      new charts.Series<LinearSales, String>(
        id: 'Vendite',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: list,
      )
    ] : [];
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final double sales;

  LinearSales(this.year, this.sales);
}