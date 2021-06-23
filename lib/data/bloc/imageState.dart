import 'package:equatable/equatable.dart';
import 'package:pexels/data/model/imageModel.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ImageState {}


class LoadSuccess extends ImageState {
   final ImageModel? images;
   LoadSuccess([this.images]);

    @override
  String toString() => 'Success { Edit: $images }';
}

class LoadFailure extends ImageState {
   final String? error;

   const LoadFailure([this.error]);

}
