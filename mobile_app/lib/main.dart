import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/main_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/hotels/providers/hotel_provider.dart';
import 'features/hotels/screens/hotels_screen.dart';
import 'features/hotels/screens/search_screen.dart';
import 'features/hotels/screens/hotel_details_screen.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/booking/screens/booking_screen.dart';
import 'features/booking/screens/booking_success_screen.dart';
import 'features/booking/screens/bookings_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const SmartHotelApp());
}

class SmartHotelApp extends StatelessWidget {
  const SmartHotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HotelProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'SmartHotel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) {
              return _getScreen(settings.name);
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              var offsetAnimation = animation.drive(tween);

              var fadeAnimation = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: curve,
              ));

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }

  Widget _getScreen(String? routeName) {
    switch (routeName) {
      case '/':
        return const SplashScreen();
      case '/login':
        return const LoginScreen();
      case '/register':
        return const RegisterScreen();
      case '/main':
      case '/home':
        return const MainScreen();
      case '/hotels':
        return const HotelsScreen();
      case '/search':
        return const SearchScreen();
      case '/hotel-details':
        return const HotelDetailsScreen();
      case '/booking':
        return const BookingScreen();
      case '/booking-success':
        return const BookingSuccessScreen();
      case '/bookings':
        return const BookingsScreen();
      case '/profile':
        return const ProfileScreen();
      default:
        return const SplashScreen();
    }
  }
}
