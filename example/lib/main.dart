import 'package:flutter/material.dart';
import 'package:flutter_engaged_2021/flutter_engaged_2021.dart';

import 'platform_view_scaffold.dart';
import 'plugin_images_scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _byPlatformView = false;
  bool _byPluginImages = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Engaged Extended Korea\n(Image Album)'),
          ),
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  ListTile(
                    title: const Text('1. Image album'),
                    subtitle: const Text('by new screen'),
                    onTap: () {
                      FlutterEngaged2021.showImageAlbum();
                    },
                  ),
                  ListTile(
                    title: const Text('2. Image album'),
                    subtitle: const Text('by platform view'),
                    trailing: IconButton(
                      icon: Icon(_byPlatformView ? Icons.remove : Icons.add),
                      onPressed: () {
                        setState(() {
                          _byPlatformView = !_byPlatformView;
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlatformViewScaffold()));
                    },
                  ),
                  if(_byPlatformView)
                    Container(
                      height: 240,
                      color: Colors.cyan,
                      child: PlatformWidget(),
                    ),
                  ListTile(
                    title: const Text('2. Image album'),
                    subtitle: const Text('by plugin images'),
                    trailing: IconButton(
                      icon: Icon(_byPluginImages ? Icons.remove : Icons.add),
                      onPressed: () {
                        setState(() {
                          _byPluginImages = !_byPluginImages;
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PluginImagesScaffold()));
                    },
                  ),
                  if(_byPluginImages)
                    PluginImagesRow()
                ],
              );
            },
          )
      ),
    );
  }
}
