import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  
  // Filter state
  RangeValues? _priceRange;
  double? _minRating;

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
  
  // Filter getters
  RangeValues? get priceRange => _priceRange;
  double? get minRating => _minRating;
  bool get hasActiveFilters => _priceRange != null || _minRating != null;

  List<Hotel> get filteredHotels {
    var result = _hotels;
    
    // Filter by category
    if (_selectedCategory != 'All') {
      result = result.where((h) => h.category == _selectedCategory).toList();
    }
    
    // Filter by price range
    if (_priceRange != null) {
      result = result.where((h) => 
        h.pricePerNight >= _priceRange!.start && 
        h.pricePerNight <= _priceRange!.end
      ).toList();
    }
    
    // Filter by minimum rating
    if (_minRating != null) {
      result = result.where((h) => h.rating >= _minRating!).toList();
    }
    
    return result;
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
  
  void setPriceRange(RangeValues? range) {
    _priceRange = range;
    notifyListeners();
  }
  
  void setMinRating(double? rating) {
    _minRating = rating;
    notifyListeners();
  }
  
  void clearFilters() {
    _priceRange = null;
    _minRating = null;
    _selectedCategory = 'All';
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
    
    _searchResults = _searchResults.map((h) {
      if (h.id == hotelId) {
        return h.copyWith(isFavorite: !h.isFavorite);
      }
      return h;
    }).toList();
    
    _favorites = _favorites.map((h) {
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
    _isLoading = true;
    notifyListeners();
    
    _favorites = await _mockService.getFavorites();
    
    _isLoading = false;
    notifyListeners();
  }

  void clearSelection() {
    _selectedHotel = null;
    _rooms = [];
    _reviews = [];
    notifyListeners();
  }
}
