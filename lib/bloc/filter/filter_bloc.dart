import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filter_client/models/filter/filter.model.dart';
import 'package:filter_client/models/filter/filter_settings.model.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:meta/meta.dart';
import '../bloc.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final FilterRepository filterRepository;
  bool filterSettingsVisible = false;
  int selectedFilterIndex = -1;
  List<Filter> filters = [];

  
  FilterBloc({@required this.filterRepository}) 
    : assert(filterRepository != null);

  @override
  FilterState get initialState => InitialFiltersState();

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
     if (event is FetchFilter) {
       
      yield FiltersLoadingState();
      try {
        String response = await filterRepository.fetchFilters();
        filters = await filterRepository.getFilters(response);

        /*FilterSetting fs1 = new FilterSettingCheckbox(1, "Checkbox 1", true);
        FilterSetting fs2 = new FilterSettingCheckbox(2, "Checkbox 2", false);
        FilterSetting fs3 = new FilterSettingCheckbox(1, "Checkbox 1", false);
        FilterSetting fs4 = new FilterSettingCheckbox(2, "Checkbox 2", true);
        FilterSetting fs7 = new FilterSettingSlider(1, "Slider", "", "", 0, 10, 1, 1);
        FilterSetting fs8 = new FilterSettingSlider(1, "Slider", "", "", 0, 10, 1, 1);

        Filter f1= new Filter("Testfilter","https://via.placeholder.com/150");
        f1.filterSettings.add(fs1);
        f1.filterSettings.add(fs2);
        f1.filterSettings.add(fs7);

        Filter f2 = new Filter("Testfilter","https://via.placeholder.com/150");
        f2.filterSettings.add(fs3);
        f2.filterSettings.add(fs4);
        f2.filterSettings.add(fs8);

        Filter f3 = new Filter("Testfilter","https://via.placeholder.com/150");
        //f3.filterSettings.add(fs5);
        //f3.filterSettings.add(fs6);
        
        filters.add(f1);
        filters.add(f2);
        filters.add(f3);

        print(filters.length);*/

        yield FiltersLoadedState(filters: filters, filterSettingsVisible: filterSettingsVisible, selectedFilterIndex: selectedFilterIndex,);
        if(state is FiltersLoadedState){

        }
      } catch (ex) {
        print(ex);
        yield FiltersErrorState();
      }
    }else if(event is SelectFilter){
      if(selectedFilterIndex == event.index || filterSettingsVisible == false) filterSettingsVisible = !filterSettingsVisible;
        selectedFilterIndex = event.index;        
        print("Ausgewählter Index: " + selectedFilterIndex.toString());
        yield FiltersLoadedState(filters: filters, filterSettingsVisible: filterSettingsVisible, selectedFilterIndex: selectedFilterIndex,);
    }else if(event is UpdateCheckbox || event is UpdateSlider){
        yield FiltersLoadingState();
        yield FiltersLoadedState(filters: filters, filterSettingsVisible: filterSettingsVisible, selectedFilterIndex: selectedFilterIndex,);
    }
  }
}
