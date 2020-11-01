import 'package:admob_flutter/admob_flutter.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Azienda/aziendaDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/services/Azienda.service.dart';
import 'package:gestioneprevendite/services/Evento.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EventoDetail extends StatefulWidget {
  final Evento evento;

  EventoDetail({ Key key, @required this.evento });

  @override
  _EventoDetailState createState() => _EventoDetailState();
}

class _EventoDetailState extends State<EventoDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  bool firstVisit = true;
  
  String nome;
  TextEditingController nomeController = new TextEditingController();
  
  String costo;
  TextEditingController costoController = new TextEditingController();

  TextEditingController dateController = new TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<Azienda> aziende;
  int selectedAzienda;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().add(Duration(days: -1)),
      lastDate: DateTime(2101)
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = new DateFormat("dd/MM/yyyy").format(selectedDate.toLocal());
      });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.evento != null && firstVisit){
      firstVisit = false;
      nomeController.text = widget.evento.nome;
      costoController.text = widget.evento.costoPrevendite.toString();
      selectedDate = widget.evento.data;
      selectedAzienda = widget.evento.fkLocale.idAzienda;
    }

    dateController.text = new DateFormat("dd/MM/yyyy").format(selectedDate.toLocal());

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        widget.evento != null ? IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () async {
            widget.evento.ablitato = false;
            bool result = await EventoService().delete(widget.evento);
            if(result){
              Navigator.pop(context);
            }
          },
        ) : Container()
      ]),
      body: Form(key: _formKey, child: 
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            TextFormField(
              controller: nomeController,
              keyboardType: TextInputType.text,
              onSaved: (String val){
                nome = val;
              },
              validator: (value){
                return value.isEmpty ? AppLocalizations.of(context).translate("campo_richiesto") : null;
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.calendar_today),
                labelText: AppLocalizations.of(context).translate("nome_evento"),
              ),
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
            InkWell(child: TextFormField(
                controller: dateController,
                enabled: false,
                validator: (value){
                  return value.isEmpty ? AppLocalizations.of(context).translate("campo_richiesto") : null;
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: AppLocalizations.of(context).translate("data_evento"),
                ),
              ),
              onTap: (){
                _selectDate(context);
              },
            ),
            SizedBox(height: 30),
            FutureBuilder(
              future: AziendaService().getAziende(),
              builder: (BuildContext context, AsyncSnapshot<List<Azienda>> snapshot) {
                if(snapshot.hasData) {
                  aziende = snapshot.data;
                  List<Map<String, dynamic>> toMap = new List<Map<String, dynamic>>();
                  snapshot.data.forEach((x) => toMap.add(x.toMap()));
                  toMap.add(new Azienda(idAzienda: -1, nome: AppLocalizations.of(context).translate("aggiungi_azienda"), percentuale: null, ablitato: true).toMap());

                  return DropDownFormField(
                  titleText: AppLocalizations.of(context).translate("azienda"),
                  hintText: AppLocalizations.of(context).translate("seleziona_azienda"),
                  value: selectedAzienda,
                  onSaved: (value) {
                    setState(() {
                      selectedAzienda = value;
                    });
                  },
                  validator: (value){
                    if(value != null || selectedAzienda != null){
                      return null;
                    }
                    else {
                      return AppLocalizations.of(context).translate("campo_richiesto");
                    }
                  },
                  onChanged: (value) {
                    if(value != -1) {
                      setState(() {
                        selectedAzienda = value;
                      });
                    } else {
                      Navigator.push(context, EnterExitRoute(exitPage: EventoDetail(evento: widget.evento), enterPage: AziendaDetail(azienda: null)));
                    }
                  },
                  dataSource: toMap,
                  textField: 'NomeAzienda',
                  valueField: 'IDAzienda',
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 30),
            AdmobBanner(
              adUnitId: "ca-app-pub-3318650813130043/3646941983", //"ca-app-pub-3940256099942544/6300978111", 
              adSize: AdmobBannerSize.BANNER,
            ),
            SizedBox(height: 20),
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
                  bool result;

                  if(widget.evento != null) {
                    widget.evento.nome = nome;
                    widget.evento.costoPrevendite = double.parse(costo);
                    widget.evento.data = selectedDate;
                    widget.evento.fkLocale = selectedAzienda != null ? aziende.where((x) => x.idAzienda == selectedAzienda).toList()[0] : widget.evento.fkLocale;
                    result = await EventoService().update(widget.evento);
                  } else {
                    Azienda az = aziende.where((x) => x.idAzienda == selectedAzienda).toList()[0];
                    Evento evento = new Evento(idEvento: null, nome: nome, data: selectedDate, fkLocale: az, costoPrevendite: double.parse(costo), ablitato: true);
                    result = await EventoService().insert(evento);
                  }

                  if(result){
                    setState(() {
                      _btnController.success();
                    });

                    await Future.delayed(const Duration(milliseconds: 1000));

                    Navigator.pop(context);
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
            )
          ]
        )
      )
    );
  }
}