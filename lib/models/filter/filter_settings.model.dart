/*
FilterSettingsJson
{
  id: ,
  name: ,
}

*/
class FilterSetting{

  final int id;
  String name;

  FilterSetting(this.id, this.name);
}

class FilterSettingSlider extends FilterSetting{

  String minText;
  String maxText;

  double minValue;
  double maxValue;

  double steps;

  FilterSettingSlider(int id, String name, this.minText, this.maxText, this.minValue, this.maxValue, this.steps) : super(id, name);
}

class FilterSettingCheckbox extends FilterSetting{

  bool checked;

  FilterSettingCheckbox(int id, String name, this.checked) : super(id, name);
}

