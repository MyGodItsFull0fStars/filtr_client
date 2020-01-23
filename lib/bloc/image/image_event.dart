import 'package:equatable/equatable.dart';
import 'package:filter_client/models/filter/filter.model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class OpenCamera extends ImageEvent{
  const OpenCamera();

  @override
  List<Object> get props => [];
}

class TakePhoto extends ImageEvent {
  const TakePhoto();

  @override
  List<Object> get props => null;  
}

class LoadImage extends ImageEvent{
  const LoadImage();

  @override
  List<Object> get props => [];

}

class SendImage extends ImageEvent{
 final Filter filter;
const SendImage(this.filter);

  @override
  List<Object> get props => null;

}