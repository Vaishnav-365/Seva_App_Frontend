class SevaCategory {
  final String id;
  final String title;
  final String subtitle;
  final String iconName; // for future icon mapping
  SevaCategory({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.iconName = '',
  });
}
