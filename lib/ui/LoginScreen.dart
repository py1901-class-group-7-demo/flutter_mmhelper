import 'package:after_init/after_init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/ui/SignUpScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'Dashboard.dart';
import 'widgets/CountryListPopup.dart';
import 'widgets/platform_exception_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AfterInitMixin {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  String _message = '';
  String _verificationId;
  bool isShowSms = false;

  @override
  void didInitState() {
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();
  }


  void _verifyPhoneNumber() async {
    var getCountryList = Provider.of<GetCountryListService>(context);
    if (getCountryList.selectedLoginCountryCode == "Select Code") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please select dial code"),
      ));
    } else if (_phoneNumberController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please enter mobile"),
      ));
    } else {
      setState(() {
        _message = '';
      });
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _firebaseAuth.signInWithCredential(phoneAuthCredential);
        setState(() {
          _message = 'Received phone auth credential: $phoneAuthCredential';
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_message),
        ));
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        setState(() {
          _message =
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_message),
        ));
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Please check your phone for the verification code."),
        ));
        setState(() {
          isShowSms = true;
        });
        _verificationId = verificationId;
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber:
              "${getCountryList.selectedLoginCountryCode}${_phoneNumberController.text}",
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
  }

  void _signInWithPhoneNumber() async {
    if (_smsController.text != "") {
      print("sms");
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      try {
        print(_smsController.text);
        final FirebaseUser user =
            (await _firebaseAuth.signInWithCredential(credential)).user;
        final FirebaseUser currentUser = await _firebaseAuth.currentUser();
        assert(user.uid == currentUser.uid);

          if (user != null) {
            print("Successfully");
            _message = 'Successfully signed in, uid: ' + user.uid;
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return Dashboard();
            }), (Route<dynamic> route) => false);
          } else {
            _message = 'Sign in failed';
          }

      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please enter SMS code"),
      ));
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
      FocusScope.of(context).requestFocus(FocusNode());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var getCountryList = Provider.of<GetCountryListService>(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StateListPopup(
                              isFromLogin: true,
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              getCountryList.selectedLoginCountry,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.grey)
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StateListPopup(
                                        isFromLogin: true,
                                      );
                                    });
                              },
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.3)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          getCountryList
                                              .selectedLoginCountryCode,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.3)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: false, decimal: false),
                                    cursorColor: Theme.of(context).accentColor,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.call),
                                        hintText: "Mobile Number",
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  isShowSms? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: _smsController,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: false),
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.sms),
                                  hintText: "Enter SMS code",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: FlatButton(
                        onPressed:(){
                          if(isShowSms){
                            _signInWithPhoneNumber();
                          }else{
                            _verifyPhoneNumber();
                          }
                        } ,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                        shape: RoundedRectangleBorder(),
                        color: Colors.pink.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SignUpScreen();
                          }));
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                        )),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
