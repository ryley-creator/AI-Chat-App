// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:chat/imports/imports.dart';
import 'package:image_picker/image_picker.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.controller,
    required this.scrollToBottom,
    this.focusNode,
  });

  final TextEditingController controller;
  final VoidCallback scrollToBottom;
  final FocusNode? focusNode;

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );
                  if (image != null) {
                    context.read<ChatBloc>().add(AttachImage(image));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );
                  if (image != null) {
                    context.read<ChatBloc>().add(AttachImage(image));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSend(BuildContext context, ChatState state) async {
    final text = controller.text.trim();
    if (text.isEmpty && state.pendingImage == null) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (state.pendingImage != null) {
      context.read<ChatBloc>().add(
        SendImageMessage(state.pendingImage!, text, uid),
      );
    } else {
      context.read<ChatBloc>().add(SendMessage(text, uid));
    }

    controller.clear();
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 300), scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (prev, curr) => prev.pendingImage != curr.pendingImage,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.pendingImage != null)
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(state.pendingImage!.path),
                        height: 120,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(ClearAttachedImage());
                      },
                      icon: Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _showImagePicker(context),
                  icon: Icon(Icons.add, size: 35),
                ),
                SizedBox(width: 3),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ask anything...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () => _onSend(context, state),
                  icon: Icon(Icons.send, size: 35),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
