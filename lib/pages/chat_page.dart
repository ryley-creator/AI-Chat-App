import '../imports/imports.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.function});
  final VoidCallback function;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    scrollDown();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        scrollDown();
      }
    });
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (prev, curr) {
        return prev.messages.length != curr.messages.length;
      },
      listener: (context, state) {
        scrollDown();
      },
      child: BlocBuilder<ChatBloc, ChatState>(
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
                  IconButton(
                    onPressed: widget.function,
                    icon: Icon(Icons.brightness_6),
                  ),
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
                                      controller: scrollController,
                                      itemCount: state.messages.length,
                                      itemBuilder: (context, index) =>
                                          ChatBubble(
                                            message: state.messages[index],
                                          ),
                                    ),
                                  ),
                            SizedBox(height: 5),
                            ChatTextField(
                              focusNode: myFocusNode,
                              controller: controller,
                              f: scrollDown,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    myFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
