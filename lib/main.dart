import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbershop_booking/providers/booking_provider.dart';
import 'package:barbershop_booking/screens/home_screen.dart';
import 'package:barbershop_booking/services/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingProvider(),
      child: MaterialApp(
        title: 'Barbershop Booking',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
