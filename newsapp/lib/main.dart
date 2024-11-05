import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project/category.dart';
import 'package:project/model.dart';
import 'package:http/http.dart';

//flutter run -d chrome --web-renderer html

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  _MyHomeAppState createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  List<newsqurymodel> newsmodellist = <newsqurymodel>[];
  bool isLoading = true;
  String url = "";

  getNewsByQuery(String queri) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$queri&from=2024-03-23&to=2024-03-23&sortBy=popularity&apiKey=b987869345984dbfaea0c0e06289708e";
    Response resp = await get(Uri.parse(url));
    Map data = jsonDecode(resp.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          newsqurymodel newsquery = new newsqurymodel();
          newsquery = newsqurymodel.fromMap(element);
          newsmodellist.add(newsquery);
          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
        } catch (e) {
          print(e);
        }
        ;
      }
    });
  }

  @override
  void initState() {
    getNewsByQuery("india");
    super.initState();
  }

  List<String> navbarItem = [
    "Top News",
    "India",
    "World",
    "Finance",
    "Health",
    "GDP Grade",
    "Sports",
    "Education",
    "crime",
    "geography",
    "polity",
    "governance"
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController controller;
    bool useCustomController = true;

    if (useCustomController) {
      controller = TextEditingController();
    }

    var news_name = [
      "GDP Grade",
      "Sports",
      "Education",
      "crime",
      "geography",
      "polity",
      "governance"
    ];
    final _random = new Random();
    var news = news_name[_random.nextInt(news_name.length)];
    return Scaffold(
      appBar: AppBar(
        title: Text('NEWS APP'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                //search container
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((controller.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Catogory(queri: controller.text),
                            ),
                          );
                        }
                      },
                      child: Container(
                        child: Icon(Icons.search, color: Colors.blue),
                        margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Catogory(queri: value),
                            ),
                          )
                        },
                        decoration: InputDecoration(
                            hintText: "Search any News $news",
                            border: InputBorder.none),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navbarItem.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Catogory(queri: navbarItem[index]),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            navbarItem[index],
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: 350,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true),
                  items: newsmodellist.map((instance) {
                    return Builder(builder: (BuildContext context) {
                      try {
                        return Container(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    child: Image.network(
                                      instance.newsImg,
                                      fit: BoxFit.fitHeight,
                                      height: 230,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Placeholder(
                                          fallbackHeight: 230,
                                          fallbackWidth: double.infinity,
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 15),
                                            child: Text(
                                              "News Is Here",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )))
                                ],
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        print(e);
                        return Container();
                      }
                    });
                  }).toList(),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 25, 10, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "LATEST NEWS",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.pink),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: newsmodellist.length,
                        itemBuilder: (context, index) {
                          try {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 1.0,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                        visible: newsmodellist[index]
                                            .newsImg
                                            .isNotEmpty,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            newsmodellist[index].newsImg,
                                            fit: BoxFit.fitHeight,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Placeholder(
                                                fallbackHeight: 230,
                                                fallbackWidth: double.infinity,
                                              );
                                            },
                                          ),
                                        ),
                                        replacement: Container(
                                          // Placeholder or alternative image
                                          height: 230,
                                          color:
                                              Colors.grey, // Placeholder color
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0),
                                                Colors.black,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 10, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsmodellist[index].newshead,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  newsmodellist[index]
                                                              .newsdes
                                                              .length >
                                                          50
                                                      ? "${newsmodellist[index].newsdes.substring(0, 55)}..."
                                                      : newsmodellist[index]
                                                          .newsdes,
                                                  style: TextStyle(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        }),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Catogory(queri: "Technology"),
                                  ),
                                );
                              },
                              child: Text(
                                "Show More",
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  final List items = [
    Colors.blue,
    Colors.pink,
    Colors.red,
    Colors.green,
    Colors.yellow
  ];
}
