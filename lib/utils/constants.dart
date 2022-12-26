import 'dart:ui';

const String currencySymbol = '৳';
const Color appBarColor = Color.fromARGB(255, 11, 11, 44);
abstract class PaymentMethod {
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

abstract class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
}

Map<String, List<String>> cityArea = {
  'Dhaka' : ['Mirpur', 'Dhanmondi', 'Uttara'],
  'Rajshahi' : ['Mohonpur', 'Paba', 'Bhaga'],
  'Pabna' : ['Sujanogor', 'Bera', 'Ishwardi'],
};