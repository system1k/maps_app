import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return !state.isGpsEnabled
            ? const _EnableGpsMesage()
            : const _AccessButton();
        }
      )
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text('Es necesario el acceso al GPS'),

          MaterialButton(
            color: Colors.black,
            splashColor: Colors.transparent,
            elevation: 0,
            shape: const StadiumBorder(),
            child: const Text('Solicitar acceso', style: TextStyle(color: Colors.white)),
            onPressed: (){
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
            }
          )

        ],
      ),
    );
  }
}

class _EnableGpsMesage extends StatelessWidget {
  const _EnableGpsMesage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Debe habilitar el GPS',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)
      ),
    );
  }
}