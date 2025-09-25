import 'package:bloc_ing/blocApp/productEvent.dart';
import 'package:bloc_ing/blocApp/productBloc.dart';
import 'package:bloc_ing/blocApp/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(create: (_) => ProductBloc()..add(LoadProducts()), child: ProductPage()),
    );
  }
}
