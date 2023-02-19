import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dorset',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int currentStep = 0;
  bool isCompleted = false;

  final firstname = TextEditingController();
  final age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dorset Waterfront"),
        centerTitle: true,
      ),
      body: isCompleted
          ? buildCompleted()
          : Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.red),
              ),
              child: Stepper(
                //if vertical type just delete bottom line
                type: StepperType.horizontal,
                steps: getSteps(),
                currentStep: currentStep,

                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;

                  if (isLastStep) {
                    setState(() {
                      isCompleted = true;
                    });
                    //print('Completed');

                    //send data to the server
                  } else {
                    setState(() => currentStep += 1);
                  }
                },

                onStepTapped: (step) => setState(() => currentStep = step),
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() => currentStep -= 1),
                controlsBuilder: (context, {onStepContinue, onStepCancel}) {
                  final isLastStep = currentStep == getSteps().length - 1;

                  return Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text(isLastStep ? "Confirm" : "NEXT"),
                            onPressed: onStepContinue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (currentStep != 0)
                          Expanded(
                            child: ElevatedButton(
                              child: Text("BACK"),
                              onPressed: onStepCancel,
                            ),
                          ),
                      ],
                    ),
                  );
                },
                //Check cant Cancel button if the first one
              ),
            ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('First Name'),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: firstname,
                decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.price_change_outlined)),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Age'),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: age,
                decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.house_outlined)),
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text('Calculation'),
          content: const Column(
            children: <Widget>[],
          ),
        ),
      ];

  buildCompleted() {
    ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 24),
            minimumSize: const Size.fromHeight(50)),
        child: const Text("Reset"),
        onPressed: () => setState(() {
              isCompleted = false;
              currentStep = 0;

              firstname.clear();
              age.clear();
            }));
  }
}
