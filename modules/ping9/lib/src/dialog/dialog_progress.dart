import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String _dialogMessage = '';
StreamController<String> _streamController =
    StreamController<String>.broadcast();

_DialogProgress _progressDialog;

Future<void> showLoading(BuildContext context,
    {String message = '', Color bgRoundedColor}) async {
  if (_progressDialog == null) {
    _progressDialog = _DialogProgress(bgRoundedColor: bgRoundedColor);
    _dialogMessage = message;
    return _progressDialog.show(context);
  }
}

void hideLoading(BuildContext context) {
  if (_progressDialog != null) {
    _progressDialog.hide(context);
    _progressDialog = null;
  }
}

void updateLoading(String message) {
  _dialogMessage = message;
  _streamController.add(message);
}

class _DialogProgress {
  _DialogProgress({this.bgRoundedColor});

  final Color bgRoundedColor;

  void hide(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  void show(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: StreamBuilder(
            initialData: _dialogMessage,
            stream: _streamController.stream,
            builder: (_, builder) {
              return Center(
                child: Container(
                  width: _dialogMessage.isEmpty ? 80 : 130,
                  decoration: BoxDecoration(
                    color: bgRoundedColor ?? Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Platform.isIOS
                            ? const CupertinoActivityIndicator(
                                radius: 15,
                              )
                            : SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor),
                                ),
                              ),
                      ),

                      /// Bottom
                      if (_dialogMessage.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          width: double.infinity,
                          child: Text(
                            _dialogMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: bgRoundedColor != null
                                  ? Colors.black87
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
