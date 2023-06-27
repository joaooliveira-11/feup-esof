import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:porto_explorer/main.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  enableFlutterDriverExtension();
  await Firebase.initializeApp();
  runApp(const MyApp());
}