import '../imports/imports.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.function});
  final controller = TextEditingController();
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () =>
              FocusScope.of(context).focusInDirection(TraversalDirection.up),
          child: Scaffold(
            drawer: ChatDrawer(),
            appBar: AppBar(
              title: Text('AI Chat App'),
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(onPressed: function, icon: Icon(Icons.brightness_6)),
                IconButton(
                  onPressed: () {
                    context.read<ChatBloc>().add(
                      StartNewChat(
                        FirebaseAuth.instance.currentUser!.uid.toString(),
                      ),
                    );
                  },
                  icon: Icon(Icons.create),
                ),
              ],
            ),
            body: state.status == ChatStatus.error
                ? Center(child: Text('Error loading data!'))
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          state.messages.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      'What are you working on today?',
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: state.messages.length,
                                    itemBuilder: (context, index) => ChatBubble(
                                      message: state.messages[index],
                                    ),
                                  ),
                                ),
                          SizedBox(height: 5),
                          ChatTextField(controller: controller),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
