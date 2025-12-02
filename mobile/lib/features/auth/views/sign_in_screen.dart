import 'package:ecommerence/utils/constants/colors.dart';
import 'package:ecommerence/utils/constants/image_strings.dart';
import 'package:ecommerence/utils/constants/sizes.dart';
import 'package:ecommerence/utils/styles/spacing_styles.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _policyCheck = false;

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 2) {
      return 'Must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
      return 'Only letters are allowed';
    }
    return null;
  }

  String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,19}$').hasMatch(value.trim())) {
      return 'Invalid username';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Must be at least 8 characters long';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number';
    }

    if (!RegExp(r'[!@#\$&*~%^()_+\-=<>?/{}|[\]]').hasMatch(value)) {
      return 'Must contain at least one special character';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '''Let's create your account''',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSizes.xl),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            validator: nameValidator,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            validator: nameValidator,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: usernameValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: passwordValidator,
                    ),

                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            activeColor: AppColors.primary,
                            value: _policyCheck,
                            onChanged: (val) {
                              setState(() {
                                _policyCheck = val ?? false;
                              });
                            },
                          ),
                        ),

                        SizedBox(width: AppSizes.spaceBtwItems),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _policyCheck = !_policyCheck;
                              });
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'I agree to ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.primary,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: 'Terms of use',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sign in'),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Center(
                      child: Text(
                        'Or sign in with',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(100),
                          ),

                          child: IconButton(
                            onPressed: () {},
                            icon: const Image(
                              image: AssetImage(AppImageStrings.googleLogo),
                              width: AppSizes.iconMd,
                              height: AppSizes.iconMd,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceBtwItems),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(100),
                          ),

                          child: IconButton(
                            onPressed: () {},
                            icon: const Image(
                              image: AssetImage(AppImageStrings.facebookLogo),
                              width: AppSizes.iconMd,
                              height: AppSizes.iconMd,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
