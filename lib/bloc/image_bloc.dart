import 'package:chat/imports/imports.dart';
import 'package:chat/models/image_model.dart';
import 'package:equatable/equatable.dart';
part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc(this.imageService) : super(ImageState()) {
    on<GenerateImage>(onGenerateImage);
  }
  final ImageService imageService;

  Future<void> onGenerateImage(
    GenerateImage event,
    Emitter<ImageState> emit,
  ) async {
    final userItem = ImageItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ImageItemType.userText,
      text: event.text,
    );

    final loadingItem = ImageItem(
      id: 'loading-${DateTime.now().millisecondsSinceEpoch}',
      type: ImageItemType.loading,
    );

    emit(
      state.copyWith(
        items: [...state.items, userItem, loadingItem],
        status: ImageStatus.loading,
      ),
    );

    try {
      final bytes = await imageService.generateImage(event.text);

      final imageItem = ImageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ImageItemType.aiImage,
        image: bytes,
      );

      final newItems = [...state.items]
        ..removeWhere((e) => e.type == ImageItemType.loading)
        ..add(imageItem);

      emit(state.copyWith(items: newItems, status: ImageStatus.created));
    } catch (e) {
      emit(state.copyWith(status: ImageStatus.error));
    }
  }
}
