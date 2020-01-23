import 'package:camera/camera.dart';
import 'package:filter_client/bloc/bloc.dart';
import 'package:filter_client/repositories/filter_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'models/filter/filter.model.dart';
import 'repositories/image_repository.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

Future<void> main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final FilterRepository filterRepository = FilterRepository();
  final ImageRepository imageRepository = ImageRepository();

  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(FilterApp(
    filterRepository: filterRepository,
    imageRepository: imageRepository,
    camera: firstCamera,
  ));
}

class FilterApp extends StatelessWidget {
  final FilterRepository filterRepository;
  final ImageRepository imageRepository;
  final CameraDescription camera;

  FilterApp(
      {Key key,
      @required this.filterRepository,
      @required this.imageRepository,
      @required this.camera})
      : assert(filterRepository != null),
        assert(imageRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Weather',
        home: MultiBlocProvider(
          providers: [
            BlocProvider<FilterBloc>(
              create: (BuildContext context) =>
                  FilterBloc(filterRepository: filterRepository),
            ),
            BlocProvider<ImageBloc>(
              create: (BuildContext context) =>
                  ImageBloc(imageRepository: imageRepository),
            ),
          ],
          child: FilterView(),
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
            child: Stack(
          children: <Widget>[
            Container(
                child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              BlocBuilder<ImageBloc, ImageState>(builder: (context, state) {
                if (state is InitialImageState) {
                  return Text("Choose an Image");
                } else if (state is ImageLoadingState) {
                  return Text("Image loading");
                } else if (state is ImageLoadedState) {
                  return Center(
                    child: state.image == null
                        ? Text("No Image")
                        : SizedBox(
                            height: 300,
                            child: Image(image: FileImage(state.image))),
                  );
                } else if (state is CameraStartState) {
                  return Text("Camera Loading");
                } else if (state is CameraShowState) {
                  return Container(
                      height: 300,
                      child: AspectRatio(
                        aspectRatio: state.controller.value.aspectRatio,
                        child: CameraPreview(state.controller),
                      ));
                } else if (state is ImageUploadState) {
                  return Text("Uploading Image");
                } else if (state is ImageProcessingState) {
                  return Text("Image is Processing on server");
                } else {
                  return Text("No Image");
                }
              }),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                      if (state is CameraShowState) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: FloatingActionButton(
                            child: Icon(Icons.camera),
                            onPressed: () {
                              BlocProvider.of<ImageBloc>(context)
                                  .add(TakePhoto());
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              BlocProvider.of<ImageBloc>(context)
                                  .add(OpenCamera());
                            },
                          ),
                        );
                      }
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.folder_open),
                        onPressed: () {
                          BlocProvider.of<ImageBloc>(context).add(LoadImage());
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.file_upload),
                        onPressed: () {
                          int chosen = BlocProvider.of<FilterBloc>(context).selectedFilterIndex;
                          Filter filter = BlocProvider.of<FilterBloc>(context).filters[chosen];
                          BlocProvider.of<ImageBloc>(context).add(SendImage(filter));
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
              )
            ])),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
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
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                    Container(
                      color: Colors.white,
                      child: BlocBuilder<FilterBloc, FilterState>(
                        builder: (context, state) {
                          if (state is InitialFiltersState) {
                            BlocProvider.of<FilterBloc>(context)
                                  .add(FetchFilter());
                            return Container();
                          } else if (state is FiltersLoadingState) {
                            return Padding(
                                padding:
                                    EdgeInsets.only(top: 40.0, bottom: 40.0),
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
                                    state.filters.length > 0
                                        ? Container(
                                            height: 184,
                                            color: Colors.white,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: state.filters.length,
                                              itemBuilder: (context, index) {
                                                final filter =
                                                    state.filters[index];
                                                return Column(
                                                    children: <Widget>[
                                                      Card(
                                                          child:
                                                              GestureDetector(
                                                                  child: 
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          image: DecorationImage(image: NetworkImage(filter.imgUrl),
                                                                          fit: BoxFit.cover),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                        ),                                                                    
                                                                    height: 150,
                                                                    width: 150,
                                                                    
                                                                  ),
                                                                  onTap: () {
                                                                    BlocProvider.of<FilterBloc>(
                                                                            context)
                                                                        .add(SelectFilter(
                                                                            index:
                                                                                index));
                                                                  })),
                                                      Container(
                                                        height: 20,
                                                        child:
                                                            Text(filter.name),
                                                      )
                                                    ]);
                                              },
                                            ))
                                        : Text("Keine Filter vorhanden!"),
                                    BlocProvider.of<FilterBloc>(context)
                                                .filterSettingsVisible ==
                                            true
                                        ? Column(
                                            children: <Widget>[
                                              state
                                                          .filters[state
                                                              .selectedFilterIndex]
                                                          .filterSettings
                                                          .length >
                                                      0
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: state
                                                          .filters[state
                                                              .selectedFilterIndex]
                                                          .filterSettings
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final filterSetting = state
                                                            .filters[state
                                                                .selectedFilterIndex]
                                                            .filterSettings[index];
                                                        return Card(
                                                            child: filterSetting.build(
                                                                BlocProvider.of<
                                                                        FilterBloc>(
                                                                    context),
                                                                context));
                                                      })
                                                  : Text(
                                                      "Keine Filtersettings vorhanden!"),
                                            ],
                                          )
                                        : Container()
                                  ],
                                ));
                          } else {
                            return Padding(
                                padding:
                                    EdgeInsets.only(top: 40.0, bottom: 40.0),
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
                    )
                  ],
                )),
          ],
        )),
      ),
    );
  }
}
