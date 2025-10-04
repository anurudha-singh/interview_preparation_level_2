import 'package:flutter/material.dart';
import 'package:sharpsheel/utils/app_drawer.dart';

class FlutterKeysImplementation extends StatefulWidget {
  static String routeName = '/flutter_keys';
  const FlutterKeysImplementation({super.key});

  @override
  State<FlutterKeysImplementation> createState() =>
      FlutterKeysImplementationState();
}

class FlutterKeysImplementationState extends State<FlutterKeysImplementation>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // ValueKey Example
  List<String> valueKeyItems = ['Apple', 'Banana', 'Cherry'];

  // ObjectKey Example
  List<Person> objectKeyItems = [
    Person('Alice', 25),
    Person('Bob', 30),
    Person('Charlie', 35),
  ];

  // UniqueKey Example
  List<Widget> uniqueKeyWidgets = [];

  // GlobalKey Examples
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<_CounterWidgetState> _counterKey =
      GlobalKey<_CounterWidgetState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // PageStorageKey Example
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Initialize UniqueKey widgets
    uniqueKeyWidgets = [
      _UniqueKeyWidget(key: UniqueKey(), color: Colors.red, text: 'Widget 1'),
      _UniqueKeyWidget(key: UniqueKey(), color: Colors.blue, text: 'Widget 2'),
      _UniqueKeyWidget(key: UniqueKey(), color: Colors.green, text: 'Widget 3'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building FlutterKeysImplementationState');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Flutter Keys Implementation'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'ValueKey'),
            Tab(text: 'ObjectKey'),
            Tab(text: 'UniqueKey'),
            Tab(text: 'GlobalKey'),
            Tab(text: 'PageStorageKey'),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildValueKeyTab(),
          _buildObjectKeyTab(),
          _buildUniqueKeyTab(),
          _buildGlobalKeyTab(),
          _buildPageStorageKeyTab(),
        ],
      ),
    );
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'Flutter Keys Overview',
            content:
                '''Keys in Flutter are unique identifiers that help Flutter's framework identify widgets in the widget tree. They are crucial for maintaining state and optimizing performance during widget tree updates.

🎯 Why are Keys Important?
• Help Flutter identify which widgets have changed
• Preserve widget state during reordering or updates
• Optimize performance by avoiding unnecessary rebuilds
• Enable proper widget matching in animations''',
            icon: Icons.key,
            color: Colors.indigo,
          ),
          SizedBox(height: 16),
          _buildKeyTypeCard(
            'ValueKey',
            'Uses a value to identify widgets. Best for simple data types.',
            Icons.label,
            Colors.blue,
            'Example: ValueKey("user_123")',
          ),
          _buildKeyTypeCard(
            'ObjectKey',
            'Uses object identity. Perfect for complex objects.',
            Icons.account_circle,
            Colors.green,
            'Example: ObjectKey(user)',
          ),
          _buildKeyTypeCard(
            'UniqueKey',
            'Always unique. Useful when you need guaranteed uniqueness.',
            Icons.fingerprint,
            Colors.orange,
            'Example: UniqueKey()',
          ),
          _buildKeyTypeCard(
            'GlobalKey',
            'Provides access to widget state and context from anywhere.',
            Icons.public,
            Colors.red,
            'Example: GlobalKey<FormState>()',
          ),
          _buildKeyTypeCard(
            'PageStorageKey',
            'Preserves scroll position and other page state.',
            Icons.storage,
            Colors.purple,
            'Example: PageStorageKey("scrollview")',
          ),
        ],
      ),
    );
  }

  // ValueKey Tab
  Widget _buildValueKeyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'ValueKey',
            content:
                '''ValueKey uses the value itself to determine equality. Two ValueKeys are equal if their values are equal.

✅ Use Cases:
• Simple data types (String, int, bool)
• When the value uniquely identifies the widget
• List items with unique identifiers

⚠️ Considerations:
• Value must be immutable
• Value should be unique within the list
• Avoid using mutable objects as values''',
            icon: Icons.label,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            'Interactive Example: Reorderable List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = valueKeyItems.removeAt(oldIndex);
                  valueKeyItems.insert(newIndex, item);
                });
              },
              children: valueKeyItems
                  .map(
                    (item) => ListTile(
                      key: ValueKey(item),
                      leading: Icon(Icons.drag_handle),
                      title: Text(item),
                      trailing: Icon(_getIconForFruit(item)),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                valueKeyItems.shuffle();
              });
            },
            child: Text('Shuffle List'),
          ),
          SizedBox(height: 20),
          _buildCodeExample('''
// ValueKey Example
ReorderableListView(
  onReorder: (oldIndex, newIndex) {
    // Reorder logic
  },
  children: items.map((item) => ListTile(
    key: ValueKey(item), // 🔑 ValueKey here
    title: Text(item),
  )).toList(),
)'''),
        ],
      ),
    );
  }

  // ObjectKey Tab
  Widget _buildObjectKeyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'ObjectKey',
            content:
                '''ObjectKey uses the identity of an object (not its value) to determine equality. Perfect for complex objects where the object reference is the unique identifier.

✅ Use Cases:
• Complex objects with multiple properties
• When object identity matters more than content
• Database entities with unique instances

⚠️ Considerations:
• Uses object identity, not equality
• Same content in different objects = different keys
• Memory efficient for large objects''',
            icon: Icons.account_circle,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Text(
            'Interactive Example: Person Objects',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = objectKeyItems.removeAt(oldIndex);
                  objectKeyItems.insert(newIndex, item);
                });
              },
              children: objectKeyItems
                  .map(
                    (person) => Card(
                      key: ObjectKey(person),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(person.name[0])),
                        title: Text(person.name),
                        subtitle: Text('Age: ${person.age}'),
                        trailing: Icon(Icons.drag_handle),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    objectKeyItems.shuffle();
                  });
                },
                child: Text('Shuffle'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    objectKeyItems.add(Person('New Person', 25));
                  });
                },
                child: Text('Add Person'),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildCodeExample('''
class Person {
  final String name;
  final int age;
  Person(this.name, this.age);
}

// ObjectKey Example
ListView(
  children: people.map((person) => ListTile(
    key: ObjectKey(person), // 🔑 ObjectKey here
    title: Text(person.name),
    subtitle: Text('Age: \${person.age}'),
  )).toList(),
)'''),
        ],
      ),
    );
  }

  // UniqueKey Tab
  Widget _buildUniqueKeyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'UniqueKey',
            content:
                '''UniqueKey generates a unique key every time it's created. No two UniqueKeys are ever equal, making them perfect when you need guaranteed uniqueness.

✅ Use Cases:
• Force widget recreation
• Animations that need unique identification
• When other key types don't provide enough uniqueness

⚠️ Considerations:
• Creates new key every time
• Can be expensive if overused
• May cause unnecessary rebuilds''',
            icon: Icons.fingerprint,
            color: Colors.orange,
          ),
          SizedBox(height: 20),
          Text(
            'Interactive Example: Unique Widgets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = uniqueKeyWidgets.removeAt(oldIndex);
                  uniqueKeyWidgets.insert(newIndex, item);
                });
              },
              children: uniqueKeyWidgets,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    uniqueKeyWidgets.shuffle();
                  });
                },
                child: Text('Shuffle'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final colors = [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.purple,
                      Colors.orange,
                    ];
                    uniqueKeyWidgets.add(
                      _UniqueKeyWidget(
                        key: UniqueKey(),
                        color: colors[uniqueKeyWidgets.length % colors.length],
                        text: 'Widget ${uniqueKeyWidgets.length + 1}',
                      ),
                    );
                  });
                },
                child: Text('Add Widget'),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildCodeExample('''
// UniqueKey Example
class _UniqueKeyWidget extends StatefulWidget {
  final Color color;
  final String text;
  
  const _UniqueKeyWidget({
    Key? key, // UniqueKey passed here
    required this.color,
    required this.text,
  }) : super(key: key);
}

// Usage
_UniqueKeyWidget(
  key: UniqueKey(), // 🔑 UniqueKey here
  color: Colors.red,
  text: 'Unique Widget',
)'''),
        ],
      ),
    );
  }

  // GlobalKey Tab
  Widget _buildGlobalKeyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'GlobalKey',
            content:
                '''GlobalKey provides access to a widget's state and context from anywhere in the app. It's the most powerful key type but should be used sparingly.

✅ Use Cases:
• Form validation
• Accessing widget methods from outside
• Getting widget size/position
• Showing snackbars, dialogs

⚠️ Considerations:
• More expensive than other keys
• Can cause memory leaks if not disposed
• Should be stored in State, not build method''',
            icon: Icons.public,
            color: Colors.red,
          ),
          SizedBox(height: 20),
          Text(
            'Interactive Examples',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Form Example
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Validation Example',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Email required';
                            if (!value!.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Form is valid!')),
                              );
                            }
                          },
                          child: Text('Validate Form'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Counter Example
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Counter Widget Control',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _CounterWidget(key: _counterKey),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _counterKey.currentState?.incrementFromOutside();
                    },
                    child: Text('Increment from Outside'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildCodeExample('''
// GlobalKey Examples
class MyWidget extends StatefulWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<_CounterState> _counterKey = GlobalKey<_CounterState>();
  
  // Form validation
  void validateForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid
    }
  }
  
  // Access widget methods
  void incrementCounter() {
    _counterKey.currentState?.increment();
  }
}'''),
        ],
      ),
    );
  }

  // PageStorageKey Tab
  Widget _buildPageStorageKeyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentationCard(
            title: 'PageStorageKey',
            content:
                '''PageStorageKey preserves the scroll position and other stateful data when widgets are removed and re-added to the widget tree.

✅ Use Cases:
• Preserving scroll position in lists
• Maintaining expansion state of panels
• Tab view state persistence
• Navigation state preservation

⚠️ Considerations:
• Requires PageStorage ancestor
• Key must be unique within PageStorage scope
• Only preserves specific types of state''',
            icon: Icons.storage,
            color: Colors.purple,
          ),
          SizedBox(height: 20),
          Text(
            'Interactive Example: Scroll Position Preservation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PageStorage(
              bucket: _bucket,
              child: ListView.builder(
                key: PageStorageKey('demo_list'),
                itemCount: 100,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Item ${index + 1}'),
                    subtitle: Text('This is item number ${index + 1}'),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '💡 Scroll down in the list above, then switch tabs and come back. Your scroll position will be preserved!',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 20),
          _buildCodeExample('''
// PageStorageKey Example
class MyApp extends StatelessWidget {
  final PageStorageBucket bucket = PageStorageBucket();
  
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: bucket,
      child: ListView.builder(
        key: PageStorageKey('my_list'), // 🔑 PageStorageKey here
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(items[index]));
        },
      ),
    );
  }
}'''),
        ],
      ),
    );
  }

  // Helper Methods
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

  Widget _buildKeyTypeCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String example,
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
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(description),
            SizedBox(height: 4),
            Text(
              example,
              style: TextStyle(
                fontFamily: 'monospace',
                color: color,
                fontWeight: FontWeight.w500,
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
      child: Text(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  IconData _getIconForFruit(String fruit) {
    switch (fruit.toLowerCase()) {
      case 'apple':
        return Icons.apple;
      case 'banana':
        return Icons.eco; // Using eco for banana
      case 'cherry':
        return Icons.nature; // Using nature for cherry
      default:
        return Icons.food_bank;
    }
  }
}

// Supporting Classes
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

class _UniqueKeyWidget extends StatefulWidget {
  final Color color;
  final String text;

  const _UniqueKeyWidget({Key? key, required this.color, required this.text})
    : super(key: key);

  @override
  State<_UniqueKeyWidget> createState() => _UniqueKeyWidgetState();
}

class _UniqueKeyWidgetState extends State<_UniqueKeyWidget> {
  late DateTime createdAt;

  @override
  void initState() {
    super.initState();
    createdAt = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.fingerprint, color: Colors.white),
          ),
          title: Text(
            widget.text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Created: ${createdAt.toString().substring(11, 19)}',
            style: TextStyle(fontSize: 12),
          ),
          trailing: Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}

class _CounterWidget extends StatefulWidget {
  const _CounterWidget({Key? key}) : super(key: key);

  @override
  State<_CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<_CounterWidget> {
  int counter = 0;

  void incrementFromOutside() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Counter: $counter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                counter++;
              });
            },
            child: Text('Internal +'),
          ),
        ],
      ),
    );
  }
}
