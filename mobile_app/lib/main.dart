import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/main_screen.dart';
import 'features/hotels/providers/hotel_provider.dart';
import 'features/hotels/screens/hotels_screen.dart';
import 'features/hotels/screens/search_screen.dart';
import 'features/hotels/screens/hotel_details_screen.dart';
import 'features/hotels/screens/favorites_screen.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/booking/screens/booking_screen.dart';
import 'features/booking/screens/booking_success_screen.dart';
import 'features/booking/screens/bookings_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/personal_info_screen.dart';
import 'features/profile/screens/payment_methods_screen.dart';
import 'features/profile/screens/notifications_screen.dart';
import 'features/profile/screens/language_screen.dart';
import 'features/profile/screens/currency_screen.dart';
import 'features/profile/screens/about_screen.dart';
import 'features/profile/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize settings provider
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();
  
  runApp(SmartHotelApp(settingsProvider: settingsProvider));
}

class SmartHotelApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  
  const SmartHotelApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HotelProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'SmartHotel',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            onGenerateRoute: (routeSettings) {
              return PageRouteBuilder(
                settings: routeSettings,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return _getScreen(routeSettings.name, routeSettings.arguments);
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
          );
        },
      ),
    );
  }

  Widget _getScreen(String? routeName, Object? arguments) {
    switch (routeName) {
      case '/':
        return const SplashScreen();
      case '/login':
        return const LoginScreen();
      case '/register':
        return const RegisterScreen();
      case '/main':
      case '/home':
        final initialTab = arguments is int ? arguments : 0;
        return MainScreen(initialTab: initialTab);
      case '/hotels':
        return const HotelsScreen();
      case '/search':
        return const SearchScreen();
      case '/hotel-details':
        return const HotelDetailsScreen();
      case '/favorites':
        return const FavoritesScreen();
      case '/booking':
        return const BookingScreen();
      case '/booking-success':
        return const BookingSuccessScreen();
      case '/bookings':
        return const BookingsScreen();
      case '/profile':
        return const ProfileScreen();
      case '/personal-info':
        return const PersonalInfoScreen();
      case '/payment-methods':
        return const PaymentMethodsScreen();
      case '/notifications':
        return const NotificationsScreen();
      case '/language':
        return const LanguageScreen();
      case '/currency':
        return const CurrencyScreen();
      case '/about':
        return const AboutScreen();
      default:
        return const SplashScreen();
    }
  }
}
