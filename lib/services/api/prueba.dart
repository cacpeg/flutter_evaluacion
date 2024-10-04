import 'dart:convert';

import 'package:evaluacion/models/Generico.dart';

import 'package:evaluacion/services/httpInterseptor.dart' as http;

class PruebaService {
  Future<List<Generico>> obtenerSucursales() {
    return http.get('informacion/agencias').then((resp) {
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        var jsonResp = jsonDecode(resp.body);
        if (!jsonResp['ok']) {
          throw jsonResp['messages'] as List;
        }
        return (jsonResp['data'] as List)
            .map((e) =>
                Generico(descripcion: e['nombre'], codigo: e['codigoAgencia']))
            .toList();
      }
      throw 'Error de conexión: Código ${resp.statusCode}';
    });
  }
}
