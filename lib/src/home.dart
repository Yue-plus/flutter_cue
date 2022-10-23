import 'package:flutter/material.dart';
import 'package:flutter_cue/src/students.dart';

import '../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// 未点到列表
  final List<String> notArrivedList = [];

  /// 已到人数
  int arrived = 0;

  /// 当前点到人数
  int index = 0;

  /// 重喊
  void _refresh() {
    // TODO
  }

  /// 到！
  void _check() {
    if (index < students.length - 1) {
      setState(() => index++);
    }
  }

  /// 跳过
  void _skip() {
    if (index < students.length - 1) {
      notArrivedList.add(students[index]);
      setState(() => index++);
    }
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
            const SizedBox(height: 23),
            Text(
              students[index],
              style: const TextStyle(fontSize: 100, fontFamily: '楷体'),
            ),
            const SizedBox(height: 23),
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
          ],
        ),
      ),
    );
  }
}
