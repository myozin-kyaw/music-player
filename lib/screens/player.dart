import 'package:beats/controllers/player_controller.dart';
import 'package:beats/global/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> songs;
  const Player({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: QueryArtworkWidget(
                    id: songs[controller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      color: whiteColor,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        songs[controller.playIndex.value]
                            .displayNameWOExt
                            .toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 20,
                          color: bgDartColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        songs[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 20,
                          color: bgDartColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              controller.position.value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: bgDartColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDurationsToSeconds(
                                    newValue.toInt(),
                                  );
                                  newValue = newValue;
                                },
                                thumbColor: sliderColor,
                                inactiveColor: bgColor,
                                activeColor: sliderColor,
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: bgDartColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              var previousSongIndex = 0;
                              if (controller.playIndex.value == 0) {
                                previousSongIndex = songs.length - 1;
                              } else {
                                previousSongIndex =
                                    controller.playIndex.value - 1;
                              }

                              controller.playSong(
                                songs[previousSongIndex].uri,
                                previousSongIndex,
                              );
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: bgDartColor,
                            ),
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: bgDartColor,
                            child: Transform.scale(
                              scale: 1.2,
                              child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.value
                                    ? const Icon(
                                        Icons.pause,
                                        size: 40,
                                        color: whiteColor,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 40,
                                        color: whiteColor,
                                      ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              var previousSongIndex =
                                  controller.playIndex.value + 1;
                              if ((songs.length - 1) ==
                                  controller.playIndex.value) {
                                previousSongIndex = 0;
                              }

                              controller.playSong(
                                songs[previousSongIndex].uri,
                                previousSongIndex,
                              );
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: bgDartColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
