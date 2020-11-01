import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:gestioneprevendite/services/Azienda.service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class AziendaDetail extends StatefulWidget {
  final Azienda azienda;

  AziendaDetail({ Key key, @required this.azienda });

  @override
  _AziendaDetailState createState() => _AziendaDetailState();
}

class _AziendaDetailState extends State<AziendaDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nome;
  TextEditingController nomeController = new TextEditingController();
  String _perc;
  TextEditingController percController = new TextEditingController();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    if(widget.azienda != null){
      nomeController.text = widget.azienda.nome;
      percController.text = widget.azienda.percentuale.toString();
    }

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        widget.azienda != null ? IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () async {
            widget.azienda.ablitato = false;
            bool result = await AziendaService().delete(widget.azienda);
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
                _nome = val;
              },
              validator: (value){
                return value.isEmpty ? AppLocalizations.of(context).translate("campo_richiesto") : null;
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.account_balance),
                labelText: AppLocalizations.of(context).translate("nome_azienda"),
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: percController,
              keyboardType: TextInputType.number,
              onSaved: (String val){
                _perc = val;
              },
              validator: (value){
                int val = int.tryParse(value);

                if(val != null && val > 0 && val <= 100) {
                  return null;
                } else {
                  return AppLocalizations.of(context).translate("campo_richiesto");
                }
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.monetization_on),
                labelText: AppLocalizations.of(context).translate("percentuale_compenso"),
              ),
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

                  if(widget.azienda != null) {
                    widget.azienda.nome = _nome;
                    widget.azienda.percentuale = int.parse(_perc);
                    result = await AziendaService().update(widget.azienda);
                  } else {
                    Azienda azienda = new Azienda(idAzienda: null, nome: _nome, percentuale: int.parse(_perc), ablitato: true);
                    result = await AziendaService().insert(azienda);
                  }

                  if(result){
                    setState(() {
                      _btnController.success();
                    });

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
            ),
            SizedBox(height: 60),
            AdmobBanner(
              adUnitId: "ca-app-pub-3318650813130043/3646941983", //"ca-app-pub-3940256099942544/6300978111",
              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          ]
        )
      )
    );
  }
}