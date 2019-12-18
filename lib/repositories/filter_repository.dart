import 'package:filter_client/models/filter/filter.model.dart';

class FilterRepository {

  FilterRepository();

  List<Filter> getFilters() {
    List<Filter> f = new List<Filter>();
    f.add(new Filter.fromJson(new Map()));
    return f;
  }
}