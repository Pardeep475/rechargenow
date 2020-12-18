import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'message_list_model.dart';


class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  SharedPreferences prefs;
  List<MessageList> messagesList= [];
  var message = "";
  var imagePath = "";
  //bool _saving = false;
  var messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  var color_white=Colors.white;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadShredPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: toolbarLayout(
          AppLocalizations.of(context).translate("CUSTOMER SERVICE")
              .toUpperCase()
              .toUpperCase(),
          context),
      body: Container(
          height: double.infinity,
          color: color_white,
          child: buildBodyUI()),
    );
  }

  buildBodyUI() {
    return Container(
      color: color_white,
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Stack(
        children: <Widget>[
          Container(
              color: color_white,
              margin: EdgeInsets.only(bottom: 85),
              child: bodyUI_WithApi_listView()),
          sendMessageUi()
        ],
      ),
    );
  }

  onSendClick() {
    if (message.trim().length == 0) {
      MyUtils.showAlertDialog("Please type your message",context);
    } else {
      sendMessage();
    }
  }

  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage(image);
    print(image);
  }

  Future uploadmultipleimage(images, accessToken) async {
    print("accestoken:"+accessToken);
    /*setState(() {
      _saving = true;
    });*/
    MyUtils.showLoaderDialog(context);
    String apiUrl = '$BASE_URL/upload-message-file';
    var uri = Uri.parse(apiUrl);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers['accessToken'] = accessToken;
    request.headers['Content-Type']="multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW";
    request.headers['Content-Type']="application/x-www-form-urlencoded";
    request.headers['cache-control']="no-cache";

    List<MultipartFile> newList = new List<MultipartFile>();
    for (int i = 0; i < images.length; i++) {
      File imageFile = File(images[i].toString());
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      /*var length = await imageFile.length();
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: imageFile.path);*/
      http.MultipartFile multipartFile1 =
      await http.MultipartFile.fromPath('file', imageFile.path);
      newList.add(multipartFile1);
    }

    /*request.files.add(http.MultipartFile.fromBytes('file', await File.fromUri(Uri.parse(File(images[0].toString()).path)).readAsBytes(), contentType: new MediaType('application', 'x-tar')));
    var response = await request.send();
*/
    request.files.add(newList[0]);
    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
   // request.send().then((response){

      print(response.statusCode.toString());
      if (response.statusCode == 200) {
       /* setState(() {
          _saving = false;
        });*/
        Navigator.pop(context);
        print("Image Uploaded?");
        final jsonResponse = json.decode(value.toString());
        print("Uploaded>>>>>> "+jsonResponse.toString());
        //MyUtils.showAlertDialog(jsonResponse['message'].toString());
        if (jsonResponse['status'].toString() == "1") {
          imagePath = jsonResponse['imagePath'].toString();
          print("Image imagePath-------------- "+imagePath);

          sendMessage();
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        }
      } else {
        /*setState(() {
          _saving = false;
        });*/
        Navigator.pop(context);
        MyUtils.showAlertDialog(AllString.something_went_wrong,context);
        print("Upload Failed");
      }
    })
    ;
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    print(croppedFile);
    var filesList = List<String>();
    filesList.add(croppedFile.path);
    uploadmultipleimage(filesList, prefs.get('accessToken'));
  }

  sendMessageUi() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 50,bottom: 20),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                openCamera();
              },
              child: SvgPicture.asset(
                'assets/images/file.svg',
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Flexible(
              child: Container(
                height: 48,
               // margin: const EdgeInsets.only(bottom: 5),
                // padding: const EdgeInsets.all(3.0),
                decoration: new BoxDecoration(
                  border: Border.all(color: Colors.grey, width: .5),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                child: new Row(
                  children: <Widget>[
                    Flexible(
                      child: new Container(
                        margin: EdgeInsets.only(left: 20, top: 0, right: 0),
                        child: new TextField(
                          controller: messageController,
                          onTap: (){
                            Timer(Duration(milliseconds: 1000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

                          },
                          onChanged: (text) {
                            message = text;
                          },
                        //  textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).translate("Enter message"),
                              hintStyle: TextStyle(color: Colors.black)),
                        ), //flexible
                      ),
                    ),

                    Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(top: 3, bottom: 3),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle, //
                          color: primaryGreenColor,

                          // You can use like this way or like the below line
                        ),
                        child: GestureDetector(
                            onTap: () {
                              onSendClick();
                            },
                            child: new Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ))),
                    //container
                  ], //widget
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getMessagesApi() {
    var apicall = getUserMessagesApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          MessageListPojo stationsListPojo =
          MessageListPojo.fromJson(jsonResponse);
          messagesList = stationsListPojo.messageList;
          setState(() {

            Timer(Duration(milliseconds: 1000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

          });
        }
      else if (jsonResponse['status'].toString() == "0") {
        MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
      } else if (jsonResponse['status'].toString() == "2") {
        MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
      } else {
        MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
      }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong,context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  sendMessage() {
    var req;
    if (imagePath == "") {
      req = {
        "userId": prefs.get('userId').toString(),
        "message": message,
        //"imagePath": "/uploadedFiles/messages/22022020_210332726.png"
      };
    } else {
      req = {
        "userId": prefs.get('userId').toString(),
        "message": "",
        "imagePath": imagePath
      };
    }
    print(req);
    var jsonReqString = json.encode(req);
    var apicall =
        sendMessageApi(jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          print("msg submit final ->>>>>"+jsonResponse.toString());
        // MessageListPojo stationsListPojo = MessageListPojo.fromJson(jsonResponse);
        //messagesList.add(stationsListPojo.messageList);
        getMessagesApi();
        messageController.text = "";
        message = "";
        imagePath = "";

        //Timer(Duration(milliseconds: 1000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));


        }else if (jsonResponse['status'].toString() == "0") {
        MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
      } else if (jsonResponse['status'].toString() == "2") {
        MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
      } else {
        MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
      }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong,context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    getMessagesApi();
  }

  Widget bodyUI_WithApi_listView() {
    return messagesList == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Flexible(
            child: ListView.builder(
                // physics: ClampingScrollPhysics(),
                controller: _scrollController,
                // reverse: true,
                shrinkWrap: true,
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  //Datum datum = eventList.data[index];
                  return messagesList[index].sentBy == "User"
                      ? rightContainer(messagesList[index].message,
                          messagesList[index].imagePath)
                      : leftContainer(messagesList[index].message,
                          messagesList[index].imagePath);
                }),
          );
  }

/*
  leftContainer(text,imagePath){
*/
/*
      return Container(
        margin: const EdgeInsets.fromLTRB(0,10,70,0),
        padding:const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.centerLeft,

          child:Text(text,
            style: new TextStyle(
                color: color_white,
                //fontWeight: FontWeight.bold,
                fontSize: 14.0,fontWeight: FontWeight.bold)),
        ),

        decoration: new BoxDecoration(

          color:  color_blackChat,
         */ /*

*/
/* border: new Border.all(
              width: .5,
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.grey),*/ /*
*/
/*

          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
      );
*/ /*

      return Container(
        margin: const EdgeInsets.fromLTRB(0,10,70,0),
        padding: imagePath==null?EdgeInsets.all(10):EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            imagePath==null? Align(
          alignment: Alignment.centerLeft,
          child:Text(text,
              style: new TextStyle(
                  color: color_white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0,fontWeight: FontWeight.bold)),
        ):
            Column(children: <Widget>[
              Image.network(IMAGE_BASE_URL+imagePath,fit: BoxFit.fill,),
             // SizedBox(height: 5,)
            ],),

          ],
        ),

        decoration: new BoxDecoration(
          color:  color_blackChat,
          */
/* border: new Border.all(
              width: .5,
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.grey),*/ /*

          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
      );

  }
*/

/*  rightContainer(text,imagePath){
    return Container(
      //margin: const EdgeInsets.fromLTRB(70,10,0,0),
      padding: imagePath==null?EdgeInsets.all(10):EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          imagePath==null?Align(
        alignment: Alignment.centerRight,
        child:Text(text,
            style: new TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontSize: 14.0,fontWeight: FontWeight.bold)),
      ):
      Column(children: <Widget>[
      Image.network(IMAGE_BASE_URL+imagePath,fit: BoxFit.fill,),
     //SizedBox(height: 5,)
      ],),

        ],
      ),

      decoration: new BoxDecoration(
        color:  color_greyChat,
        */ /* border: new Border.all(
              width: .5,
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.grey),*/ /*
        borderRadius: const BorderRadius.all(
          const Radius.circular(8.0),
        ),
      ),
    );
  }*/

  rightContainer(text, imagePath) {
    return Row(mainAxisAlignment: MainAxisAlignment.end,
        //this will determine if the message should be displayed left or right
        children: [
          Flexible(
            //Wrapping the container with flexible widget
            child: Container(
                margin: imagePath == null
                    ? const EdgeInsets.fromLTRB(0, 10, 0, 0)
                    : const EdgeInsets.fromLTRB(80, 10, 0, 0),
                padding:
                    imagePath == null ? EdgeInsets.all(10) : EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  color: color_greyChat,
                  /* border: new Border.all(
              width: .5,
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.grey),*/
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                        //We only want to wrap the text message with flexible widget
                        child: Container(
                      child: imagePath == null
                          ? Text(text,
                              style: new TextStyle(
                                  color: Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold))
                          : Image.network(
                              IMAGE_BASE_URL + imagePath,
                              fit: BoxFit.fill,
                            ),
                    )),
                  ],
                )),
          )
        ]);
  }

  leftContainer(text, imagePath) {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
        //this will determine if the message should be displayed left or right
        children: [
          Flexible(
            //Wrapping the container with flexible widget
            child: Container(
                margin: imagePath == null
                    ? const EdgeInsets.fromLTRB(0, 10, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 10, 80, 0),
                padding:
                    imagePath == null ? EdgeInsets.all(10) : EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  color: color_blackChat,
                  /* border: new Border.all(
              width: .5,
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.grey),*/
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                        //We only want to wrap the text message with flexible widget
                        child: Container(
                      child: imagePath == null
                          ? Text(text,
                              style: new TextStyle(
                                  color: color_white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold))
                          : Image.network(
                              IMAGE_BASE_URL + imagePath,
                              fit: BoxFit.fill,
                            ),
                    )),
                  ],
                )),
          )
        ]);
  }
}
