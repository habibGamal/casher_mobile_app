import 'package:casher_mobile_app/helpers/dd.dart';
import 'package:casher_mobile_app/tools/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ApiRequests {
  static final ApiRequests _instance = ApiRequests._internal();
  ApiRequests._internal();
  late BuildContext _context;
  factory ApiRequests.of(BuildContext context) {
    _instance._context = context;
    return _instance;
  }

  factory ApiRequests.setHost(String host) {
    _instance._qlAdabter.setHost = host;
    return _instance;
  }

  final _qlAdabter = _GraphQLAdapter.instance;

  GraphQLClient _client() {
    return _qlAdabter.of(_context);
  }

  Future<int?> testAuthentication() async {
    try {
      await _qlAdabter.refreshAuthorizationToken();
      final response = await _client().query(QueryOptions(document: gql("""
        query{
          me{
            id
          }
        }
      """)));
      dd("response => ${response.exception?.graphqlErrors.first.message}");
      return 401;
    } catch (e) {
      return 502;
    }
  }

  Future<dynamic> autoCompleteProductName(String productName) async {
    // try {
    //   final response = await _client().get(
    //     '/autocomplete-product-name',
    //     queryParameters: {'productName': productName},
    //   );
    //   return response.data;
    // } catch (e) {
    //   return null;
    // }
  }

  Future<dynamic> productInfoFromAllStocks(int productId) async {
    // try {
    //   final response = await _client().get(
    //     '/product-info-from-all-stocks/$productId',
    //   );
    //   dd(response.data);
    //   return response.data;
    // } catch (e) {
    //   return null;
    // }
  }

  Future<bool> login(FormData data) async {
    // try {
    //   final response = await _qlAdabter
    //       .of(_context)
    //       .post<String>('/sanctum/token', data: data);
    //   final token = response.data;
    //   await SecureStorage.instance.setAuthToken(token);
    //   _qlAdabter.refreshAuthorizationToken();
    //   return true;
    // } on DioException catch (e) {
    //   debugPrint(e.message);
    //   return false;
    // }
    return false;
  }
}

class _GraphQLAdapter {
  static final _GraphQLAdapter _instance = _GraphQLAdapter();
  static _GraphQLAdapter get instance => _instance;
  late GraphQLClient _qlClient;

  BuildContext? _context;
  GraphQLClient of(BuildContext? context) {
    _context = context;
    return _qlClient;
  }

  _GraphQLAdapter() {
    HttpLink httpLink = HttpLink("");
    AuthLink authLink = AuthLink(
      getToken: () async =>
          'Bearer ${await SecureStorage.instance.getAuthToken()}',
    );
    Link link = authLink.concat(httpLink);
    _qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }

  HttpLink httpLink = HttpLink("");
  AuthLink authLink = AuthLink(
    getToken: () async =>
        'Bearer ${await SecureStorage.instance.getAuthToken()}',
  );

  set setHost(String host) {
    httpLink = HttpLink("https://$host/graphql");
    authLink = AuthLink(
      getToken: () async =>
          'Bearer ${await SecureStorage.instance.getAuthToken()}',
    );
    Link link = authLink.concat(httpLink);
    _qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }

  refreshAuthorizationToken() async {
    authLink = AuthLink(
      getToken: () async =>
          'Bearer ${await SecureStorage.instance.getAuthToken()}',
    );
    Link link = authLink.concat(httpLink);
    _qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }
}










// class _DioAdapter {
//   static final _DioAdapter _instance = _DioAdapter();
//   static _DioAdapter get instance => _instance;
//   final Dio _dio = Dio();

//   BuildContext? _context;
//   Dio of(BuildContext? context) {
//     _context = context;
//     return _dio;
//   }

//   set setHost(String host) => _dio.options.baseUrl = "https://$host/api";

//   _DioAdapter() {
//     _dio.options.headers['accept'] = 'application/json';
//     _dio.interceptors.add(InterceptorsWrapper(
//       onError: (DioException e, ErrorInterceptorHandler handler) {
//         if (e.type == DioExceptionType.connectionError) {
//           ScaffoldMessenger.of(_context!).showSnackBar(
//             const SnackBar(
//               content: Text('Connection problem!'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//         if (e.type == DioExceptionType.unknown) {
//           ScaffoldMessenger.of(_context!).showSnackBar(
//             const SnackBar(
//               content: Text('Unknown error!'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//         if (e.type == DioExceptionType.badResponse &&
//             e.response?.statusCode == 502) {
//           ScaffoldMessenger.of(_context!).showSnackBar(
//             const SnackBar(
//               content: Text('Host propably goes down.'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//         return handler.next(e);
//       },
//     ));
//   }

//   Future<void> refreshAuthorizationToken() async {
//     final token = await SecureStorage.instance.getAuthToken();
//     if (token == null) return;
//     _dio.options.headers['Authorization'] = 'Bearer $token';
//   }
// }
