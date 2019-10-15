import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';

class SendLetter extends StatefulWidget {
  final Stream<HelpImage> _inputStream;
  final bool _show;

  SendLetter(this._inputStream, this._show);

  @override
  State<StatefulWidget> createState() => SendLetterState();
}

class SendLetterState extends State<SendLetter> with TickerProviderStateMixin {
  Animation<Offset> _sendAnimation;
  AnimationController _sendController;

  @override
  void initState() {
    _sendController = AnimationController(
        duration: Duration(milliseconds: 1000),
        vsync: this
    );
    _sendAnimation = Tween(begin: Offset.zero, end: Offset(0.0, -5.0))
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_sendController);

    _sendController.value = 0.0;

    super.initState();
  }

  @override
  void dispose() {
    _sendController.dispose();
    super.dispose();
  }

  void send() {
    _sendController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideTransition(
        position: _sendAnimation,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: AnimatedSize(
            duration: Duration(milliseconds: 700),
            reverseDuration: Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            vsync: this,
            alignment: Alignment.center,
            child: StreamBuilder<HelpImage>(
              initialData: HelpImage.missing(),
              stream: widget._inputStream,
              builder: (context, AsyncSnapshot<HelpImage> streamItem) => FutureBuilder<ImageProvider>(
                initialData: HelpImage.Missing,
                future: streamItem.data.image,
                builder: (context, AsyncSnapshot<ImageProvider> imageSnap) => FutureBuilder<bool>(
                  initialData: false,
                  future: streamItem.data.valid,
                  builder: (context, AsyncSnapshot<bool> validSnap) {
                    if (validSnap.data) {
                      Future.delayed(Duration(seconds: 1), send);
                    }
                    return Image(
                      image: imageSnap.data,
                      height:validSnap.data ? null : 40,
                    );
                  } ,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}