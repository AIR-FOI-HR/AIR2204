import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'data/firebase_options.dart';
import 'domain/repositories/local_storage_repository.dart';
import 'domain/repositories/notification_repository.dart';

dynamic main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationRepository().initNotification();
  LocalStorageRepository();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
