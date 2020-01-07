import 'package:equatable/equatable.dart';
import 'package:filter_client/models/filter/filter.model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}
  
class InitialFiltersState extends FilterState {}

class FiltersLoadingState extends FilterState {}

class FiltersLoadedState extends FilterState {
  final List<Filter> filters;

  const FiltersLoadedState({@required this.filters}) 
    : assert(true);

  @override
  List<Object> get props => [filters];
}

class FiltersErrorState extends FilterState {}