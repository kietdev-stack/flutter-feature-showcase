import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/chat/presentation/controllers/chat_controller.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/payment/presentation/controllers/payment_controller.dart';
import 'features/payment/presentation/pages/payment_page.dart';

final class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppConstants.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const ShowcaseShell(),
  );
}

final class ShowcaseShell extends StatefulWidget {
  const ShowcaseShell({super.key});

  @override
  State<ShowcaseShell> createState() => _ShowcaseShellState();
}

final class _ShowcaseShellState extends State<ShowcaseShell> {
  int _selectedIndex = 0;

  late final _pages = <Widget>[
    AuthPage(controller: getIt<AuthController>()),
    ChatPage(controller: getIt<ChatController>()),
    PaymentPage(controller: getIt<PaymentController>()),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Architecture Showcase'),
          Text(
            'OFFLINE DEMO',
            style: TextStyle(fontSize: 10, letterSpacing: 1.4),
          ),
        ],
      ),
    ),
    body: IndexedStack(index: _selectedIndex, children: _pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.lock_outline_rounded),
          selectedIcon: Icon(Icons.lock_rounded),
          label: 'Auth',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          selectedIcon: Icon(Icons.chat_bubble_rounded),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.credit_card_outlined),
          selectedIcon: Icon(Icons.credit_card_rounded),
          label: 'Payment',
        ),
      ],
    ),
  );
}
