import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:porto_explorer/screens/details_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  loc.LocationData? currentLocation;

  BitmapDescriptor currentLocationIcon =
  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);

  Future<loc.LocationData> getCurrentLocation() async {
    loc.Location location = loc.Location();

    loc.LocationData locationData = await location.getLocation();
    currentLocation = locationData;

    return locationData;
  }

  void updateLocation() async {
    loc.Location location = loc.Location();

    loc.LocationData initialLocation = await location.getLocation();
    currentLocation = initialLocation;

    GoogleMapController? controller;
    _controller.future.then((value) => controller = value);

    location.onLocationChanged.listen((newLoc) {
      if (mounted) {
        setState(() {
          currentLocation = newLoc;
        });

        controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(newLoc.latitude!, newLoc.longitude!),
              zoom: 16,
            ),
          ),
        );

        _setMarkers();
      }
    });
  }


    String getImage(Photo photoReference) {
    const baseUrl = "https://maps.googleapis.com/maps/place/photo";
    const  maxWidth = "400";
    const maxHeight = "200";

    final url =
        "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key='AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ'";

    return url;
  }

  @override
  void initState() {
    getCurrentLocation();
    updateLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Porto Explorer'),
      ),
      body: FutureBuilder(
        future: getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: GoogleMap(
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                  _setMarkers();
                },
                markers: _markers,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _goToPI(LatLng pos) async {
    GoogleMapController controller = await _controller.future;
    CameraPosition position = CameraPosition(
        bearing: 192.8334901395799,
        target: pos,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void _setMarkers() async {
    final places =
    GoogleMapsPlaces(apiKey: 'AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ');

    PlacesSearchResponse response = await places.searchNearbyWithRadius(
        Location(
            lat: currentLocation!.latitude!, lng: currentLocation!.longitude!),
        300,
        type: 'university');

    _markers.clear();

    for (var prediction in response.results) {
      final details = await places.getDetailsByPlaceId(prediction.placeId);

      LatLng pos = LatLng(details.result.geometry!.location.lat,
          details.result.geometry!.location.lng);

      if (details.result.photos.isEmpty) continue;

      final marker = Marker(
        markerId: MarkerId(details.result.placeId),
        position: pos,
        infoWindow: InfoWindow(
            title: details.result.name,
            snippet: details.result.formattedAddress,
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(details: details))),
              print("Clicked PI")
            }),
        onTap: () => _goToPI(pos),
      );

      _markers.add(marker);
    }

    _markers.add(Marker(
        markerId: const MarkerId("currentLocation"),
        icon: currentLocationIcon,
        position:
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        infoWindow: const InfoWindow(title: "You are here")));

    setState(() {});
  }
}