import 'package:filter_client/bloc/bloc.dart';
import 'package:flutter/material.dart';

abstract class FilterSetting{
  final int id = 0;
  final String name = "";

  Widget build(FilterBloc filterBloc, BuildContext context);
}

//########## 
//# SLIDER #
//##########

class FilterSettingSlider implements FilterSetting {

  int id;
  String name; 

  String minText;
  String maxText;

  double minValue;
  double maxValue;

  double actValue;

  double steps;

  FilterSettingSlider(this.id, this.name, this.minText, this.maxText,
      this.minValue, this.maxValue, this.steps, this.actValue);

  Widget build(FilterBloc filterBloc, BuildContext context){
    return new FilterSettingSliderWidget(this, filterBloc).build(context);
  }
}

class FilterSettingSliderWidget extends StatelessWidget{

  final FilterSettingSlider filterSetting;
  final FilterBloc filterBloc;

  const FilterSettingSliderWidget(this.filterSetting, this.filterBloc);

  @override
  Widget build(BuildContext context, ) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Padding(
        padding: EdgeInsets.only(left: 15, right: 25, top: 10,),
        child: Row(
        children: <Widget>[
          Text(
            filterSetting.name,
            style: TextStyle(
              fontSize: 16
            ),
          ),
          Expanded(
            child: Row(),
          ),
          Text("Aktueller Wert: " + filterSetting.actValue.round().toString())
        ],
      )),
      Slider(
        min: filterSetting.minValue,
        max: filterSetting.maxValue,
        onChanged: (newValue) {
            filterSetting.actValue = newValue;
        },
        onChangeEnd: (newValue) {
          filterBloc.add(UpdateSlider(fs: filterSetting, actValue: newValue));
        },
        value: filterSetting.actValue
      ),
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 10,),
        child: Row(
        children: <Widget>[
          Text(filterSetting.minValue.round().toString()),
          Expanded(
            child: Row(),
          ),
          Text(filterSetting.maxValue.round().toString())
        ],
      ))],);
  }  
}


//############ 
//# CHECKBOX #
//############

class FilterSettingCheckbox implements FilterSetting {
  
  int id;
  String name; 
  bool checked;

  FilterSettingCheckbox(this.id, this.name, this.checked);  

  Widget build(FilterBloc filterBloc, BuildContext context){
    return new FilterSettingCheckboxWidget(filterSetting: this, filterBloc: filterBloc,).build(context);
  }
}

class FilterSettingCheckboxWidget extends StatelessWidget{

  final FilterSettingCheckbox filterSetting;
  final FilterBloc filterBloc;

  const FilterSettingCheckboxWidget({this.filterSetting, this.filterBloc});

  @override
  Widget build(BuildContext context, ) {
    return CheckboxListTile(
        title: Text(filterSetting.name),
        
        onChanged: (_) {
          filterSetting.checked = !filterSetting.checked;
          filterBloc.add(UpdateCheckbox(fs: filterSetting, checked: filterSetting.checked));
        },
        value: filterSetting.checked,
      );
  }  
}


