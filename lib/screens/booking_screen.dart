import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbershop_booking/models/booking.dart';
import 'package:barbershop_booking/providers/booking_provider.dart';
import 'package:barbershop_booking/services/notification_service.dart';

class BookingScreen extends StatefulWidget {
  final Booking? booking;

  BookingScreen({this.booking});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _customerName;
  late DateTime _dateTime;
  late String _haircutModel;
  final List<String> _haircutModels = ['Gimbal', 'Cat Rambut', 'Potong Pendek', 'Layer', 'Buzz Cut'];

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      _customerName = widget.booking!.customerName;
      _dateTime = widget.booking!.dateTime;
      _haircutModel = widget.booking!.haircutModel;
    } else {
      _customerName = '';
      _dateTime = DateTime.now();
      _haircutModel = _haircutModels[0]; // Default pilihan pertama
    }
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final booking = Booking(
        customerName: _customerName,
        dateTime: _dateTime,
        haircutModel: _haircutModel, // Simpan pilihan model potong rambut
      );

      if (widget.booking != null) {
        booking.id = widget.booking!.id;
        Provider.of<BookingProvider>(context, listen: false).updateBooking(booking);
      } else {
        Provider.of<BookingProvider>(context, listen: false).addBooking(booking);
      }

      // Jadwalkan notifikasi
      NotificationService().scheduleNotification(
        int.parse(booking.id.substring(0, 8), radix: 16), // Konversi sebagian UUID ke int
        'Booking Reminder',
        'It\'s time for your haircut appointment with ${booking.customerName}.',
        _dateTime.subtract(Duration(minutes: 30)), // 30 menit sebelum waktu booking
      );

      Navigator.pop(context);
    }
  }

  _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );

    if (time == null) return;

    setState(() {
      _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.booking != null ? 'Edit Booking' : 'New Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _customerName,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 146, 216, 254),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _customerName = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: _pickDateTime,
                child: Text(
                  'Select Date and Time',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
              Text(
                '${_dateTime.toLocal()}'.split(' ')[0] + ' ' + _dateTime.toLocal().toString().split(' ')[1].split('.')[0],
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _haircutModel,
                decoration: InputDecoration(
                  labelText: 'Haircut Model',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                items: _haircutModels.map((model) {
                  return DropdownMenuItem(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _haircutModel = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a haircut model';
                  }
                  return null;
                },
                onSaved: (value) {
                  _haircutModel = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit',style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
