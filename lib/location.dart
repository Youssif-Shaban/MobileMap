import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class location extends StatefulWidget {
  @override
  State<location> createState() => _locationState();
}

class _locationState extends State<location> {
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  var MarkerMap = <String, String>{};

  @override
  void initState() {
    super.initState();

    void Tracking() async {
      var position = controller.currentLocation();
      if (position != null) {
        await controller.addMarker(position as GeoPoint,
            markerIcon: MarkerIcon(
              icon: Icon(
                Icons.pin_drop_sharp,
                color: Colors.teal,
                size: 60,
              ),
            ));

        //adding marker to the map to holding information of marker incase to use it later.
        // to use later
        //var key = '${position!.latitude}_${position!.longitude}';
        //MarkerMap[key] = MarkerMap.length.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var widget;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Map Location tracking"),
      ),
      body: OSMFlutter(
        controller: controller,
        trackMyPosition: true,
        initZoom: 16,
        minZoomLevel: 2,
        maxZoomLevel: 18,
        stepZoom: 1.0,
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 48,
            ),
          ),
          directionArrowMarker: MarkerIcon(
            icon: Icon(
              Icons.location_history,
              size: 50,
            ),
          ),
        ),
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
    );
  }
}
