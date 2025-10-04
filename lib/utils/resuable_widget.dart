// Helper method to build drawer items with consistent styling
import 'package:flutter/material.dart';
import 'package:sharpsheel/utils/size_helper.dart';

Widget buildDrawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
    child: ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade600, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
          fontSize: 15,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.blue.shade50,
      splashColor: Colors.blue.shade100,
    ),
  );
}

// Helper method to show about dialog
void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.blue.shade600),
            SizedBox(width: 8),
            Text('About SharpSheel'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🚀 SharpSheel Demo App'),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Built with Flutter & ❤️'),
            SizedBox(height: 8),
            Text('© 2025 SharpSheel.AI'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Colors.blue.shade600)),
          ),
        ],
      );
    },
  );
}

Widget buildWideContainers() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        width: SizeHelper.getWidthPercentage(40),
        height: SizeHelper.getHeightPercentage(30),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wide Container 1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Width: ${SizeHelper.getWidthPercentage(40).toInt()}px',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
      Container(
        width: SizeHelper.getWidthPercentage(40),
        height: SizeHelper.getHeightPercentage(30),
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wide Container 2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Height: ${SizeHelper.getHeightPercentage(30).toInt()}px',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
