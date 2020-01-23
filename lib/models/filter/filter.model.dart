import 'package:filter_client/models/filter/filter_settings.model.dart';

class Filter{
  String _id;
  String _name;
  String _imgURL = "";
  List<FilterSetting> _filterSettings = [];

  Filter(this._name, this._imgURL);

  String get id => _id;
  String get name => _name;
  String get imgUrl => _imgURL;
  List<FilterSetting> get filterSettings => _filterSettings;

  Filter.fromJson(Map<String, dynamic> parsedJson){
    _id = parsedJson['id'];
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
      case "CHECKBOX":
        fs = new FilterSettingCheckbox(
                  1, 
                  parsedJson["name"], 
                  parsedJson["checked"] == "true" ? true : false
                  );
        break;
      case "SLIDER":
        fs = new FilterSettingSlider(
          1,
          parsedJson['name'],
          parsedJson['minText'],
          parsedJson['maxText'],
          parsedJson['minValue'],
          parsedJson['maxValue'],
          parsedJson['steps'],
          parsedJson['actValue'],
        );
      break;
      default:
    }

    return fs;
  }

  String toJson(Filter filter){
    String json = "";
    json += '"filterID": "'+filter._id+'", ';
    json += '"filterSettings": [';

    for(FilterSetting fs in filter.filterSettings){
        json += fs.toJson(fs);
    }

    json += ']';
    return json;
  }
}
