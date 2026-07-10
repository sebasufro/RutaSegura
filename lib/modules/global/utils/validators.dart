import 'package:flutter/services.dart';

/// Valida un RUT chileno, incluyendo su dígito verificador, usando el algoritmo del módulo 11.
/// Acepta formatos con o sin puntos, con guión antes del verificador.
/// Ejemplo: "12.345.678-5", "12345678-5" o "12345678-K".
bool isValidRut(String rawRut) {
  final rut = rawRut.replaceAll('.', '').replaceAll(' ', '').toUpperCase();

  final match = RegExp(r'^(\d{7,8})-([0-9K])$').firstMatch(rut);
  if (match == null) return false;

  final body = match.group(1)!;
  final verifier = match.group(2)!;

  int sum = 0;
  int multiplier = 2;
  for (int i = body.length - 1; i >= 0; i--) {
    sum += int.parse(body[i]) * multiplier;
    multiplier = multiplier == 7 ? 2 : multiplier + 1;
  }

  final remainder = 11 - (sum % 11);
  final expectedVerifier = remainder == 11
      ? '0'
      : remainder == 10
          ? 'K'
          : remainder.toString();

  return verifier == expectedVerifier;
}

/// Valida un número de teléfono chileno sin el prefijo "+56", como el que ingresa el usuario en pantalla.
/// Espera exactamente 9 dígitos y que empiece con 9 una vez quitados los espacios.
bool isValidClPhoneWithoutPrefix(String rawPhone) {
  final digits = rawPhone.replaceAll(' ', '');
  return RegExp(r'^9\d{8}$').hasMatch(digits);
}

/// Formatea el RUT mientras el usuario escribe para que quede en un formato legible y consistente.
/// Solo permite dígitos y una "K" final, y agrega puntos y guión automáticamente.
/// Ejemplo: "123456785" se muestra como "12.345.678-5".
class RutInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Nos quedamos solo con dígitos y, al final, una K/k opcional.
    String digitsAndK = newValue.text.replaceAll(RegExp(r'[^0-9kK]'), '');
    digitsAndK = digitsAndK.toUpperCase();

    // Separa el cuerpo (hasta 8 dígitos) del verificador (último char).
    String body = digitsAndK;
    String verifier = '';
    if (digitsAndK.isNotEmpty) {
      final lastChar = digitsAndK[digitsAndK.length - 1];
      final isVerifierChar = RegExp(r'[0-9K]').hasMatch(lastChar);
      if (digitsAndK.length > 1 || lastChar == 'K') {
        body = digitsAndK.substring(0, digitsAndK.length - 1);
        verifier = isVerifierChar ? lastChar : '';
      }
    }
    // Solo dígitos en el cuerpo, máximo 8.
    body = body.replaceAll(RegExp(r'[^0-9]'), '');
    if (body.length > 8) body = body.substring(0, 8);

    // Inserta puntos cada 3 dígitos desde la derecha.
    final buffer = StringBuffer();
    for (int i = 0; i < body.length; i++) {
      final posFromRight = body.length - i;
      buffer.write(body[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) {
        buffer.write('.');
      }
    }

    String formatted = buffer.toString();
    if (verifier.isNotEmpty) {
      formatted += '-$verifier';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}