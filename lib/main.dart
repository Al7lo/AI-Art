import 'package:flutter/material.dart';
import 'package:flutter_application_1/DallEAPI.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  String? imageUrl;
  bool isLoading = false;
  List<String> imageUrls = [];
  String? selectedGenre;

  final DallEAPI dallEAPI =
      DallEAPI('sk-proj-9juLqzTjeFNFwa8bUcmvT3BlbkFJibjPX7C58TYgI85AgK0s');

  void _generateImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      var prompt =
          "Create a ${selectedGenre?.toLowerCase()} comic for ${_controller.text}. Make the conversation clear and funny.";
      final url = await dallEAPI.generateImage(prompt);
      setState(() {
        imageUrls.add(url as String);
        isLoading = false;
      });
    } catch (e) {
      // Handle errors appropriately
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'AI ART',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: Colors.black87,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedGenre,
                    hint: Text("Select a Genre",
                        style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.black87,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGenre = newValue;
                      });
                    },
                    items: <String>[
                      'Comic',
                      'Anime',
                      'Cartoon',
                      '3D'
                    ] // Updated genres
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Write the scenario then write the second scenario based on the first scenario and the third scenario based on the 2nd until you finish the story:",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter prompt',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => _controller.clear(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generateImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    child: const Text(
                      'Generate Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (isLoading) CircularProgressIndicator(),
                  if (imageUrls.isNotEmpty && !isLoading)
                    for (var imageUrl in imageUrls)
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                  SizedBox(height: 20), // Spacing after each image
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
