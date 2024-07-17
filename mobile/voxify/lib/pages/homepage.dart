import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voxify/consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoice;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
        setState(() {
          _voices = 
            _voices.where((_voice) => _voice["name"].contains("en")).toList();
          _currentVoice == _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print("Error: $e");      
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({
      "name": voice["name"],
      "locale": voice["locale"]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _flutterTts.speak(TTS_INPUT);
        }, 
        child: const Icon(
          Icons.speaker_phone,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _speakerSelector(),
        ],
      )
    );
  }

  Widget _speakerSelector() {
    return DropdownButton(
      value: _currentVoice,
      items: _voices
        .map(
          (_voice) => DropdownMenuItem(
            value: _voice,
            child: Text(
              _voice["name"],
            ),
          ),
        )
        .toList(),
      onChanged: (value) {},
    );
  }
}