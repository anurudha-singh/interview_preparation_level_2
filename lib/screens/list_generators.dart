import 'package:flutter/material.dart';
import 'dart:math';

class ListGenerators extends StatefulWidget {
  const ListGenerators({super.key});
  static String routeName = 'list_generators';
  
  @override
  State<ListGenerators> createState() => _ListGeneratorsState();
}

class _ListGeneratorsState extends State<ListGenerators> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;
  
  // Sample data
  final List<Product> _products = List.generate(50, (index) {
    final random = Random();
    return Product(
      id: index + 1,
      name: 'Product ${index + 1}',
      price: 10.0 + random.nextDouble() * 90.0,
      category: _categories[random.nextInt(_categories.length)],
      rating: 1.0 + random.nextDouble() * 4.0,
      imageUrl: 'https://picsum.photos/200/200?random=$index',
    );
  });
  
  static const List<String> _categories = [
    'Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports'
  ];
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    if (_scrollController.offset > 300 && !_showFloatingButton) {
      setState(() => _showFloatingButton = true);
    } else if (_scrollController.offset <= 300 && _showFloatingButton) {
      setState(() => _showFloatingButton = false);
    }
  }
  
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. SliverAppBar - Collapsible app bar with parallax effect
          _buildSliverAppBar(),
          
          // 2. SliverToBoxAdapter - Single widget in sliver
          _buildWelcomeSection(),
          
          // 3. SliverPersistentHeader - Sticky categories header
          _buildCategoriesHeader(),
          
          // 4. SliverGrid - Grid layout
          _buildFeaturedProductsGrid(),
          
          // 5. SliverToBoxAdapter - Section divider
          _buildSectionDivider('All Products'),
          
          // 6. SliverList - Efficient list
          _buildProductsList(),
          
          // 7. SliverFillRemaining - Fill remaining space
          _buildFooterSection(),
        ],
      ),
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.keyboard_arrow_up),
              backgroundColor: Colors.deepPurple,
            )
          : null,
    );
  }
  
  // 1. Collapsible SliverAppBar with parallax background
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.deepPurple,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Sliver Examples',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple,
                Colors.purple,
                Colors.purpleAccent,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.network(
                    'https://picsum.photos/400/250?random=bg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Content overlay
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.layers,
                      size: 60,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Advanced Scrolling',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () => _showSliverInfo(context),
        ),
      ],
    );
  }
  
  // 2. Welcome section using SliverToBoxAdapter
  Widget _buildWelcomeSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Slivers Demo! 🚀',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'This demo showcases different types of slivers working together in a CustomScrollView. Scroll down to see various sliver widgets in action!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildFeatureChip('SliverAppBar', Icons.view_agenda),
                    SizedBox(width: 8),
                    _buildFeatureChip('SliverGrid', Icons.grid_view),
                    SizedBox(width: 8),
                    _buildFeatureChip('SliverList', Icons.list),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
  
  // 3. Sticky header using SliverPersistentHeader
  Widget _buildCategoriesHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CategoriesHeaderDelegate(),
    );
  }
  
  // 4. Grid layout using SliverGrid
  Widget _buildFeaturedProductsGrid() {
    final featuredProducts = _products.take(6).toList();
    
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = featuredProducts[index];
            return _buildGridProductCard(product, isFeatured: true);
          },
          childCount: featuredProducts.length,
        ),
      ),
    );
  }
  
  Widget _buildGridProductCard(Product product, {bool isFeatured = false}) {
    return Card(
      elevation: isFeatured ? 6 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: isFeatured
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          // Product details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 5. Section divider
  Widget _buildSectionDivider(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Row(
          children: [
            Icon(Icons.store, color: Colors.deepPurple),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16),
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 6. Products list using SliverList
  Widget _buildProductsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = _products[index];
          return _buildListProductCard(product);
        },
        childCount: _products.length,
      ),
    );
  }
  
  Widget _buildListProductCard(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            product.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(product.category),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(product.rating.toStringAsFixed(1)),
                  SizedBox(width: 16),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  // 7. Footer section using SliverFillRemaining
  Widget _buildFooterSection() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'You\'ve reached the end!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Thanks for exploring our Slivers demo.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _scrollToTop,
              icon: Icon(Icons.arrow_upward),
              label: Text('Back to Top'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showSliverInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Slivers Overview'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('This demo showcases different sliver widgets:'),
                SizedBox(height: 12),
                _buildInfoItem('SliverAppBar', 'Collapsible app bar with parallax effect'),
                _buildInfoItem('SliverToBoxAdapter', 'Wraps regular widgets in slivers'),
                _buildInfoItem('SliverPersistentHeader', 'Sticky header that stays visible'),
                _buildInfoItem('SliverGrid', 'Efficient grid layout for slivers'),
                _buildInfoItem('SliverList', 'Efficient list layout for slivers'),
                _buildInfoItem('SliverFillRemaining', 'Fills remaining scroll space'),
                SizedBox(height: 12),
                Text(
                  'All these work together in a CustomScrollView for advanced scrolling effects!',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildInfoItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// Custom delegate for sticky header
class _CategoriesHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60.0;
  
  @override
  double get maxExtent => 60.0;
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '🌟 Featured Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// Data model
class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final double rating;
  final String imageUrl;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.rating,
    required this.imageUrl,
  });
}
