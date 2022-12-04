part of 'search_bloc.dart';

class SearchState extends Equatable {

  final bool displayManuelMarker;

  const SearchState({
    this.displayManuelMarker = false
  });

  SearchState copyWith({
    bool? displayManuelMarker
  }) => SearchState(
    displayManuelMarker: displayManuelMarker ?? this.displayManuelMarker
  );
  
  @override
  List<Object> get props => [displayManuelMarker];
}
