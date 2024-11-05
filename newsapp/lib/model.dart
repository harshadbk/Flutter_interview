class newsqurymodel {
  late String newshead;
  late String newsdes;
  late String newsImg;
  late String newsurl;

  newsqurymodel({
    this.newshead = "NEWS HEADLINE",
    this.newsdes = "Some News",
    this.newsImg = "Some Img",
    this.newsurl = "Some url",
  });

  factory newsqurymodel.fromMap(Map news) {
    return newsqurymodel(
        newshead: news["title"],
        newsdes: news["description"],
        newsImg: news["urlToImage"] != null && news["urlToImage"] != ""
            ? news["urlToImage"]
            : "images/news.jpg",
        newsurl: news["url"]);
  }
}
