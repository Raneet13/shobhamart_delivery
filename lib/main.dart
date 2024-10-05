import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_delivery/api/login.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/screens/wrapper.dart';
import 'components/shopping_cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartNotifier(),
          child: wrapper(),
        ),
        StreamProvider<userResponse?>(
          create: (context) => userDetailsStream(
              SharedPreferencesService.getString('username')!,
              SharedPreferencesService.getString('password')!),
          initialData: null,
          child: wrapper(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        routes: {'/wrapper': (context) => wrapper()},
        initialRoute: '/wrapper',
      ),
    );
  }
}
