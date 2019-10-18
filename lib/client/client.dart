import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hack_heroes_mobile/client/help_request.dart';
import 'package:hack_heroes_mobile/client/server_options.dart';
import 'package:hack_heroes_mobile/client/session.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';

/*

POST /getHelp {text, image}
Server create request with id
Response {id, place in queue}

WebSocket -> /ws
send id
Server assign socket to request with id

GET /helpNeeded
Response {needed, id, text, image}
Client ask user

POST /offerHelp {id, text}
Server find request with id
Send text -> request.socket
Remove request

 */


class AppClient {
  AppClient();

  void dispose() {

  }

  Future<HelpRequest> helpNeeded() async {
    final request = await HttpClient().get(ServerOptions.Host, ServerOptions.Port, ServerOptions.HelpNeeded);
    final response = await request.close();

    switch (response.statusCode) {
      case HttpStatus.ok:
        final data = await _decodeResponse(response);
        if (data['status'] == 'ok') {
          if (data['needed'] == false) {
            print('Help not needed');
            return null;
          }
          else {
//            final image = HelpImage.fromBase64(data['image']);
            return HelpRequest(data['id'], data['text'], null);
          }
        }
        else {
          print('Response error ${data['status']}');
          return null;
        }
        break;

      default:
        print('HTTP error ${response.statusCode}');
        return null;
    }
  }

  Future<void> offerHelp(HelpRequest helpRequest, String text) async {
    final request = await HttpClient().postUrl(
        Uri.parse('https://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.OfferHelp}')
    );

    request
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({
        'id': helpRequest.id,
        'text': text
      }));

    await request.close();
  }

  Future<void> getHelp(String text, HelpImage image) async {
    try {
      final session = await _requestHelp(text, image);
      print('Got session ${session.id}}');
      await session.connect();
    }
    catch (e) {
      print('Error getting help: $e');
    }
  }

  Future<Session> _requestHelp(String text, HelpImage image) async {
    final request = await HttpClient().postUrl(
      Uri.parse('https://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.GetHelp}')
    );

    request
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({
        'text': text,
        'image': base64Encode(await image.bytes)
      }));

    final response = await request.close();

    switch (response.statusCode) {
      case HttpStatus.ok:
        final data = await _decodeResponse(response);
        if (data['status'] == 'ok') {
          final place = data['placeInQueue'] as int;
          print('In queue: $place');
          final id = data['id'] as String;
          return Session(id);
        }
        else {
          throw('Response error ${data['status']}');
        }
        break;

      default:
        throw('HTTP error ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> _decodeResponse(HttpClientResponse response) async {
    return jsonDecode(await utf8.decoder.bind(response).join());
  }
}