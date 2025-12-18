import '../imports/imports.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.function});
  final void Function() function;
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

  void signUp() async {
    final AuthService auth = AuthService();
    try {
      await auth.signUp(email.text, password.text);
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'account',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
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
                  signUp();
                  FocusScope.of(context).unfocus();
                  changeText('Creating Account...');
                },
                child: LoginContainer(text: currentText),
              ),
              ContinueWith(
                text: 'Already have account? ',
                widget: GestureDetector(
                  onTap: widget.function,
                  child: Text('Login', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
