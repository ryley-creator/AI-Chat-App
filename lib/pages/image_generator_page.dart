import 'package:chat/bloc/image_bloc.dart';
import 'package:chat/imports/imports.dart';
import 'package:chat/widgets/image_bubble.dart';
import 'package:chat/widgets/image_textfield.dart';

class ImageGeneratorPage extends StatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  State<ImageGeneratorPage> createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends State<ImageGeneratorPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Image Generator')),
        body: BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            scrollToBottom();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              return ImageBubble(item: state.items[index]);
                            },
                          );
                        },
                      ),
                    ),
                    Container(height: 6),
                    ImageTextfield(
                      controller: controller,
                      onPressed: () {
                        if (state.status == ImageStatus.loading) return;
                        context.read<ImageBloc>().add(
                          GenerateImage(controller.text),
                        );
                        controller.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
