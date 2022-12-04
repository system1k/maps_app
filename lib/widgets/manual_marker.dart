import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManuelMarker
          ? const _ManualMarkerBody()
          : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [

          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack()
          ),

          Center(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                from: 100,
                child: const Icon(Icons.location_on_rounded, size: 60)
              ),
            ),
          ),

          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                minWidth: size.width - 120,
                elevation: 0,
                height: 50,
                color: Colors.black,
                shape: const StadiumBorder(),
                child: const Text('Confirmar destino', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                onPressed: () async {

                  final start = locationBloc.state.lastknownLocation;
                  if(start == null) return;

                  final end = mapBloc.mapCenter;
                  if(end == null) return;

                  showLoadingMessage(context);

                  final destination = await searchBloc.getCoorsStartToEnd(start, end);
                  await mapBloc.drawRoutePolyline(destination);

                  searchBloc.add(OnDeactivateManualMarkerEvent());

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  
                }
              ),
            )
          )

        ],
      )
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => BlocProvider.of<SearchBloc>(context).add( OnDeactivateManualMarkerEvent() )
        )
      ),
    );
  }
}