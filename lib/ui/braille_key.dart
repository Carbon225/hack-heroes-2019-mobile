import 'package:flutter/material.dart';

class BrailleKey extends StatelessWidget {
  final bool active;
  final int id;
  final String label;
  final Function _handleMultiTouch;

  BrailleKey(this.id, this.label, this._handleMultiTouch, [this.active = false]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (e) => _handleMultiTouch(id, e),
      onTapUp: (e) => _handleMultiTouch(id, e),
      onTapCancel: () => _handleMultiTouch(id, null),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 5
          )],
          shape: BoxShape.rectangle,
          color: active ? Colors.greenAccent : Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(label,
            style: Theme.of(context).textTheme.button.apply(color: Colors.white),
          ),
        ),
      ),
    );
  }
}