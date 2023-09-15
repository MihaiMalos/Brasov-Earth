import 'package:brasov_earth/router/app_router.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_cubit.dart';
import 'package:brasov_earth/screens/search_page/cubit/search_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BrasovEarth());
}

class BrasovEarth extends StatelessWidget {
  BrasovEarth({super.key});

  final AppRouter _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider(
          create: (context) => SearchPageCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Brasov Earth',
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
