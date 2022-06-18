import 'package:xml/xml.dart';

class XmlUtils {
  /// XML에서 key값으로 찾기
  static String searchResult(XmlElement xml, String key) {
    return xml.findAllElements(key).single.text.isEmpty
        ? ''
        : xml.findAllElements(key).single.text;
  }
}