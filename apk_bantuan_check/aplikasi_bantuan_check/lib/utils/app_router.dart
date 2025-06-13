// Untuk aplikasi sederhana, kita bisa menggunakan routes di MaterialApp secara langsung
// Jika Anda ingin routing yang lebih kompleks atau dinamis, Anda bisa mengimplementasikan ini.
// Contoh:
// class AppRouter {
//   static const String loginRoute = '/login';
//   static const String registerRoute = '/register';
//   static const String masyarakatHomeRoute = '/masyarakat_home';
//   static const String adminHomeRoute = '/admin_home';
//   // ... other routes
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case loginRoute:
//         return MaterialPageRoute(builder: (_) => LoginScreen());
//       case registerRoute:
//         return MaterialPageRoute(builder: (_) => RegisterScreen());
//       case masyarakatHomeRoute:
//         return MaterialPageRoute(builder: (_) => HomeMasyarakatScreen());
//       case adminHomeRoute:
//         return MaterialPageRoute(builder: (_) => HomeAdminScreen());
//       // ... handle other routes
//       default:
//         return MaterialPageRoute(builder: (_) => Text('Error: Unknown route'));
//     }
//   }
// }
