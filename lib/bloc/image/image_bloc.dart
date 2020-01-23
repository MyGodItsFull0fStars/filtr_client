import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:filter_client/repositories/image_repository.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository imageRepository;
  File img;

  ImageBloc({@required this.imageRepository}) : assert(imageRepository != null);

  @override
  ImageState get initialState => InitialImageState();

  @override
  Stream<ImageState> mapEventToState(
    ImageEvent event,
  ) async* {
    if (event is OpenCamera) {
      yield CameraStartState();
      try {
        await imageRepository.initCamera();
        yield CameraShowState(imageRepository.getController());
      } catch (_) {
        yield ImageErrorState();
      }
    } else if (event is LoadImage) {
      yield ImageLoadingState();
      try {
        img = await imageRepository.getImage();
        yield ImageLoadedState(image: img);
      } catch (_) {
        yield ImageErrorState();
      }
    } else if (event is TakePhoto) {
      yield CameraTakePhotoState();
      try {
        String path = await imageRepository.takePhoto();
        img = File(path);
        yield ImageLoadedState(image: img);
      } catch (_) {
        yield ImageErrorState();
      }
    } else if (event is SendImage){
      yield ImageUploadState(image: img);
      try {
        String id = await imageRepository.sendImage(img,event.filter);
        yield ImageProcessingState(image: img);
        Uint8List bytes = await imageRepository.downloadImage(id);
        img = await imageRepository.saveB64Image(bytes);
        yield ImageLoadedState(image: img);
      } catch (_) {
        yield ImageErrorState();
      }
    }
  }
}
