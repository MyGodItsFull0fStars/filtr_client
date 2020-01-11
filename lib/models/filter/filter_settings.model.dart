/*
FilterSettingsJson
{
  id: ,
  name: ,
}

*/
import 'package:filter_client/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterSetting {
  final int id;
  String name;

  FilterSetting(this.id, this.name);

  static Widget buildFilterSettingWidget(FilterSetting fs, FilterBloc fb) {
    if (fs is FilterSettingSlider) {
      return Container();
    } else if (fs is FilterSettingCheckbox) {
      return CheckboxListTile(
        title: Text(fs.name),
        onChanged: (_) {
          fs.checked = !fs.checked;
          fb.add(UpdateCheckbox(fs: fs, checked: fs.checked));
        },
        value: fs.checked,
      );
    }
    return Container();
  }
}

class FilterSettingSlider extends FilterSetting {
  String minText;
  String maxText;

  double minValue;
  double maxValue;

  double steps;

  FilterSettingSlider(int id, String name, this.minText, this.maxText,
      this.minValue, this.maxValue, this.steps)
      : super(id, name);
}

class FilterSettingCheckbox extends FilterSetting {
  bool checked;

  FilterSettingCheckbox(int id, String name, this.checked) : super(id, name);

  build() {
    return Column(
      children: <Widget>[
        Text(name),
        Checkbox(
          value: checked,
        )
      ],
    );
  }
}

class FilterSettingTest extends FilterSetting {
  FilterSettingTest(int id, String name) : super(id, name);

  build() {
    return null;
  }
}
