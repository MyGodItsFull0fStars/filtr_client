import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilterEvent extends Equatable {
  const FilterEvent();
}

class FetchFilter extends FilterEvent{
  const FetchFilter();

  @override
  List<Object> get props => [];
}

