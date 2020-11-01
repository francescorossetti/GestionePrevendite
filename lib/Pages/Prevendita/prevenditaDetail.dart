import 'package:admob_flutter/admob_flutter.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Evento/eventoDetail.dart';
import 'package:gestioneprevendite/Pages/SottoPR/sottoprDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';
import 'package:gestioneprevendite/services/Evento.service.dart';
import 'package:gestioneprevendite/services/Prevendita.service.dart';
import 'package:gestioneprevendite/services/SottoPR.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PrevenditaDetail extends StatefulWidget {
  final Prevendita prevendita;

  PrevenditaDetail({ Key key, this.prevendita }) : super(key: key);

  @override
  _PrevenditaDetailState createState() => _PrevenditaDetailState();
}

class _PrevenditaDetailState extends State<PrevenditaDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  bool firstVisit = true;
  
  String costo;
  TextEditingController costoController = new TextEditingController();

  String note;
  TextEditingController noteController = new TextEditingController();

  List<Evento> eventi;
  int selectedEvento;
  
  List<SottoPR> sottoPR;
  int selectedSottoPR;

  TextEditingController numberController = new TextEditingController();
  int selectedNumber = 1;

  AdmobInterstitial interstitialAd;

  Future<Null> selectNumber(BuildContext context) async {
    final int picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 100,
          title: new Text(AppLocalizations.of(context).translate("seleziona_numero_prevendite")),
          initialIntegerValue: selectedNumber,
        );
      }
    );

    if (picked != null && picked != selectedNumber)
      setState(() {
        selectedNumber = picked;
        numberController.text = selectedNumber.toString();
      });
  }

  @override
  void initState() {
    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-3318650813130043/7573459149", //"ca-app-pub-3940256099942544/8691691433",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.failedToLoad) {
          print("Error code: ${args['errorCode']}");
        }
        else if(event == AdmobAdEvent.closed){
          Navigator.of(context).pop();
        }
      },
    );

    interstitialAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.prevendita != null && firstVisit){
      firstVisit = false;
      costoController.text = widget.prevendita.costoPrevendita.toString();
      if(widget.prevendita.vendutaDa != null) selectedSottoPR = widget.prevendita.vendutaDa.idSottoPr; else selectedSottoPR = -1;
      selectedEvento = widget.prevendita.fkEvento.idEvento;
      noteController.text = widget.prevendita.note;
    } else if(widget.prevendita == null && firstVisit) {
      firstVisit = false;
      selectedSottoPR = -1;
    }

    numberController.text = selectedNumber.toString();

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        widget.prevendita != null ? IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () async {
            widget.prevendita.ablitato = false;
            bool result = await PrevenditaService().delete(widget.prevendita);
            if(result){
              bool adLoaded = await interstitialAd.isLoaded;
              if (adLoaded) {
                interstitialAd.show();
              }
              else {
                Navigator.of(context).pop();
              }
            }
          },
        ) : Container()
      ]),
      body: Form(key: _formKey, child: 
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            SizedBox(height: 20),
            FutureBuilder(
              future: EventoService().getEventi(),
              builder: (BuildContext context, AsyncSnapshot<List<Evento>> snapshot) {
                if(snapshot.hasData) {
                  eventi = snapshot.data;
                  List<Map<String, dynamic>> toMap = new List<Map<String, dynamic>>();
                  snapshot.data.forEach((x) => toMap.add(x.toMap()));
                  toMap.add(new Evento(idEvento: -2, nome: AppLocalizations.of(context).translate("aggiungi_evento"), data: DateTime.now(), fkLocale: new Azienda(idAzienda: null, nome: null, percentuale: null, ablitato: true), costoPrevendite: null, ablitato: true).toMap());

                  return DropDownFormField(
                  titleText: AppLocalizations.of(context).translate("evento"),
                  hintText: AppLocalizations.of(context).translate("seleziona_evento"),
                  value: selectedEvento,
                  onSaved: (value) {
                    setState(() {
                      selectedEvento = value;
                    });
                  },
                  validator: (value){
                    if(value != null || selectedEvento != null){
                      return null;
                    }
                    else {
                      return AppLocalizations.of(context).translate("campo_richiesto");
                    }
                  },
                  onChanged: (value) {
                    if(value != -2) {
                      setState(() {
                        selectedEvento = value;
                        var costoBase = eventi.where((x) => x.idEvento == value).toList()[0].costoPrevendite;
                        if(costoController.text.isEmpty)
                          costoController.text = costoBase.toString();
                      });
                    } else {
                      Navigator.push(context, EnterExitRoute(exitPage: PrevenditaDetail(prevendita: widget.prevendita), enterPage: EventoDetail(evento: null)));
                    }
                  },
                  dataSource: toMap,
                  textField: 'NomeEvento',
                  valueField: 'IDEvento',
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: costoController,
              keyboardType: TextInputType.number,
              onSaved: (String val){
                costo = val;
              },
              validator: (value){
                return value.isEmpty ? AppLocalizations.of(context).translate("campo_richiesto") : null;
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.monetization_on),
                labelText: AppLocalizations.of(context).translate("prezzo_prevendita"),
              ),
            ),  
            SizedBox(height: 30),
            TextFormField(
              controller: noteController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (String val){
                note = val;
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.note_add),
                labelText: AppLocalizations.of(context).translate("note"),
              ),
            ),           
            SizedBox(height: 30),
            FutureBuilder(
              future: SottoPRService().getSottoPR(),
              builder: (BuildContext context, AsyncSnapshot<List<SottoPR>> snapshot) {
                if(snapshot.hasData) {
                  sottoPR = snapshot.data;
                  List<Map<String, dynamic>> toMap = new List<Map<String, dynamic>>();
                  toMap.add(new SottoPR(idSottoPr: -1, nome: "", ablitato: true).toMap());
                  snapshot.data.forEach((x) => toMap.add(x.toMap()));
                  toMap.add(new SottoPR(idSottoPr: -2, nome: AppLocalizations.of(context).translate("aggiungi_personale"), ablitato: true).toMap());

                  return DropDownFormField(
                  titleText: AppLocalizations.of(context).translate("personale"),
                  hintText: AppLocalizations.of(context).translate("seleziona_membro_personale"),
                  value: selectedSottoPR,
                  onSaved: (value) {
                    setState(() {
                      selectedSottoPR = value;
                    });
                  },
                  validator: (value){
                    if(value != null || selectedSottoPR != null){
                      return null;
                    }
                    else {
                      return AppLocalizations.of(context).translate("campo_richiesto");
                    }
                  },
                  onChanged: (value) {
                    if(value != -2) {
                      setState(() {
                        selectedSottoPR = value;
                      });
                    } else {
                      Navigator.push(context, EnterExitRoute(exitPage: PrevenditaDetail(prevendita: widget.prevendita), enterPage: SottoPRDetail(sottoPR: null)));
                    }
                  },
                  dataSource: toMap,
                  textField: 'NomeSottoPR',
                  valueField: 'IDSottoPR',
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 30),
            widget.prevendita == null ? Column(children: <Widget>[
              InkWell(
                child: TextFormField(
                  controller: numberController,
                  enabled: false,
                  validator: (value){
                    return value.isEmpty ? AppLocalizations.of(context).translate("campo_richiesto") : null;
                  },
                  decoration: InputDecoration(
                    icon: const Icon(Icons.event),
                    labelText: AppLocalizations.of(context).translate("numero_prevendite"),
                  ),
                ),
                onTap: (){
                  selectNumber(context);
                },
              )
            ]) : Container(),
            SizedBox(height: 40),
            RoundedLoadingButton(
              child: Text(AppLocalizations.of(context).translate("conferma"), style: TextStyle(color: Colors.white)),
              controller: _btnController,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                setState(() {
                  _btnController.start();
                });

                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  bool result = false;

                  if(widget.prevendita != null) {
                    widget.prevendita.costoPrevendita = double.parse(costo);
                    widget.prevendita.note = note;
                    widget.prevendita.fkEvento = selectedEvento != null ? eventi.where((x) => x.idEvento == selectedEvento).toList()[0] : widget.prevendita.fkEvento;
                    widget.prevendita.vendutaDa = selectedSottoPR != null ? sottoPR.where((x) => x.idSottoPr == selectedSottoPR).toList()[0] : widget.prevendita.vendutaDa;
                    result = await PrevenditaService().update(widget.prevendita);
                  } else {
                    List<Prevendita> list = new List<Prevendita>();
                    for(int i = 0; i < selectedNumber; i++) {
                      Evento az = eventi.where((x) => x.idEvento == selectedEvento).toList()[0];
                      SottoPR pr = selectedSottoPR != null && selectedSottoPR != -1 ? sottoPR.where((x) => x.idSottoPr == selectedSottoPR).toList()[0] : null;
                      Prevendita prevendita = new Prevendita(idPrevendita: null, fkEvento: az, costoPrevendita: double.parse(costo), vendutaDa: pr, note: note, ablitato: true);
                      list.add(prevendita);
                    }

                    result = await PrevenditaService().insert(list);
                  }

                  if(result){
                    setState(() {
                      _btnController.success();
                    });

                    bool adLoaded = await interstitialAd.isLoaded;
                    if (adLoaded) {
                      interstitialAd.show();
                    }
                    else {
                      Navigator.of(context).pop();
                    }
                  }
                  else {
                    setState(() {
                      _btnController.error();
                    });
                    await Future.delayed(const Duration(seconds: 3));
                    setState(() {
                      _btnController.reset();
                    });
                  }
                } else {
                  setState(() {
                    _btnController.error();
                  });
                  await Future.delayed(const Duration(seconds: 3));
                  setState(() {
                    _btnController.reset();
                  });
                }
              },
            ),
            SizedBox(height: 20),
            AdmobBanner(
              adUnitId: "ca-app-pub-3318650813130043/7573459149", //"ca-app-pub-3940256099942544/1033173712",
              adSize: AdmobBannerSize.LARGE_BANNER,
            ),
          ]
        )
      )
    );
  }
}