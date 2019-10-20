import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hack_heroes_mobile/client/help_request.dart';
import 'package:hack_heroes_mobile/client/server_options.dart';
import 'package:hack_heroes_mobile/logic/firebase_notifications.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';
import 'package:path_provider/path_provider.dart';

/*

POST /getHelp {text, image, firebase_id}
Server create request with id
Response {place in queue}

GET /helpNeeded
Response {needed, id, text, image}
Client ask user

POST /offerHelp {id, text}
Server find request with id
Send text with FCM to client with id
Remove request

 */


class AppClient {
  AppClient();

  Future<void> dispose() async {
    await cancelRequest();
    await FirebaseNotifications.dispose();
  }

  void onResponse(Function cb) {
    FirebaseNotifications.onResponse(cb);
  }

  Future<void> cancelRequest() async {
    final request = await HttpClient().postUrl(
        Uri.parse('https://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.CancelRequest}')
    );

    request
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({
        'id': await FirebaseNotifications.getToken()
      }));

    await request.close();
  }

  Future<HelpRequest> helpNeeded() async {
    final request = await HttpClient().getUrl(
        Uri.parse('https://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.HelpNeeded}')
    );
    final response = await request.close();

    switch (response.statusCode) {
      case HttpStatus.ok:
        final data = await _decodeResponse(response);
        if (data['status'] == 'ok') {
          if (data['needed'] == false) {
            return null;
          }
          else {
            final tempDir = (await getApplicationDocumentsDirectory()).path;
            final imgPath = '$tempDir/${DateTime.now()}.png';

            final imgFile = File(imgPath).openWrite();
            imgFile.add(base64Decode(data['image']));
            imgFile.close();

            return HelpRequest(data['id'], data['text'], HelpImage.fromFile(imgPath));
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
      await cancelRequest();
      await _requestHelp(text, image);
      print('Registered request');
    }
    catch (e) {
      print('Error getting help: $e');
    }
  }

  Future<void> _requestHelp(String text, HelpImage image) async {
    final request = await HttpClient().postUrl(
      Uri.parse('https://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.GetHelp}')
    );

    request
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({
        'id': await FirebaseNotifications.getToken(),
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
//          return Session(id);
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