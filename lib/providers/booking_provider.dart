import 'package:flutter/material.dart';
import 'package:barbershop_booking/models/booking.dart';
import 'package:uuid/uuid.dart';

class BookingProvider with ChangeNotifier {
  final List<Booking> _bookings = [];
  final Uuid uuid = Uuid();

  List<Booking> get bookings => _bookings;

  void addBooking(Booking booking) {
    booking.id = uuid.v4();
    _bookings.add(booking);
    notifyListeners();
  }

  void updateBooking(Booking booking) {
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookings[index] = booking;
      notifyListeners();
    }
  }

  void removeBooking(String id) {
    _bookings.removeWhere((booking) => booking.id == id);
    notifyListeners();
  }
}
