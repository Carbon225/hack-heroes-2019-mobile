import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:hack_heroes_mobile/logic/help_image.dart';
import 'package:path_provider/path_provider.dart';

class CameraWrapper {
  CameraWrapper();

  Future<void> init() async {
    _controller = CameraController(
      await _rearCamera(),
      ResolutionPreset.medium
    );

    _initialized = _controller.initialize();
    await _initialized;
  }

  Future<void> dispose() async {
    await _controller.dispose();
  }

  Widget get preview {
    return CameraPreview(_controller);
  }

  Future<void> get initialized {
    return _initialized;
}

  Future<HelpImage> takeImage() async {
    try {
      await _initialized;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);
      return HelpImage.fromFile(path);
    }
    catch (e) {
      print(e);
      return HelpImage.missing();
    }
  }

  Future<CameraDescription> _rearCamera() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  CameraController _controller;
  Future<void> _initialized;
}