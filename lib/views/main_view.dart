import 'package:flutter/material.dart';
import 'package:kotel_pellet_app/viewmodels/kotel_tank.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  double percentage = 50; // Начална стойност на процента
  double height = 58; // Начална стойност на височината
  String responseText = '';
  bool isLoading = false; // Променлива за състоянието на зареждане

  // Функция за зареждане на настройки от SharedPreferences
  Future<Map<String, String>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url') ?? '';
    String port = prefs.getString('port') ?? '';
    String boardHeight = prefs.getString('boardHeight') ?? '';
    String maxHeight = prefs.getString('maxHeight') ?? '';
    return {'url': url, 'port': port, 'boardHeight': boardHeight, 'maxHeight': maxHeight};
  }

  // Функция за изпращане на HTTP заявка и актуализиране на данни
  Future<void> makeHttpRequest() async {
    setState(() {
      isLoading = true; // Показваме индикатор за зареждане
    });

    Map<String, String> settings = await loadSettings();
    final url = Uri.parse('http://${settings['url']}:${settings['port']}/distance?boardHeight=${settings['boardHeight']}&maxHeight=${settings['maxHeight']}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          responseText = response.body;
          final Map<String, dynamic> data = json.decode(response.body);
          percentage = data['percentage'];
          height = data['distance'];
        });
      } else {
        throw Exception('Неуспешна заявка');
      }
    } catch (e) {
      print('Грешка: $e');
      setState(() {
        responseText = 'Грешка при зареждането на данни';
      });
    } finally {
      setState(() {
        isLoading = false; // Скриваме индикатора за зареждане
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          KotelTank(percentage: percentage, height: height),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              makeHttpRequest();
            },
            child: const Text('Reload Data'),
          ),
          const SizedBox(height: 20),
          // Показваме индикацията за зареждане
          if (isLoading)
            const CircularProgressIndicator(),  // Това ще показва индикатор за зареждане
          if (!isLoading)
            Text(responseText),  // Показваме резултата от заявката
        ],
      ),
    );
  }
}
