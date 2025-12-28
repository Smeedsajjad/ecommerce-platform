import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // await ref.read(secureStorageProvider).deleteToekens();
              // ref.read(goRouterProvider).go('/login');
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to Home Screen!')),
    );
  }
}