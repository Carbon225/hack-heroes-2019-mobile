import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/client/connection_status.dart';

class HelperCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelperCardState();
}

class HelperCardState extends State<HelperCard> {

  final _appClient = AppClient();

  @override
  void dispose() {
    _appClient.dispose();
    super.dispose();
  }

  Future<void> _offerHelp() async {
    try {
      await _appClient.offerHelp();
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<ConnectionStatus>(
            stream: _appClient.stateStream,
            builder: (BuildContext context, AsyncSnapshot<ConnectionStatus> snapshot) {
              return Text(snapshot.data.toString().split('.').last);
            },
            initialData: ConnectionStatus.NotConnected,
          ),
          IconButton(
            onPressed: _offerHelp,
            alignment: Alignment.center,
            iconSize: 150,
            icon: Image.asset('assets/get_help.png'),
          ),
          Text('Offer help',
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
    );
  }
}