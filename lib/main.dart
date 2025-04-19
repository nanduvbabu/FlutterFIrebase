import 'package:crud/pages/product/add_product_page.dart';
import 'package:crud/pages/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:crud/services/firebase_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:crud/pages/authentication/register.dart';
import 'package:crud/pages/product/list_product.dart';
import 'package:crud/pages/main/admin_home_page.dart';
import 'package:crud/constans/app_routes.dart';
import 'package:crud/pages/product/product_crud.dart';
import 'package:crud/pages/chat/chat.dart';
import 'package:crud/pages/chat/chat_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper initialization
  await Firebase.initializeApp(); // Initialize Firebase
  // Register FirebaseService as a singleton in GetIt
  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.login: (context) => BiometricLoginPage(),
        AppRoutes.admin: (context) => AdminHomePage(),
        // AppRoutes.productcrud: (context) => ProductCrud(),
        AppRoutes.productadd:(context)=> AddProductPage(),
        AppRoutes.list:(context)=> ProductListPage(),
        AppRoutes.user:(context)=> RegisterPage(),
        AppRoutes.productcrud: (context) => ChatListPage(),
        '/chat': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ChatPage(
            chatId: args['chatId'],
            receiverId: args['receiverId'],
            receiverEmail: args['receiverEmail'],
          );
        }
      },
    ),
  );
}
