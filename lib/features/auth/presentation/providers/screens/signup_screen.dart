import 'package:eventify/core/router/app_router.dart';
import 'package:eventify/core/widgets/redirect_page_text_widget.dart';
import 'package:eventify/core/widgets/terms_checkbox.dart';
import 'package:eventify/core/widgets/text_field_widget.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool agreeToTermsAndConditions = false;
  bool checkBoxTick = false;

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleSignUp() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (!formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).singUp(email: emailController.text.trim(), password: passwordController.text);

    final state = ref.read(authControllerProvider);
    if (state.hasError && mounted){
      mapErrorToField(state.error);
    }
  }

  void mapErrorToField(Object? error){
    final errorMessage = error.toString();

    setState(() {
      if(errorMessage.contains("email-already-in-use")){
        emailError = "this email is already registered, try another one";
      }else if(errorMessage.contains("invalid-email")){
        emailError = "this email is not valid, enter a valid one";
      }else if(errorMessage.contains("weak-password")){
        passwordError = "password should at least be 6 characters long";
      }else { 
        emailError = "Error message check firebase";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => context.go(AppRoutes.login),
                        child: PhosphorIcon(PhosphorIcons.arrowLeft()),
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.displaySmall 
                  ),
                  SizedBox(height: 6,),
                  Text(
                    "Create events, create memories, share memories",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24,),
                  SizedBox(height: 6,),
                  Textfieldwidget(title: "Email", hintText: "enter your email", textEditingController: emailController,),
                  SizedBox(height: 16,),
                  Textfieldwidget(title: "Password", hintText: "enter your password", obscureText: true, textEditingController: passwordController,),
                  SizedBox(height: 16,),
                  Textfieldwidget(title: "Confirm Password", hintText: "confirm your password", obscureText: true,),
                  SizedBox(height: 64,),
                  TermsCheckbox(
                    value: checkBoxTick, 
                    onChanged: (val){
                      setState(() {
                        checkBoxTick = val ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: isLoading || !checkBoxTick ? null : handleSignUp, 
                      child:  isLoading ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ) :  Text("Continue"),
                    ),
                  ), 
                  SizedBox(height: 16,),
                  RedirectPageTextWidget(message: "Already have an account? ", redirectedPage: "Login", onTap: () {
                    context.go(AppRoutes.login);
                  },) 
                ],
              ) 
            ),
          ),
        ),
      )
    );
  }
}