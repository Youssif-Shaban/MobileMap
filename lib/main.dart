import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Map(),
    );
  }
}

class Map extends StatefulWidget {
  static double zoom = 12;
  static double location_lat = 0;
  static double location_long = 0;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 29.3084, longitude: 30.8428),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  bool trace = false;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  var MarkerMap = <String, String>{};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.listenerMapSingleTapping.addListener(() async {
        var position = controller.listenerMapSingleTapping.value;
        if (position != null) {
          await controller.addMarker(position,
              markerIcon: MarkerIcon(
                icon: Icon(
                  Icons.pin_drop_sharp,
                  color: Colors.teal,
                  size: 60,
                ),
              ));

          //adding marker to the map to holding information of marker incase to use it later.
          // to use later
          var key = '${position.latitude}_${position.longitude}';
          MarkerMap[key] = MarkerMap.length.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
            child: Text(
          'Map Location',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 540,
              height: 500,
              child: OSMFlutter(
                controller: controller,

                trackMyPosition: true,
                initZoom: 14,
                minZoomLevel: 4,
                maxZoomLevel: 16,
                stepZoom: 1.0,

                onGeoPointClicked: (geoPoint) {
                  var key = '${geoPoint.latitude}_${geoPoint.longitude}';
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('position ${MarkerMap[key]}'),
                                      Divider(),
                                      Text(key),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(Icons.clear),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },

                userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history,
                      size: 50,
                    ),
                  ),
                ),

                // directionArrowMarker: const MarkerIcon(
                //   icon: Icon(
                //     Icons.location_history,
                //     size: 50,
                //   ),
                // ),
                //),
                roadConfiguration: RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                markerOption: MarkerOption(
                    defaultMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 60,
                  ),
                )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await controller.zoomIn();
                    },
                    child: Container(
                      // decoration:
                      //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      width: 50,
                      height: 50,
                      color: Colors.teal,
                      child: Center(
                          child: Text(
                        "+",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await controller.zoomOut();
                    },
                    child: Container(
                      // decoration:
                      //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      width: 50,
                      height: 50,
                      color: Colors.teal,
                      child: Center(
                          child: Text(
                        "-",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              color: Colors.teal,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => location(),
                    ),
                  );
                },
                child: Text(
                  'Start tracking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
