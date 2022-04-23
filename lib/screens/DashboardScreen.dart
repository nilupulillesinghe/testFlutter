import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/helpers/commonFunctions.dart';
import 'package:test_flutter/helpers/screenNavigation.dart';
import 'package:test_flutter/helpers/style.dart';
import 'package:test_flutter/models/NewsModel.dart';
import 'package:test_flutter/models/ServerResponse.dart';
import 'package:test_flutter/screens/NewsViewScreen.dart';
import 'package:test_flutter/widgets/loading.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<NewsModel> topNewsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    _loaddata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    // controller: _userNameController,
                                    obscureText: false,
                                    enableSuggestions: false,
                                  ),
                                ),
                                Container(
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

                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: Container(
                              width: 33,
                              height: 33,
                              // color: Colors.redAccent,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/images/bell.png')
                                )
                              ),
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


                    Text("Latest News",style: TextStyle(fontFamily: 'NewYork',fontWeight: FontWeight.w700,fontSize: 18),),
                    Text("New York Small Semibold",style: TextStyle(fontFamily: 'NewYork',fontWeight: FontWeight.w700,fontSize: 20),),
                    GestureDetector(
                      onTap: () async {
                        await _loaddata();
                      },
                        child: Text("New York Small Semibold",style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w700,fontSize: 20),)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loaddata() async {
    setState(() {
      _isLoading = true;
    });
    ServerResponse serverResponse = await getData("https://newsapi.org/v2/top-headlines?country=us&apiKey=e820df172d4b4c00b46858d9c43f224f");

    setState(() {
      topNewsList = List<NewsModel>.from(
          List<Map<String, dynamic>>.from(jsonDecode(serverResponse.message)['articles'])
              .map((e) => NewsModel.fromMap(e))
              .toList());
      _isLoading = false;
    });
  }
}
