import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class ImageRepository {
  ImageRepository();
  Client client = new Client();
  int _reps = 5;
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

    Response response = await client.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      return getValueFromResponse(response.body, 'id');
    } else if (statusCode == 500) {
      throw Exception("Service unavailable!");
    } else {
      throw Exception("Unknown Error occured during request with statuscode $statusCode!");
    }
  }

  String getValueFromResponse(String response, String value) {
    Map<String, dynamic> json = jsonDecode(response);
    if(json.containsKey(value)){
      return json[value].toString();
    }
    else{
      throw Exception("Value $value does not exist in response!");
    }
  }

  Future<Uint8List> downloadImage(String id) async {
    String url = 'https://EXAMPLEURL/IMAGE/ID/$id';
    int statusCode = 500;
    String json = '{"init":"1234"}';
    for (int i = 0; i < _reps; i++) {
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        Response response = await client.get(url);
        statusCode = response.statusCode;
        json = response.body;
      });
      if (statusCode == 200) {
        return base64Decode(getValueFromResponse(json, 'b64'));
      } else if (statusCode == 202) {
        // still not finished
      } else {
        //Throw Error?
      }
    }
    return null;
  }

  Future<File> saveB64Image(Uint8List bytes) async {
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    File file = File(path);
    await file.writeAsBytes(bytes);
    return file;
  }
}
