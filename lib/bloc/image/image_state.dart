import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class InitialImageState extends ImageState {}

class CameraStartState extends ImageState {}

class CameraShowState extends ImageState {
  final CameraController controller;
  const CameraShowState(this.controller);
}

class CameraTakePhotoState extends ImageState{}

class ImageLoadingState extends ImageState {}

class ImageLoadedState extends ImageState {
  final File image;
  const ImageLoadedState({@required this.image});
}

class ImageUploadState extends ImageState {
  final File image;
  const ImageUploadState({@required this.image});
}
class ImageProcessingState extends ImageState {
  final File image;
  const ImageProcessingState({@required this.image});
}

class ImageErrorState extends ImageState {}