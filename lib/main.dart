import 'package:filter_client/bloc/bloc.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        create: (context) =>
            FilterBloc(filterRepository: filterRepository),
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
    return Column(
      children:[
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
      ]
    );
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


class FilterView extends StatelessWidget{
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
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state){
                    if(state is InitialFiltersState){
                      return RaisedButton(
                        onPressed: () async{ 
                          BlocProvider.of<FilterBloc>(context).add(FetchFilter());
                          });
                    }else {
                      return Text("else");
                    }
                  },
                ),
                Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.black26,
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: <Widget>[
                                FilterCard(),
                                FilterCard(),
                                FilterCard(),
                                FilterCard(),
                                FilterCard(),
                              ],
                            ))))
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