// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(const TourismApp());
}

class TourismApp extends StatelessWidget {
  const TourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jordan Tourism",
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("السياحة في الأردن")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
            child: const Text("مشاهدة الفيديو التعريفي"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VideoScreen()));
            },
          ),
          ElevatedButton(
            child: const Text("المعالم السياحية"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PlacesScreen()));
            },
          ),
          ElevatedButton(
            child: const Text("اختبار معلوماتك"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()));
            },
          ),
          ElevatedButton(
            child: const Text("تقييم التطبيق"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RatingScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
        'https://samplelib.com/lib/preview/mp4/sample-5s.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الفيديو التعريفي")),
      body: Stack(
      children: [
        Center(
          child: controller.value.isInitialized
              ? AspectRatio(
                  child: VideoPlayer(controller),
                  aspectRatio: controller.value.aspectRatio,
                )
              : Text("تعذر التشغيل"),
        ),
        Center(
          child: IconButton(
            style: ElevatedButton.styleFrom(shape: CircleBorder()),
            onPressed: () async {
              controller.value.isPlaying
                  ?await controller.pause()
                  :await controller.play();
            },
            icon: controller.value.isPlaying
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
          ),
        ),
      ],
    )
    );
  }
}

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المعالم السياحية")),
      body: ListView(
        children: const [
          ListTile(
              title: Text("البتراء"),
              subtitle: Text("إحدى عجائب الدنيا السبع الجديدة")),
          ListTile(
              title: Text("وادي رم"),
              subtitle: Text("صحراء جميلة ذات طبيعة ساحرة")),
          ListTile(
              title: Text("البحر الميت"),
              subtitle: Text("أخفض نقطة على سطح الأرض")),
          ListTile(
              title: Text("جرش"),
              subtitle: Text("مدينة رومانية تاريخية")),
          ListTile(
              title: Text("قلعة الكرك"),
              subtitle: Text("قلعة تاريخية تعود للعصور الوسطى")),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;
  int questionIndex = 0;
  final AudioPlayer player = AudioPlayer();

  List<Map<String, Object>> questions = [
    {
      "question": "أين تقع البتراء؟",
      "answers": ["معان", "إربد", "الزرقاء"],
      "correct": 1 
    },
    {
      "question": "أين يقع البحر الميت؟",
      "answers": ["شمال الأردن", "غرب الأردن", "شرق الأردن"],
      "correct": 2
    },
  ];

  void answerQuestion(int selected) async {
    if (selected == questions[questionIndex]["correct"]) {
      score++;
      await player.play(AssetSource('correct.mp3'));
    }
    setState(() {
      if (questionIndex < questions.length - 1) {
        questionIndex++;
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("النتيجة"),
                  content: Text("عدد الإجابات الصحيحة: $score"),
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var current = questions[questionIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("الاختبار")),
      body: Column(
        children: [
          Text(current["question"] as String,
              style: const TextStyle(fontSize: 22)),
          ...(current["answers"] as List<String>)
              .asMap()
              .entries
              .map((entry) => ElevatedButton(
                    onPressed: () => answerQuestion(entry.key),
                    child: Text(entry.value),
                  ))
              .toList()
        ],
      ),
    );
  }
}

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int rating = 0;
  final AudioPlayer player = AudioPlayer();

  void rate(int value) async {
    setState(() {
      rating = value;
    });
    if (value >= 4) {
      await player.play(AssetSource('clap.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تقييم التطبيق")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return IconButton(
            icon: Icon(
              Icons.star,
              color: rating > index ? Colors.orange : Colors.grey,
            ),
            onPressed: () => rate(index + 1),
          );
        }),
      ),
    );
  }
}
            


class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller;
  
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset("assets/videos/jordan.mp4")
      ..initialize().then((value) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: controller.value.isInitialized
              ? AspectRatio(
                  child: VideoPlayer(controller),
                  aspectRatio: controller.value.aspectRatio,
                )
              : Text("تعذر التشغيل"),
        ),
        Center(
          child: IconButton(
            style: ElevatedButton.styleFrom(shape: CircleBorder()),
            onPressed: () async {
              controller.value.isPlaying
                  ?await controller.pause()
                  :await controller.play();
            },
            icon: controller.value.isPlaying
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
          ),
        ),
      ],
    );
  }
}
