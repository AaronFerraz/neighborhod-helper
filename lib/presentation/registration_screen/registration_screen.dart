import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/mock_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _unitIdController = TextEditingController();

  final List<String> _approvedCondominiums = [
    'Condomínio Vista Alegre',
    'Condomínio São José',
    'Residencial Primavera',
    'Rua Central (bairro)',
  ];

  final List<String> _unitTypes = ['Torre', 'Apartamento', 'Casa', 'Bloco'];

  String? _selectedCondominium;
  String? _selectedUnitType;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _unitIdController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _unitIdController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();
    final unitId = _unitIdController.text.trim();

    setState(() {
      _isFormValid = name.isNotEmpty &&
          _isValidEmailOrCPF(email) &&
          password.length >= 8 &&
          phone.isNotEmpty &&
          unitId.isNotEmpty &&
          _selectedCondominium != null &&
          _selectedUnitType != null;
    });
  }

  bool _isValidEmailOrCPF(String input) {
    if (input.isEmpty) return false;

    // Check if it's an email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailRegex.hasMatch(input)) return true;

    // Check if it's a CPF (11 digits)
    final cpfRegex = RegExp(r'^\d{11}$');
    final cleanCPF = input.replaceAll(RegExp(r'[^\d]'), '');
    return cpfRegex.hasMatch(cleanCPF);
  }

  String? _validateNonEmpty(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Por favor, insira sua senha';
    if (v.length < 8) return 'A senha deve ter pelo menos 8 caracteres';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email ou CPF';
    }
    if (!_isValidEmailOrCPF(value)) {
      return 'Email ou CPF inválido';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock register - may throw if already exists
      MockAuth.registerUser(
        name: _nameController.text.trim(),
        emailOrCpf: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        condominium: _selectedCondominium!,
        unitType: _selectedUnitType!,
        unitId: _unitIdController.text.trim(),
      );

      // Success haptic feedback
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso')),
      );

      // Return to login screen
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Cadastro',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header text
                    Text(
                      'Bem-vindo à comunidade',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Preencha seus dados para se cadastrar',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Full name field
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      validator: _validateNonEmpty,
                      decoration: InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Email or CPF field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Email ou CPF',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'alternate_email',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.next,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'lock',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: _isPasswordVisible
                                ? 'visibility_off'
                                : 'visibility',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: _validateNonEmpty,
                      decoration: InputDecoration(
                        labelText: 'Telefone de contato',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'contact_phone',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Condominium dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCondominium,
                      items: _approvedCondominiums
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedCondominium = v);
                        Future.delayed(Duration.zero, _validateForm);
                      },
                      decoration: InputDecoration(
                        labelText: 'Condomínio / Prédio',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'apartment',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          v == null ? 'Selecione um condomínio' : null,
                    ),
                    SizedBox(height: 2.h),

                    // Unit type dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedUnitType,
                      items: _unitTypes
                          .map(
                              (u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedUnitType = v);
                        Future.delayed(Duration.zero, _validateForm);
                      },
                      decoration: InputDecoration(
                        labelText: 'Tipo de unidade',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'home',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          v == null ? 'Selecione o tipo de unidade' : null,
                    ),
                    SizedBox(height: 2.h),

                    // Unit identification field
                    TextFormField(
                      controller: _unitIdController,
                      textInputAction: TextInputAction.done,
                      validator: _validateNonEmpty,
                      decoration: InputDecoration(
                        labelText: 'Identificação da unidade',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'edit_location',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Register button - only enabled when form is complete
                    SizedBox(
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: _isFormValid && !_isLoading
                            ? _handleRegister
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.3),
                          foregroundColor: Colors.white,
                          elevation: _isFormValid ? 2 : 0,
                          shadowColor: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          disabledBackgroundColor: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Cadastrar',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Back to login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem conta? ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 0.5.h),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Voltar ao login',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
