import 'package:eventify/core/router/app_router.dart';
import 'package:eventify/core/widgets/text_field_widget.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UsernamePickerScreen extends ConsumerStatefulWidget {
  const UsernamePickerScreen({super.key});

  @override
  ConsumerState<UsernamePickerScreen> createState() => _UsernamePickerScreenState();
}

class _UsernamePickerScreenState extends ConsumerState<UsernamePickerScreen> {
  final userNameController = TextEditingController();
  String? errorText;
  bool isChecking = false;

  @override
  void initState(){
    super.initState();
    userNameController.addListener(_onFieldChange);
  }

  void _onFieldChange(){
    setState(() {
      
    });
  }

  @override
  void dispose(){
    userNameController.dispose();
    super.dispose();
  }

  bool get _isFormField => userNameController.text.trim().length >= 3;

  String? _validate(String userName){
    if(userName.trim().isEmpty){
      return "please input a username";
    }
    if(_isFormField != true){
      return "username should be 3 characters or longer";
    }
    if(!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(userName)){
      return "only alphabets, numbers and underscores can be used";
    }
    return null;
  }

  Future<void> _setUpUserName() async {
    setState(() {
      errorText = null;
    });

    final username = userNameController.text.trim();
    final validationError = _validate(username);
    if(validationError != null){
      setState(() {
        errorText = validationError;
        return;
      });
    }

    setState(() {
      isChecking = true;
    });
    final availableUserName = await ref.read(authRepositoryProvider).isUserNameAvailable(username);
    setState(() {
      isChecking = false;
    });

    if(!availableUserName){
      setState(() {
        errorText = "username cant be chosen please choose another one";
      });
    }

    final state = ref.read(authStateChangesProvider);
    final uid = state.value!.id;
    await ref.read(authControllerProvider.notifier).setUserName(uid, username);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading || isChecking;
    final canSubmit = _isFormField && !isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Pick a username",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 6,),
                Text("choose a unique username."),
                //SizedBox(height: 12,),
                Textfieldwidget(
                  title: "", 
                  hintText: "", 
                  textEditingController: userNameController,
                  errorText: errorText,
                  onChanged: (_){
                    if(errorText != null){
                      setState(() {
                        errorText = null;
                      });
                    }
                  },
                ),
                SizedBox(height: 12,),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: canSubmit? _setUpUserName : null,
                    child: Text("Continue")
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}