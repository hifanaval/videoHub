import 'package:flutter/material.dart';
import 'package:videohub/screens/home/model/category_model.dart';
import 'package:videohub/utils/api_urls.dart';
import 'package:videohub/utils/get_service_utils.dart';

class CategoryProvider extends ChangeNotifier {
  bool isLoading = false;
  CategoryListModel? categoryListModel;
  List<Category> categories = [];

  Future<void> fetchCategoryData(BuildContext context) async {
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

  
}
