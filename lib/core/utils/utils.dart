import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Utils {
  //==========================================================
  /// TRADUCE LOS ERRORES DE DIO A MENSAJES CLAROS
  //==========================================================
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado. Inténtalo de nuevo.';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado. Revisa tu conexión.';
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardó demasiado en responder.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'El recurso solicitado no fue encontrado.';
        }
        if (statusCode == 500) {
          return 'Error interno del servidor. Inténtalo más tarde.';
        }
        return 'Error del servidor: Código $statusCode';
      case DioExceptionType.cancel:
        return 'La petición al servidor fue cancelada.';
      case DioExceptionType.connectionError:
        return 'No se pudo establecer conexión. Revisa tu internet.';
      default:
        return 'Error de red desconocido.';
    }
  }

  //==========================================================
  /// DEVUELVE COLOR EN HEXADECIMAL
  //==========================================================
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
