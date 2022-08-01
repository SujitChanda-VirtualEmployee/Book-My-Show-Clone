import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinkService {
  Future<String>  screateDynamicLink(bool short) async {
    String linkMessage = "";
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://movieHallTicketBookingSystem.page.link',
      link: Uri.parse("https://bookmyshow.com"),
      androidParameters: const AndroidParameters(
        packageName: 'com.sujitchanda.book_my_show_clone',
        minimumVersion: 123,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'io.invertase.testing',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    linkMessage = url.toString();

    return linkMessage;
  }
}
