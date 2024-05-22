import 'package:esof/pages/stats/stats_widget.dart';
import 'package:esof/pages/validation/validation_widget.dart';
import 'package:esof/sigarraApi/session.dart';
import 'package:esof/sigarraApi/sigarraApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/firebase_auth/auth_util.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'backend/firebase/firebase_config.dart';
import 'backend/stripe/payment_manager.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await dotenv.load(fileName: "assets/.env");

  await initFirebase();

  await FlutterFlowTheme.initialize();

  await initializeStripe();

  runApp(const QuickFork());
}

class QuickFork extends StatefulWidget {
  const QuickFork({super.key});

  // This widget is the root of your application.
  @override
  State<QuickFork> createState() => _QuickForkState();

  static _QuickForkState of(BuildContext context) =>
      context.findAncestorStateOfType<_QuickForkState>()!;
}

class _QuickForkState extends State<QuickFork> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _appStateNotifier.username = prefs.getString('user_up_code') ?? "";
      _appStateNotifier.password = prefs.getString('user_password') ?? "";
      _appStateNotifier.faculty = prefs.getString('user_faculty') ?? "";
      _appStateNotifier.image_small =
          prefs.getString('user_image_small_small') ?? "";
      _appStateNotifier.image_big =
          prefs.getString('user_image_small_small') ?? "";
    });

    if (_appStateNotifier.username == "" ||
        _appStateNotifier.password == "" ||
        _appStateNotifier.faculty == "") {
      _router.goNamed('SigarraLogin');
    } else {
      Session? session = await sigarraLogin(
              _appStateNotifier.username, _appStateNotifier.password)
          .timeout(const Duration(seconds: 30));
      if (session == null) {
        _router.goNamed('SigarraLogin');
      }
    }

    userStream = esofFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    _loadData();
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quickfork',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;
  late AppStateNotifier _appStateNotifier;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> tabs;
    if (_appStateNotifier.isAdmin) {
      tabs = {
        'Store': ValidationWidget(),
        'HomePage': const HomePageWidget(),
        'StatsPage': const StatsWidget(),
      };
    } else {
      tabs = {
        'Store': const StoreWidget(),
        'HomePage': const HomePageWidget(),
        'PlaceHolder': const BoughtMealsWidget(),
      };
    }
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: const Color(0xFF2E1F1F),
        selectedItemColor: FlutterFlowTheme.of(context).alternate,
        unselectedItemColor: const Color(0x8A000000),
        showSelectedLabels: false,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.storefront_sharp,
              size: 24.0,
            ),
            label: 'Store',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 24.0,
            ),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.deck_outlined,
            ),
            label: 'Tickets',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
