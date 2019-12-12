import 'package:filter_client/models/filter/filter.model.dart';
import 'package:filter_client/models/filter/filter_settings.model.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
                  height: 20,
                  width: double.infinity,
                  color: Colors.black26,
                  child: Text(
                    "filter",
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
