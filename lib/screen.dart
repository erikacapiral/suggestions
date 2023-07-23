import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late TextEditingController youtubeController;
  late YoutubePlayerController _youtubePlayerController;
  late DocumentReference linkRef;
  List<String> videoID = [];
  bool showItem = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resources and Tips'
        ),
      ),
      body: Column(
        children: [
          Container(
            child: TextField(
              controller: youtubeController,
              decoration: InputDecoration(
                labelText: 'URL',
                suffixIcon: GestureDetector(
                  child: Icon(
                    Icons.add,
                    size: 32,
                  ),
                  onTap: () {

                  },
                )
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 4
              ),
              child: ListView.builder(
                itemCount: videoID.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(8),
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: videoID[index],
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blue,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.blue, 
                      handleColor: Colors.blueAccent
                    ),
                  ),
                ),
              ),
            )
          )
        ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    linkRef = FirebaseFirestore.instance.collection('links').doc('url');
  }

  _addItem() async {
    await linkRef.set(
      {youtubeController.text.toString():youtubeController.text.toString()},
      SetOptions(
        merge: true
      )
    );
    Flushbar(
      title: 'Added',
      message: 'Updating...',
      duration: Duration(
        seconds: 3
      ),
      icon: Icon(
        Icons.info_outline
      )
    )..show(context);
    setState(() {
      videoID.add(youtubeController.text);
    });
  }

  getData() async {
    await linkRef
        .get()
        .then((value) => value.data()!.forEach((key, value) {
              if (!videoID.contains(value)) {
                videoID.add(value);
              }
            }))
        .whenComplete(() => setState(() {
              videoID.shuffle();
              showItem = true;
            }));
  }
}