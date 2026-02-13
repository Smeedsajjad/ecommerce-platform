import 'package:ecommerence/core/utils/constants/colors.dart';
import 'package:ecommerence/features/cart/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartIcon extends ConsumerWidget {
  final Color? color;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const CartIcon({
    super.key,
    this.color = AppColors.primary,
    this.badgeColor = AppColors.secondary,
    this.badgeTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () => context.push('/cart'),
          icon: Icon(Icons.shopping_cart_outlined, color: color, size: 28),
        ),
        cartAsync.maybeWhen(
          data: (cart) {
            if (cart.items.isEmpty) return const SizedBox.shrink();

            // Calculate total quantity of items in cart
            final totalQuantity = cart.items.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );

            return Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  totalQuantity > 99 ? '99+' : totalQuantity.toString(),
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
