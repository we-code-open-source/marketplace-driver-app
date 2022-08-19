import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/statistic.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../repository/order_repository.dart';
import '../repository/user_repository.dart';

class ProfileController extends ControllerMVC {
  User user = new User();
  List<Order> recentOrders = [];
  GlobalKey<ScaffoldState>? scaffoldKey;
  Statistics statistics = new Statistics();
  OverlayEntry? loader;

  ///Image_picker
  final picker = ImagePicker();
  File? image;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForUser();
    listenForStatistics();
  }
  void imgFromCamera() async {
    try{
      final pickedFile = await  picker.getImage(
          source: ImageSource.camera
      );

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
          imageUpload(image!).then((value) {
            if(value) {
              ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
                content: Text('تم تحميل الصورة بنجاح'),
              ));
            }else  ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
              content: Text('للاسف هنالك خطأ! لمم يتم تحميل الصورة'),
            ));
          });
        } else {
          print('No image selected.');
        }
      });
    }catch(e){

    }
  }

  void imgFromGallery() async {
    try{
    final pickedFile = await  picker.getImage(
        source: ImageSource.gallery
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        imageUpload(image!).then((value) {
          if(value) {
              ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
                content: Text('تم تحميل الصورة بنجاح'),
              ));
            }else  ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
            content: Text('للاسف هنالك خطأ! لمم يتم تحميل الصورة'),
          ));
          });

      } else {
        print('No image selected.');
      }
    });
  }catch(e){

    }
  }



  void listenForStatistics({String? message}) async {
    getStatistics()
        .then((v) {
      setState(() => statistics = v!);
    });
  }
  void listenForUser({String? message}) async {
    getUserProfile().then((value) {
      setState(() {
        user = value!;
      });
    });
  }
  void updateDriverState(driverState) {
    try{
      updateDriverAvailable(driverState).then((v) {

        setState(() {});

      });

    }catch(e){
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text('حدث خطأ ما !'),
      ));

  }}
    Future<void> refreshUser() async {
      user=new User();
      listenForUser(message: S.of(state!.context)!.order_refreshed_successfuly);
    }
  void listenForRecentOrders({String? message}) async {
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() {
        recentOrders.add(_order);
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context)!.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshProfile() async {
    recentOrders.clear();
    user = new User();
    listenForRecentOrders(message: S.of(state!.context)!.orders_refreshed_successfuly);
    listenForUser();
  }
}
