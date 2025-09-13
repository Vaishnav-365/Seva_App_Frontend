import 'package:flutter/material.dart';
import '../models/seva_model.dart';

class CategoryCard extends StatelessWidget {
  final SevaCategory category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0,4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon placeholder
            CircleAvatar(child: Text(category.title[0])),
            const SizedBox(height: 8),
            Text(category.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            if (category.subtitle.isNotEmpty) Text(category.subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
