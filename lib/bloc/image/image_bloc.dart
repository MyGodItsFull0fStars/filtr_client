import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:filter_client/repositories/image_repository.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository imageRepository;

  ImageBloc({@required this.imageRepository}) 
    : assert(imageRepository != null);

  @override
  ImageState get initialState => InitialImageState();

  @override
  Stream<ImageState> mapEventToState(
    ImageEvent event,
  ) async* {
     if (event is FetchImage) {
      yield ImageLoadingState();
      try {
        final Image img = imageRepository.getImage();
        yield ImageLoadedState();
      } catch (_) {
        yield ImageErrorState();
      }
    }
  }
}