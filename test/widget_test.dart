<<<<<<< HEAD
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

      fsc.checked = false;
      await tester.pumpAndSettle();
      expect(tester.widget<CheckboxListTile>(cb).value, false);
      
      final nameFinder = find.text(fsc.name);
      expect(nameFinder, findsOneWidget);

    });
  });

  test('Test, if tests work', () {
    expect("", "");
  });
}
=======
void main(){
  
}
>>>>>>> d5b24bd72fcd7ac1825d37c4ed891b6d75e1a75d
