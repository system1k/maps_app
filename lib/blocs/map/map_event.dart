part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitializedEvent(this.controller);
}

class OnStopFollowingUser extends MapEvent {}
class OnStartFollowingUser extends MapEvent {}

class UpdateUserPolylines extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylines(this.userLocations);
}

class OnToggleUserRoute extends MapEvent {}
