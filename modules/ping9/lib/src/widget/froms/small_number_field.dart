import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ping9/src/core/utils.dart';

class SmallNumberField extends StatelessWidget {
  SmallNumberField({this.value, this.onChanged, this.hintText});

  final ValueChanged onChanged;
  final int value;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: _buildValueBox(value), onPressed: () => _showAddItem(context));
  }

  Widget _buildValueBox(int val) {
    final bool normal = val == null || val <= 0;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: normal ? Colors.grey : Colors.blue,
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          normal ? "-" : "$val",
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _addItem(String val) {
    try {
      final int num = int.parse(val);
      if (num >= 0 && num <= 10) {
        onChanged(num);
      } else {
        Get.snackbar("Error", "Value from 0 to 10");
      }
    } catch (e) {
      printTrace(e);
    }
  }

  final _textController = TextEditingController();

  Future _showAddItem(BuildContext context) async {
    final result = await _showAddItemModal(context);
    if (isNullOrEmpty(result) == false) {
      _addItem(result);
    }
  }

  Future<String> _showAddItemModal(BuildContext context) async {
    _textController.text = (value ?? "").toString();
    String _valueInput = '';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(width: 24),
                    Text(
                      hintText,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const CloseButton(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _textController,
                        maxLength: 2,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: InputDecoration(
                            hintText: "0 -> 10",
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.add,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              onPressed: () {
                                _valueInput = _textController.text;
                                Navigator.pop(context);
                              },
                            )),
                        onFieldSubmitted: (value) {
                          _valueInput = _textController.text;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return _valueInput;
  }
}
