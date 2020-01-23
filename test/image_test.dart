import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:filter_client/bloc/bloc.dart';
import 'package:filter_client/models/filter/filter.model.dart';
import 'package:filter_client/repositories/image_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:mockito/mockito.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  ImageRepository imageRepository;
  MockImageRepository mic;
  ImageBloc bloc;
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  final List<MethodCall> log = <MethodCall>[];
  dynamic response;

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
    return response;
  });

  setUp(() {
    setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
    imageRepository = new ImageRepository();
    mic = new MockImageRepository();
    bloc = new ImageBloc(imageRepository: mic);
  });

  group("http requests", () {
    test("sendImage for correct response", () async {
      MockClient mc = MockClient((request) async {
        final mapJson = {'imgID': 123};
        return Response(jsonEncode(mapJson), 200);
      });
      imageRepository.client = mc;
      final image = new File('flowers.png');
      String value = await imageRepository.sendImage(image,new Filter("test", "test"));
      expect(value, "123");
    });

    test("sendImage for service unavailable", () async {
      MockClient mc = MockClient((request) async {
        final mapJson = {'imgID': 123};
        return Response(jsonEncode(mapJson), 500);
      });
      imageRepository.client = mc;
      final image = new File('flowers.png');

      expect(() => imageRepository.sendImage(image,new Filter("test", "test")), throwsException);
    });

    test("downloadImage for correct response", () async {
      File image = new File('flowers.png');
      List<int> imageBytes = image.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      MockClient mc = MockClient((request) async {
        final mapJson = {'image': imageB64};
        return Response(jsonEncode(mapJson), 200);
      });
      imageRepository.client = mc;

      Uint8List newbytes = await imageRepository.downloadImage("123");
      expect(newbytes, base64Decode(imageB64));
    });

    test("downloadImage exception for uncompleted response", () async {
      File image = new File('flowers.png');
      List<int> imageBytes = image.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      MockClient mc = MockClient((request) async {
        final mapJson = {'image': imageB64};
        return Response(jsonEncode(mapJson), 202);
      });
      imageRepository.client = mc;

      Uint8List newbytes = await imageRepository.downloadImage("123");
      expect(newbytes, isNull);
    });
  });

  group("json parsing", () {
    test('Correctly parse id from json', () {
      String json = '{"id": "123456789"}';
      String identifier = 'id';

      expect(
          imageRepository.getValueFromResponse(json, identifier), "123456789");
    });

    test('Throw error if value does not exist in json', () {
      String json = '{"identifier": "123456789"}';
      String identifier = 'id';

      expect(() => imageRepository.getValueFromResponse(json, identifier),
          throwsException);
    });
  });

  group('bloc testing', () {
    test('initial state', () {
      expect(bloc.initialState, InitialImageState());
    });
    test('event OpenCamera', () {
      final expectedResponse = [
        bloc.state,
        CameraStartState(),
        CameraShowState(null)
      ];

      when(mic.initCamera()).thenAnswer((_) async => null);

      expectLater(bloc, emitsInOrder(expectedResponse));

      bloc.add(OpenCamera());
    });

    test('event LoadImage', () {
      final expectedResponse = [
        bloc.state,
        ImageLoadingState(),
        ImageLoadedState(image: File("flowers.png"))
      ];

      when(mic.getImage()).thenAnswer((_) async => File("flowers.png"));

      expectLater(bloc, emitsInOrder(expectedResponse));

      bloc.add(LoadImage());
    });

    test('event TakePhoto', () {
      final expectedResponse = [
        bloc.state,
        CameraTakePhotoState(),
        ImageLoadedState(image: File("flowers.png"))
      ];

      when(mic.takePhoto()).thenAnswer((_) async => "flowers.png");

      expectLater(bloc, emitsInOrder(expectedResponse));

      bloc.add(TakePhoto());
    });

    test('event SendImage', () {
      final expectedResponse = [
        bloc.state,
        ImageUploadState(image: File("flowers.png")),
        ImageProcessingState(image: File("flowers.png"))
      ];

      when(mic.sendImage(File("flowers.png"),null)).thenAnswer((_) async => null);
      when(mic.downloadImage(null)).thenAnswer((_) async => null);
      when(mic.saveB64Image(null)).thenAnswer((_) async => File("flowers.png"));

      expectLater(bloc, emitsInOrder(expectedResponse));

      bloc.add(SendImage(null));
    });
  });

  /*
  group('save b64File', () {
    test('correct saving of b64 String', () async {
      File image = new File('flowers.png');
      List<int> imageBytes = image.readAsBytesSync();

      File newImage = await imageRepository.saveB64Image(imageBytes);
      expect(newImage.readAsBytesSync(), imageBytes);
    });
  });*/
}
