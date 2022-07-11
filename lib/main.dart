import 'package:flutter/material.dart';
import 'customed_slider_widget.dart';
import 'time_keeping_by_month_response.dart';

import 'customed_date_picker.dart';
import 'data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _counter = 0;

  bool isEnableCheckin = true;
  bool isCheckedIn = false;
  bool isEnableCheckout = true;
  bool isCheckedOut = false;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Container(),
                  Column(
                    children: [
                      CustomedSliderWidget(
                        buttonTitle: Text(
                          'Trượt để Checkin',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: isCheckedIn || !isEnableCheckin
                              ? null
                              : LinearGradient(colors: [
                                  Color(0xff718CFB),
                                  Color(0xff71ADFB),
                                ]),
                          color: isCheckedIn || !isEnableCheckin
                              ? Colors.grey
                              : null,
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: isCheckedIn || !isEnableCheckin
                              ? Color(0xffF2F3F4)
                              : Color(0xffEAF0FF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundPadding: EdgeInsets.symmetric(vertical: 4),
                        reverse: false,
                        onComplete: (value) => setState(() {
                          isCheckedIn = value;
                        }),
                        height: 40,
                        status: isCheckedIn,
                        disable: isCheckedIn || !isEnableCheckin,
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '07:58',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff4D4D4D)),
                          ),
                        ),
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            '07:58',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                        ),
                      ),
                      CustomedSliderWidget(
                        buttonTitle: Text(
                          'Trượt để Checkout',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: isCheckedOut || !isEnableCheckout
                              ? null
                              : LinearGradient(colors: [
                                  Color(0xff718CFB),
                                  Color(0xff71ADFB),
                                ]),
                          color: isCheckedOut || !isEnableCheckout
                              ? Colors.grey
                              : null,
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: isCheckedOut || !isEnableCheckout
                              ? Color(0xffF2F3F4)
                              : Color(0xffEAF0FF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundPadding: EdgeInsets.symmetric(vertical: 4),
                        reverse: true,
                        onComplete: (value) => setState(() {
                          isCheckedOut = value;
                        }),
                        height: 40,
                        status: isCheckedOut,
                        disable: isCheckedOut || !isEnableCheckout,
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '07:58',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff4D4D4D)),
                          ),
                        ),
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            '07:58',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                        ),
                      ),
                      CustomedCalendar(
                        onChange: (newDateTime, dayDetail) {
                          print('''
          on picked date: ${newDateTime.toString()}, ${dayDetail?.afternoonTimekeeping.toString()}''');
                        },
                        data: TimeKeepingByMonthResponse.fromJson(jsonData),
                        isEnable: true,
                      ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: TabBar(
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Color(0xDD613896),
                    width: 5,
                  ),
                  insets: EdgeInsets.fromLTRB(0, 0.0, 0, 48),
                ),
                controller: _tabController,
                tabs: const <Widget>[
                  SizedBox(
                    height: 50,
                    child: Tab(
                      icon: Icon(
                        Icons.cloud_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Tab(
                      icon: Icon(
                        Icons.beach_access_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Tab(
                      icon: Icon(
                        Icons.brightness_5_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
