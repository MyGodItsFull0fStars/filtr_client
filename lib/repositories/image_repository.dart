import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class ImageRepository {
  ImageRepository();

  CameraController _controller;
  CameraDescription _camera;

  Future<String> takePhoto() async {
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    await _controller.takePicture(path);
    return path;
  }

  Future<File> getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _camera = cameras.first;
    _controller = CameraController(
      _camera,
      ResolutionPreset.medium,
    );
    return _controller.initialize();
  }

  CameraController getController() {
    return _controller;
  }

  Future<String> sendImage(File image) async {
    List<int> imageBytes = image.readAsBytesSync();
    String imageB64 = base64Encode(imageBytes);

    String url = 'https://UNSREAPI/HASHTAGADRESSE';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"image": $imageB64}';

    Response response = await post(url, headers: headers, body: json);
    //int statusCode = response.statusCode;

    return response.body;
  }

  /*Future<File> downloadImage(String json){
    //decode json

    //return file
  }*/
}
