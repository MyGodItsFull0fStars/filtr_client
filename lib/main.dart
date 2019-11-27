
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
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                    children: <Widget>[
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),
                      FilterCard(),                    
                    ],
                  )
                )
              )
                  ],
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}

class FilterCard extends StatelessWidget{

Widget build(BuildContext context){
  return Card(
    child: GestureDetector(
      child: Container(
      child: Text("Card 3"),
        height: 150,
        width: 150,
      ),
      onTap: () => {
Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Card touched"),
    ))
      },
    )
  );
  }
}