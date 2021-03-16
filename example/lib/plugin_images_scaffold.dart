
import 'package:flutter/material.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';
import 'package:flutter_engaged_2021/flutter_engaged_2021.dart';
import 'package:flutter_engaged_2021/widget/plugin_thumbnail_widget.dart';
import 'package:flutter_engaged_2021_example/plugin_image_view_scaffold.dart';

class PluginImagesScaffold extends StatefulWidget {
  @override
  _PluginImagesScaffoldState createState() => _PluginImagesScaffoldState();
}

class _PluginImagesScaffoldState extends State<PluginImagesScaffold> {

  List<PluginImage>? _list;

  @override
  void initState() {
    super.initState();
    FlutterEngaged2021.getImages().then((value) {
      if(mounted) {
        setState(() {
          _list = value;
        });
      } else {
        _list = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image album by plugin images'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: _list?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              final item = _list?[index];
              if(item != null) {
                return Material(
                    child: InkWell(child: PluginThumbnailWidget(image: item), onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PluginImageViewScaffold(pluginImage: item)));
                    },));
              } else {
                return Container();
              }
            },
          ),
        )
    );
  }
}

class PluginImagesRow extends StatefulWidget {
  @override
  _PluginImagesRowState createState() => _PluginImagesRowState();
}

class _PluginImagesRowState extends State<PluginImagesRow> {

  List<PluginImage>? _list;

  @override
  void initState() {
    super.initState();
    FlutterEngaged2021.getImages().then((value) {
      if(mounted) {
        setState(() {
          _list = value;
        });
      } else {
        _list = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 120,
      color: Colors.blue,
      child: ListView.builder(
        itemCount: _list?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final item = _list?[index];
          if(item != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Material(
                    child: InkWell(child: PluginThumbnailWidget(image: item), onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PluginImageViewScaffold(pluginImage: item)));
                    },)),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}