import 'package:filter_client/models/filter/filter_settings.model.dart';

class Filter{
  String _name;
  String _imgURL = "";
  List<FilterSetting> _filterSettings = [];

  Filter(this._name, this._imgURL);

  String get name => _name;
  String get imgUrl => _imgURL;
  List<FilterSetting> get filterSettings => _filterSettings;

  Filter.fromJson(Map<String, dynamic> parsedJson){
    _name = parsedJson["name"];
    _imgURL = parsedJson["imgUrl"];
    List<FilterSetting> temp = [];
    for(int i = 0; i < parsedJson["filterSettings"].length; i++){
        FilterSetting filterSettings = parseFilterSettings(parsedJson["filterSettings"][i]);
        temp.add(filterSettings);
    }
    _filterSettings = temp;
  }

  FilterSetting parseFilterSettings(Map<String, dynamic> parsedJson){
    FilterSetting fs;

    //Type #1: FilterSettingCheckbox
    //Type #2: 
    switch (parsedJson["type"]) {
      case 1:
        fs = new FilterSettingCheckbox(
                  1, 
                  parsedJson["name"], 
                  parsedJson["checked"] == "true" ? true : false
                  );
        break;
      default:
    }

    return fs;
  }
}
