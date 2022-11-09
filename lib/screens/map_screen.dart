import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/views/views.dart';
import 'package:maps_app/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();

    locationBloc = BlocProvider.of<LocationBloc>(context);
    //locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context,locationState) {
            if (locationState.lastknownLocation == null) {
              return const Center(child: Text('Espere por favor...'));
            }

            return BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {

                Map<String, Polyline> polylines = Map.from(mapState.polylines);

                if(!mapState.showMyRoute) {
                  polylines.removeWhere((key, value) => key == 'myRoute');
                }

                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      MapView(
                        initialLocation: locationState.lastknownLocation!,
                        polylines: polylines.values.toSet()
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [

            BtnToggleUserRoute(),
            BtnFollowUser(), 
            BtnCurrentLocation()
            
          ],
        ));
  }
}
