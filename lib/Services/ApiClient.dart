import 'dart:convert';

import 'package:flutter_simple_page/Models/User.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Reservation.dart';

class ApiClient {
  static const baseUrl = 'http://192.168.1.10:5000';

  static Future<http.Response> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return response;
  }
  static Future<http.Response> RegisterUser(String name,String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        "email": email,
        "password": password,
      }),
    );
    return response;
  }
  static Future<User> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${baseUrl}/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userProfileMap  = jsonDecode(response.body);
      final userProfile = User.fromJson(userProfileMap);
      return userProfile;
    }
    else
      {
        throw Exception('Failed to load User');
      }

  }


  static Future<List<dynamic>> fetchTerrains({String? query}) async {
    final response = await http.get(Uri.parse('${baseUrl}/terrains/all${query != null ? '?q=$query' : ''}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load terrains');
    }
  }

  static Future<List<int>> fetchUnavailableHours(String idt,DateTime dat) async {
    String dateres=DateFormat('dd-MM-yyyy').format(dat);
    final uri = Uri.parse('${baseUrl}/reservation/avaihours?terrainId=${idt}&date=${dateres}');
    final response = await http.get(uri);
    List<int> resHours=[];
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      resHours = List<int>.from(jsonResponse['availablehours']);
    }
    return resHours;
  }
  static Future<List<String>> fetchAvailableDates(String idt) async {
    final uri = Uri.parse('${baseUrl}/reservation/avaidays?terrainId=${idt}');
    final response = await http.get(uri);
    List<String> avaiDates = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      avaiDates = List<String>.from(jsonResponse['daysavai']);
    }
    return avaiDates;
  }
  //cancel reservation
  static Future<http.Response> cancelReservation( String idresv) async {
    final url = Uri.parse('${baseUrl}/reservation/${idresv}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete Reservation');
    }
  }
  static Future<http.Response> postReservation(String idt,DateTime date, int Selected) async {
    final url = Uri.parse('${baseUrl}/reservation/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(url, body: {
      'terrain': idt,
      'date': DateFormat('dd-MM-yyyy').format(date),
      'heure': Selected.toString(),
    }, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to Add terrain Reservation');
    }
  }
  static Future<List<Reservation>> ReservationsEnAttente() async {
    final url = Uri.parse('${baseUrl}/reservation/still');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return List.from(jsonResponse).map((model) => Reservation.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load Reservations');
    }
  }
  static Future<List<Reservation>> ReservationsConfirmer() async {
    final url = Uri.parse('${baseUrl}/reservation/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return List.from(jsonResponse).map((model) => Reservation.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load new Reservations');
    }
  }
// return myres count
static Future<Map<String, int>> fetchmyres() async {
  final url = '${baseUrl}/reservation/myres';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final resdone = jsonResponse['resdone'];
      final respending = jsonResponse['respending'];

      return {'resdone': resdone, 'respending': respending};
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
//Edit phone number
static Future<http.Response> Editprofilenumber(int phone) async {
    final url = Uri.parse('${baseUrl}/users/phone/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(url, body: {
      'phone': phone.toString(),
    }, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to edit phone');
    }
  }
  }