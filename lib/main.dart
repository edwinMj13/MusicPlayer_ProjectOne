import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_project_one/modal_class/favoriteslistmodal.dart';
import 'package:music_player_project_one/modal_class/playlistmodal.dart';
import 'package:music_player_project_one/screens/login.dart';
import 'package:music_player_project_one/modal_class/db_modalclass.dart';
import 'package:music_player_project_one/modal_class/songList.dart';
import 'package:music_player_project_one/screens/home_page.dart';
import 'package:music_player_project_one/utils/colors.dart';

import 'modal_class/playlistnames.dart';

 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(DbModalClassAdapter().typeId)) {
    Hive.registerAdapter(DbModalClassAdapter());
  }
  if(!Hive.isAdapterRegistered(AlbumDetailsAdapter().typeId)) {
    Hive.registerAdapter(AlbumDetailsAdapter());
  }
  if(!Hive.isAdapterRegistered(ModalClassAllSongsAdapter().typeId)) {
    Hive.registerAdapter(ModalClassAllSongsAdapter());
  }
  if(!Hive.isAdapterRegistered(PlayListNameAdapter().typeId)) {
    Hive.registerAdapter(PlayListNameAdapter());
  }
  if(!Hive.isAdapterRegistered(PlayListModalClassAdapter().typeId)) {
    Hive.registerAdapter(PlayListModalClassAdapter());
  }
  if(!Hive.isAdapterRegistered(FavoritesListModalClassAdapter().typeId)) {
    Hive.registerAdapter(FavoritesListModalClassAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: appThemeT),
        primaryColor: appThemeT,
      ),
      home:  const SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
   const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Box boxSignup;
  late dynamic userStatus;
  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    openBoxes();
  }
  void openBoxes()async{
    boxSignup = await Hive.openBox("signup");
    userStatus=boxSignup.get("userStatus");
    await Hive.openBox<ModalClassAllSongs>("allSongs2");
    await Hive.openBox("SongLength");
    await Hive.openBox<List<String>>("albumNames");
    await Hive.openBox<ModalClassAllSongs>("playlist");
    await Hive.openBox<PlayListName>("playlistNames");
    await Hive.openBox<ModalClassAllSongs>("favorites");
    await Hive.openBox("playing");
    await Hive.openBox<ModalClassAllSongs>("recent");
    getValues(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appThemeT,
        body: Center(child: SvgPicture.asset(
          "assets/appsplash_icon.svg", height: 100, width: 100,)),
  );
  }

  void getValues(BuildContext context) {
    if (userStatus!=null && userStatus == "loggedIn") {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return const HomePage();
      }));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return const LoginPage();
      }));
    }
  }
}



