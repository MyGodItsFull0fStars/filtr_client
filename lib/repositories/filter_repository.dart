import 'dart:convert';

import 'package:filter_client/models/filter/filter.model.dart';
import 'package:http/http.dart';

class FilterRepository {

  FilterRepository();

  Future<String> fetchFilters() async {
    String url = 'http://www.leustik.com/filter/json.txt';
    
        Response response = await get(url);
        int statusCode = response.statusCode;
        String json = response.body;
      if (statusCode == 200) {
        return json;
      } else if (statusCode == 202) {
        // still not finished
      } else {
        //Throw Error?
      }    
    return null;
  }

  Future<List<Filter>> getFilters(String response) async {

    List<Filter> filters = new List<Filter>();
    List<dynamic> json = jsonDecode(response);

    for(dynamic d in json){
      filters.add(Filter.fromJson(d));
    }

    return filters;
  }
}