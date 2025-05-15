import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/register_page.dart';
import 'package:yummy/screens/OrderConfirmationPage.dart';
import 'package:yummy/screens/PaymentPage.dart';

import 'constants.dart';
import 'home.dart';
import 'landing_page.dart';
import 'login_page.dart';
import 'models/cart_model.dart';
import 'package:yummy/screens/cart_page.dart';
import 'package:yummy/screens/orders_page.dart';
import 'package:yummy/screens/alerts_page.dart';
import 'package:yummy/screens/profile_page.dart';
import 'package:yummy/screens/more_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Yummy());
}

class Yummy extends StatefulWidget {
  const Yummy({super.key});

  @override
  State<Yummy> createState() => _YummyState();
}

class _YummyState extends State<Yummy> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.pink;

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Tfokomala Hotel App';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartModel>(create: (_) => CartModel()),
      ],
      child: MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const LandingPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => Home(
            appTitle: appTitle,
            changeTheme: changeThemeMode,
            changeColor: changeColor,
          ),
          '/cart': (context) => const CartPage(),
          '/orders': (context) => const OrdersPage(),
          '/alerts': (context) => const AlertsPage(),
          '/profile': (context) => const ProfilePage(),
          '/more': (context) => const MorePage(),
          '/order-confirmation': (context) => OrderConfirmationPage(address: '', totalAmount: 0), // Placeholder
          '/payment': (context) => const PaymentPage(),
        },
      ),
    );
  }
}
