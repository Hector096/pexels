import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pexels/data/bloc/ImagesEvent.dart';
import 'package:pexels/data/bloc/imageRepo.dart';
import 'package:pexels/data/bloc/imageState.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepo repository = ImageRepo();
  int page = 1;
  bool isFetching = false;

  ImageBloc(ImageState initialState) : super(initialState);

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is GetImages) yield* _newData(event);
  }

  Stream<ImageState> _newData(GetImages event) async* {
    yield LoadingState();
    try {
      yield LoadSuccess(await repository.getImages(page.toString()));
      page++;
    } catch (e) {
      yield LoadFailure(e.toString());
    }
  }
}
