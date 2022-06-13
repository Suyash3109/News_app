import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/model.dart';
import 'package:flutter_application_1/api/services.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  DateTimeRange? _selectedDateRange;

  RxList<Welcome> response = <Welcome>[].obs;
  var isload = true.obs;
  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void fetch() async {
    try {
      var now = DateTime.now();
      var formatter = DateFormat('dd-mm-yyyy');
      String formattedDate = formatter.format(now);
      print(formattedDate);
      isload(true);
      var normal = await services.fetchAlbum(formattedDate, formattedDate);
      response.assign(normal);
    } finally {
      isload(false);
    }
  }

  Future<void> show(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
        context: context,
        // initialDateRange: DateTimeRange(,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (result != null && result != showDateRangePicker) {
      _selectedDateRange = result;
      var start = result.start;
      var formatter = DateFormat('dd-mm-yyyy');
      String startformattedDate = formatter.format(start);
      var end = result.end;
      var formattert = DateFormat('dd-mm-yyyy');
      String endformattedDate = formattert.format(end);
      try {
        isload(true);
        var normal =
            await services.fetchAlbum(startformattedDate, endformattedDate);
        response.assign(normal);
      } finally {
        isload(false);
      }
    }

    print("_showFtfuv uunction Executed");
  }
}
