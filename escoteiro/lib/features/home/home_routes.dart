import 'package:escoteiro/features/home/home_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> homeRoutes = <GoRoute>[
  GoRoute(
    path: "/home",
    name: "home",
    builder: (context, state) {
      return HomeScreen();    
    },
  ),
];