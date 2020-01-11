import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:filter_client/models/filter/filter_settings.model.dart';

@immutable
abstract class FilterEvent extends Equatable {
  const FilterEvent();
  
}

class FetchFilter extends FilterEvent{
  const FetchFilter();

  @override
  List<Object> get props => [];
}

class GetFilter extends FilterEvent{
  const GetFilter();

  @override
  List<Object> get props => [];
}

class SelectFilter extends FilterEvent{
  final int index;

  const SelectFilter({this.index});

  @override
  List<Object> get props => [];
}

class UpdateCheckbox extends FilterEvent{
  final bool checked;
  final FilterSettingCheckbox fs;

  const UpdateCheckbox({this.fs, this.checked});

  @override
  List<Object> get props => [];
}
