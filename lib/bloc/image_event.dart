part of 'image_bloc.dart';

class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class GenerateImage extends ImageEvent {
  final String text;
  const GenerateImage(this.text);

  @override
  List<Object> get props => [text];
}
