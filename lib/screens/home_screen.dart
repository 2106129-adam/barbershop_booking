import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbershop_booking/providers/booking_provider.dart';
import 'package:barbershop_booking/screens/booking_screen.dart';
import 'package:barbershop_booking/screens/booking_detail_screen.dart';
import 'package:barbershop_booking/models/booking.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<BookingProvider>(context).bookings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Barbershop Booking'),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 5,
            child: ListTile(
              title: Text(booking.customerName),
              subtitle: Text('${booking.dateTime} - ${booking.haircutModel}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(booking: booking),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteDialog(context, booking);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailScreen(booking: booking),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Booking"),
          content: Text("Are you sure you want to delete this booking?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Provider.of<BookingProvider>(context, listen: false).removeBooking(booking.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
