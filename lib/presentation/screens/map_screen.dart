import 'dart:async';

import 'package:authphone/busniss_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:authphone/constant/my_colors.dart';
import 'package:authphone/helper/location_helper.dart';
import 'package:authphone/presentation/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  initState() {
    super.initState();
    getMyCurrentLocation();
  }

  FloatingSearchBarController _controller = FloatingSearchBarController();
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  static Position? position;
  Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _myCurrentLocation = CameraPosition(
      bearing: 0.0,
      target: LatLng(position!.latitude, position!.longitude),
      tilt: 0.0,
      zoom: 17);
  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
    // position = await Geolocator.getLastKnownPosition().whenComplete(() {
    //   setState(() {});
    // });
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: _myCurrentLocation,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_myCurrentLocation));
  }

  Widget buildFloatingSearchBar() {
    final bool isPorterat =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: _controller,
      elevation: 6,
      hint: 'Find a place..',
      hintStyle: TextStyle(
        color: Colors.blue[200],
        fontSize: 18,
      ),
      queryStyle: TextStyle(
        color: Colors.blue[200],
        fontSize: 18,
      ),
      border: BorderSide(style: BorderStyle.none),
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(seconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPorterat ? 0.0 : -1.0,
      openAxisAlignment: 0,
      width: isPorterat ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {},
      onFocusChanged: (isfocus) {},
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            onPressed: () {},
            icon: Icon(
              Icons.place,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        )
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : Center(
                  child: CircularProgressIndicator(
                    color: MyColors.blue,
                  ),
                ),
          buildFloatingSearchBar(),
        ],
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: _goToMyLocation,
          backgroundColor: MyColors.blue,
          child: Icon(
            Icons.place,
            color: Colors.white,
          ),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
      ),
    );
  }
}
