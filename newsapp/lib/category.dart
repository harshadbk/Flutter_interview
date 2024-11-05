import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/model.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class Catogory extends StatefulWidget {
  String queri;

  Catogory({
    required this.queri,
  });

  @override
  State<Catogory> createState() => _CatogoryState();
}

class _CatogoryState extends State<Catogory> {
  bool isLoading = true;
  List<newsqurymodel> newsmodellist = <newsqurymodel>[];
  getNewsByQuery(String queri) async {
    String url;
    if (queri == "Top News" || queri == "India") {
      url =
          "https://newsapi.org/v2/top-headlines?in=us&category=business&apiKey=b987869345984dbfaea0c0e06289708e";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$queri&from=2024-03-23&to=2024-03-23&sortBy=popularity&apiKey=b987869345984dbfaea0c0e06289708e";
    }
    Response resp = await get(Uri.parse(url));
    Map data = jsonDecode(resp.body);
    setState(() {
      data["articles"].forEach((element) {
        newsqurymodel newsquery = new newsqurymodel();
        newsquery = newsqurymodel.fromMap(element);
        newsmodellist.add(newsquery);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void initState() {
    getNewsByQuery(widget.queri);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 25, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.queri,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 39,
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Center(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                Visibility(
                                  visible:
                                      newsmodellist[index].newsImg.isNotEmpty,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
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
                                    height: 230,
                                    color: Colors.grey,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
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
                                      padding:
                                          EdgeInsets.fromLTRB(15, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsmodellist[index].newshead,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            newsmodellist[index]
                                                        .newsdes
                                                        .length >
                                                    50
                                                ? "${newsmodellist[index].newsdes.substring(0, 55)}..."
                                                : newsmodellist[index].newsdes,
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
                        onPressed: () {},
                        child: Text(
                          "Show More",
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
