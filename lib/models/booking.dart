import 'package:uuid/uuid.dart';

class Booking {
  late String id;
  late String customerName;
  late DateTime dateTime;
  late String haircutModel;
  
  Booking({
    required this.customerName,
    required this.dateTime,
    required this.haircutModel, 
  }) {
    id = Uuid().v4();
  }
}
