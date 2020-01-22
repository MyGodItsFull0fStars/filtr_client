/*
FilterSettingsJson
{
  id: ,
  name: ,
}

*/
import 'package:filter_client/bloc/bloc.dart';
import 'package:flutter/material.dart';

class FilterSetting {
  final int id;
  String name;

  FilterSetting(this.id, this.name);

  static Widget buildFilterSettingWidget(FilterSetting fs, FilterBloc fb) {
    if (fs is FilterSettingSlider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Padding(
        padding: EdgeInsets.only(left: 15, right: 25, top: 10,),
        child: Row(
        children: <Widget>[
          Text(
            fs.name,
            style: TextStyle(
              fontSize: 16
            ),
          ),
          Expanded(
            child: Row(),
          ),
          Text("Aktueller Wert: " + fs.actValue.round().toString())
        ],
      )),
      Slider(
        min: fs.minValue,
        max: fs.maxValue,
        onChanged: (newValue) {
            fs.actValue = newValue;
        },
        onChangeEnd: (newValue) {
          fb.add(UpdateSlider(fs: fs, actValue: newValue));
        },
        value: fs.actValue
      ),
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 10,),
        child: Row(
        children: <Widget>[
          Text(fs.minValue.round().toString()),
          Expanded(
            child: Row(),
          ),
          Text(fs.maxValue.round().toString())
        ],
      ))],);
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

  double actValue;

  double steps;

  FilterSettingSlider(int id, String name, this.minText, this.maxText,
      this.minValue, this.maxValue, this.steps, this.actValue)
      : super(id, name);
}

class FilterSettingCheckbox extends FilterSetting {
  bool checked;

  FilterSettingCheckbox(int id, String name, this.checked) : super(id, name);
}
