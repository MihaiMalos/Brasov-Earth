import 'package:brasov_earth/screens/search_page/cubit/search_page_cubit.dart';
import 'package:brasov_earth/screens/search_page/cubit/search_page_state.dart';
import 'package:brasov_earth/screens/search_page/view/widgets/search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _searchNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100),
        () => FocusScope.of(context).requestFocus(_searchNode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 10,
              left: 15,
              right: 15,
            ),
            child: SearchBar(
              onSubmitted: (text) async {
                await context.read<SearchPageCubit>().searchByText(text);
              },
              controller: _searchController,
              leading: IconButton(
                onPressed: () {
                  _searchNode.unfocus();
                  _searchController.clear();
                  Navigator.of(context).pop();
                  context.read<SearchPageCubit>().resetPage();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25,
                ),
                color: Colors.black.withOpacity(0.7),
              ),
              hintText: 'Search here',
              focusNode: _searchNode,
              textStyle: const MaterialStatePropertyAll(TextStyle(
                fontSize: 18,
              )),
              hintStyle: MaterialStatePropertyAll(TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              )),
              elevation: const MaterialStatePropertyAll(0),
              constraints: const BoxConstraints(minHeight: 48),
              side: const MaterialStatePropertyAll(BorderSide(width: 0.2)),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchPageCubit, SearchPageState>(
              builder: (context, state) {
                final searchOutput = state.searchedLandmarks;
                final elementsCount =
                    searchOutput.length > 10 ? 10 : searchOutput.length;
                final currentCoordinates =
                    context.read<SearchPageCubit>().mapCenterCoordinates;

                return elementsCount == 0
                    ? const SizedBox()
                    : SearchList(
                        landmarkList: searchOutput,
                        maximumElementsCount: elementsCount,
                        currentCoordinates: currentCoordinates,
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}


/*

Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).viewPadding.top + 10,
            horizontal: 15),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                  color: Colors.black.withOpacity(0.5),
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search here",
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

*/