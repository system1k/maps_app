import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1Ijoic3lzdGVtMWsiLCJhIjoiY2t4a28zbno0M2lrZzJub2MwZjA1NGlkZCJ9.jGpRrwafDT78kcq3y12xpw';
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.queryParameters.addAll({
      'access_token' : accessToken,
      'language'     : 'es',
      'limit'        : 7
    });     

    super.onRequest(options, handler);
  }

}