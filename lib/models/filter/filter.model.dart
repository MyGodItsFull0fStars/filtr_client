import 'dart:convert';

import 'package:filter_client/models/filter/filter_settings.model.dart';

class Filter{
  String name;
  String imgURL = "";
  List filterSettings = new List<FilterSetting>();

  Filter(this.name, this.imgURL);

  /*Filter.fromJson(Map<String, dynamic> json) : name = json['name'], imgURL = json['imgURL'];

  Filter getFilterFromJson(String json){
    Map filterMap = jsonDecode(json);
    return Filter.fromJson(filterMap);
  }
  
  Code:
  Map filterMap = jsonDecode(jsonString);
  var filter = Filter.fromJson(filterMap);
  */

}