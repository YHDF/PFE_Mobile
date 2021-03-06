import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfe_mobile/background.dart';
import 'package:pfe_mobile/check_feedbacks.dart';
import 'package:pfe_mobile/device_dimensions.dart';
import 'package:pfe_mobile/home.dart';
import 'package:pfe_mobile/message.dart';
import 'package:pfe_mobile/user_favorites.dart';
import 'bottom_bar.dart';
import 'side.dart';
import 'Globals.dart' as globals;

class user_profile extends StatefulWidget {
  user_profileState createState() => user_profileState();
}

class user_profileState extends State<user_profile>
    with TickerProviderStateMixin {
  double dev_width, dev_height;
  AnimationController opacity_controller;
  Animation<double> opacity_anim;
  static double opacity = 0;
  final _controller = TextEditingController();
  static bool editable = false;
  bool hidden = true;
  String str;
  static double icon_opacity = 1;

  @override
  void initState() {
    setState(() {
      super.initState();
      str = '';
      opacity_controller =
          AnimationController(vsync: this, duration: Duration(seconds: 1));
      opacity_anim = Tween<double>(begin: 0, end: 0.9).animate(CurvedAnimation(
        parent: opacity_controller,
        curve: Interval(0.5, 1, curve: Curves.linear),
      ));
      opacity_controller.addListener(() {
        setState(() {
          opacity = opacity_anim.value;
        });
      });
      opacity_controller.forward();
    });
  }

  void change_name() async {
    await Future<Message>(() async {
      final response = await http.put(
          '${globals.MyGlobals.link_start}/api/user?api_token=${globals.MyGlobals.api_token}&name=${globals.MyGlobals.current_user.name}');
      if (response.statusCode == 200) {
        return Message.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Profile');
      }
    }).then((value) {
      setState(() {
        hidden = false;
        str = 'Click the button down below to confirm changes!';
      });
    });
  }

  @override
  void dispose() {
    opacity_controller.dispose();
    super.dispose();
  }

  Future<bool> _onpress() async {
    setState(() {
      bottom_barState.page_counter = 1;
      side_barState.lst_selected_side[0] = false;
      Navigator.pop(context);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        bottom_barState.visible = false;
      } else {
        bottom_barState.visible = true;
      }
    });
    dev_width = device_dimensions(context).dev_width;
    dev_height = device_dimensions(context).dev_height;
    return WillPopScope(
      onWillPop: _onpress,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Background(),
            GestureDetector(
              child: Container(
                width: dev_width,
                height: dev_height,
                alignment: Alignment(0, 0),
                child: Container(
                  width: dev_width,
                  height: 7 * dev_height / 8,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        alignment: Alignment(0, 0),
                        child: Text(
                          ' HELLO, ',
                          style: TextStyle(
                            fontSize: dev_height > dev_width ? dev_width / 10.3 : dev_height / 10.3,
                            fontWeight: FontWeight.w200,
                            color: globals.MyGlobals.lightcolor.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Divider(),
                      new editablecontainer(
                          globals.MyGlobals.current_user.name),
                      Visibility(
                        visible: editable,
                        child: Container(
                          width: dev_width,
                          height: dev_height / 6,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 2 * dev_width / 3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: globals.MyGlobals.lightcolor,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: globals.MyGlobals.lightcolor,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    hintStyle: TextStyle(
                                      color: globals.MyGlobals.lightcolor,
                                      fontSize: dev_height > dev_width
                                          ? dev_height / 29.28
                                          : dev_height / 16.48,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: dev_height / 32,
                              ),
                              Container(
                                height: dev_height / 18,
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      editable = false;
                                      globals.MyGlobals.current_user.name =
                                          _controller.text;
                                      change_name();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment(0, 0),
                                    width: dev_width / 3,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: globals.MyGlobals.lightcolor, width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: globals.MyGlobals.lightcolor,
                                        fontSize: dev_height > dev_width ? dev_width / 20.6 : dev_height / 20.6,
                                        fontWeight: FontWeight.w200
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        alignment: Alignment(0, 0),
                        child: Text(
                          ' YOU HAVE : ',
                          style: TextStyle(
                            fontSize: dev_height > dev_width ? dev_width / 10.3 : dev_height / 10.3,
                            fontWeight: FontWeight.w200,
                            color: globals.MyGlobals.lightcolor.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Divider(),
                      viewable_container(
                          globals.MyGlobals.favorite_count.toString(),
                          IconData(59517, fontFamily: 'MaterialIcons'),true),
                      Divider(),
                      viewable_container(
                          globals.MyGlobals.feedback_count.toString(),
                          IconData(57534, fontFamily: 'MaterialIcons',),false),
                      Divider(),
                      Container(
                        alignment: Alignment(0, 0),
                        child: Text(
                          'WITH EMAIL :',
                          style: TextStyle(
                            fontSize: dev_height > dev_width ? dev_width / 10.3 : dev_height / 10.3,
                            fontWeight: FontWeight.w200,
                            color: globals.MyGlobals.lightcolor.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Divider(),
                      viewable_container(
                          globals.MyGlobals.current_user.email, null,null),
                      Container(
                        height: dev_height / 12,
                        child: Visibility(
                          visible: !hidden,
                          child: Container(
                            alignment: Alignment(0, 1),
                            child: Text(
                              str,
                              style: TextStyle(
                                color: globals.MyGlobals.lightcolor,
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: dev_height / 12,
                        color: Colors.transparent,
                      ),
                      Container(
                        height: dev_height / 12,
                        alignment: Alignment(0, 1),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                          child: Container(
                            width: dev_height / 16,
                            height: dev_height / 16,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: globals.MyGlobals.lightcolor, width: 0.5),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Icon(
                                IconData(58139, fontFamily: 'MaterialIcons'),
                                color: globals.MyGlobals.lightcolor..withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom_bar(),
          ],
        ),
        drawer: side_bar(),
      ),
    );
  }
}

class editablecontainer extends StatefulWidget {
  String data;

  editablecontainer(String data) {
    this.data = data;
  }

  editablecontainerState createState() => editablecontainerState(data);
}

class editablecontainerState extends State<editablecontainer> {
  String data;

  editablecontainerState(String data) {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: device_dimensions(context).dev_width,
        height: device_dimensions(context).dev_height / 16,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment(0, 0),
              child: FlatButton(
                onPressed: () {},
                child: Container(
                  width: 7 * device_dimensions(context).dev_width / 8,
                  alignment: Alignment(0, 0),
                  child: Text(
                    data,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: globals.MyGlobals.lightcolor.withOpacity(user_profileState.opacity),
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: device_dimensions(context).dev_width,
              alignment: Alignment(1, 0),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    user_profileState.editable =
                        user_profileState.editable ? false : true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => user_profile()),
                    );
                  });
                },
                child: Container(
                  width: device_dimensions(context).dev_width / 8,
                  alignment: Alignment(1,0),
                  child: Container(
                    width: device_dimensions(context).dev_width / 28,
                    child: Icon(
                      IconData(57680, fontFamily: 'MaterialIcons'),
                      size: 20,
                      color: globals.MyGlobals.lightcolor.withOpacity(user_profileState.opacity),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class viewable_container extends StatefulWidget {
  String data;
  IconData icon_data;
  bool isit;

  viewable_container(String data, IconData icon_data,bool isit) {
    this.data = data;
    this.icon_data = icon_data;
    this.isit = isit;
  }

  viewable_containerState createState() =>
      viewable_containerState(data, icon_data,isit);
}

class viewable_containerState extends State<viewable_container> {
  String data;
  IconData icondata;
  bool isit;

  viewable_containerState(String data, IconData icondata, bool isit) {
    this.data = data;
    this.icondata = icondata;
    this.isit = isit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: device_dimensions(context).dev_width,
        height: device_dimensions(context).dev_height / 16,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment(0, 0),
              child: Container(
                  width: 7 * device_dimensions(context).dev_width / 8,
                  alignment: Alignment(0, 0),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 7 * device_dimensions(context).dev_width / 8,
                          alignment: Alignment(-0.1, 0),
                          child: Text(
                            data,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: globals.MyGlobals.lightcolor.withOpacity(user_profileState.opacity),
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        Container(
                          width: 7 * device_dimensions(context).dev_width / 8,
                          alignment: Alignment(0.1, 0),
                          child: Icon(
                            icondata,
                            color: globals.MyGlobals.lightcolor.withOpacity(user_profileState.opacity),
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              width: device_dimensions(context).dev_width,
              alignment: Alignment(1, 0),
              child: Container(
                width: device_dimensions(context).dev_width / 8,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isit ? user_favorite() : Myfeedbacks()),
                    );
                  },
                  child: Container(
                    width: device_dimensions(context).dev_width / 8,
                    child: Icon(
                      IconData(58391, fontFamily: 'MaterialIcons'),
                      size: 20,
                      color: globals.MyGlobals.lightcolor.withOpacity(user_profileState.opacity),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
