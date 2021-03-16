import 'dart:typed_data';

extension MapExtension on Map {
  T? get<T>(dynamic key, {T Function(Map map)? converter}) {
    switch(T) {
      case bool:
        return (this[key] == true) as T;
      case int:
        return (dynamicToInt(this[key]) as T);
      case double:
        return (dynamicToDouble(this[key]) as T);
      case String:
        return (dynamicToString(this[key]) as T);
      case Uint8List:
        return this[key] is Uint8List ? this[key] : null;
      case Map:
        return this[key] is Map ? this[key] : null;
      default:
        final value = this[key];
        if(value is Map && converter != null) {
          return converter(value);
        }
        return value?.runtimeType == T ? this[key] : null;
    }
  }
}

int? dynamicToInt(dynamic? value) {
  if (value is int) {
    return value;
  } else if (value is double) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value);
  } else {
    return null;
  }
}

double? dynamicToDouble(dynamic? value) {
  if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value);
  } else {
    return null;
  }
}

String? dynamicToString(dynamic? value) {
  if (value is String) {
    return value;
  } else {
    return value?.toString();
  }
}

bool? dynamicToBool(dynamic? value) {
  if (value is bool) {
    return value;
  } else {
    return false;
  }
}