import 'package:filter_client/bloc/bloc.dart';
import 'package:filter_client/models/filter/filter_settings.model.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('[FilterSetting]', () {
    testWidgets('Checkbox', (WidgetTester tester) async {
      FilterRepository fr = new FilterRepository();
      FilterSettingCheckbox fsc = new FilterSettingCheckbox(1, "Checkbox", true);
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: FilterSettingCheckboxWidget(
                  filterSetting: fsc,
                  filterBloc: new FilterBloc(filterRepository: fr)))));

      expect(find.byType(CheckboxListTile), findsOneWidget);
      Finder cb = find.byType(CheckboxListTile);
      expect(tester.widget<CheckboxListTile>(cb).value, true);
      
      final nameFinder = find.text(fsc.name);
      expect(nameFinder, findsOneWidget);

    });

    testWidgets('Slider', (WidgetTester tester) async {
      FilterRepository fr = new FilterRepository();
      FilterSettingSlider fss = new FilterSettingSlider(1, "Slider", "", "", 0, 10, 5, 2);
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: FilterSettingSliderWidget(
                  filterSetting: fss,
                  filterBloc: new FilterBloc(filterRepository: fr)))));

      expect(find.byType(Slider), findsOneWidget);
      Finder slider = find.byType(Slider);
      expect(tester.widget<Slider>(slider).value, 2);
      
      final nameFinder = find.text(fss.name);
      expect(nameFinder, findsOneWidget);

    });
  });
}