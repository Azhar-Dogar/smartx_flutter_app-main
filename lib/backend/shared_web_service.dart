import 'dart:convert';

import 'package:http/http.dart' as http;

class SharedWebService {

  static SharedWebService? _instance;

  SharedWebService._();

  static SharedWebService instance() {
    _instance ??= SharedWebService._();
    return _instance!;
  }

  Future<void> sendNotification(String token, Map<String, dynamic> data) async {
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final res = await http.post(uri, body: jsonEncode(data), headers: {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAvPso1_Y:APA91bHL1luhLDH_sHJaZ3YMgsGjWOgvwRSSmn8PcQM1cy_lTVuvzqegG0acMDP8_YwSOTidgunPXvLYz5pAvhuQlqvxVNuNCshG7XxGmHYAHopv6Ub9vq4q_ohHPHDxfcDArCTCzk1l'
    });
  }
}