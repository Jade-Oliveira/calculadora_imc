import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  //chave global que será utilizada pelo formulário
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = 'Informe seus dados!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculadora de IMC'),
          backgroundColor: Colors.green,
          centerTitle: true,
          //colocar o botão de refresh
          actions: [
            IconButton(
              onPressed: () {
                _resetFields();
              },
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            //adiciona o Form para poder usar as validações de formulário como a globalkey
            child: Form(
              key: _formKey,
              child: Column(
                //scretch tenta preencher toda a largura,
                // mas no caso do ícone não faz isso porque ele tem um tamanho específico
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 120,
                    color: Colors.green,
                  ),
                  //mudei de TextField para TextFormField para usar o parâmetro validator
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        labelStyle: TextStyle(color: Colors.green)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25),
                    controller: weightController,
                    //função anônima que recebe o valor do campo
                    validator: (value) {
                      if(value!.isEmpty) return 'Insira seu peso!';
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Altura (cm)',
                        labelStyle: TextStyle(color: Colors.green)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25),
                    controller: heightController,
                    validator: (value) {
                      if(value!.isEmpty) return 'Insira sua altura!';
                    },
                  ),
                  //coloquei um container para definir a altura do botão
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      height: 40.0,
                      child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                            textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          onPressed: () {
                            //quando apertar o botão vai verificar se o formulário tá válido e se estiver ele chama a função calculate
                            if(_formKey.currentState!.validate()) {
                              _calculate();
                            }
                          },
                          child: Text(
                            'Calcular',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  Text(
                    _infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            )
          ),
        )
    );
  }

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _infoText = 'Informe seus dados';
    });
  }

  void _calculate() {
    setState(() {
      //transforma os textos em double
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      if(imc < 18.6) {
        //transforma o número em uma string com uma precisão de 4 dígitos
        _infoText = 'Abaixo do Peso (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = 'Peso ideal (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = 'Sobrepeso (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = 'Obesidade Grau I (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = 'Obesidade Grau II(${imc.toStringAsPrecision(4)})';
      } else {
        _infoText = 'Obesidade Grau III(${imc.toStringAsPrecision(4)})';
      }
    });
  }
}
