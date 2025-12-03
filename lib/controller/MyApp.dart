import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/ClinicaVeterinariaController.dart';
import '../view/LoginUsuario.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ClinicaVeterinariaController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VetFinder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const LoginUsuario(),
      ),
    );
  }
}
