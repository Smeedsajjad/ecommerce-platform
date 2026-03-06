import 'package:ecommerence/core/utils/constants/colors.dart';
import 'package:ecommerence/features/auth/services/auth_service.dart';
import 'package:ecommerence/features/order/models/order_model.dart';
import 'package:ecommerence/features/order/services/order_service.dart';
import 'package:ecommerence/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final authState = ref.watch(authServiceProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.search, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: isAuthenticated
                    ? DefaultTabController(
                        length: 5,
                        child: Column(
                          children: [
                            const TabBar(
                              isScrollable: true,
                              dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: AppColors.secondary,
                              labelColor: AppColors.secondary,
                              unselectedLabelColor: AppColors.textSecondary,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                              tabs: [
                                Tab(text: "All"),
                                Tab(text: "Pending"),
                                Tab(text: "Paid"),
                                Tab(text: "Shipping"),
                                Tab(text: "Delivered"),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: orderState.when(
                                data: (orders) {
                                  return TabBarView(
                                    children: [
                                      _buildOrdersList(orders),
                                      _buildOrdersList(
                                        orders
                                            .where((o) => o.status == "pending")
                                            .toList(),
                                      ),
                                      _buildOrdersList(
                                        orders
                                            .where((o) => o.status == "paid")
                                            .toList(),
                                      ),
                                      _buildOrdersList(
                                        orders
                                            .where(
                                              (o) => o.status == "shipping",
                                            )
                                            .toList(),
                                      ),
                                      _buildOrdersList(
                                        orders
                                            .where(
                                              (o) => o.status == "delivered",
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (err, stack) => Center(
                                  child: Text('Error loading orders: $err'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildLoginPrompt(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Please login to view your orders",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Login Now"),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              "No orders found",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}
