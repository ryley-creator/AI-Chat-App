import '../imports/imports.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String currentText = 'Create Account';
  void changeText(String text) {
    setState(() {
      currentText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(function: () {}),
              ),
            );
          }
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error signing up!')));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create an',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'account',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Textfield(
                        controller: email,
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                      ),
                      SizedBox(height: 31),
                      Textfield(
                        controller: password,
                        hintText: 'New Password',
                        prefixIcon: Icon(Icons.lock),
                        obscure: true,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(
                        RegisterEvent(email.text.trim(), password.text.trim()),
                      );
                      FocusScope.of(context).unfocus();
                      changeText('Creating Account...');
                    },
                    child: LoginContainer(text: currentText),
                  ),
                  ContinueWith(
                    text: 'Already have account? ',
                    widget: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      ),
                      child: Text('Login', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
