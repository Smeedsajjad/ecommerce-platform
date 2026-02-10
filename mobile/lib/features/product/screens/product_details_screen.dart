import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerence/core/utils/constants/colors.dart';
import 'package:ecommerence/features/product/services/product_details_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productAsync = ref.watch(productDetailsProvider(widget.productId));

    return productAsync.when(
      data: (product) {
        final List<String> images = product.images.map((img) {
          return img;
        }).toList();

        return Scaffold(
          backgroundColor: Colors.white,
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
              "Product Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((image) {
                          return InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 4.0,
                            child: Image.network(
                              image,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 100,
                                      color: AppColors.grey,
                                    ),
                                  ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 350,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, _) {
                            setState(() => currentIndex = index);
                          },
                        ),
                      )
                    else
                      Container(
                        height: 350,
                        width: double.infinity,
                        color: AppColors.lightGrey,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 100,
                          color: AppColors.grey,
                        ),
                      ),

                    // Animated Dot Indicator
                    if (images.length > 1) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: currentIndex == index ? 20 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentIndex == index
                                  ? AppColors.secondary
                                  : AppColors.grey,
                            ),
                          );
                        }),
                      ),
                    ],

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "\$${product.price}",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Rating Bar
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: 4.5, // Mocked rating
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: AppColors.secondary,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "(128 Reviews)", // Mocked reviews
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Description Section
                          Text(
                            "Description",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ReadMoreText(
                            product.description,
                            trimLines: 4,
                            colorClickableText: AppColors.secondary,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' Read more',
                            trimExpandedText: ' Less',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                            moreStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text("Error: $error")),
      ),
    );
  }
}
