import 'package:flutter/foundation.dart';
import '../../../data/models/models.dart';
import '../../../data/services/mock_data_service.dart';

class HotelProvider with ChangeNotifier {
  final MockDataService _mockService = MockDataService();

  List<Hotel> _hotels = [];
  List<Hotel> _popularHotels = [];
  List<Hotel> _searchResults = [];
  List<Hotel> _favorites = [];
  Hotel? _selectedHotel;
  List<Room> _rooms = [];
  List<Review> _reviews = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<Hotel> get hotels => _hotels;
  List<Hotel> get popularHotels => _popularHotels;
  List<Hotel> get searchResults => _searchResults;
  List<Hotel> get favorites => _favorites;
  Hotel? get selectedHotel => _selectedHotel;
  List<Room> get rooms => _rooms;
  List<Review> get reviews => _reviews;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get categories => _mockService.categories;

  List<Hotel> get filteredHotels {
    if (_selectedCategory == 'All') return _hotels;
    return _hotels.where((h) => h.category == _selectedCategory).toList();
  }

  Future<void> loadHotels() async {
    _isLoading = true;
    notifyListeners();

    try {
      _hotels = await _mockService.getHotels();
      _popularHotels = await _mockService.getPopularHotels();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchHotels(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _mockService.searchHotels(query);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> selectHotel(String hotelId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedHotel = await _mockService.getHotelById(hotelId);
      if (_selectedHotel != null) {
        _rooms = await _mockService.getRooms(hotelId);
        _reviews = await _mockService.getReviews(hotelId);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String hotelId) {
    _mockService.toggleFavorite(hotelId);
    
    // Update local state
    _hotels = _hotels.map((h) {
      if (h.id == hotelId) {
        return h.copyWith(isFavorite: !h.isFavorite);
      }
      return h;
    }).toList();
    
    _popularHotels = _popularHotels.map((h) {
      if (h.id == hotelId) {
        return h.copyWith(isFavorite: !h.isFavorite);
      }
      return h;
    }).toList();
    
    if (_selectedHotel?.id == hotelId) {
      _selectedHotel = _selectedHotel!.copyWith(isFavorite: !_selectedHotel!.isFavorite);
    }
    
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _favorites = await _mockService.getFavorites();
    notifyListeners();
  }

  void clearSelection() {
    _selectedHotel = null;
    _rooms = [];
    _reviews = [];
    notifyListeners();
  }
}
