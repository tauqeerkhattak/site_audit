import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:site_audit/controllers/auth_controller.dart';
import 'package:site_audit/screens/auth/confirm_detail.dart';
import 'package:site_audit/screens/auth/login.dart';
import 'package:site_audit/screens/auth/site_detail.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page!;
      notifyListeners();
    });
  }

  double get offset => _offset;

  double get page => _page;
}

class MapAnimationNotifier with ChangeNotifier {
  final AnimationController _animationController;

  MapAnimationNotifier(this._animationController) {
    _animationController.addListener(_onAnimationControllerChanged);
  }

  double get value => _animationController.value;

  void forward() => _animationController.forward();

  void _onAnimationControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationControllerChanged);
    super.dispose();
  }
}

double startTop(context) =>
    topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;

double endTop(context) => topMargin(context) + 32 + 16 + 8;

double oneThird(context) => (startTop(context) - endTop(context)) / 3;

double topMargin(BuildContext context) =>
    MediaQuery.of(context).size.height > 700 ? 128 : 64;

double mainSquareSize(BuildContext context) =>
    MediaQuery.of(context).size.height / 2;

double dotsTopMargin(BuildContext context) =>
    topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;

double bottom(BuildContext context) =>
    MediaQuery.of(context).size.height - dotsTopMargin(context) - 8;

//TODO: Shoud be a field passed in constructor but this weak is quicker...
EdgeInsets? mediaPadding;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  AnimationController? _mapAnimationController;
  AuthController controller = Get.find<AuthController>();
  PageController _pageController = PageController();
  int index = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _mapAnimationController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    mediaPadding = MediaQuery.of(context).padding;
    return ChangeNotifierProvider(
      create: (context) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              LoginScreen(controller: controller,),
              ConfirmDetail(),
              SiteDetail()
            ],
          ),
        ),
      ),
    );
  }
}
