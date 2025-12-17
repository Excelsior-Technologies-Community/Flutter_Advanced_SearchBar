import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class AdvancedSearchBar extends StatefulWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSearch;

  const AdvancedSearchBar({
    super.key,
    required this.suggestions,
    required this.onSearch,
  });

  @override
  State<AdvancedSearchBar> createState() => _AdvancedSearchBarState();
}

class _AdvancedSearchBarState extends State<AdvancedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<String> _filteredSuggestions = [];

  late stt.SpeechToText _speech;

  /// true = mic OFF (initial state), false = mic ON
  bool _micOff = true;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  /// 🔁 Debounce logic
  void _onTextChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(value);

      setState(() {
        _filteredSuggestions = widget.suggestions
            .where((item) =>
            item.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    });
  }

  /// 🌐 Internet check
  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// 🎤 Start listening (mic ON)
  Future<void> _startListening() async {
    if (!await _hasInternet()) {
      _showMessage("Internet required for voice search");
      return;
    }

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showMessage("Microphone permission denied");
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) => debugPrint("Speech status: $status"),
      onError: (error) => debugPrint("Speech error: $error"),
    );

    if (!available) {
      _showMessage("Speech recognition not available");
      return;
    }

    setState(() => _micOff = false); // 🎤 mic ON

    _speech.listen(
      listenMode: stt.ListenMode.confirmation,
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _onTextChanged(result.recognizedWords);
      },
    );
  }

  /// ❌ Stop listening (mic OFF)
  void _stopListening() {
    _speech.stop();
    setState(() => _micOff = true);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔍 Search Field
        TextField(
          controller: _controller,
          onChanged: _onTextChanged,
          decoration: InputDecoration(
            hintText: "Search products...",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(
                _micOff ? Icons.mic_off : Icons.mic,
              ),
              onPressed: () {
                if (_micOff) {
                  _startListening(); // turn mic ON
                } else {
                  _stopListening(); // turn mic OFF
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        /// 📋 Suggestions List
        if (_filteredSuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredSuggestions[index]),
                  onTap: () {
                    _controller.text =
                    _filteredSuggestions[index];
                    widget.onSearch(_filteredSuggestions[index]);
                    setState(() => _filteredSuggestions.clear());
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
