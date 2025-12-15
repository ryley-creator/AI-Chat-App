import 'package:cloud_firestore/cloud_firestore.dart';

import 'imports/imports.dart';

const String themeKey = 'theme_mode';

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: Colors.black,

  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
    surface: Colors.black,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: Colors.white,

  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
    surface: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(GeminiService(getApiKey(), getModel())),
          child: MyApp(),
        ),
        BlocProvider(create: (_) => AuthBloc(AuthService())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('settings');
    final savedTheme = box.get(themeKey, defaultValue: 'light');

    _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      Hive.box(
        'settings',
      ).put(themeKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      themeMode: _themeMode,
      theme: lightTheme,
      home: AuthWrapper(function: toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key, required this.function});
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: Text('Loading')));
        }
        if (snapshot.hasData) {
          return ChatPage(function: function);
        }
        return LoginPage();
      },
    );
  }
}
