import 'package:web_scraper/web_scraper.dart';

class Scraper {
  static Future<String> scrapResults(String query) async {
    if (query.length == 0) {
      return '';
    }
    final webScraper = WebScraper();
    if (await webScraper.loadFullURL('https://duckduckgo.com/html/?q=$query+change+password')) {
      List<Map<String, dynamic>> elements = webScraper.getElement('a.result__a', ['href']);

      String url = elements[0]["attributes"]["href"];

      String cleanUrl = url
          .substring(url.indexOf('https'), url.indexOf('&rut'))
          .replaceAll('%3A', ':')
          .replaceAll('%2F', '/')
          .replaceAll('3F', '?')
          .replaceAll('%25', '')
          .replaceAll('3D', '=');

      if (!cleanUrl.contains('duckduckgo')) {
        return cleanUrl;
      }
    }
    return '';
  }
}
