import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/client/help_request.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';

class IncomingRequest extends StatefulWidget {

  final Stream<HelpRequest> helpStream;

  IncomingRequest(this.helpStream);

  @override
  State<StatefulWidget> createState() => IncomingRequestState();
}

class IncomingRequestState extends State<IncomingRequest> with TickerProviderStateMixin {

  AppClient _appClient;

  HelpRequest _lastRequest;
  StreamSubscription _streamSubscription;

  Animation<Offset> _verticalSlide;
  AnimationController _verticalAnimation;

  TextEditingController _textController;
  String _responseText = '';

  @override
  void initState() {
    _textController = TextEditingController(
      text: _responseText,
    );

    _textController.addListener(() {
      setState(() {
        _responseText = _textController.text;
      });
    });

    _appClient = AppClient();

    _verticalAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0,
    );

    _verticalSlide = MaterialPointArcTween(
      begin: Offset(0, -1), end: Offset(0, 0),
    ).animate(_verticalAnimation);

    _streamSubscription = widget.helpStream.listen((request) {
      setState(() {
        _lastRequest = request;
        _verticalAnimation.forward();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _appClient.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _verticalAnimation.reverse();
    _textController.text = '';
    _responseText = '';
  }

  Future<void> _respond() async {
    if (_responseValid()) {
      _appClient.offerHelp(_lastRequest, _responseText);
      _dismiss();
    }
  }

  bool _responseValid() {
    return _responseText.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _verticalSlide,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text('Someone needs help',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  IconButton(
                    color: Colors.redAccent,
                    icon: Icon(Icons.cancel),
                    onPressed: _dismiss,
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<ImageProvider>(
                  initialData: HelpImage.Missing,
                  future: _lastRequest?.image?.image ?? Future.value(HelpImage.Missing),
                  builder: (context, AsyncSnapshot<ImageProvider> snapshot) => Image(
                    image: snapshot.data,
                  ),
                ),
              ),
              Text(_lastRequest?.text ?? ''),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                    ),
                  ),
                  IconButton(
                    onPressed: _responseValid() ? _respond : null,
                    icon: Icon(Icons.send),
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}