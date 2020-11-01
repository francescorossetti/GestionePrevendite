import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/SottoPR/sottopr.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';
import 'package:gestioneprevendite/services/SottoPR.service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class SottoPRDetail extends StatefulWidget {
  final SottoPR sottoPR;

  SottoPRDetail({ Key key, @required this.sottoPR }) : super(key: key);

  @override
  _SottoPRDetailState createState() => _SottoPRDetailState();
}

class _SottoPRDetailState extends State<SottoPRDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nome;
  TextEditingController nomeController = new TextEditingController();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    if(widget.sottoPR != null){
      nomeController.text = widget.sottoPR.nome;
    }

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        widget.sottoPR != null ? IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () async {
            widget.sottoPR.ablitato = false;
            bool result = await SottoPRService().delete(widget.sottoPR);
            if(result){
              Navigator.pop(context);
              Navigator.pushReplacement(context, EnterExitRoute(exitPage: SottoPRDetail(sottoPR: widget.sottoPR), enterPage: SottoPRList()));
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
                icon: const Icon(Icons.person),
                labelText: AppLocalizations.of(context).translate("nome"),
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

                  if(widget.sottoPR != null) {
                    widget.sottoPR.nome = _nome;
                    result = await SottoPRService().update(widget.sottoPR);
                  } else {
                    SottoPR sottoPR = new SottoPR(idSottoPr: null, nome: _nome, ablitato: true);
                    result = await SottoPRService().insert(sottoPR);
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