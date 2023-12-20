import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_project_one/contentWidget/albumfile.dart';
import 'package:music_player_project_one/contentWidget/playlistfile.dart';
import 'package:music_player_project_one/utils/controllers.dart';
import 'package:music_player_project_one/screens/all_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../hive_db/db_albums.dart';
import '../hive_db/db_functions.dart';
import '../modal_class/songList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PlayerControllers playerControllers = PlayerControllers();
  List<SongModel> songlist = [];
  List<SongModel> modalAll = [];
  List<String> albumNAMES = [];
  List<ModalClassAllSongs> allSongsList = [];
  var syncClicked = false;
  var clickedfiles = false;
  late BuildContext mainContext;
  var playlistAddFloating = true;
  List<Tab> tabs = <Tab>[
    const Tab(
      text: "Albums",
    ),
    const Tab(
      text: "Playlists",
    )
  ];

  //late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStoragePermission();
    //  tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerControllers.audioPlayer.dispose();
  }


  /*
  * added default tab controller globally
  * to change floating icon to playsection to add to playlist
  *
  * */



  void requestStoragePermission() async {
    var permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
    } else {
      requestStoragePermission();
    }
  }

/*
  getsongFiles() {
    Directory dir = Directory('/storage/emulated/0/');
    String mp3path = dir.toString();
    print(mp3path);
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }
    print("SONGS $_songs");
    print(_songs.length);
  }
*/

  @override
  Widget build(BuildContext context) {
    getALbums();
    mainContext = context;
    print("Home Page Song Status ${playerControllers.audioPlayer}");
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
          length: tabs.length,
          child: Builder(builder: (BuildContext ctx) {
            final tabController =
            DefaultTabController.of(ctx);
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                print(tabController.index);
                if(tabController.index==1){
                  playlistAddFloating=true;
                }else{
                  playlistAddFloating=false;
                }
              }
            });
            return Scaffold(
              backgroundColor: Colors.blueGrey,
              floatingActionButton: playlistAddFloating
                  ? FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(
                        Icons.add,
                        color: Colors.blueGrey,
                      ))
                  : null,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Audio Mix"),
                actions: <Widget>[
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(value: 1, child: Text("Sync")),
                      ];
                    },
                    onSelected: (value) {
                      futureSyncMethod();
                    },
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    //   height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: topRow(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        TabBar(
                            isScrollable: false,
                            indicatorColor: Colors.white,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            tabs: tabs),
                        const Expanded(
                          child: TabBarView(children: [
                            AlbumList(),
                            //   albumListView(),
                            //    playListView();,
                            PlayNameWidget(),
                          ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );

          })),
    );
  }

  Widget topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            boxShadow: const [BoxShadow(color: Colors.grey)],
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: 80,
          width: 80,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return AllSongsScreen(
                  fromPageName: "all",
                  title: 'All Songs',
                );
              }));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "All",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: 80,
          width: 80,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return AllSongsScreen(
                  fromPageName: 'favorite',
                  title: "Favorites",
                );
              }));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, color: Colors.white, size: 30),
                SizedBox(
                  height: 10,
                ),
                Text("Favourites", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: 80,
          width: 80,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.queue_music, color: Colors.white, size: 30),
              SizedBox(
                height: 10,
              ),
              Text("Recent", style: TextStyle(color: Colors.white)),
            ],
          ),
        )
      ],
    );
  }

/*
  Widget albumListView(){
    return ValueListenableBuilder(
        valueListenable: db_Notifier,
        builder: (BuildContext context, List<String> value,
            Widget? child) {
          print("Albums length ${value.length}");
          if (value.isEmpty) {
            return const Center(
              child: Text("No Data"),
            );
          } else if (value == null) {
            return const Center(
              child: Text("No Data"),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              itemCount: value.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                var itemSong = value[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return AlbumPlayList(
                        albumName: itemSong,
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/album_icon.svg",
                          height: 140,
                          width: 140,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(fontSize: 15.0),
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white),
                            text: itemSong,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }
  */
  /* Widget playListView() {
    return ValueListenableBuilder(
        valueListenable: valueListenable,
        builder: builder);
  }*/

  void doSaveToHive(List<SongModel> modalAll, List<String> uniquelist) async {
    print("await getLength() ${await getLength()}");
    if (await getLength() != modalAll.length) {
      clearAllSongsBox("allSongs2");
      forHive(modalAll);
      saveAlbum(uniquelist);
      clickedfiles = false;
      dataFound();
    } else {
      clickedfiles = true;
      dataFound();
    }
  }

  forHive(List<SongModel> itemSong) {
    for (var element in itemSong) {
      ModalClassAllSongs modalClassAllSongs = ModalClassAllSongs(
          uri: element.uri,
          artist: element.artist,
          title: element.title,
          display_name: element.displayName,
          album: element.album,
          id: element.id);
      addAllSongs(modalClassAllSongs);
    }
  }

  saveAlbum(List<String> uniquelist) async {
    final albumDb = Hive.box<List<String>>("albumNames");
    albumDb.put("idAlbum", uniquelist);
  }

  void futureSyncMethod() async {
    List<SongModel> songModal = await PlayerControllers().audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        );
    print("await songModal  ${await songModal}");
//  songlist.add(await songModal);

    modalAll.clear();
    if (songModal.isNotEmpty) {
      for (var elem in songModal) {
        if (elem.title.length == 14) {
          if (elem.title.substring(0, 14) != "Call recording") {
            modalAll.add(elem);
          }
        } else if (elem.title.length > 13 &&
            elem.title.substring(0, 14) != "Call recording") {
          modalAll.add(elem);
        } else if (elem.title.length <= 13) {
          modalAll.add(elem);
        }
      }
      for (int i = 0; i < modalAll.length; i++) {
        albumNAMES.add(modalAll[i].album!);
      }
      var seen = <String>{};
      List<String> uniquelist =
          albumNAMES.where((alb) => seen.add(alb)).toList();
      print("uniquelist    $uniquelist");

      doSaveToHive(modalAll, uniquelist);
    }
  }

  void dataFound() {
    if (clickedfiles == true) {
      playerControllers.scaffoldMessage(mainContext, "No New Data Found!");
    } else {
      playerControllers.scaffoldMessage(mainContext, "New Data Updated!");
    }
  }
}
