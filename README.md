# Sharpshell 🚀

A comprehensive Flutter demonstration project showcasing advanced Flutter concepts, platform channels, isolates, responsive design, and state management.

## 🌟 Features

### 📱 Multi-Screen Navigation
- **Home Screen (Users List)**: StreamBuilder with proper disposal management
- **First Screen**: Platform channel integration and responsive design
- **Second Screen**: Adaptive layouts with LayoutBuilder
- **Third Screen**: Isolate demonstrations and heavy computation handling

### 🔗 Platform Channel Integration
- **Native Android Integration**: Battery level access through Kotlin
- **Method Channel Implementation**: Bidirectional communication between Flutter and native code
- **Error Handling**: Comprehensive error management for platform-specific operations

### ⚡ Isolate & Concurrency Management
- **Flutter `compute()` Function**: Simple isolate implementation for heavy computations
- **Manual `Isolate.spawn()`**: Advanced isolate management with:
  - Real-time progress updates
  - Bidirectional communication via SendPort/ReceivePort
  - Custom isolate lifecycle management
  - Error handling and cleanup

### 📐 Responsive Design System
- **SizeHelper Utility**: Global screen dimension management
- **Percentage-based Sizing**: Responsive layouts across different screen sizes
- **Safe Area Handling**: Proper handling of notches, status bars, and home indicators
- **Orientation Detection**: Portrait/landscape adaptive layouts

### 🎨 UI/UX Features
- **Stream Management**: Proper stream disposal and memory leak prevention
- **Loading States**: Visual feedback during async operations
- **Progress Indicators**: Real-time computation progress
- **Error States**: User-friendly error handling and messaging
- **Navigation Patterns**: Both `pushNamed` and `pushReplacementNamed` demonstrations

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── users_list.dart      # Home screen with StreamBuilder
│   ├── first_screen.dart    # Platform channels & responsive design
│   ├── second_screen.dart   # Adaptive layouts
│   └── third_screen.dart    # Isolate demonstrations
├── model/
│   └── users_model.dart     # Data models
└── utils/
    ├── routes.dart          # App routing
    └── size_helper.dart     # Responsive design utility
```

## 🔧 Technical Highlights

### Stream Management
```dart
// Proper stream controller with disposal
late StreamController<int> _streamController;
Timer? _timer;

@override
void dispose() {
  _timer?.cancel();
  _streamController.close();
  super.dispose();
}
```

### Platform Channel Implementation
```dart
// Flutter side
MethodChannel platformChannel = MethodChannel('com.example.battery');
int batteryLevel = await platformChannel.invokeMethod('getBatteryLevel');

// Android/Kotlin side
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
  .setMethodCallHandler { call, result ->
    if (call.method == "getBatteryLevel") {
      result.success(getBatteryLevel())
    }
  }
```

### Isolate with Progress Updates
```dart
// Advanced isolate with bidirectional communication
static void isolateEntryPoint(SendPort sendPort) async {
  // Heavy computation with progress updates
  for (var i = 0; i < iterations; i++) {
    if (i % 100000000 == 0) {
      sendPort.send({'type': 'progress', 'progress': (i / iterations * 100).toInt()});
    }
  }
}
```

### Responsive Design
```dart
// Global responsive helper
SizeHelper.init(context);
Container(
  width: SizeHelper.getWidthPercentage(80), // 80% of screen width
  height: SizeHelper.getHeightPercentage(10), // 10% of screen height
)
```

## 📋 Prerequisites

- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=3.0.0`
- Android Studio / VS Code
- Android SDK (for platform channel features)

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd Sharpshell
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

### 4. Test Platform Channels (Android)
Ensure you have an Android device/emulator connected to test the battery level feature.

## 🎯 Key Demonstrations

### Navigation & Memory Management
- **Stream Disposal**: Demonstrates proper cleanup to prevent memory leaks
- **Navigation Patterns**: Shows difference between `pushNamed` and `pushReplacementNamed`
- **Widget Lifecycle**: Proper `dispose()` method implementation

### Platform Integration
- **Native Code Integration**: Kotlin-Flutter communication
- **Battery Level Access**: Real device hardware interaction
- **Error Handling**: Graceful handling of platform-specific errors

### Performance Optimization
- **Isolate Comparison**: Side-by-side comparison of `compute()` vs `Isolate.spawn()`
- **UI Responsiveness**: Heavy computation without UI blocking
- **Progress Feedback**: Real-time updates during long operations

### Responsive Design
- **Adaptive Layouts**: Different layouts for different screen sizes
- **Safe Area Handling**: Proper handling of device-specific UI elements
- **Orientation Support**: Portrait and landscape optimizations

## 📚 Learning Outcomes

This project demonstrates proficiency in:

- ✅ **Flutter State Management**: Proper StatefulWidget lifecycle management
- ✅ **Asynchronous Programming**: Streams, Futures, and async/await patterns
- ✅ **Platform Channels**: Native iOS/Android integration
- ✅ **Isolate Programming**: Advanced concurrency and parallel processing
- ✅ **Responsive Design**: Cross-device compatibility
- ✅ **Memory Management**: Proper resource disposal and leak prevention
- ✅ **Error Handling**: Comprehensive error management strategies
- ✅ **UI/UX Patterns**: Loading states, progress indicators, and user feedback

## 🔍 Code Quality Features

- **Clean Architecture**: Well-organized code structure
- **Documentation**: Comprehensive code comments
- **Error Boundaries**: Proper try-catch implementations
- **Resource Management**: Automatic cleanup and disposal
- **Performance Monitoring**: Efficient memory usage patterns

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is created for educational purposes and Flutter development demonstration.

---

**Built with ❤️ using Flutter**
