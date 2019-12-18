import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class FetchImage extends ImageEvent{
  const FetchImage();

  @override
  List<Object> get props => [];
}