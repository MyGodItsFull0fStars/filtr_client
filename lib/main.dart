import 'package:filter_client/bloc/bloc.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import './models/filter/filter_settings.model.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final FilterRepository filterRepository = FilterRepository();

  runApp(FilterApp(filterRepository: filterRepository));
}

class FilterApp extends StatelessWidget {
  final FilterRepository filterRepository;

  FilterApp({Key key, @required this.filterRepository})
      : assert(filterRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather',
      home: BlocProvider(
        create: (context) => FilterBloc(filterRepository: filterRepository),
        child: FilterView(),
      ),
    );
  }
}

class FilterCard extends StatefulWidget {
  @override
  _FilterCardState createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  bool touched = false;

  Widget build(BuildContext context) {
    return Column(children: [
      Card(
          child: GestureDetector(
              child: Container(
                child: Text("Test"),
                height: 150,
                width: 150,
              ),
              onTap: () => {tapCard()})),
      Container(
        child: Text("Test"),
      )
    ]);
  }

  void tapCard() {
    setState(() {
      !touched ? touched = true : touched = false;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(this.touched ? "Erscheinen" : "Verschwinden"),
      duration: new Duration(milliseconds: 300),
    ));
  }
}

class FilterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Filtr'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.amber,
              ),
            ),
            Container(
                child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    color: Colors.black26,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Filter",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )),
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    if (state is InitialFiltersState) {
                      return RaisedButton(onPressed: () async {
                        BlocProvider.of<FilterBloc>(context).add(FetchFilter());
                      });
                    } else if (state is FiltersLoadingState) {
                      return Padding(
                          padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                          child: Column(children: <Widget>[
                            Text("Filter werden geladen"),
                            Loading(
                                indicator: BallPulseIndicator(),
                                size: 20.0,
                                color: Colors.grey)
                          ]));
                    } else if (state is FiltersLoadedState) {
                      return Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              state.filters.length > 0 ? 
                              SizedBox(
                                  height: 184,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.filters.length,
                                    itemBuilder: (context, index) {
                                      final filter = state.filters[index];
                                      return Column(children: <Widget>[
                                        Card(
                                            child: GestureDetector(
                                                child: Container(
                                                  child: Image.network(
                                                      filter.imgUrl),
                                                  height: 150,
                                                  width: 150,
                                                ),
                                                onTap: () => {
                                                      BlocProvider.of<
                                                                  FilterBloc>(
                                                              context)
                                                          .add(SelectFilter(
                                                              index: index))
                                                    })),
                                        Container(
                                          height: 20,
                                          child: Text(filter.name),
                                        )
                                      ]);
                                    },
                                  ) 
                                  ) : Text("Keine Filter vorhanden!"),
                              BlocProvider.of<FilterBloc>(context)
                                          .filterSettingsVisible ==
                                      true
                                  ? Column(
                                      children: <Widget>[
                                        state.filters[state.selectedFilterIndex]
                                                    .filterSettings.length >
                                                0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: state.filters[state.selectedFilterIndex].filterSettings.length,
                                                itemBuilder: (context, index) {
                                                  final filterSetting = state.filters[state.selectedFilterIndex].filterSettings[index];
                                                  return Card(                                                    
                                                    child: FilterSetting.buildFilterSettingWidget(filterSetting, BlocProvider.of<FilterBloc>(context))
                                                  );
                                                })
                                            : Text("Keine Filtersettings vorhanden!"),
                                      ],
                                    )
                                  : Container()
                            ],
                          ));
                    } else {
                      return Padding(
                          padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                          child: Column(children: <Widget>[
                            Text("Fehler beim Laden der Filter!"),
                            RaisedButton(
                                child: Text("Erneut versuchen"),
                                onPressed: () async {
                                  BlocProvider.of<FilterBloc>(context)
                                      .add(FetchFilter());
                                })
                          ]));
                    }
                  },
                ),
              ],
            )),
          ],
        )),
      ),
    );
  }
}
/*
Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < strings.length; i++){
        list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }
*/
