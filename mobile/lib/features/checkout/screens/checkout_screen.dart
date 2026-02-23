import 'package:ecommerence/core/utils/constants/colors.dart';
import 'package:ecommerence/core/utils/constants/sizes.dart';
import 'package:ecommerence/features/checkout/models/checkout_model.dart';
import 'package:ecommerence/features/checkout/services/checkout_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _placingOrder = false;

  // ── Hardcoded address mock ────────────────────────────────────────────────
  final _address = const _AddressMock(
    name: 'John Doe',
    line1: '123 Main Street, Apt 4B',
    city: 'New York',
    state: 'NY',
    zip: '10001',
    country: 'United States',
  );

  // ── Selected payment method ───────────────────────────────────────────────
  int _selectedPayment = 0; // 0 = Stripe Card

  Future<void> _onPlaceOrder(CheckoutSummary summary) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Stripe PaymentSheet is only supported on Android/iOS. Please run on a mobile emulator or device.',
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _placingOrder = true);
    try {
      // 1. Backend creates order + Stripe PaymentIntent
      final result = await ref.read(checkoutServiceProvider).placeOrder();

      // 2. Init PaymentSheet (Native only)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: result.clientSecret,
          merchantDisplayName: 'My Store',
          style: ThemeMode.light,
        ),
      );

      // 3. Present PaymentSheet to user
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment confirmed — navigate to success screen
      if (mounted) {
        context.go('/order-success/${result.orderId}');
      }
    } on StripeException catch (e) {
      if (mounted) {
        final msg = e.error.localizedMessage ?? 'Payment cancelled';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _placingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(checkoutSummaryProvider);

    if (summary == null) {
      // Should never happen if navigated correctly from CartScreen
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Order Summary ─────────────────────────────────────────────
              _SectionCard(
                title: '🧾 Order Summary',
                child: Column(
                  children: [
                    ...summary.items.map((item) => _OrderItemRow(item: item)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
                    _TotalRow(
                      label: 'Subtotal',
                      value: '\$${summary.subtotal.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 6),
                    _TotalRow(
                      label: 'Shipping',
                      value: summary.shipping == 0
                          ? 'Free'
                          : '\$${summary.shipping.toStringAsFixed(2)}',
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: 6),
                    _TotalRow(
                      label: 'Discount',
                      value: summary.discount == 0
                          ? '\$0.00'
                          : '-\$${summary.discount.toStringAsFixed(2)}',
                      valueColor: summary.discount > 0
                          ? AppColors.success
                          : AppColors.textSecondary,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
                    _TotalRow(
                      label: 'Total',
                      value: '\$${summary.total.toStringAsFixed(2)}',
                      bold: true,
                      valueColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Delivery Address (UI only) ─────────────────────────────────
              _SectionCard(
                title: '📍 Delivery Address',
                trailing: TextButton(
                  onPressed: () {
                    // TODO: implement address picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address selection coming soon!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
                child: _AddressCard(address: _address),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Payment Method ─────────────────────────────────────────────
              _SectionCard(
                title: '💳 Payment Method',
                child: Column(
                  children: [
                    _PaymentOption(
                      index: 0,
                      selected: _selectedPayment,
                      icon: Icons.credit_card_rounded,
                      label: 'Credit / Debit Card',
                      subtitle: 'Powered by Stripe',
                      onTap: (i) => setState(() => _selectedPayment = i),
                    ),
                    const SizedBox(height: 8),
                    _PaymentOption(
                      index: 1,
                      selected: _selectedPayment,
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Apple Pay / Google Pay',
                      subtitle: 'Available via Stripe',
                      onTap: (i) => setState(() => _selectedPayment = i),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // space for bottom bar
            ],
          ),
        ),

        // ── Place Order Button ──────────────────────────────────────────────
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total to pay',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${summary.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _placingOrder
                      ? null
                      : () => _onPlaceOrder(summary),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.secondary.withValues(
                      alpha: 0.55,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.buttonRadius,
                      ),
                    ),
                  ),
                  child: _placingOrder
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock_outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final CheckoutSummaryItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 52,
                height: 52,
                color: AppColors.softGrey,
                child: const Icon(Icons.shopping_bag_outlined, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + qty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Qty: ${item.quantity}  ×  \$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Subtotal
          Text(
            '\$${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Address ──────────────────────────────────────────────────────────────────

class _AddressMock {
  final String name;
  final String line1;
  final String city;
  final String state;
  final String zip;
  final String country;

  const _AddressMock({
    required this.name,
    required this.line1,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });
}

class _AddressCard extends StatelessWidget {
  final _AddressMock address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: AppColors.secondary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address.line1,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${address.city}, ${address.state} ${address.zip}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  address.country,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Default',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment Option ────────────────────────────────────────────────────────────

class _PaymentOption extends StatelessWidget {
  final int index;
  final int selected;
  final IconData icon;
  final String label;
  final String subtitle;
  final void Function(int) onTap;

  const _PaymentOption({
    required this.index,
    required this.selected,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.08)
              : AppColors.softGrey,
          borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.secondary : AppColors.darkGrey,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.secondary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
