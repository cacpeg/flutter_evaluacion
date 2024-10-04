import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'device_info.dart';
import 'geolocator.dart';
import 'package:evaluacion/enviroment.dart';
import 'package:evaluacion/services/crypto.dart' as crypto;

class httpInterseptor {
  static String? _ipPublic;
  static String? _codigoPais;
  get ipPublic async {
    return _ipPublic ?? await getPublicIP();
  }

  get codigoPais async {
    return _codigoPais ?? await getPublicIP();
  }

  Future<String?> getPublicIP() async {
    try {
      Uri uri = Uri.parse('https://freeipapi.com/api/json');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var jsonResp = jsonDecode(response.body);
        _ipPublic = jsonResp['ipAddress'];
        _codigoPais = jsonResp['countryCode'];
        return _ipPublic;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

Future<Response> httpRequest(String metodo, String url,
    [String sbody = '', bool ultimoIntento = false]) async {
  print("hhtp url:" + url);
  http.Response resp;

  var result = await _checkInternetConnection();
  if (!result)
    throw 'Parece que estás sin conexión. Por favor, verifica tu conexión a internet y vuelve a intentarlo.';

  Uri uri = Uri.parse(enviroment.url + url);
  String bodyback = sbody;
  var request = http.Request(metodo, uri)
    ..headers['Content-Type'] = 'application/json; charset=UTF-8'
    ..headers['Accept'] = 'application/json'
    ..headers['CanalTransferencia'] = crypto.encriptar("Guala Movil")
    ..headers['IpPublica'] =
        crypto.encriptar(await httpInterseptor().ipPublic ?? 'Desconocido')
    ..headers['CodigoPais'] =
        crypto.encriptar(await httpInterseptor().codigoPais ?? 'Desconocido')
    ..headers['Posicion'] = crypto.encriptar(jsonEncode(Geolocator.posicion))
    ..headers['Dispositivo'] =
        crypto.encriptar(jsonEncode(DeviceService.dispositivo))
    ..headers['Authorization'] = 'Bearer tokensesionlogin';
  if (metodo != 'GET') {
    if (enviroment.HabilitarEncriptacionApi) {
      sbody = jsonEncode({'value': crypto.encriptar(sbody)});
    }
    request.body = sbody;
  }
  resp = await http.Response.fromStream(await request.send());
  if (enviroment.HabilitarEncriptacionApi) {
    var responseBody = crypto.desencriptar(jsonDecode(resp.body)['value']);
    resp = Response(responseBody, resp.statusCode);
  }
  return resp;
}

Future<Response> post(String url, String body,
    [bool ultimoIntento = false]) async {
  print("hhtp post url:" + url);
  String bodyback = body;
  if (enviroment.HabilitarEncriptacionApi) {
    body = jsonEncode({'Value': crypto.encriptar(body)});
  }

  var result = await _checkInternetConnection();
  if (!result)
    throw 'Parece que estás sin conexión. Por favor, verifica tu conexión a internet y vuelve a intentarlo.';

  Uri uri = Uri.parse(enviroment.url + url);
  Response resp = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer tokensesionlogin',
        'Posicion': crypto.encriptar(jsonEncode(Geolocator.posicion)),
        'Dispositivo': crypto.encriptar(jsonEncode(DeviceService.dispositivo)),
        'CanalTransferencia': crypto.encriptar("Guala Movil"),
        'IpPublica':
            crypto.encriptar(await httpInterseptor().ipPublic ?? 'Desconocido'),
        'CodigoPais': crypto
            .encriptar(await httpInterseptor().codigoPais ?? 'Desconocido'),
      },
      body: body);

  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    throw 'Error de conexión, Estimado socio, vuelva a iniciar sesion';
  }
  if (enviroment.HabilitarEncriptacionApi) {
    var responseBody = crypto.desencriptar(jsonDecode(resp.body)['value']);
    var decoded = json.decode(responseBody);

    if (!decoded["ok"]) {
      try {
        var code = decoded["messages"][0]["code"];
        if ((code == "-0002-01-02" && url == "autenticacion/pin/validar") ||
            (code == "-0008-01-03" && url == "autenticacion/pin/validar")) {}
      } catch (e) {
        print(e);
      }
    }
    resp = Response(responseBody, resp.statusCode);
  }
  return resp;
}

Future<Response> get(String url, [bool ultimoIntento = false]) async {
  Uri uri = Uri.parse(enviroment.url + url);
  print("hhtp get:" + url);
  var result = await _checkInternetConnection();
  if (!result)
    throw 'Parece que estás sin conexión. Por favor, verifica tu conexión a internet y vuelve a intentarlo.';
  Response resp = await http.get(uri, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization': 'Bearer tokensesionlogin',
    'Posicion': crypto.encriptar(jsonEncode(Geolocator.posicion)),
    'Dispositivo': crypto.encriptar(jsonEncode(DeviceService.dispositivo)),
    'CanalTransferencia': crypto.encriptar("Guala Movil"),
    'IpPublica':
        crypto.encriptar(await httpInterseptor().ipPublic ?? 'Desconocido'),
    'CodigoPais':
        crypto.encriptar(await httpInterseptor().codigoPais ?? 'Desconocido'),
  });

  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    print(resp.body);
    throw 'Error de conexión: Código ${resp.statusCode}';
  }
  if (enviroment.HabilitarEncriptacionApi) {
    var responseBody = crypto.desencriptar(jsonDecode(resp.body)['value']);
    var decoded = json.decode(responseBody);

    if (!decoded["ok"]) {
      try {
        var code = decoded["messages"][0]["code"];
        if ((code == "-0002-01-02" && url == "autenticacion/pin/validar") ||
            (code == "-0008-01-03" && url == "autenticacion/pin/validar")) {}
      } catch (e) {
        print(e);
      }
    }
    resp = Response(responseBody, resp.statusCode);
  }
  return resp;
}

Future<bool> _checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup("google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}
