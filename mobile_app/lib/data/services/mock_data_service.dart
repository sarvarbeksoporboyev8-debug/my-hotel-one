import '../models/models.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  User? _currentUser;
  final List<Booking> _bookings = [];
  final Set<String> _favoriteIds = {};

  // High-quality placeholder images from Unsplash
  static const _hotelImages = [
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
    'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
    'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
    'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
    'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=800',
    'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800',
    'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=800',
  ];

  static const _roomImages = [
    'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
    'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=800',
    'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
  ];

  final List<Hotel> _hotels = [
    Hotel(
      id: 'h1',
      name: 'The Grand Palace Hotel',
      description: 'Experience luxury at its finest in our award-winning hotel. Featuring stunning city views, world-class dining, and impeccable service that will make your stay unforgettable. Our rooms blend modern elegance with timeless comfort.',
      address: '123 Luxury Avenue',
      city: 'New York',
      country: 'USA',
      rating: 4.9,
      reviewCount: 2847,
      pricePerNight: 450,
      originalPrice: 550,
      images: [_hotelImages[0], _hotelImages[1], _hotelImages[2]],
      amenities: ['Free WiFi', 'Pool', 'Spa', 'Gym', 'Restaurant', 'Bar', 'Room Service', 'Parking'],
      category: 'Luxury',
      isPopular: true,
      discount: 18,
    ),
    Hotel(
      id: 'h2',
      name: 'Seaside Resort & Spa',
      description: 'Wake up to breathtaking ocean views and fall asleep to the sound of waves. Our beachfront resort offers the perfect escape with private beach access, infinity pools, and rejuvenating spa treatments.',
      address: '456 Ocean Drive',
      city: 'Miami',
      country: 'USA',
      rating: 4.8,
      reviewCount: 1923,
      pricePerNight: 380,
      originalPrice: 420,
      images: [_hotelImages[3], _hotelImages[4], _hotelImages[5]],
      amenities: ['Beach Access', 'Pool', 'Spa', 'Free WiFi', 'Restaurant', 'Water Sports'],
      category: 'Resort',
      isPopular: true,
      discount: 10,
    ),
    Hotel(
      id: 'h3',
      name: 'Urban Boutique Hotel',
      description: 'A stylish urban retreat in the heart of downtown. Our boutique hotel combines contemporary design with personalized service, perfect for business travelers and city explorers alike.',
      address: '789 Downtown Street',
      city: 'San Francisco',
      country: 'USA',
      rating: 4.7,
      reviewCount: 1456,
      pricePerNight: 220,
      originalPrice: 220,
      images: [_hotelImages[6], _hotelImages[7], _hotelImages[8]],
      amenities: ['Free WiFi', 'Gym', 'Restaurant', 'Business Center', 'Concierge'],
      category: 'Boutique',
      isPopular: false,
      discount: 0,
    ),
    Hotel(
      id: 'h4',
      name: 'Mountain View Lodge',
      description: 'Escape to nature without sacrificing comfort. Our mountain lodge offers cozy accommodations with stunning alpine views, hiking trails, and a warm fireplace to end your day.',
      address: '321 Alpine Road',
      city: 'Aspen',
      country: 'USA',
      rating: 4.6,
      reviewCount: 892,
      pricePerNight: 290,
      originalPrice: 350,
      images: [_hotelImages[9], _hotelImages[0], _hotelImages[1]],
      amenities: ['Free WiFi', 'Fireplace', 'Ski Storage', 'Restaurant', 'Hot Tub', 'Hiking'],
      category: 'Lodge',
      isPopular: true,
      discount: 17,
    ),
    Hotel(
      id: 'h5',
      name: 'City Center Inn',
      description: 'Affordable comfort in a prime location. Perfect for travelers who want to explore the city without breaking the bank. Clean, modern rooms with all essential amenities.',
      address: '555 Central Ave',
      city: 'Chicago',
      country: 'USA',
      rating: 4.3,
      reviewCount: 2156,
      pricePerNight: 120,
      originalPrice: 150,
      images: [_hotelImages[2], _hotelImages[3], _hotelImages[4]],
      amenities: ['Free WiFi', 'Breakfast', 'Parking', 'Laundry'],
      category: 'Budget',
      isPopular: false,
      discount: 20,
    ),
    Hotel(
      id: 'h6',
      name: 'The Ritz Heritage',
      description: 'Step into a world of timeless elegance. Our heritage hotel combines historic charm with modern luxury, featuring antique furnishings, gourmet dining, and butler service.',
      address: '100 Heritage Lane',
      city: 'Boston',
      country: 'USA',
      rating: 4.9,
      reviewCount: 1678,
      pricePerNight: 520,
      originalPrice: 600,
      images: [_hotelImages[5], _hotelImages[6], _hotelImages[7]],
      amenities: ['Butler Service', 'Fine Dining', 'Spa', 'Library', 'Garden', 'Valet'],
      category: 'Luxury',
      isPopular: true,
      discount: 13,
    ),
  ];

  List<Room> _generateRooms(String hotelId) {
    return [
      Room(
        id: '${hotelId}_r1',
        hotelId: hotelId,
        name: 'Deluxe King Room',
        description: 'Spacious room with king-size bed, city views, and premium amenities.',
        pricePerNight: 180,
        maxGuests: 2,
        size: 35,
        bedType: 'King',
        amenities: ['King Bed', 'City View', 'Mini Bar', 'Safe', 'Work Desk'],
        images: [_roomImages[0], _roomImages[1]],
      ),
      Room(
        id: '${hotelId}_r2',
        hotelId: hotelId,
        name: 'Premium Suite',
        description: 'Luxurious suite with separate living area, panoramic views, and exclusive perks.',
        pricePerNight: 320,
        maxGuests: 3,
        size: 55,
        bedType: 'King + Sofa',
        amenities: ['King Bed', 'Living Area', 'Panoramic View', 'Jacuzzi', 'Butler Service'],
        images: [_roomImages[2], _roomImages[3]],
      ),
      Room(
        id: '${hotelId}_r3',
        hotelId: hotelId,
        name: 'Twin Room',
        description: 'Comfortable room with two single beds, perfect for friends or colleagues.',
        pricePerNight: 150,
        maxGuests: 2,
        size: 30,
        bedType: 'Twin',
        amenities: ['Twin Beds', 'Garden View', 'Mini Bar', 'Safe'],
        images: [_roomImages[0], _roomImages[2]],
      ),
      Room(
        id: '${hotelId}_r4',
        hotelId: hotelId,
        name: 'Family Suite',
        description: 'Spacious suite ideal for families, with connecting rooms and kid-friendly amenities.',
        pricePerNight: 280,
        maxGuests: 4,
        size: 65,
        bedType: 'King + Twin',
        amenities: ['King Bed', 'Twin Beds', 'Kids Corner', 'Kitchenette', 'Balcony'],
        images: [_roomImages[1], _roomImages[3]],
      ),
    ];
  }

  List<Review> _generateReviews(String hotelId) {
    return [
      Review(
        id: '${hotelId}_rev1',
        hotelId: hotelId,
        userName: 'Sarah Johnson',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        rating: 5.0,
        comment: 'Absolutely stunning hotel! The service was impeccable and the room exceeded all expectations. Will definitely return.',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Review(
        id: '${hotelId}_rev2',
        hotelId: hotelId,
        userName: 'Michael Chen',
        userAvatar: 'https://i.pravatar.cc/150?img=3',
        rating: 4.5,
        comment: 'Great location and beautiful rooms. The breakfast buffet was amazing. Only minor issue was slow WiFi.',
        date: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Review(
        id: '${hotelId}_rev3',
        hotelId: hotelId,
        userName: 'Emma Williams',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        rating: 5.0,
        comment: 'Perfect for our anniversary! The staff arranged a surprise for us. Truly memorable experience.',
        date: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }

  // Auth methods
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: 'user_001',
        name: 'John Doe',
        email: email,
        avatar: 'https://i.pravatar.cc/150?img=8',
        phone: '+1 234 567 8900',
      );
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      avatar: 'https://i.pravatar.cc/150?img=8',
    );
    return true;
  }

  User? get currentUser => _currentUser;

  void updateUser(User user) {
    _currentUser = user;
  }

  void logout() {
    _currentUser = null;
  }

  // Hotel methods
  Future<List<Hotel>> getHotels() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _hotels.map((h) => h.copyWith(isFavorite: _favoriteIds.contains(h.id))).toList();
  }

  Future<List<Hotel>> getPopularHotels() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _hotels
        .where((h) => h.isPopular)
        .map((h) => h.copyWith(isFavorite: _favoriteIds.contains(h.id)))
        .toList();
  }

  Future<List<Hotel>> searchHotels(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowerQuery = query.toLowerCase();
    return _hotels
        .where((h) =>
            h.name.toLowerCase().contains(lowerQuery) ||
            h.city.toLowerCase().contains(lowerQuery) ||
            h.category.toLowerCase().contains(lowerQuery))
        .map((h) => h.copyWith(isFavorite: _favoriteIds.contains(h.id)))
        .toList();
  }

  Future<Hotel?> getHotelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final hotel = _hotels.firstWhere((h) => h.id == id);
      return hotel.copyWith(isFavorite: _favoriteIds.contains(hotel.id));
    } catch (e) {
      return null;
    }
  }

  Future<List<Room>> getRooms(String hotelId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _generateRooms(hotelId);
  }

  Future<List<Review>> getReviews(String hotelId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateReviews(hotelId);
  }

  // Favorites
  void toggleFavorite(String hotelId) {
    if (_favoriteIds.contains(hotelId)) {
      _favoriteIds.remove(hotelId);
    } else {
      _favoriteIds.add(hotelId);
    }
  }

  Future<List<Hotel>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _hotels
        .where((h) => _favoriteIds.contains(h.id))
        .map((h) => h.copyWith(isFavorite: true))
        .toList();
  }

  // Booking methods
  Future<Booking> createBooking({
    required Hotel hotel,
    required Room room,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final nights = checkOut.difference(checkIn).inDays;
    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      hotel: hotel,
      room: room,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      totalPrice: room.pricePerNight * nights,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );
    _bookings.add(booking);
    return booking;
  }

  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _bookings;
  }

  // Categories
  List<String> get categories => ['All', 'Luxury', 'Resort', 'Boutique', 'Lodge', 'Budget'];
}
