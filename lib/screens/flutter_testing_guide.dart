import 'package:flutter/material.dart';
import 'package:sharpsheel/utils/app_drawer.dart';

class FlutterTestingGuide extends StatefulWidget {
  static String routeName = '/flutter_testing_guide';
  const FlutterTestingGuide({super.key});

  @override
  State<FlutterTestingGuide> createState() => _FlutterTestingGuideState();
}

class _FlutterTestingGuideState extends State<FlutterTestingGuide>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Example data for demonstrations
  int _counter = 0;
  List<String> _todos = ['Learn Unit Testing', 'Practice Widget Testing'];
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void addTodo(String todo) {
    if (todo.isNotEmpty) {
      setState(() {
        _todos.add(todo);
        _todoController.clear();
      });
    }
  }

  void removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Testing Guide'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Unit Testing'),
            Tab(text: 'Widget Testing'),
            Tab(text: 'Integration Testing'),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUnitTestingTab(),
          _buildWidgetTestingTab(),
          _buildIntegrationTestingTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'Flutter Testing Overview',
            content: '''Testing is crucial for building reliable Flutter applications. Flutter provides three main types of testing:

🎯 Why Testing Matters:
• Catch bugs early in development
• Ensure code reliability and maintainability
• Provide confidence when refactoring
• Document expected behavior
• Improve code quality and design''',
            icon: Icons.quiz,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 16),
          _buildTestingPyramid(),
          SizedBox(height: 20),
          _buildTestTypeCard(
            'Unit Testing',
            'Tests individual functions, methods, and classes in isolation.',
            Icons.functions,
            Colors.green,
            'Fast • Isolated • Focused',
            '70% of your tests',
          ),
          _buildTestTypeCard(
            'Widget Testing',
            'Tests individual widgets and their behavior.',
            Icons.widgets,
            Colors.blue,
            'UI-focused • Component-level • Interactive',
            '20% of your tests',
          ),
          _buildTestTypeCard(
            'Integration Testing',
            'Tests complete app flows and user journeys.',
            Icons.device_hub,
            Colors.orange,
            'End-to-end • User scenarios • Real devices',
            '10% of your tests',
          ),
        ],
      ),
    );
  }

  Widget _buildUnitTestingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'Unit Testing',
            content: '''Unit tests verify the behavior of individual functions, methods, and classes in isolation. They are the foundation of your testing strategy.

✅ What to Test:
• Business logic and calculations
• Data models and validation
• Utility functions
• State management logic

⚡ Characteristics:
• Fast execution (milliseconds)
• No dependencies on UI or external systems
• Easy to write and maintain
• Provide quick feedback''',
            icon: Icons.functions,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          
          Text(
            'Interactive Example: Counter Logic',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Counter Value: $_counter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: incrementCounter,
                        child: Text('Increment'),
                      ),
                      ElevatedButton(
                        onPressed: resetCounter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          _buildCodeExample('''
// counter_logic.dart - Business Logic
class Counter {
  int _value = 0;
  
  int get value => _value;
  
  void increment() => _value++;
  void decrement() => _value--;
  void reset() => _value = 0;
  
  bool get isEven => _value % 2 == 0;
  bool get isPositive => _value > 0;
}

// test/counter_test.dart - Unit Tests
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/counter_logic.dart';

void main() {
  group('Counter Tests', () {
    late Counter counter;
    
    setUp(() {
      counter = Counter();
    });
    
    test('should start with value 0', () {
      expect(counter.value, 0);
    });
    
    test('should increment value', () {
      counter.increment();
      expect(counter.value, 1);
    });
    
    test('should reset to 0', () {
      counter.increment();
      counter.increment();
      counter.reset();
      expect(counter.value, 0);
    });
    
    test('should detect even numbers', () {
      expect(counter.isEven, true); // 0 is even
      counter.increment();
      expect(counter.isEven, false); // 1 is odd
    });
  });
}'''),
          
          SizedBox(height: 20),
          _buildBestPracticesCard('Unit Testing Best Practices', [
            '✅ Test one thing at a time',
            '✅ Use descriptive test names',
            '✅ Follow AAA pattern (Arrange, Act, Assert)',
            '✅ Use setUp() and tearDown() for common setup',
            '✅ Mock external dependencies',
            '✅ Test edge cases and error scenarios',
            '❌ Don\'t test Flutter framework code',
            '❌ Don\'t test private methods directly',
          ]),
        ],
      ),
    );
  }

  Widget _buildWidgetTestingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'Widget Testing',
            content: '''Widget tests verify the behavior and appearance of individual widgets. They test the UI components in isolation without running on a real device.

✅ What to Test:
• Widget rendering and layout
• User interactions (tap, scroll, input)
• Widget state changes
• Navigation between screens
• Form validation

⚡ Characteristics:
• Run in simulated environment
• Faster than integration tests
• Can test widget interactions
• Good for testing UI logic''',
            icon: Icons.widgets,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          
          Text(
            'Interactive Example: Todo List Widget',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _todoController,
                          decoration: InputDecoration(
                            labelText: 'Add a todo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => addTodo(_todoController.text),
                        child: Text('Add'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Todo Items (${_todos.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.task_alt),
                        title: Text(_todos[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeTodo(index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          _buildCodeExample('''
// todo_widget.dart - Widget to Test
class TodoWidget extends StatefulWidget {
  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  List<String> todos = [];
  final controller = TextEditingController();
  
  void addTodo() {
    if (controller.text.isNotEmpty) {
      setState(() {
        todos.add(controller.text);
        controller.clear();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: Key('todo_input'),
                controller: controller,
                decoration: InputDecoration(hintText: 'Add todo'),
              ),
            ),
            ElevatedButton(
              key: Key('add_button'),
              onPressed: addTodo,
              child: Text('Add'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            key: Key('todo_list'),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return ListTile(
                key: Key('todo_item_\$index'),
                title: Text(todos[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// test/widget_test.dart - Widget Tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/todo_widget.dart';

void main() {
  group('TodoWidget Tests', () {
    testWidgets('should add todo when button pressed', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: TodoWidget()));
      
      // Act
      await tester.enterText(find.byKey(Key('todo_input')), 'Test Todo');
      await tester.tap(find.byKey(Key('add_button')));
      await tester.pump(); // Rebuild widget
      
      // Assert
      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.byKey(Key('todo_item_0')), findsOneWidget);
    });
    
    testWidgets('should not add empty todo', (tester) async {
      await tester.pumpWidget(MaterialApp(home: TodoWidget()));
      
      await tester.tap(find.byKey(Key('add_button')));
      await tester.pump();
      
      expect(find.byKey(Key('todo_item_0')), findsNothing);
    });
    
    testWidgets('should clear input after adding todo', (tester) async {
      await tester.pumpWidget(MaterialApp(home: TodoWidget()));
      
      await tester.enterText(find.byKey(Key('todo_input')), 'Test Todo');
      await tester.tap(find.byKey(Key('add_button')));
      await tester.pump();
      
      expect(find.text('Test Todo'), findsOneWidget); // In list
      expect(
        tester.widget<TextField>(find.byKey(Key('todo_input'))).controller?.text,
        isEmpty,
      ); // Input cleared
    });
  });
}'''),
          
          SizedBox(height: 20),
          _buildBestPracticesCard('Widget Testing Best Practices', [
            '✅ Use testWidgets() for widget tests',
            '✅ Add keys to widgets for easy finding',
            '✅ Use pump() and pumpAndSettle() appropriately',
            '✅ Test user interactions and state changes',
            '✅ Verify both positive and negative scenarios',
            '✅ Test accessibility features',
            '❌ Don\'t test platform-specific behavior',
            '❌ Don\'t test external API calls',
          ]),
        ],
      ),
    );
  }

  Widget _buildIntegrationTestingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'Integration Testing',
            content: '''Integration tests verify complete user flows and app behavior. They run on real devices or emulators and test the entire application stack.

✅ What to Test:
• Complete user journeys
• Navigation flows
• Data persistence
• API integration
• Platform-specific features
• Performance under real conditions

⚡ Characteristics:
• Runs on real devices/emulators
• Tests entire app stack
• Slower execution
• Most confidence in app behavior''',
            icon: Icons.device_hub,
            color: Colors.orange,
          ),
          SizedBox(height: 20),
          
          _buildCodeExample('''
// integration_test/app_test.dart - Integration Tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete user flow test', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test navigation to different screens
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Second Screen'));
      await tester.pumpAndSettle();
      
      // Verify we're on the second screen
      expect(find.text('Second Screen'), findsOneWidget);
      
      // Test form submission
      await tester.enterText(find.byType(TextField), 'Test Input');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      
      // Verify result
      expect(find.text('Success'), findsOneWidget);
    });
    
    testWidgets('offline behavior test', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Simulate network disconnection
      // Test app behavior without internet
      
      await tester.tap(find.text('Load Data'));
      await tester.pumpAndSettle();
      
      // Should show offline message
      expect(find.text('No internet connection'), findsOneWidget);
    });
  });
}

// Run with: flutter test integration_test/'''),
          
          SizedBox(height: 20),
          Text(
            'Setting Up Integration Tests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          _buildSetupCard('1. Add Dependencies', '''
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter'''),
          
          _buildSetupCard('2. Create Test Directory', '''
Create folder: integration_test/
Add file: integration_test/app_test.dart'''),
          
          _buildSetupCard('3. Run Integration Tests', '''
# Run on connected device
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d <device_id>

# Run with coverage
flutter test integration_test/ --coverage'''),
          
          SizedBox(height: 20),
          _buildBestPracticesCard('Integration Testing Best Practices', [
            '✅ Test critical user journeys',
            '✅ Test on multiple devices and platforms',
            '✅ Include error scenarios and edge cases',
            '✅ Test offline/poor network conditions',
            '✅ Validate data persistence',
            '✅ Test app lifecycle events',
            '❌ Don\'t test every possible scenario',
            '❌ Don\'t duplicate unit/widget test coverage',
          ]),
        ],
      ),
    );
  }

  Widget _buildTestingPyramid() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Testing Pyramid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CustomPaint(
              size: Size(200, 150),
              painter: TestingPyramidPainter(),
            ),
            SizedBox(height: 16),
            Text(
              'More tests at the bottom (fast, isolated)\nFewer tests at the top (slow, comprehensive)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper methods for building UI components
  Widget _buildDocumentationCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestTypeCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String characteristics,
    String percentage,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(description),
            SizedBox(height: 4),
            Text(
              characteristics,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: color,
              ),
            ),
            Text(
              percentage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample(String code) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildBestPracticesCard(String title, List<String> practices) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...practices.map((practice) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                practice,
                style: TextStyle(
                  fontSize: 14,
                  color: practice.startsWith('❌') ? Colors.red : Colors.green,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupCard(String title, String content) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for testing pyramid
class TestingPyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Integration Tests (top - orange)
    paint.color = Colors.orange.withOpacity(0.7);
    final topRect = Rect.fromLTWH(size.width * 0.3, 0, size.width * 0.4, size.height * 0.3);
    canvas.drawRect(topRect, paint);
    
    // Widget Tests (middle - blue)
    paint.color = Colors.blue.withOpacity(0.7);
    final middleRect = Rect.fromLTWH(size.width * 0.2, size.height * 0.3, size.width * 0.6, size.height * 0.35);
    canvas.drawRect(middleRect, paint);
    
    // Unit Tests (bottom - green)
    paint.color = Colors.green.withOpacity(0.7);
    final bottomRect = Rect.fromLTWH(size.width * 0.1, size.height * 0.65, size.width * 0.8, size.height * 0.35);
    canvas.drawRect(bottomRect, paint);
    
    // Add labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // Integration label
    textPainter.text = TextSpan(
      text: 'Integration\n10%',
      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.5 - textPainter.width / 2, size.height * 0.15 - textPainter.height / 2));
    
    // Widget label
    textPainter.text = TextSpan(
      text: 'Widget\n20%',
      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.5 - textPainter.width / 2, size.height * 0.475 - textPainter.height / 2));
    
    // Unit label
    textPainter.text = TextSpan(
      text: 'Unit\n70%',
      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.5 - textPainter.width / 2, size.height * 0.825 - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
