import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});


  @override
  State<StatefulWidget> createState() => _SettingsViewState();

}

  class _SettingsViewState extends State<SettingsView> {

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _boardHeightController = TextEditingController();
  final TextEditingController _maxHeightController = TextEditingController();
  String _savedUrl = '';
  String _savedPort = '';
  String _savedBoardHeight = '';
  String _savedMaxHeight = '';

  void dispose() {
    _urlController.dispose();
    _portController.dispose();
    _boardHeightController.dispose();
    _maxHeightController.dispose();
    super.dispose();
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('url', _savedUrl);
    prefs.setString('port', _savedPort);
    prefs.setString('boardHeight', _savedBoardHeight);
    prefs.setString('maxHeight', _savedMaxHeight);
  }

  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUrl = prefs.getString('url') ?? '';
      _savedPort = prefs.getString('port') ?? '';
      _savedBoardHeight = prefs.getString('boardHeight') ?? '';
      _savedMaxHeight = prefs.getString('maxHeight') ?? '';

      _urlController.text = _savedUrl;
      _portController.text = _savedPort;
      _boardHeightController.text = _savedBoardHeight;
      _maxHeightController.text = _savedMaxHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            controller: _portController,
            decoration: const InputDecoration(
              labelText: 'Port',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),

            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _boardHeightController,
            decoration: const InputDecoration(
              labelText: 'Board Height',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _maxHeightController,
            decoration: const InputDecoration(
              labelText: 'Max Height',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _savedUrl = _urlController.text;
                _savedPort = _portController.text;
                _savedBoardHeight = _boardHeightController.text;
                _savedMaxHeight = _maxHeightController.text;
              });

              saveSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),

    );
  }

  }

