import 'package:flutter/material.dart';

class ConfirmDialogView extends StatefulWidget {
  const ConfirmDialogView(
      {Key? key,
        this.description,
        this.leftButtonText,
        this.rightButtonText,
        this.title,
        this.onAgreeTap,
        this.forceUpdate=false,
      })
      : super(key: key);

  final String? description, leftButtonText,rightButtonText,title;
  final bool? forceUpdate;
  final Function? onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ConfirmDialogView> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ConfirmDialogView widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: 4,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: 20,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        Icon(
          Icons.help_outline,
          color: Colors.white,
        ),
        _spacingWidget,
        Text(
          widget.title!,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );

    final Widget _messageWidget = Text(
      widget.description!,
      style: Theme.of(context).textTheme.subtitle2,
    );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Theme.of(context).accentColor,
              ),
              child: _headerWidget),
          _largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(widget.leftButtonText!,
                      style: Theme.of(context).textTheme.button),
                )),
            Container(
                height: 50,
                width: 0.4,
                color: Theme.of(context).iconTheme.color),
            widget.forceUpdate!
                ?Expanded(
                child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    widget.onAgreeTap!();
                  },
                  child: Text(
                    widget.rightButtonText!,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        !.copyWith(color: Theme.of(context).accentColor),
                  ),
                ))
                :SizedBox(height: 0,),
          ]),

        ],
      ),
    );
  }
}
