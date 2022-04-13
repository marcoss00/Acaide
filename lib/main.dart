import 'package:acaide/screens/anuncios_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AcaideApp());
}

class AcaideApp extends StatelessWidget {
  const AcaideApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnunciosList(),
    );
  }
}
