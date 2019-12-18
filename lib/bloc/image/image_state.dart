import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}
  
class InitialImageState extends ImageState {}

class ImageLoadingState extends ImageState {}

class ImageLoadedState extends ImageState {}

class ImageErrorState extends ImageState {}