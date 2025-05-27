import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infotest = 'Informe seus dados!';

  void _resetFields() {
    weightController.text='';
    heightController.text='';
    setState(() {
      _infotest = 'Informe seus dados!';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text)/100;
      double imc = weight / (height*height);
      if(imc<18.6){
        _infotest = 'Abaixo do Peso (${imc.toStringAsPrecision(3)})';
      }
      else if(imc >= 18.6 && imc < 24.9){
        _infotest = 'Peso Ideal (${imc.toStringAsPrecision(3)})';
      }
      else if(imc >= 24.9 && imc < 29.9){
        _infotest = 'Levemente Acima do Peso (${imc.toStringAsPrecision(3)})';
      }
      else if(imc >= 29.9 && imc < 34.9){
        _infotest = 'Obesidade Grau I (${imc.toStringAsPrecision(3)})';
      }
      else if(imc >= 34.9 && imc < 39.9){
        _infotest = 'Obesidade Grau II (${imc.toStringAsPrecision(3)})';
      }
      else if(imc >= 39.9){
        _infotest = 'Obesidade Grau III (${imc.toStringAsPrecision(3)})';
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        actions: [
          IconButton(
            onPressed: _resetFields,
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person_outline,
                size: 120.0,
                color: Colors.green,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: weightController,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    setState(() {
                      _infotest = 'Informe seus dados!';
                    });
                    return "Insira seu Peso!";
                  }
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
                    if(value == null || value.isEmpty){
                      setState(() {
                        _infotest = 'Informe seus dados!';
                      });
                      return "Insira sua Altura!";
                    }
                  },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if(_formKey.currentState?.validate() ?? false)
                        {
                          _calculate();
                        }
                    },
                    child: Text(
                      'Calcular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                _infotest,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
