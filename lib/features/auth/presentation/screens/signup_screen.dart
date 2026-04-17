import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/core/routes/app_routes_name.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/core/utils/app_snackbar.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/profile_image_picker.dart';
import '../widgets/auth_bottom_section.dart';
import 'package:sample/core/utils/validators.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignup() {
    final blocState = context.read<SignupBloc>().state;

    if (!_formKey.currentState!.validate()) return;

    if (blocState.profileImage == null) {
      AppSnackBar.error(context, "Please select a profile picture");
      return;
    }

    context.read<SignupBloc>().add(
      SignupRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        profileImage: blocState.profileImage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            AppSnackBar.success(context, "Signup successful");
            Navigator.pushReplacementNamed(context, AppRoutesName.signin);
          }

          if (state.status == SignupStatus.failure) {
            AppSnackBar.error(context, "Signup failed");
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Instagram',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Billabong',
                    fontSize: 48,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.profileImage != current.profileImage,
                  builder: (context, state) {
                    return ProfileImagePicker(
                      image: state.profileImage,
                      onImageSelected: (file) {
                        if (file != null) {
                          context.read<SignupBloc>().add(
                            ProfileImageChanged(file),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        hint: "Name",
                        controller: _nameController,
                        validator: Validators.name,
                      ),
                      const SizedBox(height: 16),
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
                      BlocBuilder<SignupBloc, SignupState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status,
                        builder: (context, state) {
                          if (state.status == SignupStatus.loading) {
                            return CircularProgressIndicator(
                              color: theme.primaryColor,
                            );
                          }

                          return AuthButton(
                            text: "Sign Up",
                            onTap: _onSignup,
                            backgroundColor: theme.primaryColor,
                            textColor:
                                theme.elevatedButtonTheme.style?.foregroundColor
                                    ?.resolve({}) ??
                                AppColors.buttonText,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AuthBottomSection(
                  onForgotPassword: () {},
                  onFacebookLogin: () {},
                  onSignUp: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
