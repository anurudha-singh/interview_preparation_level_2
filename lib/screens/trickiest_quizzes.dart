import 'package:flutter/material.dart';

class TrickiestQuizzess extends StatefulWidget {
  static String routeName = 'trickiest_questions';
  const TrickiestQuizzess({super.key});

  @override
  State<TrickiestQuizzess> createState() => _TrickiestQuizzessState();
}

class _TrickiestQuizzessState extends State<TrickiestQuizzess> {
  // Infinite scrolling state variables
  List<QuizItem> _items = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  static const int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener to detect when user reaches bottom
  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more data when user is 200 pixels from bottom
      _loadMoreData();
    }
  }

  // Simulate initial data loading
  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    List<QuizItem> newItems = _generateQuizItems(1, _itemsPerPage);
    
    setState(() {
      _items = newItems;
      _isLoading = false;
      _currentPage = 1;
    });
  }

  // Load more data for infinite scrolling
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));

    // Simulate reaching end of data after 5 pages
    if (_currentPage >= 5) {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
      return;
    }

    List<QuizItem> newItems = _generateQuizItems(
      _currentPage + 1, 
      _itemsPerPage
    );

    setState(() {
      _items.addAll(newItems);
      _currentPage++;
      _isLoading = false;
    });
  }

  // Generate dummy quiz data
  List<QuizItem> _generateQuizItems(int page, int itemsPerPage) {
    List<QuizItem> items = [];
    int startIndex = (page - 1) * itemsPerPage;
    
    for (int i = 0; i < itemsPerPage; i++) {
      int itemNumber = startIndex + i + 1;
      items.add(QuizItem(
        id: itemNumber,
        question: "What is the tricky Flutter question #$itemNumber?",
        difficulty: _getDifficulty(itemNumber),
        category: _getCategory(itemNumber),
      ));
    }
    return items;
  }

  String _getDifficulty(int index) {
    List<String> difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];
    return difficulties[index % difficulties.length];
  }

  String _getCategory(int index) {
    List<String> categories = ['Widgets', 'State Management', 'Navigation', 'Testing', 'Performance'];
    return categories[index % categories.length];
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return Colors.green;
      case 'Medium': return Colors.orange;
      case 'Hard': return Colors.red;
      case 'Expert': return Colors.purple;
      default: return Colors.grey;
    }
  }

  // Pull to refresh functionality
  Future<void> _onRefresh() async {
    _currentPage = 1;
    _hasMoreData = true;
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Scroll Quiz'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showInfiniteScrollInfo(context),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_items.isEmpty && _isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading quiz questions...'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _items.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          // Show quiz item
          if (index < _items.length) {
            return _buildQuizItem(_items[index]);
          }
          
          // Show loading indicator at bottom
          if (_hasMoreData) {
            return _buildLoadingIndicator();
          }
          
          // Show end of data message
          return _buildEndOfDataWidget();
        },
      ),
    );
  }

  Widget _buildQuizItem(QuizItem item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDifficultyColor(item.difficulty),
          child: Text(
            '${item.id}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          item.question,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    item.difficulty,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: _getDifficultyColor(item.difficulty),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(
                    item.category,
                    style: TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.grey[200],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle quiz item tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Quiz ${item.id} selected!'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Loading more questions...'),
        ],
      ),
    );
  }

  Widget _buildEndOfDataWidget() {
    return Container(
      padding: EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Colors.green,
          ),
          SizedBox(height: 16),
          Text(
            'You\'ve reached the end!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'No more quiz questions available.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showInfiniteScrollInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Infinite Scrolling Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Features demonstrated:'),
              SizedBox(height: 8),
              Text('✅ Automatic loading when scrolling'),
              Text('✅ Pull-to-refresh functionality'),
              Text('✅ Loading indicators'),
              Text('✅ End of data detection'),
              Text('✅ ScrollController monitoring'),
              Text('✅ Pagination simulation'),
            ],
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
}

// Data model for quiz items
class QuizItem {
  final int id;
  final String question;
  final String difficulty;
  final String category;

  QuizItem({
    required this.id,
    required this.question,
    required this.difficulty,
    required this.category,
  });
}
