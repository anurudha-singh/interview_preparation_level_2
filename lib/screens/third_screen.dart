import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharpsheel/utils/size_helper.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});
  static String routeName = '/thirdScreen';

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  bool isUploading = false;
  bool isUploading2 = false; // For isolate.spawn method
  String uploadStatus = 'Ready to upload';
  String uploadStatus2 = 'Ready to upload'; // For isolate.spawn method

  // Static function that will run in isolate
  static String uploadDataInIsolate(int iterations) {
    for (var i = 0; i < iterations; i++) {
      // Heavy computation
      if (i % 100000000 == 0) {
        // Optional: You can add some logging here if needed
      }
    }
    return "Upload completed successfully!";
  }

  // Data class for isolate communication
  static void isolateEntryPoint(SendPort sendPort) async {
    // Create a receive port for this isolate
    final receivePort = ReceivePort();

    // Send the send port back to main isolate
    sendPort.send(receivePort.sendPort);

    // Listen for messages from main isolate
    await for (var message in receivePort) {
      if (message is Map<String, dynamic>) {
        if (message['action'] == 'compute') {
          try {
            int iterations = message['iterations'];

            // Perform heavy computation
            for (var i = 0; i < iterations; i++) {
              // Heavy computation
              if (i % 100000000 == 0) {
                // Send progress updates (optional)
                sendPort.send({
                  'type': 'progress',
                  'progress': (i / iterations * 100).toInt(),
                });
              }
            }

            // Send completion message
            sendPort.send({
              'type': 'completed',
              'result': 'Upload completed successfully using Isolate.spawn()!',
            });
          } catch (e) {
            // Send error message
            sendPort.send({'type': 'error', 'error': e.toString()});
          }
        } else if (message['action'] == 'shutdown') {
          // Clean shutdown
          receivePort.close();
          break;
        }
      }
    }
  }

  // Function to handle upload using Isolate.spawn
  Future<void> handleUploadWithIsolateSpawn() async {
    setState(() {
      isUploading2 = true;
      uploadStatus2 = 'Starting isolate...';
    });

    try {
      // Create a receive port for communication
      final receivePort = ReceivePort();

      // Spawn the isolate
      final isolate = await Isolate.spawn(
        isolateEntryPoint,
        receivePort.sendPort,
      );

      setState(() {
        uploadStatus2 = 'Isolate started, waiting for communication...';
      });

      SendPort? childSendPort;

      // Listen for messages from the isolate
      await for (var message in receivePort) {
        if (message is SendPort) {
          // First message should be the child's send port
          childSendPort = message;

          setState(() {
            uploadStatus2 = 'Connected to isolate, starting computation...';
          });

          // Send the computation task
          childSendPort.send({'action': 'compute', 'iterations': 500000000});
        } else if (message is Map<String, dynamic>) {
          if (message['type'] == 'progress') {
            setState(() {
              uploadStatus2 = 'Computing... ${message['progress']}% done';
            });
          } else if (message['type'] == 'completed') {
            setState(() {
              isUploading2 = false;
              uploadStatus2 = message['result'];
            });

            // Show success message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Isolate.spawn computation completed!'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            // Clean up
            childSendPort?.send({'action': 'shutdown'});
            receivePort.close();
            isolate.kill();
            break;
          } else if (message['type'] == 'error') {
            setState(() {
              isUploading2 = false;
              uploadStatus2 = 'Error: ${message['error']}';
            });

            // Show error message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Isolate error: ${message['error']}'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            // Clean up
            receivePort.close();
            isolate.kill();
            break;
          }
        }
      }
    } catch (e) {
      setState(() {
        isUploading2 = false;
        uploadStatus2 = 'Failed to start isolate: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start isolate: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to handle the upload using compute
  Future<void> handleUpload() async {
    setState(() {
      isUploading = true;
      uploadStatus = 'Uploading... Please wait';
    });

    try {
      // Run the heavy computation in an isolate
      String result = await compute(
        uploadDataInIsolate,
        500000000,
      ); // Reduced for demo
      print('Result ${result}');
      setState(() {
        isUploading = false;
        uploadStatus = result;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload completed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
        uploadStatus = 'Upload failed: $e';
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize SizeHelper
    SizeHelper.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Third Screen - Isolate Demo'),
        backgroundColor: Colors.purple.shade300,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeHelper.getWidthPercentage(4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: SizeHelper.getHeightPercentage(2)),

              // Title
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Welcome to the Third Screen!\nIsolate Compute Demo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(3)),

              // Upload Status Container for compute()
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isUploading
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUploading
                        ? Colors.orange.shade300
                        : Colors.green.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (isUploading) ...[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange.shade600,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    Icon(
                      isUploading ? Icons.cloud_upload : Icons.cloud_done,
                      size: 40,
                      color: isUploading
                          ? Colors.orange.shade600
                          : Colors.green.shade600,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'compute() Status:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      uploadStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isUploading
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(2)),

              // Upload Status Container for Isolate.spawn()
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isUploading2
                      ? Colors.purple.shade100
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUploading2
                        ? Colors.purple.shade300
                        : Colors.blue.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (isUploading2) ...[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.purple.shade600,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    Icon(
                      isUploading2 ? Icons.settings : Icons.done_all,
                      size: 40,
                      color: isUploading2
                          ? Colors.purple.shade600
                          : Colors.blue.shade600,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Isolate.spawn() Status:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      uploadStatus2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isUploading2
                            ? Colors.purple.shade700
                            : Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(3)),

              // Demo of IntrinsicHeight
              Text(
                'IntrinsicHeight Demo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.red.shade200,
                        child: Text("Short", textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.green.shade200,
                        child: Text(
                          "This is a very long text that makes the box taller and demonstrates IntrinsicHeight widget",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(4)),

              // Action Buttons
              SizedBox(
                width: SizeHelper.getWidthPercentage(80),
                height: SizeHelper.getHeightPercentage(6),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Go Back to Second Screen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(2)),

              SizedBox(
                width: SizeHelper.getWidthPercentage(80),
                height: SizeHelper.getHeightPercentage(6),
                child: ElevatedButton.icon(
                  onPressed: isUploading ? null : handleUpload,
                  icon: Icon(
                    isUploading ? Icons.hourglass_empty : Icons.rocket_launch,
                  ),
                  label: Text(
                    isUploading
                        ? 'Processing...'
                        : 'Start Heavy Computation (compute)',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUploading
                        ? Colors.grey
                        : Colors.orange.shade400,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(1)),

              SizedBox(
                width: SizeHelper.getWidthPercentage(80),
                height: SizeHelper.getHeightPercentage(6),
                child: ElevatedButton.icon(
                  onPressed: isUploading2 ? null : handleUploadWithIsolateSpawn,
                  icon: Icon(isUploading2 ? Icons.settings : Icons.memory),
                  label: Text(
                    isUploading2
                        ? 'Processing...'
                        : 'Start Heavy Computation (Isolate.spawn)',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUploading2
                        ? Colors.grey
                        : Colors.purple.shade400,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: SizeHelper.getHeightPercentage(2)),

              // Info text
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      'ℹ️ Compare two isolate methods:',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🟠 compute(): Simple, automatic cleanup\n🟣 Isolate.spawn(): More control, progress updates, manual cleanup',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
