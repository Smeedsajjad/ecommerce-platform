import 'package:ecommerence/core/utils/constants/colors.dart';
import 'package:ecommerence/features/home/views/home_screen.dart';
import 'package:ecommerence/features/order/screens/order_screen.dart';
import 'package:ecommerence/features/product/screens/product_list.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const ProductList(),
    const OrderScreen(),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: currentPageIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        destinations: [
          _buildDestination(Icons.home, 'Home'),
          _buildDestination(Icons.category, 'Products'),
          _buildDestination(Icons.shopping_bag, 'Order'),
          _buildDestination(Icons.person, 'Profile'),
        ],
        backgroundColor: AppColors.background,
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }

  NavigationDestination _buildDestination(IconData icon, String label) {
    return NavigationDestination(
      icon: Icon(icon, color: AppColors.darkGrey),
      selectedIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(height: 4),
          Container(
            width: 20,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
