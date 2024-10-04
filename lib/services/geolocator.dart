import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class Geolocator{

  static final GeolocatorPlatform _geolocatorPlatform=GeolocatorPlatform.instance;

  static Map<String,dynamic> posicion={
    'latitud': '0.0',
    'longitud': '0.0',
    'altitud': '0.0',
    'isMocked': false
  };

  ActualizarPosicion() async {
   await _determinePosition();
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
   
      return;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
      
      }
      return;
    }
    //await Geolocator.getLastKnownPosition();
    //await Geolocator.getLocationAccuracy();
    Position position = await _geolocatorPlatform.getCurrentPosition();
    posicion['latitud']=position.latitude.toString();
    posicion['longitud']=position.longitude.toString();
    posicion['altitud']=position.altitude.toString();
    posicion['isMocked']=position.isMocked.toString();

  }

}