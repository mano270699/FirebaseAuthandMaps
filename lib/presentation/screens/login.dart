import 'package:authphone/busniss_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:authphone/constant/component.dart';
import 'package:authphone/constant/my_colors.dart';
import 'package:authphone/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  late String phoneNumber;
  Widget _buildIntroText() {
    return Column(
      children: [
        Text(
          'What is yor phone number?',
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
          child: Text(
            'Please enter your phone number to verify your account.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberSubmitedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) showProgressIndecator(context);
        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          Navigator.pushNamed(context, otpScreen, arguments: phoneNumber);
        }
        if (state is ErrorOccurred) {
          Navigator.pop(context);
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

  Widget _buildFormField() => Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.lightGray),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _generateCountryFlag() + ' +20',
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.blue),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextFormField(
                autofocus: true,
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
                decoration: InputDecoration(border: InputBorder.none),
                cursorColor: MyColors.blue,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length < 11) {
                    return 'Please enter only 11 number ';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value!;
                },
              ),
            ),
          ),
        ],
      );
  String _generateCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      _formKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    } else {
      Navigator.pop(context);
      return;
    }
  }

  Widget _buildNextButton(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(context, otpScreen);
            showProgressIndecator(context);
            _register(context);
          },
          child: Text(
            'Next',
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

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: widthSize / 12, vertical: heightSize / 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroText(),
              SizedBox(
                height: heightSize / 20,
              ),
              _buildFormField(),
              SizedBox(
                height: heightSize / 10,
              ),
              _buildNextButton(context),
              _buildPhoneNumberSubmitedBloc(),
            ],
          ),
        ),
      ),
    ));
  }
}
