import 'package:flutter/material.dart';
import 'package:test_flutter/helpers/screenNavigation.dart';
import 'package:test_flutter/models/NewsModel.dart';
import 'package:intl/intl.dart';
import 'package:test_flutter/widgets/loading.dart';

class NewsViewScreen extends StatefulWidget {
  final NewsModel newsModel;

  const NewsViewScreen({required this.newsModel});

  @override
  _NewsViewScreenState createState() => _NewsViewScreenState();
}

class _NewsViewScreenState extends State<NewsViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Loading(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("${widget.newsModel.urlToImage}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(MediaQuery.of(context).size.height*0.05),topRight: Radius.circular(MediaQuery.of(context).size.height*0.05)),
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                  Container(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.42,
                        child: ListView(
                          children: [
                            Text(
                              "${widget.newsModel.content}",style: TextStyle(fontFamily: 'Nunito',fontSize: 14,fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*0.28,
                left: MediaQuery.of(context).size.width*0.1,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.22,
                  decoration: BoxDecoration(
                      color: Color(0XFFF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height*0.02))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16,right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${DateFormat('EEEE, dd-MMM-yyyy').format(DateTime.parse(widget.newsModel.publishedAt))}",style: TextStyle(fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                        Text(
                          "${widget.newsModel.title}",style: TextStyle(fontFamily: 'NewYork',fontSize: 16,fontWeight: FontWeight.w700),
                          maxLines: 3,
                        ),
                        Text(
                          "Published by ${widget.newsModel.author}",style: TextStyle(fontFamily: 'Nunito',fontSize: 10,fontWeight: FontWeight.w800),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*0.05,
                left: MediaQuery.of(context).size.width*0.05,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Color(0XFFF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black45,
                    onPressed: () {
                      backToPrevious(context);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height*0.05,
                right: MediaQuery.of(context).size.width*0.05,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Color(0XFFF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/fab.png')
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
