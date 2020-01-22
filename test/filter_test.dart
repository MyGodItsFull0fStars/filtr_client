import 'package:filter_client/models/filter/filter_settings.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterSettingsCheckobox', () {

    final int idx = 1;
    final String name = "TestCheckbox";
    final bool checked = false;

    FilterSettingCheckbox fsc = FilterSettingCheckbox(idx, name, checked);

    test('initialized correctly with index ' + idx.toString(), () {
      expect(fsc.id, idx);
    });
    test('initialized correctly with name ' + name, () {
      expect(fsc.name, name);
    });
    test('initialized correctly with bool ' + checked.toString(), () {
      expect(fsc.checked, checked);
    });

  });

  group('FilterSettingsSlider', () {

    final int idx = 1;
    final String name = "TestSlider";
    final String minText = "";
    final String maxText = "";
    final double minValue = 1;
    final double maxValue = 10;
    final double steps = 10;
    final double actValue = 5;

    FilterSettingSlider fss = FilterSettingSlider(idx, name, minText, maxText, minValue, maxValue, steps, actValue);

    test('initialized correctly with index ' + idx.toString(), () {
      expect(fss.id, idx);
    });
    test('initialized correctly with name ' + name, () {
      expect(fss.name, name);
    });
    test('initialized correctly with minText ' + minText, () {
      expect(fss.minText, minText);
    });
    test('initialized correctly with maxText ' + maxText, () {
      expect(fss.maxText, maxText);
    });
    

  });
}
