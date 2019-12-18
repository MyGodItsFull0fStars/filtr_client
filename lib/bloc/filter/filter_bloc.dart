import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filter_client/models/filter/filter.model.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:meta/meta.dart';
import '../bloc.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final FilterRepository filterRepository;

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
        final List<Filter> filters = filterRepository.getFilters();
        yield FiltersLoadedState(filters: filters);
      } catch (_) {
        yield FiltersErrorState();
      }
    }
  }
}
