import 'dart:io';

import 'package:flutter/material.dart';

class HelpImage {
  static const ImageProvider Missing = AssetImage('assets/image-missing.png');

  HelpImage.missing()
      : _path = 'null',
        _validFuture = Future.value(false),
        _imageFuture = Future.value(Missing),
        _bytesFuture = Future.error('File not found');

  HelpImage.fromFile(this._path)
      : _validFuture = File(_path).exists(),
        _imageFuture = Future(() async {
          if (await File(_path).exists()) {
            return FileImage(File(_path));
          }
          else {
            return Missing;
          }
        }),
        _bytesFuture = Future(() async {
          if (await File(_path).exists()) {
            return File(_path).readAsBytes();
          }
          else {
            return Future.error('File not found');
          }
        });

  String get path {
    return _path;
  }

  Future<bool> get valid {
    return _validFuture;
  }

  Future<ImageProvider> get image {
    return _imageFuture;
  }

  Future<List<int>> get bytes {
    return _bytesFuture;
  }

  final String _path;
  final Future<bool> _validFuture;
  final Future<ImageProvider> _imageFuture;
  final Future<List<int>> _bytesFuture;
}