valueProcessor(var value) {
  if (value == null || value == "null") {
    return "";
  } else if (value != null) {
    return value;
  }
}