import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zocbo/home.dart';
import 'package:zocbo/pages/auth_page.dart';
import 'package:zocbo/pages/search_page.dart';
import 'package:zocbo/services/info_service.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ZocboApp());
}

class ZocboApp extends StatefulWidget {
  const ZocboApp({super.key});

  @override
  State<ZocboApp> createState() => _ZocboAppState();
}

class _ZocboAppState extends State<ZocboApp> {
  late AuthService authService;
  late InfoService infoService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, InfoService>(
          create: (context) => InfoService(),
          update: (context, authModel, infoModel) {
            if (authModel.isLogined) infoModel?.getInfo();
            return (infoModel is InfoService) ? infoModel : InfoService();
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return const Home();
        },
      ),
    );
  }
}
