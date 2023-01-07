import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationStateSubcription;
  LatLng? mapCenter;

  MapBloc({
    required this.locationBloc
  }) : super(const MapState()) {

    on<OnMapInitializedEvent>( _onInitMap );
    on<OnStartFollowingUser>( _onStartFollowingUser );
    on<OnStopFollowingUser>((event, emit) => emit( state.copyWith(isFollowingUser: false) ));
    on<UpdateUserPolylines>( _onPolylineNewPoint );
    on<OnToggleUserRoute>((event, emit) => emit( state.copyWith(showMyRoute: !state.showMyRoute) ));
    
    on<DisplayPolylinesEvent>((event, emit) => emit( state.copyWith(
      polylines: event.polylines, 
      markers: event.markers
    ) ));

    locationStateSubcription = locationBloc.stream.listen((locationState) {

      if(locationState.lastknownLocation != null) {
        add(UpdateUserPolylines(locationState.myLocationHistory));
      }

      if(!state.isFollowingUser) return;
      if(locationState.lastknownLocation == null) return;

      moveCamera(locationState.lastknownLocation!);
    });

  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(OnStartFollowingUser event, Emitter<MapState> emit) {
    state.copyWith(isFollowingUser: true);
    if(locationBloc.state.lastknownLocation == null) return;
    moveCamera(locationBloc.state.lastknownLocation!);
  }

  void _onPolylineNewPoint(UpdateUserPolylines event, Emitter<MapState> emit) {

    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {

    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    final startMarkerIcon = await getAssetImageMarker();

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: startMarkerIcon,
      infoWindow: InfoWindow(
        title: 'Inicio',
        snippet: 'Kms: $kms Distancia: $tripDuration'
      )
    );

    final endMarkerIcon = await getNetworkImageMarker();

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMarkerIcon,
      infoWindow: InfoWindow(
        title: destination.endPlace.text,
        snippet: destination.endPlace.placeName
      )
    );

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add( DisplayPolylinesEvent(currentPolylines, currentMarkers) );

    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId('start'));

  } 

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubcription?.cancel();
    return super.close();
  }

}
