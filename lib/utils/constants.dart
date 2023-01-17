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
  static const String cancelled = 'Cancelled this Order';
}

Map<String, List<String>> cityArea = {
  'Dhaka' : ['Mirpur', 'Uttara', 'Mohammadpur', 'Savar', 'Dhanmondi', 'Jatrabari', 'Basundhara', 'Badda', 'Gulshan', 'Elephant Road', 'Baridhara', 'Khilgaon', 'Rampura', 'Keraniganj', 'Tongi', 'Motijheel', 'Banani', 'Tejgon', 'Basabo', 'Lalbag', 'Demra', 'Banglamotor', 'Purbachal', 'Paltan', 'Kamrangirchar', 'Khilkhet', 'Farmgate', 'New Market', 'Malibagh', 'Sutrapur', 'Banasree', 'Cantonment', 'Mogbazar', 'Wari', 'Mohakhali', 'Bangshal', 'Chaukbazar', 'Hazaribagh', 'Aftab Nagar', 'Shyamoli', 'Ramna', 'ECB Chattar', 'Dhamrai', 'Kotwali', 'Kafrul', '60 Feet Road', 'Shantinagar', 'Nowabganj', 'Shewrapara', 'Eskaton', 'Dohar', 'Bosila'],
  'Chattogram' : ['Chattogram'],
  'Sylhet' : ['Sylhet'],
  'Khulna' : ['Khulna'],
  'Barishal' : ['Barishal'],
  'Rajshahi' : ['Rajshahi'],
  'Rangpur' : ['Rangpur'],
  'Mymensingh' : ['Mymensingh'],

};