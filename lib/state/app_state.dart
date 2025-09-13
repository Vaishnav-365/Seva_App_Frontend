import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AppState extends ChangeNotifier {
  UserProfile? user;

  void setUser(UserProfile? u) {
    user = u;
    notifyListeners();
  }

  // Example: cache of counts, or the selected category index
  int selectedCategoryIndex = 0;
  void setSelectedCategory(int i) {
    selectedCategoryIndex = i;
    notifyListeners();
  }
}
