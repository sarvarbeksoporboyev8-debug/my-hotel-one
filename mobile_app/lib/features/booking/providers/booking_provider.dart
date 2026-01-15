import 'package:flutter/foundation.dart';
import '../../../data/models/models.dart';
import '../../../data/services/mock_data_service.dart';

class BookingProvider with ChangeNotifier {
  final MockDataService _mockService = MockDataService();

  List<Booking> _bookings = [];
  Booking? _currentBooking;
  Room? _selectedRoom;
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  Booking? get currentBooking => _currentBooking;
  Room? get selectedRoom => _selectedRoom;
  DateTime? get checkIn => _checkIn;
  DateTime? get checkOut => _checkOut;
  int get guests => _guests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get nights => _checkIn != null && _checkOut != null
      ? _checkOut!.difference(_checkIn!).inDays
      : 0;

  double get totalPrice => _selectedRoom != null
      ? _selectedRoom!.pricePerNight * nights
      : 0;

  void selectRoom(Room room) {
    _selectedRoom = room;
    notifyListeners();
  }

  void setCheckIn(DateTime date) {
    _checkIn = date;
    if (_checkOut != null && _checkOut!.isBefore(date)) {
      _checkOut = date.add(const Duration(days: 1));
    }
    notifyListeners();
  }

  void setCheckOut(DateTime date) {
    _checkOut = date;
    notifyListeners();
  }

  void setGuests(int count) {
    _guests = count;
    notifyListeners();
  }

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _mockService.getBookings();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createBooking(Hotel hotel) async {
    if (_selectedRoom == null || _checkIn == null || _checkOut == null) {
      _error = 'Please select dates and room';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentBooking = await _mockService.createBooking(
        hotel: hotel,
        room: _selectedRoom!,
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        guests: _guests,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearBookingData() {
    _selectedRoom = null;
    _checkIn = null;
    _checkOut = null;
    _guests = 1;
    _currentBooking = null;
    notifyListeners();
  }
}
