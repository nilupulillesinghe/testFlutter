import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:test_flutter/helpers/commonFunctions.dart';
import 'package:test_flutter/helpers/screenNavigation.dart';
import 'package:test_flutter/helpers/style.dart';
import 'package:test_flutter/models/GridDataModel.dart';
import 'package:test_flutter/models/NewsModel.dart';
import 'package:test_flutter/models/ServerResponse.dart';
import 'package:test_flutter/screens/LoginScreen.dart';
import 'package:test_flutter/screens/NewsViewScreen.dart';
import 'package:test_flutter/widgets/loading.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<NewsModel> topNewsList = [];
  List<NewsModel> mainNewsList = [];
  bool _isLoading = false;
  bool _isMainLoading = false;
  bool _isPagingLoading = false;
  bool _isMax = false;
  int page = 1;
  int sortBy = 0;

  List<GridDataModel> _tagList = [
    GridDataModel(true, "Reset"),
    GridDataModel(false, "Relevancy"),
    GridDataModel(false, "Popularity"),
    GridDataModel(false, "PublishedAt")
  ];

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    _loadData();
    _loadAllNews(page);
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isMainLoading && !_isMax && !_isPagingLoading){
        page = page+1;
        _loadAllNews(page);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? _lastPressedAt;

    return WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 1)) {
            Fluttertoast.showToast(
              fontSize: 12.0,
              msg: "Press again to exit the app",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              textColor: Colors.black87,
              gravity: ToastGravity.BOTTOM,
            );
            //Re-timed after two clicks of more than 1 second
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.95,
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.95 - 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0XFF818181).withOpacity(0.8),
                                        blurRadius: 0.2,
                                        spreadRadius: 0.2,
                                        // offset: Offset(0, 2),
                                      ),
                                    ]),
                                child: Row(
                                  children: [
                                    SizedBox(width: 13,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.95 - 113,
                                      child: TextFormField(
                                        textAlign: TextAlign.start,
                                        autocorrect: false,
                                        cursorColor: Color(0XFF818181).withOpacity(0.8),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.04,
                                          color: Color(0XFF818181),
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w600
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Dogecoin to the Moon...",
                                          hintStyle: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: Color(0XFF818181),
                                              fontSize:12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        controller: _searchController,
                                        obscureText: false,
                                        enableSuggestions: false,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if(_searchController.value.text != ""){
                                          await _searchNews(_searchController.value.text);
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          // color: Colors.redAccent,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage('assets/images/scope.png')
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.logout),
                                  color: Colors.red,
                                  onPressed: () {
                                    _logOutPop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Latest News",style: TextStyle(fontFamily: 'NewYork',fontWeight: FontWeight.w700,fontSize: 18),),
                              Text("See All  \u{2192}",style: TextStyle(fontFamily: 'Nunito',fontSize: 13,color: secondaryColor),),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        _isLoading ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Center(
                            child: Loading(),
                          ),
                        ) : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Center(
                            child: ListView.builder(
                              itemCount: topNewsList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_,index){
                                return GestureDetector(
                                  onTap: (){
                                    changeScreen(context, NewsViewScreen(newsModel: topNewsList[index],));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        width: 345,
                                        height: 240,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: Center(
                                                child: Loading(),
                                              ),
                                            ),
                                            Container(
                                              width: 345,
                                              height: 240,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${topNewsList[index].urlToImage}"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                            ),
                                            Container(

                                              // bottom: 22,
                                              // left: 5,
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: 345,
                                                height: 170,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black.withOpacity(0.8),
                                                        Colors.black.withOpacity(0.7),
                                                        Colors.black.withOpacity(0.6),
                                                        Colors.black.withOpacity(0.5),
                                                        Colors.black.withOpacity(0.025),
                                                      ],
                                                      begin: Alignment.bottomCenter,
                                                      end: Alignment.topCenter,
                                                    ),
                                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          "by ${topNewsList[index].author}",
                                                          style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w800,fontSize: 10,color: Colors.white,),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2,),
                                                      Container(
                                                        child: Text(
                                                          "${topNewsList[index].title}",
                                                          style: TextStyle(fontFamily: 'NewYork',fontWeight: FontWeight.w700,fontSize: 16,color: Colors.white),
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20,),
                                                      Container(
                                                        child: Text(
                                                          "${topNewsList[index].description}",
                                                          style: TextStyle(fontFamily: 'Nunito',fontSize: 10,color: Colors.white),
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        Container(
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: 35,
                                  child: ListView.builder(
                                    itemCount: _tagList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_,index){
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await _tagCall(index);
                                            },
                                            child: Container(
                                              decoration: _tagList[index].isSelected ? BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        Color(0XFFFF3A44),
                                                        Color(0xFFFF8086)
                                                      ])) : BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(25),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0XFF818181).withOpacity(0.8),
                                                      blurRadius: 0.2,
                                                      spreadRadius: 0.2,
                                                      // offset: Offset(0, 2),
                                                    ),
                                                  ]),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                                child: Center(
                                                    child: Text(
                                                      _tagList[index].name,
                                                      style: TextStyle(
                                                          color: _tagList[index].isSelected ? Colors.white : Color(0XFF2E0505),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: 'Nunito'),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text("News",style: TextStyle(fontFamily: 'NewYork',fontWeight: FontWeight.w700,fontSize: 18),)
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        _isMainLoading ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Center(
                            child: Loading(),
                          ),
                        ) : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.6,
                          child: Stack(
                            children: [
                              ListView.builder(
                                  controller: _scrollController,
                                  itemCount: mainNewsList.length,
                                  itemBuilder: (_,index){
                                    return Container(
                                      child: GestureDetector(
                                        onTap: (){
                                          changeScreen(context, NewsViewScreen(newsModel: mainNewsList[index],));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height*0.22,
                                              alignment: Alignment.center,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: Center(
                                                      child: Loading(),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.height*0.22,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage("${mainNewsList[index].urlToImage}"),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height*0.22,
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Colors.black.withOpacity(0.7),
                                                              Colors.black.withOpacity(0.6),
                                                              Colors.black.withOpacity(0.025),
                                                              Colors.black.withOpacity(0.025),
                                                              Colors.black.withOpacity(0.025),
                                                              Colors.black.withOpacity(0.025),
                                                            ],
                                                            begin: Alignment.bottomCenter,
                                                            end: Alignment.topCenter,
                                                          ),
                                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                                alignment: Alignment.topLeft,
                                                                child: Text(
                                                                  "${mainNewsList[index].title}",
                                                                  style: TextStyle(fontFamily: 'NewYork',fontSize: 14,color: Colors.white),
                                                                  maxLines: 2,
                                                                )
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${mainNewsList[index].author}",
                                                                    style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w600,fontSize: 12,color: Colors.white,),
                                                                    maxLines: 1,
                                                                  ),
                                                                  Text(
                                                                    "${DateFormat('EEEE, dd-MMM-yyyy').format(DateTime.parse(mainNewsList[index].publishedAt))}",
                                                                    style: TextStyle(fontFamily: 'Nunito',fontSize: 12,color: Colors.white,fontWeight: FontWeight.w600),
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                              Positioned(
                                bottom: 0,
                                child: _isPagingLoading && !_isMax ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: SpinKitFadingCircle(color: Colors.white70, size: 30.0),
                                  ),
                                ) : _isMax ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Max Reached...",
                                      style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w800,fontSize: 10,color: Colors.white,),
                                      maxLines: 1,
                                    ),
                                  ),
                                ) : Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  /// Initiate data load.
  _loadData() async {
    bool internetStatus = await checkInternet().catchError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Please check internet, Connectivity.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
      print("outer: $error");
    });
    if(internetStatus){
      setState(() {
        _isLoading = true;
      });
      ServerResponse serverResponse = await getData("https://newsapi.org/v2/top-headlines?country=us&apiKey=e820df172d4b4c00b46858d9c43f224f").catchError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: "Please contact Server Administrator. : ${error}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
        print("outer: $error");
      });

      setState(() {
        topNewsList = List<NewsModel>.from(
            List<Map<String, dynamic>>.from(jsonDecode(serverResponse.message)['articles'])
                .map((e) => NewsModel.fromMap(e))
                .toList());
        _isLoading = false;
      });
    }else{
      Fluttertoast.showToast(
          msg: "Internet Not Available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }

  /// Load news according to keyword.
  _searchNews(String keyword) async {
    for(int i = 0; i<_tagList.length;i++){
      if(i == 0){
        setState(() {
          _tagList[i].isSelected = true;
          sortBy = 0;
        });
      }else{
        setState(() {
          _tagList[i].isSelected = false;
        });
      }
    }
    bool internetStatus = await checkInternet().catchError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Please check internet, Connectivity.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
      print("outer: $error");
    });
    if(internetStatus){
      setState(() {
        _isMainLoading = true;
      });
      String url = "https://newsapi.org/v2/everything?q=" + keyword +"&from=2022-04-23&sortBy=popularity&apiKey=e820df172d4b4c00b46858d9c43f224f";
      ServerResponse serverResponse = await getData(url).catchError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: "Please contact Server Administrator. : ${error}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
        print("outer: $error");
      });

      setState(() {
        mainNewsList = List<NewsModel>.from(
            List<Map<String, dynamic>>.from(jsonDecode(serverResponse.message)['articles'])
                .map((e) => NewsModel.fromMap(e))
                .toList());
        _isMainLoading = false;
      });
    }else{
      Fluttertoast.showToast(
          msg: "Internet Not Available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }

  /// Load news according to passed parameters.
  _loadAllNews(int page) async {
    bool internetStatus = await checkInternet().catchError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Please check internet, Connectivity.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
      print("outer: $error");
    });
    if(internetStatus){
      setState(() {
        if(page == 1) {
          _isMainLoading = true;
        }else{
          _isPagingLoading = true;
        }
      });

      String url = "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com";
      if(sortBy > 0){
        url = url +"&sortBy=${_tagList[sortBy].name.toLowerCase()}";
      }
      url = url+ "&page=${page}" +"&apiKey=e820df172d4b4c00b46858d9c43f224f";

      ServerResponse serverResponse = await getData(url).catchError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: "Please contact Server Administrator. : ${error}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black45,
            fontSize: 16.0);
        print("outer: $error");
      });

      setState(() {
        if(serverResponse.isSuccess) {
          mainNewsList += List<NewsModel>.from(
              List<Map<String, dynamic>>.from(
                  jsonDecode(serverResponse.message)['articles'])
                  .map((e) => NewsModel.fromMap(e))
                  .toList());
        }else {
          _isMax = true;
        }
        if(page == 1) {
          _isMainLoading = false;
        }else{
          _isPagingLoading = false;
        }
      });
    } else{
      Fluttertoast.showToast(
          msg: "Internet Not Available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }

  /// Tag color change and load data according to selected tag.
  _tagCall(int index) async {
    _searchController.clear();
    for(int i = 0; i<_tagList.length;i++){
      if(i == index){
        setState(() {
          _tagList[index].isSelected = true;
        });
      }else{
        setState(() {
          _tagList[i].isSelected = false;
        });
      }
    }
    if(index == 0){
      setState(() {
        topNewsList = [];
        mainNewsList = [];
        _isLoading = false;
        _isMainLoading = true;
        _isPagingLoading = false;
        _isMax = false;
        page = 1;
        sortBy = 0;
      });
      await _loadData();
      await _loadAllNews(page);
    } else if(index > 0){
      setState(() {
        mainNewsList = [];
        _isLoading = false;
        _isMainLoading = true;
        _isPagingLoading = false;
        _isMax = false;
        page = 1;
        sortBy = index;
      });
      await _loadAllNews(page);
    }
  }

  /// Logout dialog popup.
  _logOutPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Are you sure, You want to logout?",
                    style: TextStyle(
                        color: Color(0XFF2E0505),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (){
                          changeScreenReplacement(context, LoginScreen());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "YES",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito'),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          backToPrevious(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "NO",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
