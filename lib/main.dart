import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tvs_application/Application/Reminder/reminderadd.dart';
import 'package:tvs_application/Model/User.dart';
import 'Application/Prescription/adherence.dart';
import 'Application/Reminder/remindermain.dart';
import 'Application/login.dart';
import 'Application/mainmenu.dart';
import 'Application/register.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MyApp());
}

Future<void> initializeSetting() async {
  var initializationSettingAndroid = AndroidInitializationSettings('tvs_logo');
  var initializationSettings = InitializationSettings( android: initializationSettingAndroid);
  await notificationsPlugin.initialize(initializationSettings);

  tz.initializeTimeZones();
}


class MyApp extends StatelessWidget {
  // UserModel user = UserModel();
  

  @override
  Widget build(BuildContext context) {
     //user.patient = true;

    return MaterialApp(

    /*   home: ReminderMainScreen(),
      theme: ThemeData(
        primaryColor: Color(0xff06224A),
      ),  */

      initialRoute: '/login',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (contex) => RegisterScreen(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) =>
              Scaffold(body: Center(child: Text('Not Found'))),
        );
      },
    );
  }
}