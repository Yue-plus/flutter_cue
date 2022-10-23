import 'package:flutter/material.dart';
import 'package:flutter_cue/src/students.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

    /// 等待说话完成。
    await flutterTts.awaitSpeakCompletion(false);

    /// 等待合成文件完成。
    await flutterTts.awaitSynthCompletion(true);

    /// 设置说简体中文
    await flutterTts.setLanguage("zh-CN");

    /// 设置说话速度
    await flutterTts.setSpeechRate(2.0);

    /// 设置说话音量
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
      appBar: AppBar(title: const Text(title)),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              '人数：$index/${students.length - 1}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 24),
            Text(
              students[index],
              style: const TextStyle(fontSize: 100, fontFamily: '楷体'),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            Text(notArrivedList != '' ? '以下同学未到：$notArrivedList' : ''),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
