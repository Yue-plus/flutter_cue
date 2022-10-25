import 'package:flutter/material.dart';
import 'package:flutter_cue/src/students.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// [文字转语音](https://pub.flutter-io.cn/packages/flutter_tts)
  final FlutterTts flutterTts = FlutterTts();

  /// 未点到列表
  // final List<String> notArrivedList = [];
  String notArrivedList = '';

  /// 已到人数
  int arrived = 0;

  /// 当前点到人数
  int index = 0;

  /// 重喊
  void _refresh() {
    flutterTts.speak(students[index]);
  }

  /// 到！
  void _check() {
    if (index < students.length - 1) {
      setState(() => index++);
    }
    flutterTts.speak(students[index]);
  }

  /// 跳过
  void _skip() {
    // 开始点名不可跳过
    if (index == 0) return;
    if (index < students.length - 1) {
      // notArrivedList.add(students[index]);
      notArrivedList += '${students[index]}；';
      setState(() => index++);
    }
    flutterTts.speak(students[index]);
  }

  Future<void> _initFlutterTts() async {
    /// 设置共享音频实例（仅 iOS）。
    await flutterTts.setSharedInstance(true);

    /// 设置音频类别和选项的可选模式（仅 iOS）。
    /// 下面的设置允许背景音乐和应用内音频会话同时继续。
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );

    // Android 端设置

    /// 0 表示立即开始发声。如果该值大于零，则根据参数设置以毫秒为单位的静默期
    await flutterTts.setSilence(0);

    // await flutterTts.isLanguageInstalled("zh-CN");
    // await flutterTts.areLanguagesInstalled(["zh-CN"]);

    /// `0` 表示 `QUEUE_FLUSH` ——队列模式，其中播放队列中的所有条目
    /// （要播放的媒体和要合成的文本）都被丢弃并替换为新条目。
    /// 相对于给定的呼叫应用程序刷新队列。不会丢弃来自其他 `callees` 的队列中的条目。
    /// `1` 表示 `QUEUE_ADD` ——Queue 模式，其中在播放队列的末尾添加了新条目。
    await flutterTts.setQueueMode(1);


    /// 等待说话完成。
    await flutterTts.awaitSpeakCompletion(true);

    /// 等待合成文件完成。
    await flutterTts.awaitSynthCompletion(true);

    /// 设置说简体中文
    await flutterTts.setLanguage("zh-CN");

    /// 设置说话速度；范围 0.0~1.0
    await flutterTts.setSpeechRate(2.0);

    /// 设置说话音量；范围 0.0~1.0
    await flutterTts.setVolume(1.0);

    /// 设置音高；默认为 1.0；范围 0.5~2.0
    await flutterTts.setPitch(1.5);

    /// 喊开始点名
    await flutterTts.speak(students[index]);
  }

  @override
  void initState() {
    super.initState();
    _initFlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            onPressed: () =>
                launchUrl(Uri.parse('https://github.com/Yue-plus/flutter_cue')),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: ListView(
        children: [
          Text(
            '人数：$index/${students.length - 1}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            child: FittedBox(
              child: Text(
                students[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: '楷体'),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            textBaseline: TextBaseline.ideographic,
            children: [
              IconButton(
                onPressed: _refresh,
                iconSize: 64,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: _check,
                iconSize: 64,
                icon: const Icon(Icons.check),
              ),
              IconButton(
                onPressed: _skip,
                iconSize: 64,
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 32),
            child: SelectableText(
                notArrivedList != '' ? '以下同学未到：$notArrivedList' : ''),
          ),
        ],
      ),
    );
  }
}
