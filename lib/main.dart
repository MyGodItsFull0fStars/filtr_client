import 'package:camera/camera.dart';
import 'package:filter_client/bloc/bloc.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'repositories/image_repository.dart';

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
  final ImageRepository imageRepository;
  final CameraDescription camera;

  FilterApp({Key key, @required this.filterRepository, @required this.imageRepository, @required this.camera})
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
            Container(
              
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        //do something
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FloatingActionButton(
                      child: Icon(Icons.folder_open),
                      onPressed: () {
                        //do something
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FloatingActionButton(
                      child: Icon(Icons.file_upload),
                      onPressed: () {
                        //do something
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FloatingActionButton(
                      child: Icon(Icons.save_alt),
                      onPressed: () {
                        //do something
                      },
                    ),
                  ),
                ],
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
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    children: <Widget>[
                                      /*FilterCard(),
                                      FilterCard(),
                                      FilterCard(),
                                      FilterCard(),
                                      FilterCard(),*/
                                      //BlocProvider.of<FilterBloc>(context).add(GetFilter());
                                    ],
                                  )),
                                  BlocProvider.of<FilterBloc>(context).filterSettingsVisible == true ? Text("Visible") : Text("Invisible")
                                  ])));
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

*/
class ImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
