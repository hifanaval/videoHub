import 'package:flutter/material.dart';
import 'package:videohub/screens/home/model/category_model.dart';
import 'package:videohub/utils/api_urls.dart';
import 'package:videohub/utils/get_service_utils.dart';

class CategoryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isInitial = true;
  CategoryListModel? categoryListModel;
  List<Category> categories = [];
  List<String> selectedCategoryIds = [];
  

  Future<void> fetchCategoryData(BuildContext context) async {
    // Only fetch data if it's the initial load
    if (!isInitial) {
      debugPrint("Categories already loaded, skipping fetch");
      return;
    }

    categoryListModel = null;
    categories.clear();
    setLoading(true);

    try {
      final jsonData = await GetServiceUtils.fetchData(
        ApiUrls.getCategoryData(),
        context,
      );

      categoryListModel = categoryListModelFromJson(jsonData);
      categories = categoryListModel!.categories ?? [];

      // Mark as no longer initial after successful load
      isInitial = false;

      debugPrint("categories fetched successfully");
      debugPrint("Parsed JSON Data: $jsonData");
    } catch (e, stackTrace) {
      debugPrint('categories Data Error: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      setLoading(false);
    }
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Method to reset initial state (useful for logout or force refresh)
  void resetInitialState() {
    isInitial = true;
    categoryListModel = null;
    categories.clear();
    notifyListeners();
  }

  // Method to force refresh categories
  Future<void> forceRefresh(BuildContext context) async {
    resetInitialState();
    await fetchCategoryData(context);
  }
void toggleCategory(String categoryId) {
    if (selectedCategoryIds.contains(categoryId)) {
      selectedCategoryIds.remove(categoryId);
    } else {
      selectedCategoryIds.add(categoryId);
    }
    notifyListeners();
  }

  bool isSelected(String categoryId) {
    return selectedCategoryIds.contains(categoryId);
  }

  void clearCategories() {
    selectedCategoryIds.clear();
    notifyListeners();
  }

  void setCategories(List<String> categoryIds) {
    selectedCategoryIds = categoryIds;
    notifyListeners();
  }

}
