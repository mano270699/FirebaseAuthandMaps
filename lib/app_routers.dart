import 'package:authphone/presentation/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:authphone/busniss_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:authphone/constant/strings.dart';
import 'package:authphone/presentation/screens/login.dart';
import 'package:authphone/presentation/screens/otp_screen.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;
  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(builder: (_) => MapScreen());
      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: LoginScreen(),
                ));
      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => PhoneAuthCubit(),
                  child: OtpScreen(
                    phoneNumber: phoneNumber,
                  ),
                ));
    }
  }
}
