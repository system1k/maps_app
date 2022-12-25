part of 'search_bloc.dart';

class SearchState extends Equatable {

  final bool displayManuelMarker;
  final List<Feature> places;
  final List<Feature> history;

  const SearchState({
    this.displayManuelMarker = false,
    this.places = const [],
    this.history = const []
  });

  SearchState copyWith({
    bool? displayManuelMarker,
    List<Feature>? places,
    List<Feature>? history
  }) => SearchState(
    displayManuelMarker: displayManuelMarker ?? this.displayManuelMarker,
    places: places ?? this.places,
    history: history ?? this.history
  );
  
  @override
  List<Object> get props => [displayManuelMarker, places, history];
}
