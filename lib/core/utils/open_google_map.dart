import 'package:url_launcher/url_launcher.dart';
import '../models/store.dart';

Future<void> openGoogleMap(Store store) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${store.lat},${store.lng}',
  );

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}
