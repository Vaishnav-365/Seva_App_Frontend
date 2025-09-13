import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const TopBanner({super.key, required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFB4801), Color(0xFFF99810)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0,3), color: Colors.black26)],
      ),
      child: Row(
        children: [
          const Icon(Icons.volunteer_activism, size: 42, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
