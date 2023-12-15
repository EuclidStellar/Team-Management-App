import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:brl_task4/create&join-Team/Domain-team.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  late Future<List<Track>> tracks;
  TextEditingController searchController = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    tracks = fetchTracks();
  }

  Future<List<Track>> fetchTracks() async {
    var headers = {
      'X-RapidAPI-Key': '6a506bf363msh70b280c80245a2ap15b295jsn61aff7c2dc6e',
      'X-RapidAPI-Host': 'shazam.p.rapidapi.com'
    };
    var response = await http.get(
      Uri.parse(
          'https://shazam.p.rapidapi.com/search?term=${searchController.text}&locale=en-US&limit=5&offset=0'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> hits = jsonDecode(response.body)['tracks']['hits'];
      return hits.map((hit) => Track.fromJson(hit)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  void onSearchButtonPressed() {
    setState(() {
      tracks = fetchTracks();
    });
  }

  void playPausePreview(String previewUrl) {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play(UrlSource(previewUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 51, 15, 44),
        foregroundColor: Colors.white,
        elevation: 12,
        title: const Text('Zen Zone </>'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  
                  child: MyTextField(
                    nameController1 : searchController,
                    hintText: 'Enter song name', inputType: TextInputType.name, secure1: false, capital: TextCapitalization.none, labelText2: 'Search',
                  
                  ),
                  // child: TextField(
                  //   controller: searchController,
                  //   decoration: const InputDecoration(
                  //     hintText: 'Enter song name',
                  //   ),
                  // ),
                ),
                const SizedBox(width: 8),
              //  Buttonkii(buttonName: 'Search', onTap: onSearchButtonPressed, bgColor: Colors.black, textColor: Colors.white,)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                  ),
                  onPressed: onSearchButtonPressed,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Track>>(
              future: tracks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Wanna try some songs ? '));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MusicCard(
                        track: snapshot.data![index],
                        onPlayPressed: () =>
                            playPausePreview(snapshot.data![index].previewUrl),
                        isPlaying: isPlaying,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MusicCard extends StatelessWidget {
  final Track track;
  final VoidCallback onPlayPressed;
  final bool isPlaying;

  const MusicCard(
      {Key? key,
      required this.track,
      required this.onPlayPressed,
      required this.isPlaying})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: track.imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  track.subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onPlayPressed,
                  child: Text(isPlaying ? 'Pause' : 'Play Preview'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// model

class Track {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String previewUrl;

  Track({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['track']['title'] ?? '',
      subtitle: json['track']['subtitle'] ?? '',
      imageUrl: json['track']['images']['coverarthq'] ?? '',
      previewUrl: json['track']['hub']['actions'][1]['uri'] ?? '',
    );
  }
}
