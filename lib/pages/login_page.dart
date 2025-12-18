import '../imports/imports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.function});
  final void Function() function;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String currentText = 'Login';
  void onTextChanged(String text) {
    setState(() {
      currentText = text;
    });
  }

  void login() async {
    final AuthService auth = AuthService();
    try {
      await auth.login(email.text, password.text);
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
                    'Welcome',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Back!',
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
                    hintText: 'Username or email',
                  ),
                  SizedBox(height: 31),
                  Textfield(
                    controller: password,
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    obscure: true,
                  ),
                  SizedBox(height: 9),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  login();
                  FocusScope.of(context).unfocus();
                  onTextChanged('Logging in...');
                },
                child: LoginContainer(text: currentText),
              ),
              ContinueWith(
                text: 'Dont have an account? ',
                widget: GestureDetector(
                  onTap: widget.function,
                  child: Text('Sign Up', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
