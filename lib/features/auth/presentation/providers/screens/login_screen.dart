import 'package:eventify/core/router/app_router.dart';
import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/divider_widget.dart';
import 'package:eventify/core/widgets/redirect_page_text_widget.dart';
import 'package:eventify/core/widgets/text_field_widget.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool obscurePassword = true;

  String? emailError;
  String? passwordError;

  @override
  void initState(){
    super.initState();
    emailController.addListener(_onChangedField);
    passwordController.addListener(_onChangedField);
  }

  void _onChangedField(){
    setState(() {
      
    });
  }

  @override
  void dispose(){
    emailController.removeListener(_onChangedField);
    passwordController.removeListener(_onChangedField);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool get _isFormField => emailController.text.trim().isNotEmpty && passwordController.text.isNotEmpty;

  Future<void> _handleLogin() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if(emailController.text.trim().isEmpty){
      emailError = "please input a valid email address";
    }
    if(passwordController.text.isEmpty){
      passwordError = "please input a valid password";
    }

    await ref.read(authControllerProvider.notifier).signIn(email: emailController.text.trim(), password: passwordController.text.trim());
    final state = ref.read(authControllerProvider);
    if(state.hasError && mounted){
      final msg = state.error.toString();
      setState(() {
        if(msg.contains("invalid email")){
          emailError = "please input a valid email";
        }
        if(msg.contains("wrong password")){
          passwordError = "please input the correct password or email";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final canSubmit = _isFormField && !isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: ()=> context.go(AppRoutes.signup),
                      child: PhosphorIcon(PhosphorIcons.arrowLeft())
                    )
                  ],
                ),
                SizedBox(height: 16,),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 6,),
                Text(
                  "Create events, create memories, share memories",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 24,),
                Textfieldwidget(title: "Email", hintText: "enter your email", textEditingController: emailController,),
                SizedBox(height: 16,),
                Textfieldwidget(title: "Password", hintText: "enter your password", textEditingController: passwordController, obscureText: obscurePassword,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
                SizedBox(height: 24,),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: canSubmit ? _handleLogin : null, 
                    child: isLoading? 
                    SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CustomProgressIndicator()
                    ) : 
                    Text(
                      "Continue",
                    )
                  ),
                ),
                SizedBox(height: 24,),
                Dividerwidget(text: "OR"),
                SizedBox(height: 24,),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: null,
                    child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "lib/core/assets/icons/google_logo.svg",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "Sign in with Google",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    )
                  ),
                ),
                SizedBox(height: 128,),
                RedirectPageTextWidget(message: "Do not have an account? ", redirectedPage: "Register", onTap: () => context.go(AppRoutes.signup),)

              ],
            ),
          ),
        )
      ),
    );
  }
}