import 'dart:convert';

class Filter{
  String name;
  String imgURL = "";
  List filterSettings = new List<Object>();

  Filter(this.name, this.imgURL);

  Filter.json(String json){

  }

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