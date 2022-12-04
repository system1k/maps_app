import 'package:dio/dio.dart';

const accessToken = 'pk.eyJ1Ijoic3lzdGVtMWsiLCJhIjoiY2t4a28zbno0M2lrZzJub2MwZjA1NGlkZCJ9.jGpRrwafDT78kcq3y12xpw';

class TrafficInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'alternatives' : true,
      'geometries'   : 'polyline6',
      'overview'     : 'simplified',
      'steps'        : false,
      'access_token' : accessToken
    });

    super.onRequest(options, handler);
  }
  
}