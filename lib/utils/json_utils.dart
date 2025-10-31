double? parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  if (value is Map) {
    if (value.containsKey('value')) {
      return parseNullableDouble(value['value']);
    }
    if (value.containsKey('Value')) {
      return parseNullableDouble(value['Value']);
    }
    if (value.isNotEmpty) {
      return parseNullableDouble(value.values.first);
    }
  }
  return null;
}

int? parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  if (value is Map) {
    if (value.containsKey('value')) {
      return parseNullableInt(value['value']);
    }
    if (value.containsKey('Value')) {
      return parseNullableInt(value['Value']);
    }
    if (value.isNotEmpty) {
      return parseNullableInt(value.values.first);
    }
  }
  return null;
}
