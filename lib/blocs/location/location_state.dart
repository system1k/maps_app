part of 'location_bloc.dart';

class LocationState extends Equatable {

  final bool followingUser;
  final LatLng? lastknownLocation;
  final List<LatLng> myLocationHistory;

  const LocationState({
    this.followingUser = false,
    this.lastknownLocation,
    myLocationHistory
  }) : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastknownLocation,
    List<LatLng>? myLocationHistory
  }) => LocationState(
    followingUser    : followingUser ?? this.followingUser,
    lastknownLocation: lastknownLocation ?? this.lastknownLocation,
    myLocationHistory: myLocationHistory ?? this.myLocationHistory
  );
  
  @override
  List<Object?> get props => [followingUser, lastknownLocation, myLocationHistory];
}
