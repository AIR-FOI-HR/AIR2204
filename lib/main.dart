import 'app.dart';
import 'data/firebase_options.dart';

dynamic main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
