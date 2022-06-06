import 'package:flutter_application_1/api/model.dart';
import 'package:flutter_application_1/api/services.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxList<Welcome> response = <Welcome>[].obs;
  var isload = true.obs;
  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void fetch() async {
    try {
      isload(true);
      var normal = await services.fetchAlbum();
      response.assign(normal);
    } finally {
      isload(false);
    }
  }
}
