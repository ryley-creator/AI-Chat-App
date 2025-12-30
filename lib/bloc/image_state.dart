part of 'image_bloc.dart';

enum ImageStatus { initial, created, loading, error }

class ImageState extends Equatable {
  const ImageState({this.items = const [], this.status = ImageStatus.initial});

  final List<ImageItem> items;
  final ImageStatus status;

  ImageState copyWith({List<ImageItem>? items, ImageStatus? status}) {
    return ImageState(
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [items, status];
}
