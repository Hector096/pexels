
abstract class ImageEvent {}

class GetImages extends ImageEvent {
  GetImages();

  
  List<Object> get props => [int];
}
