import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cepController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _dataIngressaoController = TextEditingController();
  
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  final _cepMaskFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  String _ramoSelecionado = 'Lobinho';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _emailValid = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _cepController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _dataNascimentoController.dispose();
    _dataIngressaoController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      setState(() => _emailValid = false);
      return 'E-mail inválido';
    }
    setState(() => _emailValid = true);
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }
    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00A000),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void _nextPage() {
    if (_currentPage == 0 && _formKey1.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 1 && _formKey2.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 2 && _formKey3.currentState!.validate()) {
      _handleSignup();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleSignup() async {
    setState(() => _isLoading = true);
  
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text.trim(),
          'nome': _nomeController.text.trim(),
          'sobrenome': _sobrenomeController.text.trim(),
          'telefone': _telefoneController.text.trim(),
          'endereco': _enderecoController.text.trim(),
          'cep': _cepController.text.trim(),
          'bairro': _bairroController.text.trim(),
          'cidade': _cidadeController.text.trim(),
          'dataNascimento': _dataNascimentoController.text,
          'dataIngressao': _dataIngressaoController.text,
          'ramo': _ramoSelecionado,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        print('Erro ao salvar no Firestore: $firestoreError');
      }

      await FirebaseAuth.instance.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Color(0xFF00A000),
            duration: Duration(seconds: 2),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro ao criar conta';
      
      if (e.code == 'weak-password') {
        errorMessage = 'Senha muito fraca';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este e-mail já está em uso';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'E-mail inválido';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro inesperado. Tente novamente'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/imagem-1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF00A000),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Text(
                        'Passo ${_currentPage + 1} de 3',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(32.0),
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A000),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Junte-se à nossa aventura',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              
                              SizedBox(
                                height: 400,
                                child: PageView(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (page) {
                                    setState(() => _currentPage = page);
                                  },
                                  children: [
                                    _buildPage1(),
                                    _buildPage2(),
                                    _buildPage3(),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              Row(
                                children: [
                                  if (_currentPage > 0)
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _previousPage,
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Color(0xFF00A000)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                        child: const Text(
                                          'VOLTAR',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00A000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_currentPage > 0) const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _nextPage,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF00A000),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              _currentPage == 2 ? 'CADASTRAR' : 'PRÓXIMO',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Form(
      key: _formKey1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            label: 'E-mail',
            controller: _emailController,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: _emailController.text.isNotEmpty
                ? Icon(
                    _emailValid ? Icons.check_circle : Icons.cancel,
                    color: _emailValid ? Colors.green : Colors.red,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Senha',
            controller: _passwordController,
            validator: _validatePassword,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF00A000),
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Confirmar Senha',
            controller: _confirmPasswordController,
            validator: _validateConfirmPassword,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF00A000),
              ),
              onPressed: () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Form(
      key: _formKey2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              label: 'Nome',
              controller: _nomeController,
              validator: (v) => _validateRequired(v, 'Nome'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Sobrenome',
              controller: _sobrenomeController,
              validator: (v) => _validateRequired(v, 'Sobrenome'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Telefone',
              controller: _telefoneController,
              validator: (v) => _validateRequired(v, 'Telefone'),
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneMaskFormatter],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Rua',
              controller: _enderecoController,
              validator: (v) => _validateRequired(v, 'Rua'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Bairro',
              controller: _bairroController,
              validator: (v) => _validateRequired(v, 'Bairro'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Cidade',
              controller: _cidadeController,
              validator: (v) => _validateRequired(v, 'Cidade'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'CEP',
              controller: _cepController,
              validator: (v) => _validateRequired(v, 'CEP'),
              keyboardType: TextInputType.number,
              inputFormatters: [_cepMaskFormatter],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return Form(
      key: _formKey3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDateField(
            label: 'Data de Nascimento',
            controller: _dataNascimentoController,
          ),
          const SizedBox(height: 16),
          _buildDateField(
            label: 'Data de Ingressão',
            controller: _dataIngressaoController,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ramo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _ramoSelecionado,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: ['Lobinho', 'Escoteiro', 'Júnior']
                    .map((ramo) => DropdownMenuItem(
                          value: ramo,
                          child: Text(ramo),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _ramoSelecionado = value!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          validator: (v) => _validateRequired(v, label),
          onTap: () => _selectDate(context, controller),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF00A000)),
          ),
        ),
      ],
    );
  }
}