import 'package:dr_mohamed_app/constants/color.dart';
import 'package:dr_mohamed_app/widgets/custom_video_player2.dart';
import 'package:flutter/material.dart';

class VideoShow extends StatefulWidget {
  final String url;
  const VideoShow({super.key, required this.url});

  @override
  State<VideoShow> createState() => _VideoShowState();
}

class _VideoShowState extends State<VideoShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: kPrimaryColor,),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: DefaultPlayer(
            url: widget.url,
          ),
        ),
      ),
    );
  }
}
