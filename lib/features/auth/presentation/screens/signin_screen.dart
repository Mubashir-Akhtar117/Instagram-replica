import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/core/routes/app_routes_name.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/auth/presentation/bloc/signin_states.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/auth_bottom_section.dart';
import 'package:sample/core/utils/validators.dart';
import '../bloc/signin_bloc.dart';
import '../bloc/signin_event.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    context.read<SigninBloc>().add(
      SigninRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state.status == SigninStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutesName.home);
        }

        if (state.status == SigninStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? "Login failed")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _emailController.text = 'usertest1@gmail.com';
                      _passwordController.text = 'Abcd@123';
                    });
                  },
                  child: const Text(
                    'Instagram',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 48,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        hint: "Email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hint: "Password",
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 24),

                      BlocBuilder<SigninBloc, SigninState>(
                        builder: (context, state) {
                          if (state.status == SigninStatus.loading) {
                            return const CircularProgressIndicator();
                          }

                          return AuthButton(
                            text: "Log In",
                            onTap: _submitForm,
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.buttonText,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AuthBottomSection(
                  onForgotPassword: () {},
                  onFacebookLogin: () {},
                  onSignUp: () {
                    Navigator.pushNamed(context, AppRoutesName.signup);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
