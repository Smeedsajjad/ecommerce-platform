import 'package:ecommerence/core/utils/constants/colors.dart';
import 'package:ecommerence/features/order/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Number and Status Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    order.date,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress Bar
              _buildProgressBar(),

              const SizedBox(height: 32),
              const Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Order Items List - handling multiple efficiently
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return _buildOrderItem(context, item);
                },
              ),

              const SizedBox(height: 32),
              const Text(
                'Payment Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildPaymentInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final stages = ['Pending', 'Paid', 'Shipping', 'Delivered'];
    int currentStageIndex = stages.indexWhere(
      (stage) => stage.toLowerCase() == order.status.toLowerCase(),
    );
    if (currentStageIndex == -1)
      currentStageIndex = 0; // Default or cancelled etc.

    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index % 2 == 0) {
          final stageIndex = index ~/ 2;
          final isActive = stageIndex <= currentStageIndex;
          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : Colors.grey[300],
                ),
                child: isActive
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                stages[stageIndex],
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? AppColors.textPrimary : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        } else {
          final stageIndex = index ~/ 2;
          final isPast = stageIndex < currentStageIndex;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              height: 2,
              color: isPast ? AppColors.primary : Colors.grey[300],
            ),
          );
        }
      }),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                  (item.product?.images != null &&
                          item.product!.images.isNotEmpty)
                      ? item.product!.images.first
                      : '',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.name ?? 'Unknown Product',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: item.product == null
                ? null
                : () {
                    context.push('/product_details/${item.product!.id}');
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    if (order.payment == null) {
      return const Text('Payment information not available.');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'Payment Method',
            order.payment!.paymentMethod.toUpperCase(),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Transaction ID',
            order.payment!.transactionId ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Status', order.payment!.status.toUpperCase()),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Total Amount',
            '\$${order.payment!.amount.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
