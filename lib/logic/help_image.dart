import 'dart:io';

import 'package:flutter/material.dart';

class HelpImage {
  static const ImageProvider Missing = AssetImage('assets/image-missing.png');

  HelpImage.missing()
      : _path = 'null',
        _validFuture = Future.value(false),
        _imageFuture = Future.value(Missing);

  HelpImage.fromFile(this._path)
      : _validFuture = File(_path).exists(),
        _imageFuture = Future(() async {
          if (await File(_path).exists()) {
            return FileImage(File(_path));
          }
          else {
            return Missing;
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

  final String _path;
  final Future<bool> _validFuture;
  final Future<ImageProvider> _imageFuture;
}