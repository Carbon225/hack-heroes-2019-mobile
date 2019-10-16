import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';

class SendLetter extends StatefulWidget {
  final Stream<HelpImage> _inputStream;

  SendLetter(this._inputStream);

  @override
  State<StatefulWidget> createState() => SendLetterState();
}

class SendLetterState extends State<SendLetter> with TickerProviderStateMixin {
  HelpImage _currentImage;

  StreamSubscription _streamSubscription;

  static const SendDuration = Duration(milliseconds: 500);
  static const ScaleDuration = Duration(milliseconds: 700);

  Animation<double> _sendAnimation;
  AnimationController _sendController;

  @override
  void initState() {
    _streamSubscription = widget._inputStream.listen(_sendImage);

    _sendController = AnimationController(
      duration: SendDuration,
      reverseDuration: Duration.zero,
      vsync: this,
      value: 0.0,
    );
    _sendAnimation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_sendController);

    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _sendController.dispose();
    super.dispose();
  }

  Future<void> _sendImage(HelpImage image) async {
    if (!await image.valid) {
      await _reset();
      return;
    }

    // scale up card
    setState(() {
      _currentImage = image;
    });
    await _awaitScale();
    await Future.delayed(Duration(milliseconds: 300));
    // start and wait for flight to finish
    await _sendController.forward();
    await _reset();
  }

  Future<void> _reset() async {
    // start scaling down card
    setState(() {
      _currentImage = null;
    });
    await _awaitScale();
    // card now has 0 height
    _sendController.reset();
  }

  Future<void> _awaitScale() async {
    await Future.delayed(ScaleDuration);
  }

  Future<void> _awaitSend() async {
    await Future.delayed(SendDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _sendController,
        builder: (context, child) => Transform(
          transform: Matrix4.translationValues(0.0, -_sendAnimation.value*1000, 0.0),
          child: child,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: AnimatedSize(
            duration: ScaleDuration,
            reverseDuration: Duration.zero,
            curve: Curves.easeInOut,
            vsync: this,
            alignment: Alignment.center,
            child: FutureBuilder<ImageProvider>(
              initialData: HelpImage.Missing,
              future: _currentImage?.image ?? Future.value(HelpImage.Missing),
              builder: (context, AsyncSnapshot<ImageProvider> imageSnap) => FutureBuilder<bool>(
                initialData: false,
                future: _currentImage?.valid ?? Future.value(false),
                builder: (context, AsyncSnapshot<bool> validSnap) {
                  if (_currentImage == null) {
                    return Container();
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
    );
  }
}