import 'package:bloc_ing/cubitBlocApp/productCubit.dart';
import 'package:bloc_ing/cubitBlocApp/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCubitApp extends StatelessWidget {
  const MyCubitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BloC Cubit CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(create: (_) => ProductCubit()..loadProducts(), child: ProductPage()),
    );
  }
}
