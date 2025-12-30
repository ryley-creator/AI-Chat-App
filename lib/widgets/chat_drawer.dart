import 'package:chat/pages/image_generator_page.dart';

import '../imports/imports.dart';

class ChatDrawer extends StatelessWidget {
  ChatDrawer({super.key});
  final FirebaseAuth user = FirebaseAuth.instance;
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      user.currentUser!.photoURL != null
                          ? Image.network(user.currentUser!.photoURL.toString())
                          : Icon(Icons.person),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: state.history.isEmpty
                        ? Center(child: Text('No history yet...'))
                        : ListView.builder(
                            itemCount: state.history.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(state.history[index].title),
                              onLongPress: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text(
                                    'Do you really want to delete this chat?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.read<ChatBloc>().add(
                                          DeleteChat(
                                            state.history[index].id,
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                context.read<ChatBloc>().add(
                                  LoadChat(state.history[index]),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    user.currentUser!.email.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<ChatBloc>().add(LogoutChat());
                      auth.logOut();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 30),
                        SizedBox(width: 10),
                        Text('LogOut', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
