import 'package:authphone/busniss_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:authphone/constant/component.dart';
import 'package:authphone/constant/my_colors.dart';
import 'package:authphone/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final phoneNumber;
  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  late String otpCode;

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your phone number.',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
              text: 'Enter your 6 digit code number sent to you at',
              style: TextStyle(color: Colors.black, fontSize: 18, height: 1.5),
              children: <TextSpan>[
                TextSpan(
                    text: ' $phoneNumber',
                    style: TextStyle(
                      fontSize: 18,
                      color: MyColors.blue,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return Container(
      child: PinCodeTextField(
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeColor: MyColors.blue,
          inactiveColor: MyColors.blue,
          inactiveFillColor: Colors.white,
          activeFillColor: MyColors.lightBlue,
          selectedColor: MyColors.blue,
          selectedFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (submitedCode) {
          otpCode = submitedCode;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
          // setState(() {
          //   currentText = value;
          // });
        },
        appContext: context,
      ),
    );
  }

  void _login(BuildContext context) {
    print('otpCode: $otpCode');

    BlocProvider.of<PhoneAuthCubit>(context).submitOTP(otpCode);
  }

  Widget _buildVerifyButton(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: ElevatedButton(
          onPressed: () {
            showProgressIndecator(context);
            _login(context);
          },
          child: Text(
            'Verify',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(110, 50),
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              )),
        ),
      );
  Widget _buildVerificationBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) showProgressIndecator(context);
        if (state is PhoneOTPVerified) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, mapScreen);
        }
        if (state is ErrorOccurred) {
          // Navigator.pop(context);
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMsg.toString(),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: widthSize / 12, vertical: heightSize / 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildIntroText(),
          SizedBox(
            height: heightSize / 10,
          ),
          _buildPinCodeFields(context),
          SizedBox(
            height: heightSize / 30,
          ),
          _buildVerifyButton(context),
          _buildVerificationBloc(),
        ]),
      ),
    ));
  }
}
