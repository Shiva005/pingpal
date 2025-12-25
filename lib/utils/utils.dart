import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static openDialPad(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not open dial pad';
    }
  }

  static void openLink(String urlLink) async {
    final Uri url = Uri.parse(urlLink);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  static void openExternalApp(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openMail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQuery({
        'subject': 'Support Request',
        'body': 'Hello, I need assistance regarding...',
      }),
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email client');
    }
  }

  static String encodeQuery(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  static List<Color> chartColors = [
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.teal,
    Colors.cyan,
    Colors.amber,
  ];

  static Map<String, String> parseLatLng(String value) {
    value = value.trim();
    List<String> parts = value.split(',');

    if (parts.length != 2) {
      throw Exception("Invalid format. Expected 'lat,lng'");
    }

    String lat = parts[0].trim();
    String lng = parts[1].trim();

    return {"lat": lat, "lng": lng};
  }

  static void shareLocation(String houseName, String latLngString) {
    final parsed = parseLatLng(latLngString);

    final lat = parsed["lat"];
    final lng = parsed["lng"];

    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

    Share.share("📍 $houseName Location:\n$url", subject: "Share Location");
  }

  static Future<void> openDirections(String latLngString) async {
    final parsed = parseLatLng(latLngString);

    final lat = parsed["lat"];
    final lng = parsed["lng"];
    final url = Uri.parse(
      "google.maps://?daddr=$lat,$lng&directionsmode=driving",
    );

    // If Google Maps app is available → open it
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final webUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
      );
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  static void cherrySuccess(BuildContext context, String message) {
    CherryToast(
      backgroundColor: Colors.green.shade200,
      iconSize: 24,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green.shade900,
      themeColor: Colors.green.shade900,
      description: Text(message),
      toastPosition: Position.top,
      toastDuration: const Duration(milliseconds: 4000),
      animationDuration: const Duration(milliseconds: 1000),
      autoDismiss: true,
    ).show(context);
  }

  static void cherryFailed(BuildContext context, String message) {
    CherryToast(
      backgroundColor: Colors.red.shade100,
      iconSize: 24,
      icon: Icons.close,
      iconColor: Colors.red,
      themeColor: Colors.red,
      description: Text(message),
      toastPosition: Position.top,
      toastDuration: const Duration(milliseconds: 4000),
      animationDuration: const Duration(milliseconds: 1000),
      autoDismiss: true,
    ).show(context);
  }
}
