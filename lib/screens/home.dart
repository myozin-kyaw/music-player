import 'package:beats/controllers/player_controller.dart';
import 'package:beats/global/colors.dart';
import 'package:beats/screens/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: bgDartColor,
      appBar: AppBar(
        backgroundColor: bgDartColor,
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
          size: 28,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: whiteColor,
              size: 28,
            ),
          ),
        ],
        title: const Text(
          'Music Player',
          style: TextStyle(
            fontSize: 18,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Song found',
                style: TextStyle(
                  fontSize: 32,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Obx(
                        () => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: bgColor,
                          title: Text(
                            snapshot.data![index].displayNameWOExt.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index].artist.toString(),
                            style: const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),
                          trailing: controller.playIndex.value == index &&
                                  controller.isPlaying.value
                              ? const Icon(
                                  Icons.pause,
                                  color: whiteColor,
                                  size: 26,
                                )
                              : null,
                          onTap: () {
                            Get.to(
                              () => Player(
                                songs: snapshot.data!,
                              ),
                              transition: Transition.downToUp,
                            );
                            controller.playSong(
                              snapshot.data![index].uri,
                              index,
                            );
                          },
                        ),
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
