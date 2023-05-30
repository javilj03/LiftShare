import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lift_share/constants.dart';
import './Profile/ProfileRoutine.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  int index = 0;

  late TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 140,
        child: Column(
          children: [
            Container(
              color: Color(ORANGE),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1564564295391-7f24f26f568b")),
                        const SizedBox(height: 10),
                        Text("Junaid Khan")
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 208, 134, 14),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                    BLACK), // Utilizamos Colors.black para el color negro
                                offset: Offset(0, 2),
                                blurRadius: 2,
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text("16"),
                              const SizedBox(height: 5),
                              Text(
                                "Posts",
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 208, 134, 14),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                    BLACK), // Utilizamos Colors.black para el color negro
                                offset: Offset(0, 2),
                                blurRadius: 2,
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text("158"),
                              const SizedBox(height: 5),
                              Text("Followers")
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 208, 134, 14),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                    BLACK), // Utilizamos Colors.black para el color negro
                                offset: Offset(0, 2),
                                blurRadius: 2,
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text("1,425"),
                              const SizedBox(height: 5),
                              Text("Following")
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                color: Color(ORANGE),
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Story Highlights"),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Keep your favourite stories on your profile")
                        ],
                      ),
                      flex: 9,
                    ),
                  ],
                )),
            Container(
              color: Color(ORANGE),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 0.8,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                controller: tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.camera_alt)),
                  Tab(icon: Icon(Icons.calendar_month)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _postsDisplay(),
                  _routineDisplay(scrollController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _routineDisplay(ScrollController routineScrollController) {
    return ProfileRoutine(
      scrollController: routineScrollController,
    );
  }

  Widget _postsDisplay() {
    return Text('posts');
  }

  Widget favouriteStoriesWidget() {
    return const Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: CircleAvatar(
        radius: 33,
        backgroundColor: Color(0xFF3E3E3E),
      ),
    );
  }
}
