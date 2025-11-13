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
  final _estadoController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _dataIngressaoController = TextEditingController();
  
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _nomeFocusNode = FocusNode();
  final _sobrenomeFocusNode = FocusNode();
  final _telefoneFocusNode = FocusNode();
  final _enderecoFocusNode = FocusNode();
  final _bairroFocusNode = FocusNode();
  final _cidadeFocusNode = FocusNode();
  final _estadoFocusNode = FocusNode();
  final _cepFocusNode = FocusNode();
  final _dataNascimentoFocusNode = FocusNode();
  final _dataIngressaoFocusNode = FocusNode();
  
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  final _cepMaskFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  final _dateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
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
    _estadoController.dispose();
    _dataNascimentoController.dispose();
    _dataIngressaoController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _nomeFocusNode.dispose();
    _sobrenomeFocusNode.dispose();
    _telefoneFocusNode.dispose();
    _enderecoFocusNode.dispose();
    _bairroFocusNode.dispose();
    _cidadeFocusNode.dispose();
    _estadoFocusNode.dispose();
    _cepFocusNode.dispose();
    _dataNascimentoFocusNode.dispose();
    _dataIngressaoFocusNode.dispose();
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
  
  String? _validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    if (value.length != 10) {
      return 'Data inválida';
    }
    final parts = value.split('/');
    if (parts.length != 3) {
      return 'Data inválida';
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return 'Data inválida';
    }
    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
      return 'Data inválida';
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
          'estado': _estadoController.text.trim(),
          'dataNascimento': _dataNascimentoController.text,
          'dataIngressao': _dataIngressaoController.text,
          'ramo': _ramoSelecionado,
          'role': 'user',
          'pontos': 0,
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A000).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final isActive = index == _currentPage;
                            final isCompleted = index < _currentPage;
                            
                            return Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: isActive ? 32 : 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: isActive || isCompleted
                                        ? const Color(0xFF00A000)
                                        : Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                if (index < 2)
                                  Container(
                                    width: 24,
                                    height: 2,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    color: isCompleted
                                        ? const Color(0xFF00A000)
                                        : Colors.white.withOpacity(0.3),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
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
                                height: 450,
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
            focusNode: _emailFocusNode,
            nextFocusNode: _passwordFocusNode,
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
            focusNode: _passwordFocusNode,
            nextFocusNode: _confirmPasswordFocusNode,
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
            focusNode: _confirmPasswordFocusNode,
            textInputAction: TextInputAction.done,
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
              allowAccents: true,
              focusNode: _nomeFocusNode,
              nextFocusNode: _sobrenomeFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Sobrenome',
              controller: _sobrenomeController,
              validator: (v) => _validateRequired(v, 'Sobrenome'),
              allowAccents: true,
              focusNode: _sobrenomeFocusNode,
              nextFocusNode: _telefoneFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Telefone',
              controller: _telefoneController,
              validator: (v) => _validateRequired(v, 'Telefone'),
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneMaskFormatter],
              focusNode: _telefoneFocusNode,
              nextFocusNode: _enderecoFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Rua',
              controller: _enderecoController,
              validator: (v) => _validateRequired(v, 'Rua'),
              allowAccents: true,
              focusNode: _enderecoFocusNode,
              nextFocusNode: _bairroFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Bairro',
              controller: _bairroController,
              validator: (v) => _validateRequired(v, 'Bairro'),
              allowAccents: true,
              focusNode: _bairroFocusNode,
              nextFocusNode: _cidadeFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Cidade',
              controller: _cidadeController,
              validator: (v) => _validateRequired(v, 'Cidade'),
              allowAccents: true,
              focusNode: _cidadeFocusNode,
              nextFocusNode: _estadoFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Estado',
              controller: _estadoController,
              validator: (v) => _validateRequired(v, 'Estado'),
              allowAccents: true,
              focusNode: _estadoFocusNode,
              nextFocusNode: _cepFocusNode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'CEP',
              controller: _cepController,
              validator: (v) => _validateRequired(v, 'CEP'),
              keyboardType: TextInputType.number,
              inputFormatters: [_cepMaskFormatter],
              focusNode: _cepFocusNode,
              textInputAction: TextInputAction.done,
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
            focusNode: _dataNascimentoFocusNode,
            nextFocusNode: _dataIngressaoFocusNode,
          ),
          const SizedBox(height: 16),
          _buildDateField(
            label: 'Data de Ingressão',
            controller: _dataIngressaoController,
            focusNode: _dataIngressaoFocusNode,
            textInputAction: TextInputAction.done,
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
                items: ['Lobinho', 'Júnior', 'Sênior']
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
    bool allowAccents = false,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextInputAction? textInputAction,
  }) {
    List<TextInputFormatter> formatters = inputFormatters ?? [];
    if (!allowAccents && 
        keyboardType != TextInputType.phone && 
        keyboardType != TextInputType.number && 
        keyboardType != TextInputType.emailAddress) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s@._-]')));
    }

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
          inputFormatters: formatters,
          focusNode: focusNode,
          textInputAction: textInputAction ?? (nextFocusNode != null ? TextInputAction.next : TextInputAction.done),
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
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
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextInputAction? textInputAction,
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
          validator: (v) => _validateDate(v, label),
          keyboardType: TextInputType.number,
          inputFormatters: [_dateMaskFormatter],
          focusNode: focusNode,
          textInputAction: textInputAction ?? (nextFocusNode != null ? TextInputAction.next : TextInputAction.done),
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            hintText: 'DD/MM/AAAA',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Color(0xFF00A000)),
              onPressed: () => _selectDate(context, controller),
            ),
          ),
        ),
      ],
    );
  }
}