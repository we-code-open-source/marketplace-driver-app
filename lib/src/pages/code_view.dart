import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../elements/BlockButtonWidget.dart';
import '../controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CodeView extends StatefulWidget {
  final RouteArgument? routeArgument;

  CodeView({Key? key, this.routeArgument}) : super(key: key);
  @override
  _CodeViewState createState() => _CodeViewState();
}

class _CodeViewState extends StateMVC<CodeView> {
  late UserController _con;

  _CodeViewState() : super(UserController()) {
    _con = controller as UserController;
  }
  @override
  void initState() {
    _con.confirmResetCode.phone_number=widget.routeArgument!.param['phone'];
    _con.startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () {
                Navigator.of(context).pop();

            }),
        automaticallyImplyLeading: false,
        title: Text(
          widget.routeArgument!.param['title'],
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Image.asset(
                "assets/img/code.png",
                height: MediaQuery.of(context).size.height / 3,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                widget.routeArgument!.param['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                ),
                currentCode: _con.codeController.text,
                controller: _con.codeController,
                onCodeSubmitted: (code) {},
                onCodeChanged: (code) {
                  if (code!.length == 6) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: BlockButtonWidget(
                  text: Text(
                      S.of(context)!.verification,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    if(widget.routeArgument!.param['type']=='pass') {
                      _con.confirmReset();
                    }else{
                      _con.confirmRegister();
                    }
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _con.counter!=0? Text(
                      "الرجاء الانتظار  ${_con.counter.toString()}" ,
                      style: TextStyle(color: Theme.of(context).accentColor,fontSize: 20),
                    )
                        :GestureDetector(
                      onTap: () => _con.reSendCode(_con.confirmResetCode.phone_number),
                      child: Text(
                        "اعادة ارسال" ,
                        style: TextStyle(color: Theme.of(context).accentColor,fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
