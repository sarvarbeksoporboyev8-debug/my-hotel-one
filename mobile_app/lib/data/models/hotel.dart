class Hotel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final double originalPrice;
  final List<String> images;
  final List<String> amenities;
  final String category;
  final double latitude;
  final double longitude;
  final bool isFavorite;
  final bool isPopular;
  final int discount;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.originalPrice,
    required this.images,
    required this.amenities,
    required this.category,
    this.latitude = 0,
    this.longitude = 0,
    this.isFavorite = false,
    this.isPopular = false,
    this.discount = 0,
  });

  Hotel copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? city,
    String? country,
    double? rating,
    int? reviewCount,
    double? pricePerNight,
    double? originalPrice,
    List<String>? images,
    List<String>? amenities,
    String? category,
    double? latitude,
    double? longitude,
    bool? isFavorite,
    bool? isPopular,
    int? discount,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      isPopular: isPopular ?? this.isPopular,
      discount: discount ?? this.discount,
    );
  }
}

class Room {
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final double pricePerNight;
  final int maxGuests;
  final double size;
  final String bedType;
  final List<String> amenities;
  final List<String> images;
  final bool isAvailable;

  Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.pricePerNight,
    required this.maxGuests,
    required this.size,
    required this.bedType,
    required this.amenities,
    required this.images,
    this.isAvailable = true,
  });
}

class Review {
  final String id;
  final String hotelId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.hotelId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class Booking {
  final String id;
  final Hotel hotel;
  final Room room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.hotel,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  int get nights => checkOut.difference(checkIn).inDays;
}

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
  });
}
