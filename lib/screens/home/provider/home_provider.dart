import 'package:flutter/material.dart';
import 'package:videohub/screens/home/model/home_model.dart';
import 'package:videohub/utils/api_urls.dart';
import 'package:videohub/utils/get_service_utils.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  HomeDataModel? homeModel;
  List<HomeItem> homeItems = [];

  Future<void> fetchHomeData(BuildContext context) async {
    homeModel = null;
    homeItems.clear();
    setLoading(true);

    try {
      final jsonData = await GetServiceUtils.fetchData(
        ApiUrls.getHomeData(),
        context,
      );

      homeModel = homeDataModelFromJson(jsonData);
      homeItems = homeModel!.results ?? [];

      debugPrint("homeItems fetched successfully");
      debugPrint("Parsed JSON Data: $jsonData");
    } catch (e, stackTrace) {
      debugPrint('homeItems Data Error: $e');
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
