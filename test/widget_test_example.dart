import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Example widgets for testing
class CounterWidget extends StatefulWidget {
  final int initialValue;
  final String title;
  
  const CounterWidget({
    Key? key,
    this.initialValue = 0,
    this.title = 'Counter',
  }) : super(key: key);
  
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _counter;
  
  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue;
  }
  
  void _increment() {
    setState(() {
      _counter++;
    });
  }
  
  void _decrement() {
    setState(() {
      _counter--;
    });
  }
  
  void _reset() {
    setState(() {
      _counter = widget.initialValue;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter Value:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$_counter',
              key: Key('counter_value'),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  key: Key('decrement_button'),
                  onPressed: _decrement,
                  child: Icon(Icons.remove),
                ),
                ElevatedButton(
                  key: Key('reset_button'),
                  onPressed: _reset,
                  child: Icon(Icons.refresh),
                ),
                ElevatedButton(
                  key: Key('increment_button'),
                  onPressed: _increment,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({Key? key}) : super(key: key);
  
  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final List<String> _todos = [];
  final TextEditingController _controller = TextEditingController();
  
  void _addTodo() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _todos.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }
  
  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: Key('todo_input'),
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a todo item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  key: Key('add_todo_button'),
                  onPressed: _addTodo,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              key: Key('todo_list'),
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  key: Key('todo_item_$index'),
                  title: Text(_todos[index]),
                  trailing: IconButton(
                    key: Key('delete_button_$index'),
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeTodo(index),
                  ),
                );
              },
            ),
          ),
          if (_todos.isEmpty)
            Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No todos yet. Add one above!',
                key: Key('empty_message'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  group('CounterWidget Tests', () {
    testWidgets('should display initial counter value', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: CounterWidget(initialValue: 5),
        ),
      );
      
      // Assert
      expect(find.text('5'), findsOneWidget);
      expect(find.byKey(Key('counter_value')), findsOneWidget);
    });
    
    testWidgets('should increment counter when plus button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CounterWidget()),
      );
      
      // Initial state
      expect(find.text('0'), findsOneWidget);
      
      // Act
      await tester.tap(find.byKey(Key('increment_button')));
      await tester.pump();
      
      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });
    
    testWidgets('should decrement counter when minus button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CounterWidget(initialValue: 5)),
      );
      
      await tester.tap(find.byKey(Key('decrement_button')));
      await tester.pump();
      
      expect(find.text('4'), findsOneWidget);
    });
    
    testWidgets('should reset counter when reset button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CounterWidget(initialValue: 10)),
      );
      
      // Increment a few times
      await tester.tap(find.byKey(Key('increment_button')));
      await tester.pump();
      await tester.tap(find.byKey(Key('increment_button')));
      await tester.pump();
      
      expect(find.text('12'), findsOneWidget);
      
      // Reset
      await tester.tap(find.byKey(Key('reset_button')));
      await tester.pump();
      
      expect(find.text('10'), findsOneWidget);
    });
    
    testWidgets('should display custom title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterWidget(title: 'My Custom Counter'),
        ),
      );
      
      expect(find.text('My Custom Counter'), findsOneWidget);
    });
    
    testWidgets('should handle multiple increments correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CounterWidget()),
      );
      
      // Increment 5 times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(Key('increment_button')));
        await tester.pump();
      }
      
      expect(find.text('5'), findsOneWidget);
    });
  });
  
  group('TodoListWidget Tests', () {
    testWidgets('should show empty state initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      expect(find.byKey(Key('empty_message')), findsOneWidget);
      expect(find.text('No todos yet. Add one above!'), findsOneWidget);
    });
    
    testWidgets('should add todo when add button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      // Enter text
      await tester.enterText(find.byKey(Key('todo_input')), 'Test Todo');
      await tester.tap(find.byKey(Key('add_todo_button')));
      await tester.pump();
      
      // Verify todo is added
      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.byKey(Key('todo_item_0')), findsOneWidget);
      expect(find.byKey(Key('empty_message')), findsNothing);
    });
    
    testWidgets('should clear input after adding todo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      await tester.enterText(find.byKey(Key('todo_input')), 'Test Todo');
      await tester.tap(find.byKey(Key('add_todo_button')));
      await tester.pump();
      
      // Input should be cleared
      final textField = tester.widget<TextField>(find.byKey(Key('todo_input')));
      expect(textField.controller?.text, isEmpty);
    });
    
    testWidgets('should not add empty todo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      // Try to add empty todo
      await tester.tap(find.byKey(Key('add_todo_button')));
      await tester.pump();
      
      expect(find.byKey(Key('empty_message')), findsOneWidget);
      expect(find.byKey(Key('todo_item_0')), findsNothing);
    });
    
    testWidgets('should remove todo when delete button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      // Add a todo
      await tester.enterText(find.byKey(Key('todo_input')), 'Test Todo');
      await tester.tap(find.byKey(Key('add_todo_button')));
      await tester.pump();
      
      expect(find.text('Test Todo'), findsOneWidget);
      
      // Delete the todo
      await tester.tap(find.byKey(Key('delete_button_0')));
      await tester.pump();
      
      expect(find.text('Test Todo'), findsNothing);
      expect(find.byKey(Key('empty_message')), findsOneWidget);
    });
    
    testWidgets('should add todo by pressing enter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      await tester.enterText(find.byKey(Key('todo_input')), 'Test Todo');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      
      expect(find.text('Test Todo'), findsOneWidget);
    });
    
    testWidgets('should handle multiple todos correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TodoListWidget()),
      );
      
      // Add multiple todos
      const todos = ['First Todo', 'Second Todo', 'Third Todo'];
      
      for (final todo in todos) {
        await tester.enterText(find.byKey(Key('todo_input')), todo);
        await tester.tap(find.byKey(Key('add_todo_button')));
        await tester.pump();
      }
      
      // Verify all todos are present
      for (final todo in todos) {
        expect(find.text(todo), findsOneWidget);
      }
      
      // Verify correct number of todo items
      expect(find.byKey(Key('todo_item_0')), findsOneWidget);
      expect(find.byKey(Key('todo_item_1')), findsOneWidget);
      expect(find.byKey(Key('todo_item_2')), findsOneWidget);
    });
  });
  
  group('Widget Interaction Tests', () {
    testWidgets('should find widgets by different methods', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CounterWidget()),
      );
      
      // Find by key
      expect(find.byKey(Key('counter_value')), findsOneWidget);
      
      // Find by text
      expect(find.text('Counter Value:'), findsOneWidget);
      
      // Find by widget type
      expect(find.byType(ElevatedButton), findsNWidgets(3));
      
      // Find by icon
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
    
    testWidgets('should handle widget animations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CounterWidget()),
      );
      
      await tester.tap(find.byKey(Key('increment_button')));
      
      // Use pumpAndSettle for animations
      await tester.pumpAndSettle();
      
      expect(find.text('1'), findsOneWidget);
    });
  });
}
