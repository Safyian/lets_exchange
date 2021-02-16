import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class PickAddressFromMap extends StatefulWidget {
  @override
  _PickAddressFromMapState createState() => _PickAddressFromMapState();
}

class _PickAddressFromMapState extends State<PickAddressFromMap> {
  GoogleMapController _controller;
  Geolocator _geolocator;
  CameraPosition _initialPosition;
  Position currentloc;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Position currentLocation;
    if ((await _geolocator.isLocationServiceEnabled())) {
      currentLocation = await _geolocator.getCurrentPosition();
      currentloc = currentLocation;
    }

    if (currentLocation == null)
      _initialPosition = CameraPosition(target: LatLng(0, 0));
    else
      _initialPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15.0,
      );

    MarkerId id = MarkerId(DateTime.now().millisecondsSinceEpoch.toString());
    final Marker marker = Marker(
      markerId: id,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    if (mounted) {
      setState(() {
        markers.clear();
        markers[id] = marker;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.done),
        onPressed: _confirm,
      ),
      body: SafeArea(
        child: _initialPosition == null
            ? Container()
            : Stack(
                children: <Widget>[
                  GoogleMap(
                    onMapCreated: (controller) async {
                      _controller = controller;
                    },
                    markers: Set<Marker>.of(markers.values),
                    initialCameraPosition: _initialPosition,
                    onCameraMove: _onCameraMove,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: SearchMapPlaceWidget(
                            // apiKey: 'AIzaSyCZQPRFkLD9J8UuS-d2ieGkDdftW9mbX98',
                            apiKey: 'AIzaSyCbMziWDAkk09r_C1QmEAQ55cLjgXEc3tg',
                            language: 'en',
                            location: LatLng(
                                currentloc.latitude, currentloc.longitude),
                            radius: 20000,
                            strictBounds: true,
                            onSelected: (Place place) async {
                              final geolocation = await place.geolocation;
                              print(geolocation.coordinates);
                              print("---------------------------------------");
                              _controller.animateCamera(CameraUpdate.newLatLng(
                                  geolocation.coordinates));
                              _controller.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      geolocation.bounds, 0));
                            },
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: (IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: _getMyLocation,
                          )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _onCameraMove(position) {
    MarkerId id = MarkerId(DateTime.now().millisecondsSinceEpoch.toString());

    final Marker marker = Marker(
      markerId: id,
      position: position.target,
    );

    if (mounted)
      setState(() {
        markers.clear();
        markers[id] = marker;
      });
  }

  _getMyLocation() async {
    var position = await _geolocator.getCurrentPosition();

    await _controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        15));
  }

  _confirm() async {
    try {
      var point = markers.values.toList()[0].position;
      var places = await _geolocator.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (places.length == 0)
        Navigator.pop(context);
      else {
        // Address address = Address(
        //   building: null,
        //   city: null,
        //   country: null,
        //   state: null,
        //   street: null,
        //   zipCode: null,
        //   position: AddressLocation(
        //     latitude: places[0].position.latitude,
        //     longitude: places[0].position.longitude,
        //   ),
        // );
        List<double> addrss = [
          places[0].position.latitude,
          places[0].position.longitude
        ];

        Navigator.of(context).pop(addrss);
      }
    } catch (e) {
      // Toast.show('Error in getting address\nCheck ', context, duration: 3);
      print(e);
    }
  }
}
