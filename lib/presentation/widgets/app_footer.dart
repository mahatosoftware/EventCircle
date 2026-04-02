import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 12,
        bottom: bottomPadding + 12, // Reduced slightly, still safe
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copyright_rounded, size: 10, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                '2026 EVENT CIRCLE',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'All rights reserved.',
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
