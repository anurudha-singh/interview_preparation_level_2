import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AnimatedContainerEverySecond extends StatefulWidget {
  static String routeName = 'animated_container';
  const AnimatedContainerEverySecond({super.key});

  @override
  State<AnimatedContainerEverySecond> createState() =>
      _AnimatedContainerEverySecondState();
}

class _AnimatedContainerEverySecondState
    extends State<AnimatedContainerEverySecond> with TickerProviderStateMixin {
  
  // Timer for automatic color changes
  Timer? _timer;
  
  // Random number generator
  final Random _random = Random();
  
  // Animation properties
  Color _currentColor = Colors.blue;
  double _width = 150.0;
  double _height = 150.0;
  BorderRadius _borderRadius = BorderRadius.circular(20);
  
  // Control variables
  bool _isAutoAnimating = true;
  bool _randomSizeEnabled = false;
  bool _randomShapeEnabled = false;
  
  // Animation controller for additional effects
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _startAutoAnimation();
    _setupPulseAnimation();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
  
  void _setupPulseAnimation() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));
  }
  
  void _startAutoAnimation() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isAutoAnimating) {
        _animateToRandomProperties();
      }
    });
  }
  
  void _animateToRandomProperties() {
    setState(() {
      // Always change color
      _currentColor = _generateRandomColor();
      
      // Optionally change size
      if (_randomSizeEnabled) {
        _width = 100.0 + _random.nextDouble() * 200.0;  // 100-300
        _height = 100.0 + _random.nextDouble() * 200.0; // 100-300
      }
      
      // Optionally change shape
      if (_randomShapeEnabled) {
        double radius = _random.nextDouble() * 50.0; // 0-50
        _borderRadius = BorderRadius.circular(radius);
      }
    });
    
    // Trigger pulse animation
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }
  
  Color _generateRandomColor() {
    List<Color> vibrantColors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.blueGrey,
    ];
    
    return vibrantColors[_random.nextInt(vibrantColors.length)];
  }
  
  void _toggleAutoAnimation() {
    setState(() {
      _isAutoAnimating = !_isAutoAnimating;
    });
  }
  
  void _manualTrigger() {
    _animateToRandomProperties();
  }
  
  void _resetToDefault() {
    setState(() {
      _currentColor = Colors.blue;
      _width = 150.0;
      _height = 150.0;
      _borderRadius = BorderRadius.circular(20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Container Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isAutoAnimating ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleAutoAnimation,
            tooltip: _isAutoAnimating ? 'Pause' : 'Play',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Animated Container Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Watch the container change colors automatically every second. Use the controls below to customize the animation.',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Main Animated Container
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius: _borderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: _currentColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Animated',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 40),
            
            // Controls Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Animation Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Auto Animation Toggle
                    SwitchListTile(
                      title: Text('Auto Animation'),
                      subtitle: Text('Changes color every second'),
                      value: _isAutoAnimating,
                      onChanged: (value) => _toggleAutoAnimation(),
                      activeColor: Colors.deepPurple,
                    ),
                    
                    // Random Size Toggle
                    SwitchListTile(
                      title: Text('Random Size'),
                      subtitle: Text('Changes width and height randomly'),
                      value: _randomSizeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _randomSizeEnabled = value;
                        });
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    
                    // Random Shape Toggle
                    SwitchListTile(
                      title: Text('Random Shape'),
                      subtitle: Text('Changes border radius randomly'),
                      value: _randomShapeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _randomShapeEnabled = value;
                        });
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _manualTrigger,
                            icon: Icon(Icons.refresh),
                            label: Text('Manual Trigger'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetToDefault,
                            icon: Icon(Icons.restore),
                            label: Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Code Example Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Implementation Points',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildCodePoint(
                      '⏰ Timer.periodic()',
                      'Creates automatic animation every second',
                    ),
                    _buildCodePoint(
                      '🎨 AnimatedContainer',
                      'Smoothly animates between property changes',
                    ),
                    _buildCodePoint(
                      '📊 Random color generation',
                      'Uses predefined vibrant colors for better UX',
                    ),
                    _buildCodePoint(
                      '✨ Pulse animation',
                      'Additional AnimationController for scale effect',
                    ),
                    _buildCodePoint(
                      '🎛️ Interactive controls',
                      'Toggle different animation features',
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCodePoint(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
